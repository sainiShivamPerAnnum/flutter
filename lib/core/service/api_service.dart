import 'dart:convert';
import 'dart:io';

import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:felloapp/util/custom_logger.dart';

abstract class API {
  void setBaseUrl(String url);
  dynamic returnResponse(http.Response response);

  Future<dynamic> getData(String url);
  Future<dynamic> postData(String url, {Map<String, dynamic> body});
  Future<dynamic> deleteData(String url, {Map<String, dynamic> body});
  Future<dynamic> patchData(String url, {Map<String, dynamic> body});
  Future<dynamic> putData(String url);
}

class APIService implements API {
  String _baseUrl = 'https://' + FlavorConfig.instance.values.baseUriAsia;
  //"https://asia-south1-fello-dev-station.cloudfunctions.net";
  final logger = locator<CustomLogger>();
  final userService = locator<UserService>();
  String _versionString = "";

  APIService._();
  static final instance = APIService._();

  @override
  Future<dynamic> getData(
    String url, {
    String token,
    Map<String, dynamic> queryParams,
  }) async {
    final HttpMetric metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();

    var responseJson;
    // token = Preference.getString('token');
    try {
      String queryString = '';
      String finalPath = '$_baseUrl$url';
      if (queryParams != null) {
        queryString = Uri(queryParameters: queryParams).query;
        finalPath += '?$queryString';
      }
      final response = await http.get(
        Uri.parse(finalPath),
        headers: {
          HttpHeaders.authorizationHeader: token != null ? 'Bearer $token' : '',
          'platform': Platform.isAndroid ? 'android' : 'iOS',
          'version':
              _versionString.isEmpty ? await _getAppVersion() : _versionString,
          'uid': userService?.baseUser?.uid,
        },
      );
      logger.d("response from $url");
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on UnauthorisedException {
      throw UnauthorisedException("Token Expired, Signout current user");
    } finally {
      await metric.stop();
    }
    return responseJson;
  }

  @override
  Future<dynamic> postData(
    String url, {
    Map<String, dynamic> body,
    String token,
  }) async {
    final HttpMetric metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Post);
    await metric.start();
    var responseJson;
    try {
      Map<String, String> _headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'platform': Platform.isAndroid ? 'android' : 'iOS',
        'version':
            _versionString.isEmpty ? await _getAppVersion() : _versionString,
        'uid': userService?.baseUser?.uid,
      };
      logger.d(_headers);
      if (token != null)
        _headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      String _url = _baseUrl + url;
      logger.d("response from $url");

      final response = await http.post(
        Uri.parse(_url),
        headers: _headers,
        body: jsonEncode(body ?? {}),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(
        'Error communication with server: Please check your internet connectivity',
      );
    } finally {
      await metric.stop();
    }
    return responseJson;
  }

  @override
  Future<dynamic> putData(
    String url, {
    Map<String, dynamic> body,
    String token,
  }) async {
    final HttpMetric metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();

    var responseJson;
    // token = Preference.getString('token');
    try {
      logger.d("response from $url");
      final response = await http.put(
        Uri.parse(_baseUrl + url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: token != null ? token : '',
          'platform': Platform.isAndroid ? 'android' : 'iOS',
          'version':
              _versionString.isEmpty ? await _getAppVersion() : _versionString,
          'uid': userService?.baseUser?.uid,
        },
        body: body == null ? null : jsonEncode(body),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } finally {
      await metric.stop();
    }
    return responseJson;
  }

  @override
  Future<dynamic> deleteData(
    String url, {
    Map<String, dynamic> body,
    String token,
  }) async {
    final HttpMetric metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();

    dynamic responseJson;
    // token = Preference.getString('token');
    try {
      logger.d("response from $url");
      final response = await http.delete(
        Uri.parse('$_baseUrl$url'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: token ?? '',
          'platform': Platform.isAndroid ? 'android' : 'iOS',
          'version':
              _versionString.isEmpty ? await _getAppVersion() : _versionString,
          'uid': userService?.baseUser?.uid,
        },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } finally {
      await metric.stop();
    }
    return responseJson;
  }

  @override
  Future<dynamic> patchData(
    String url, {
    Map<String, dynamic> body,
    String token,
  }) async {
    final HttpMetric metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();

    var responseJson;
    // token = Preference.getString('token');
    try {
      final response = await http.patch(
        Uri.parse(_baseUrl + url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: token != null ? token : '',
          'platform': Platform.isAndroid ? 'android' : 'iOS',
          'version':
              _versionString.isEmpty ? await _getAppVersion() : _versionString,
          'uid': userService?.baseUser?.uid,
        },
        body: body == null ? null : jsonEncode(body),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } finally {
      await metric.stop();
    }
    return responseJson;
  }

  @override
  dynamic returnResponse(http.Response response) {
    var responseJson = json.decode(response.body);
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        logger.d(response.body);
        throw BadRequestException(responseJson['message']);
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }

  Future<String> _getAppVersion() async {
    try {
      if (_versionString == null || _versionString.isEmpty) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        _versionString = '${packageInfo.buildNumber}';
      }
    } catch (e) {
      print(e);
    }
    _versionString = _versionString;
    return _versionString;
  }

  @override
  void setBaseUrl(String url) {
    _baseUrl = url;
  }
}
