import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:package_info_plus/package_info_plus.dart';

abstract class API {
  Future<T> getData<T>(String url);

  Future<T> postData<T>(String url, {Map<String, dynamic>? body});

  Future<T> deleteData<T>(String url, {Map<String, dynamic>? body});

  Future<T> patchData<T>(String url, {Map<String, dynamic>? body});

  Future<T> putData<T>(String url);
}

class APIService implements API {
  final Dio _dio = Dio()
    ..interceptors.addAll([
      CoreInterceptor(),
      LogInterceptor(),
    ]);

  final String _baseUrl =
      'https://${FlavorConfig.instance!.values.baseUriAsia}';
  final CustomLogger? logger = locator<CustomLogger>();
  final UserService? userService = locator<UserService>();

  APIService._();

  static final instance = APIService._();

  static const _cacheEncryptionKey = "264a239b0d87e175509b2aeb2a44b28c";
  static const _cacheEncryptionIV = "cffb220f03eaac73";

  @override
  Future<T> getData<T>(
    String url, {
    final String? token,
    final Map<String, dynamic>? queryParams,
    final Map<String, dynamic>? headers,
    final String? cBaseUrl,
    final bool decryptData = false,
  }) async {
    try {
      String finalPath = (cBaseUrl ?? _baseUrl) + url;

      final response = await _dio.get(
        finalPath,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
        ),
      );

      if (decryptData) {
        final data = await _decryptData(response.data);
        log("decryptData  ${data!}");
        return json.decode(data);
      }

      return returnResponse(response);
    } catch (e) {
      if (e is SocketException) {
        throw const FetchDataException('No Internet connection');
      } else if (e is UnauthorizedException) {
        throw const UnauthorizedException(
            "Verification Failed. Please try again");
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<T> postData<T>(
    String url, {
    Map<String, dynamic>? body,
    String? cBaseUrl,
    String? token,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    final bool decryptData = false,
  }) async {
    try {
      String finalPath = (cBaseUrl ?? _baseUrl) + url;

      final response = await _dio.post(
        finalPath,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
        ),
        data: body,
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
    }
  }

  @override
  Future<T> putData<T>(
    String url, {
    Object? body,
    String? absoluteUrl,
    String? cBaseUrl,
    String? token,
    Map<String, dynamic>? headers,
  }) async {
    try {
      String finalPath = (cBaseUrl ?? _baseUrl) + url;

      final response = await _dio.put<T>(
        absoluteUrl ?? finalPath,
        data: body,
        options: Options(headers: headers),
      );

      return returnResponse(response);
    } on SocketException {
      throw const FetchDataException('No Internet connection');
    }
  }

  @override
  Future<T> deleteData<T>(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final response = await _dio.delete<T>(
        '$_baseUrl$url',
      );

      return returnResponse(response);
    } on SocketException {
      throw const FetchDataException('No Internet connection');
    }
  }

  @override
  Future<T> patchData<T>(
    String url, {
    Map<String, dynamic>? body,
    String? cBaseUrl,
    String? token,
  }) async {
    String finalPath = (cBaseUrl ?? _baseUrl) + url;

    try {
      final response = await _dio.patch<T>(
        finalPath,
        data: body,
      );

      return returnResponse(response);
    } on SocketException {
      throw const FetchDataException('No Internet connection');
    }
  }

  dynamic returnResponse(Response response) {
    final responseJson = response.data;
    // logger!.d("$responseJson with code  ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
      case 404:
        // logger!.d(response.body);
        throw BadRequestException(responseJson['message']);

      case 401:
        BaseRepo.refreshToken = true;
        throw BadRequestException(responseJson['message']);
      case 403:
        throw UnauthorizedException(response.data.toString());
      case 500:
        throw const InternalServerException('Internal server exception');

      default:
        throw FetchDataException(responseJson["message"]);
    }
  }

  Future<String?> _decryptData(String data) async {
    final encrypter = Encrypter(AES(
      Key.fromUtf8(utf8.decode(_cacheEncryptionKey.codeUnits)),
      mode: AESMode.cbc,
    ));

    final data0 = encrypter.decrypt16(
      data,
      iv: IV.fromUtf8(utf8.decode(_cacheEncryptionIV.codeUnits)),
    );

    return data0;
  }
}

class CoreInterceptor extends Interceptor {
  PackageInfo? _info;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    /// TODO(@DK070202): Whitelist domain for the headers qulification.
    if (options.path.contains('uploads/')) {
      handler.next(options);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();
    final uid = user?.uid;

    if (idToken != null) {
      /// TODO(@DK070202): Confirm if token is uniq at all place.
      options.headers['authorization'] = 'Bearer $idToken';
    }

    if (uid != null) {
      options.headers['uid'] = uid;
    }

    try {
      _info ??= await PackageInfo.fromPlatform();
      options.headers['version'] = _info!.version;
      options.headers['platform'] = defaultTargetPlatform.name;
      // ignore: empty_catches
    } catch (e) {}
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    switch (err.response?.statusCode) {
      case 401:
        try {
          await FirebaseAuth.instance.currentUser?.getIdToken(true);
          // ignore: empty_catches
        } catch (e) {}
        break;
      default:
    }
    handler.next(err);
  }
}
