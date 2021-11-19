import 'dart:convert';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/signzy_pan/pan_verification_res_model.dart';
import 'package:felloapp/core/model/signzy_pan/signzy_identities.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HttpModel extends ChangeNotifier {
  final _userService = locator<UserService>();
  final logger = locator<Logger>();

  final Log log = new Log('HttpModel');
  static final String ASIA_BASE_URI = FlavorConfig.instance.values.baseUriAsia;
  static final String US_BASE_URI = FlavorConfig.instance.values.baseUriUS;
  static final String _stage = FlavorConfig.getStage();

  void init() {
    if (_userService == null || _userService.idToken == null) {
      logger.e("Null received from user service for IdToken");
      return;
    }
    logger.d("Https Ops initialized");
  }

  Future<String> getBearerToken() async{
    String token = await _userService.firebaseUser.getIdToken();
    logger.d(token);

    return token;
  }

  ///Returns the number of tickets that need to be added to user's balance
  Future<bool> postUserReferral(
      String userId, String referee, String userName) async {
    try {
      String _stage = FlavorConfig.getStage();
      Map<String, dynamic> _params = {
        'uid': userId,
        'rid': referee,
        'uname': userName
      };

      String _bearer = await getBearerToken();
      Uri _uri = Uri.https(
          ASIA_BASE_URI, '/referralOps/$_stage/api/validate', _params);
      http.Response _response = await http.post(_uri, headers: {HttpHeaders.authorizationHeader: 'Bearer $_bearer'});
      logger.d(_response.body);
      if (_response.statusCode == 200) {
        try {
          Map<String, dynamic> parsed = jsonDecode(_response.body);
          if (parsed != null && parsed['status'] != null) {
            try {
              return true;
            } catch (ee) {
              return false;
            }
          } else {
            return false;
          }
        } catch (err) {
          logger.e('Failed to parse ticket update count');
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
      return false;
    }
  }

  //amount must be integer
  //sample url: https://us-central1-fello-d3a9c.cloudfunctions.net/razorpayops/dev/api/orderid?amount=121&notes=hellp
  Future<Map<String, dynamic>> generateRzpOrderId(
      double amount, String notes, String noteDetails) async {
    String amx = (amount * 100).round().toString();
    String _stage = FlavorConfig.instance.values.razorpayStage.value();
    Map<String, dynamic> queryMap = {'amount': amx};
    if (notes != null) queryMap['notes'] = Uri.encodeComponent(notes);
    if (noteDetails != null) queryMap['notes_detail'] = Uri.encodeComponent(noteDetails);

    final Uri _uri =
        Uri.https(US_BASE_URI, '/razorpayops/$_stage/api/orderid', queryMap);
    logger.d('URL: $_uri');

    String _bearer = await getBearerToken();
    try {
      http.Response response = await http.get(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_bearer'});
      logger.d(response.body);
      Map<String, dynamic> parsed = jsonDecode(response.body);
      //logger.d(parsed);
      return parsed;
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> generateRzpSignature(
      String orderId, String paymentId) async {
    String _stage = FlavorConfig.instance.values.razorpayStage.value();
    final Uri _uri = Uri.https(
        US_BASE_URI,
        '/razorpayops/$_stage/api/signature',
        {'orderid': orderId, 'payid': paymentId});
    logger.d('URL: $_uri');

    String _bearer = await getBearerToken();
    try {
      http.Response response = await http.get(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_bearer'});
      logger.d(response.body);
      Map<String, dynamic> parsed = jsonDecode(response.body);
      //logger.d(parsed);
      return parsed;
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> registerPrizeClaim(
      String userId, double amount, PrizeClaimChoice claimChoice) async {
    if (userId == null || amount == null || claimChoice == null) return null;

    final Uri _uri = Uri.https(
        US_BASE_URI, '/userTxnOps/$_stage/api/prize/claim', {
      'userId': userId,
      'amount': '$amount',
      'redeemType': claimChoice.value()
    });
    logger.d('URL: $_uri');

    String _bearer = await getBearerToken();
    try {
      http.Response response = await http.post(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_bearer'});
      logger.d(response.body);
      Map<String, dynamic> parsed = jsonDecode(response.body);
      logger.d(parsed.toString());
      if (response.statusCode == 200 &&
          parsed['flag'] != null &&
          parsed['flag'] == true) {
        logger.d('Action successful');
        return {
          'status': true
        };
      }
      else {
        return {
          'status': false,
          'message': parsed['message']??'Operation failed. Please try again in sometime'
        };
      }
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
      return {
        'status': false,
        'message': 'Operation failed. Please try again in sometime'
      };
    }
  }

  ///Returns the number of tickets that need to be added to user's balance
  Future<bool> isEmailNotRegistered(String userId, String email) async {
    //build request
    final Uri _uri =
        Uri.https(ASIA_BASE_URI, '/userSearch/dev/api/isemailregd');
    String _bearer = await getBearerToken();
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: 'Bearer $_bearer'
    };
    var request = http.Request('POST', _uri);
    request.bodyFields = {'uid': userId, 'email': email};
    request.headers.addAll(headers);

    try {
      http.StreamedResponse _response = await request.send();
      if (_response.statusCode == 200) {
        try {
          Map<String, dynamic> parsed =
              jsonDecode(await _response.stream.bytesToString());
          return !(parsed != null && parsed['flag'] != null && parsed['flag']);
        } catch (err) {
          logger.e('Failed to parse email regd boolean field');
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
      return false;
    }
  }

  Future<bool> isPanRegistered(String pan) async {
    //build request
    final Uri _uri =
        Uri.https(ASIA_BASE_URI, '/userSearch/$_stage/api/ispanregd');
    String _bearer = await getBearerToken();
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: 'Bearer $_bearer'
    };
    var request = http.Request('POST', _uri);
    request.bodyFields = {'pan': pan};
    request.headers.addAll(headers);
    try {
      http.StreamedResponse _response = await request.send();
      if (_response.statusCode == 200) {
        try {
          Map<String, dynamic> parsed =
              jsonDecode(await _response.stream.bytesToString());
          return (parsed != null && parsed['flag'] != null && parsed['flag']);
        } catch (err) {
          logger.e('Failed to parse pan regd booleand field');
          return false;
        }
      } else {
        logger.e("Response code: ${_response.statusCode}");
        return false;
      }
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
      return false;
    }
  }

  ///encrypt text - used for pan
  Future<String> encryptText(String encText, int encVersion) async {
    //build request
    final Uri _uri =
        Uri.https(ASIA_BASE_URI, '/encoderops/$_stage/api/encrypt');
    String _bearer = await getBearerToken();
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: 'Bearer $_bearer'
    };
    var request = http.Request('POST', _uri);
    request.bodyFields = {'etext': encText, 'eversion': encVersion.toString()};
    request.headers.addAll(headers);

    try {
      http.StreamedResponse _response = await request.send();
      if (_response.statusCode == 200) {
        try {
          Map<String, dynamic> parsed =
              jsonDecode(await _response.stream.bytesToString());
          String resText = (parsed != null) ? parsed['value'] : '';
          return (resText != null) ? resText : '';
        } catch (err) {
          logger.e('Failed to encryption $err');
          return '';
        }
      } else {
        return '';
      }
    } catch (e) {
      logger.e('Http GET failed: ' + e.toString());
      return '';
    }
  }

  ///decrypt text - used for pan
  Future<String> decryptText(String decText, int decVersion) async {
    //build request
    final Uri _uri =
        Uri.https(ASIA_BASE_URI, '/encoderops/$_stage/api/decrypt');
    String _bearer = await getBearerToken();
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: 'Bearer $_bearer'
    };
    var request = http.Request('POST', _uri);
    request.bodyFields = {'dtext': decText, 'dversion': decVersion.toString()};
    request.headers.addAll(headers);

    try {
      http.StreamedResponse _response = await request.send();
      if (_response.statusCode == 200) {
        try {
          Map<String, dynamic> parsed =
              jsonDecode(await _response.stream.bytesToString());
          String resText = (parsed != null) ? parsed['value'] : '';
          return (resText != null) ? resText : '';
        } catch (err) {
          logger.e('Failed to decryption $err');
          return '';
        }
      } else {
        return '';
      }
    } catch (e) {
      logger.e('Http GET failed: ' + e.toString());
      return '';
    }
  }

  ///Returns:
  ///{flag: B,
  ///count: X,
  ///fail_msg: Y}
  Future<Map<String, dynamic>> postGoldenTicketRedemption(
      String userId, String goldenTicketId) async {
    try {
      Uri _uri = Uri.https(
          ASIA_BASE_URI,
          '/goldenTicketOps/$_stage/api/redeemGoldenTicket',
          {'userId': userId, 'gtId': goldenTicketId});
      //post request
      String _bearer = await getBearerToken();
      http.Response _response = await http.post(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_bearer'});
      logger.d(_response.body);
      if (_response.statusCode == 200) {
        //redemption successful
        try {
          Map<String, dynamic> parsed = jsonDecode(_response.body);
          if (parsed != null &&
              parsed['gflc_count'] != null &&
              parsed['gamt_win'] != null) {
            try {
              logger.d(parsed['gflc_count'].toString());
              logger.d(parsed['gamt_win'].toString());
              int goldenTckRewardCount = BaseUtil.toInt(parsed['gflc_count']);
              int goldenTckRewardAmt = BaseUtil.toInt(parsed['gamt_win']);
              return {
                'flag': true,
                'count': goldenTckRewardCount,
                'amt': goldenTckRewardAmt
              };
            } catch (ee) {
              logger.e('$ee');
            }
          }
        } catch (err) {
          logger.e('Failed to parse ticket update count');
          logger.e('$err');
        }
      } else {
        try {
          Map<String, dynamic> parsed = jsonDecode(_response.body);
          if (parsed != null && parsed['msg'] != null) {
            try {
              logger.d(parsed['msg'].toString());
              return {'flag': false, 'fail_msg': parsed['msg']};
            } catch (ee) {
              return {
                'flag': false,
                'fail_msg': 'Your ticket could not be redeemed'
              };
            }
          }
        } catch (err) {
          logger.e('Failed to parse ticket update count');
          logger.e('$err');
        }
      }
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
    }
    return {'flag': false, 'fail_msg': 'Your ticket could not be redeemed'};
  }

  Future<ApiResponse<PanVerificationResModel>> verifyPanSignzy(
      {String baseUrl,
      String panNumber,
      String panName,
      String authToken,
      String patronId}) async {
    SignzyIdentities _signzyIdentities;

    //add base url for signzy apis
    // String baseUrl = 'https://preproduction.signzy.tech/api/v2/';
    //testing pan with signy verification API

    //Hit identities api to get accessToken and ID
    var headers = {
      'Authorization': authToken,
      'Content-Type': 'application/json'
    };

    var identityBody = jsonEncode({
      "type": "individualPan",
      "email": "admin@signzy.com",
      "callbackUrl": "https://fello.in/"
    });

    String _identitiesUri = baseUrl + '/patrons/$patronId/identities';

    try {
      final response = await http
          .post(Uri.parse(_identitiesUri), headers: headers, body: identityBody)
          .catchError((message) {
        logger.e(message);
      });
      logger.d(response.body);

      if (response.statusCode == 200) {
        _signzyIdentities =
            SignzyIdentities.fromJson(jsonDecode(response.body));

        //Use Access token and id to hit PAN Verification Prod API
        String panVerificationUrl = '$baseUrl/snoops';

        var panVerificationBody = jsonEncode({
          "service": "Identity",
          "itemId": _signzyIdentities.id,
          "task": "verification",
          "accessToken": _signzyIdentities.accessToken,
          "essentials": {"number": panNumber, "name": panName, "fuzzy": "true"}
        });

        final res = await http.post(Uri.parse(panVerificationUrl),
            headers: headers, body: panVerificationBody);

        logger.d("Hitting verification api");
        logger.d(res.body);

        if (res.statusCode == 200) {
          PanVerificationResModel _panVerificationResModel =
              PanVerificationResModel.fromJson(json.decode(res.body));
          if (_panVerificationResModel.response.result.verified) {
            return ApiResponse(model: _panVerificationResModel, code: 200);
          }
        } else if (res.statusCode == 404) {
          throw Exception('PAN not found');
        } else {
          throw Exception('Failed to get response from Signz Verification Api');
        }
      }
      return ApiResponse.withError(
          "Failed to get response from Signzy Identity Api", 400);
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to get response from Signzy Identity Api');
    }
  }
}
