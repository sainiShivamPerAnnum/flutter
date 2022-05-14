import 'dart:convert';
import 'dart:io';

import 'package:felloapp/core/service/notifier_services/user_service.dart';
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
  // String _baseUrl = 'http://028b-103-108-4-230.ngrok.io/fello-dev-station/asia-south1';
  String _baseUrl = 'https://' + FlavorConfig.instance.values.baseUriAsia;
  //"https://asia-south1-fello-dev-station.cloudfunctions.net";
  String _awssubUrl = FlavorConfig.isProduction()
      ? "https://2z48o79cm5.execute-api.ap-south-1.amazonaws.com/prod/"
      : "https://2je5zoqtuc.execute-api.ap-south-1.amazonaws.com/dev";
  String _awstxnUrl = FlavorConfig.isProduction()
      ? "https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod"
      : "https://hl4otla349.execute-api.ap-south-1.amazonaws.com/dev";
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
    bool isAwsSubUrl = false,
    bool isAwsTxnUrl = false,
  }) async {
    final HttpMetric metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();

    var responseJson;
    // token = Preference.getString('token');
    try {
      String queryString = '';
      String finalPath =
          "${getBaseUrl(isSubUrl: isAwsSubUrl, isTxnUrl: isAwsTxnUrl)}$url";
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
      logger.d("response from $finalPath");
      logger.d("Full url: $finalPath");
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
    String cBaseUrl,
    String token,
    bool isAuthTokenAvailable = true,
    bool isAwsSubUrl = false,
    bool isAwsTxnUrl = false,
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

      if (!isAuthTokenAvailable) _headers['x-api-key'] = 'QTp93rVNrUJ9nv7rXDDh';

      String _url =
          getBaseUrl(isSubUrl: isAwsSubUrl, isTxnUrl: isAwsTxnUrl) + url;

      if (cBaseUrl != null) _url = cBaseUrl + url;
      logger.d("response from $_url");

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
    bool isAwsSubUrl = false,
    bool isAwsTxnUrl = false,
  }) async {
    final HttpMetric metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Put);
    await metric.start();

    var responseJson;
    // token = Preference.getString('token');
    try {
      logger.d("response from $url");
      final response = await http.put(
        Uri.parse(
            getBaseUrl(isSubUrl: isAwsSubUrl, isTxnUrl: isAwsTxnUrl) + url),
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

  getBaseUrl({bool isSubUrl = false, bool isTxnUrl = false}) {
    if (isSubUrl)
      return _awssubUrl;
    else if (isTxnUrl)
      return _awstxnUrl;
    else
      return _baseUrl;
  }
}
