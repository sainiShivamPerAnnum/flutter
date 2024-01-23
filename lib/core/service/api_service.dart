// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:encrypt/encrypt.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:package_info_plus/package_info_plus.dart';

enum _RequestType {
  GET,
  POST,
  PUT,
  PATCH,
}

abstract class API {
  Future<T> getData<T>(
    String url, {
    required String apiName,
  });

  Future<T> postData<T>(
    String url, {
    required String apiName,
    Map<String, dynamic>? body,
  });

  Future<T> patchData<T>(
    String url, {
    required String apiName,
    Map<String, dynamic>? body,
  });

  Future<T> putData<T>(
    String url, {
    required String apiName,
  });
}

class APIService implements API {
  APIService._() : _dio = Dio() {
    _dio
      ..interceptors.addAll(
        [
          CoreInterceptor(),
          LogInterceptor(),
        ],
      )
      ..httpClientAdapter = Http2Adapter(
        ConnectionManager(
          idleTimeout: const Duration(seconds: 35),
        ),
      );

    assert(() {
      _dio.httpClientAdapter = IOHttpClientAdapter();
      return true;
    }());
  }
  static final instance = APIService._();

  final Dio _dio;

  PackageInfo? _info;
  final FirebasePerformance _performance = FirebasePerformance.instance;

  final String _baseUrl =
      'https://${FlavorConfig.instance!.values.baseUriAsia}';
  final CustomLogger? logger = locator<CustomLogger>();
  final UserService? userService = locator<UserService>();

  static const _cacheEncryptionKey = "264a239b0d87e175509b2aeb2a44b28c";
  static const _cacheEncryptionIV = "cffb220f03eaac73";

  @override
  Future<T> getData<T>(
    String url, {
    required String apiName,
    final String? token, // Just in case of blogs.
    final Map<String, dynamic>? queryParams,
    final Map<String, dynamic>? headers,
    final String? cBaseUrl,
    final bool decryptData = false,
  }) async {
    try {
      String finalPath = (cBaseUrl ?? _baseUrl) + url;

      final response = await _request<T>(
        _RequestType.GET,
        finalPath,
        queryParameters: queryParams,
        headers: {
          if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
          ...?headers,
        },
        apiName: apiName,
      );

      if (decryptData) {
        final data = await _decryptData(response.data);
        log("decryptData  ${data!}");
        return json.decode(data);
      }

      return returnResponse(response);
    } on DioException catch (e) {
      return returnResponse(e.response);
    } catch (e) {
      if (e is SocketException) {
        throw const FetchDataException('No Internet connection');
      } else if (e is UnauthorizedException) {
        throw const UnauthorizedException(
            "Verification Failed. Please try again");
      } else {
        throw const UnknownException('Something went wrong');
      }
    }
  }

  @override
  Future<T> postData<T>(
    String url, {
    required String apiName,
    Map<String, dynamic>? body,
    String? cBaseUrl,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    final bool decryptData = false,
  }) async {
    try {
      String finalPath = (cBaseUrl ?? _baseUrl) + url;

      final response = await _request<T>(
        _RequestType.POST,
        finalPath,
        queryParameters: queryParams,
        headers: headers,
        data: body,
        apiName: apiName,
      );

      if (decryptData) {
        final data = await _decryptData(response.data);
        log("decryptData  ${data!}");
        return json.decode(data);
      }

      return returnResponse(response);
    } on SocketException {
      throw const FetchDataException(
        'Error communication with server: Please check your internet connectivity',
      );
    } on DioException catch (e) {
      return returnResponse(e.response);
    }
  }

  @override
  Future<T> putData<T>(
    String url, {
    required String apiName,
    Object? body,
    String? cBaseUrl,
    Map<String, dynamic>? headers,
    bool passToken = true,
  }) async {
    try {
      String finalPath = (cBaseUrl ?? _baseUrl) + url;

      final response = await _request<T>(
        _RequestType.PUT,
        finalPath,
        headers: headers,
        data: body,
        passToken: passToken,
        apiName: apiName,
      );

      return returnResponse(response);
    } on DioException catch (e) {
      return returnResponse(e.response);
    } on SocketException {
      throw const FetchDataException('No Internet connection');
    }
  }

  @override
  Future<T> patchData<T>(
    String url, {
    required String apiName,
    Map<String, dynamic>? body,
    String? cBaseUrl,
  }) async {
    String finalPath = (cBaseUrl ?? _baseUrl) + url;

    try {
      final response = await _request<T>(
        _RequestType.PATCH,
        finalPath,
        data: body,
        apiName: apiName,
      );

      return returnResponse(response);
    } on DioException catch (e) {
      return returnResponse(e.response);
    } on SocketException {
      throw const FetchDataException('No Internet connection');
    }
  }

  dynamic returnResponse(Response? response) {
    final responseJson = response?.data;
    switch (response?.statusCode) {
      case 200:
        return responseJson;
      case 400:
        throw BadRequestException(responseJson['message']);
      case 403:
        throw UnauthorizedException(response?.data.toString());
      case 500:
        throw const InternalServerException('Internal server exception');

      default:
        throw FetchDataException(responseJson["message"]);
    }
  }

  Future<String?> _decryptData(String data) async {
    final encAlgo = AES(
      Key.fromUtf8(utf8.decode(_cacheEncryptionKey.codeUnits)),
      mode: AESMode.cbc,
    );

    final enc = Encrypter(encAlgo);

    final decryptedData = enc.decrypt16(
      data,
      iv: IV.fromUtf8(utf8.decode(_cacheEncryptionIV.codeUnits)),
    );

    return decryptedData;
  }

  Future<Response> _request<T>(
    _RequestType method,
    String path, {
    required String apiName,
    Map<String, dynamic>? headers,
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool passToken = false,
  }) async {
    final modifiedHeaders = await _attachHeaders(
      headers ?? {},
    );

    final options = Options(
      method: method.name,
      headers: modifiedHeaders,
      listFormat: ListFormat.multi,
    );

    Trace? trace;

    try {
      trace = _performance.newTrace(
        apiName,
      );
      await trace.start();
    } catch (e) {
      log(e.toString());
    }

    try {
      trace?.putAttribute('method', method.name);

      final response = await _dio.request<T>(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
      );

      final code = response.statusCode;
      if (code != null) {
        trace?.putAttribute('status_code', code.toString());
      }

      final contentHeaders = response.headers[HttpHeaders.contentLengthHeader];
      if (contentHeaders != null && contentHeaders.isNotEmpty) {
        trace?.putAttribute(
          HttpHeaders.contentLengthHeader,
          contentHeaders.first,
        );
      }

      try {
        await trace?.stop();
      } catch (e) {
        log(e.toString());
      }
      return response;
    } on DioException catch (e) {
      final response = e.response;

      final code = response?.statusCode;
      if (code != null) {
        trace?.putAttribute('status_code', code.toString());
      }

      final contentHeaders = response?.headers[HttpHeaders.contentLengthHeader];
      if (contentHeaders != null && contentHeaders.isNotEmpty) {
        trace?.putAttribute(
          HttpHeaders.contentLengthHeader,
          contentHeaders.first,
        );
      }

      try {
        await trace?.stop();
      } catch (e) {
        log(e.toString());
      }
      rethrow;
    } catch (e) {
      try {
        await trace?.stop();
      } catch (e) {
        log(e.toString());
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _attachHeaders(
    Map<String, dynamic> headers, {
    bool passToken = true,
  }) async {
    final head = <String, dynamic>{...headers};
    final trace = _performance.newTrace('auth-token');
    try {
      final authToken = head[HttpHeaders.authorizationHeader];
      final user = FirebaseAuth.instance.currentUser;

      if (authToken == null && passToken) {
        await trace.start();
        final token = await user?.getIdToken();
        head[HttpHeaders.authorizationHeader] =
            token != null ? 'Bearer $token' : '';
        await trace.stop();
      }

      final uid = user?.uid;
      head['uid'] = uid ?? '';
    } catch (e) {
      await trace.stop();
    }

    try {
      _info ??= await PackageInfo.fromPlatform();
      head['version'] = _info!.buildNumber;
      head['platform'] = defaultTargetPlatform.name;
    } catch (e) {
      debugPrint(e.toString());
    }

    return head;
  }
}

class CoreInterceptor extends Interceptor {
  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    switch (err.response?.statusCode) {
      case 401:
        try {
          await FirebaseAuth.instance.currentUser?.getIdToken(true);
        } catch (e) {
          debugPrint(e.toString());
        }
        break;
      default:
    }
    handler.next(err);
  }
}
