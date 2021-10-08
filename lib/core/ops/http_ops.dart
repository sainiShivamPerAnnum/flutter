import 'dart:convert';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/core/model/signzy_pan/pan_verification_res_model.dart';
import 'package:felloapp/core/model/signzy_pan/signzy_identities.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';

class HttpModel extends ChangeNotifier {
  BaseUtil _baseUtil = locator<BaseUtil>(); //required to fetch client token
  final logger = locator<Logger>();
  static final String ASIA_BASE_URI = FlavorConfig.instance.values.baseUriAsia;
  static final String US_BASE_URI = FlavorConfig.instance.values.baseUriUS;

  ///Returns the number of tickets that need to be added to user's balance
  Future<int> postUserReferral(
      String userId, String referee, String userName) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return -1;
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    logger.d('Fetched user IDToken: ' + idToken);
    try {
      Uri _uri = Uri.https(US_BASE_URI, '/validateUserReferral',
          {'uid': userId, 'rid': referee, 'uname': userName});
      http.Response _response = await http.post(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      logger.d(_response.body);
      if (_response.statusCode == 200) {
        try {
          Map<String, dynamic> parsed = jsonDecode(_response.body);
          if (parsed != null && parsed['add_tickets_count'] != null) {
            try {
              logger.d(parsed['add_tickets_count'].toString());
              int userTicketUpdateCount =
                  BaseUtil.toInt(parsed['add_tickets_count']);
              return userTicketUpdateCount;
            } catch (ee) {
              return -1;
            }
          } else {
            return -1;
          }
        } catch (err) {
          logger.e('Failed to parse ticket update count');
          return -1;
        }
      } else {
        return -1;
      }
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
      return -1;
    }
  }

  //amount must be integer
  //sample url: https://us-central1-fello-d3a9c.cloudfunctions.net/razorpayops/dev/api/orderid?amount=121&notes=hellp
  Future<Map<String, dynamic>> generateRzpOrderId(
      double amount, String notes) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null || amount == null)
      return null;

    String idToken;
    idToken = await _baseUtil.firebaseUser.getIdToken();
    logger.d('Fetched user IDToken: ' + idToken);

    String amx = (amount * 100).round().toString();
    String _stage = FlavorConfig.instance.values.razorpayStage.value();
    Map<String, dynamic> queryMap = {'amount': amx};
    if (notes != null) queryMap['notes'] = Uri.encodeComponent(notes);

    final Uri _uri =
        Uri.https(US_BASE_URI, '/razorpayops/$_stage/api/orderid', queryMap);
    logger.d('URL: $_uri');

    try {
      http.Response response = await http.get(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
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
    if (_baseUtil == null ||
        _baseUtil.firebaseUser == null ||
        orderId == null ||
        paymentId == null) return null;

    String idToken;
    idToken = await _baseUtil.firebaseUser.getIdToken();
    logger.d('Fetched user IDToken: ' + idToken);

    String _stage = FlavorConfig.instance.values.razorpayStage.value();
    final Uri _uri = Uri.https(
        US_BASE_URI,
        '/razorpayops/$_stage/api/signature',
        {'orderid': orderId, 'payid': paymentId});
    logger.d('URL: $_uri');

    try {
      http.Response response = await http.get(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      logger.d(response.body);
      Map<String, dynamic> parsed = jsonDecode(response.body);
      //logger.d(parsed);
      return parsed;
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
      return null;
    }
  }

  Future<bool> registerPrizeClaim(
      String userId, double amount, PrizeClaimChoice claimChoice) async {
    if (userId == null || amount == null || claimChoice == null) return null;

    ///    '$US_BASE_URI/userTxnOps/api/registerPrizeClaim?userId=$userId&amount=$amount&redeemType=${claimChoice.value()}';
    final Uri _uri = Uri.https(
        US_BASE_URI, '/userTxnOps/api/registerPrizeClaim', {
      'userId': userId,
      'amount': '$amount',
      'redeemType': claimChoice.value()
    });
    logger.d('URL: $_uri');

    String idToken;
    idToken = await _baseUtil.firebaseUser.getIdToken();
    logger.d('Fetched user IDToken: ' + idToken);

    try {
      http.Response response = await http.post(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      logger.d(response.body);
      Map<String, dynamic> parsed = jsonDecode(response.body);
      logger.d(parsed.toString());
      if (response.statusCode == 200 &&
          parsed['flag'] != null &&
          parsed['flag'] == true) {
        logger.d('Action successful');
        return true;
      }
      return false;
    } catch (e) {
      logger.e('Http post failed: ' + e.toString());
      return false;
    }
  }

  ///Returns the number of tickets that need to be added to user's balance
  Future<bool> isEmailNotRegistered(String userId, String email) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return false;
    //get auth
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    logger.d('Fetched user IDToken: ' + idToken);

    //build request
    final Uri _uri =
        Uri.https(ASIA_BASE_URI, '/userSearch/dev/api/isemailregd');
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: 'Bearer $idToken'
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
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return false;
    //get auth
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    logger.d('Fetched user IDToken: ' + idToken);

    //build request
    final Uri _uri = Uri.https(ASIA_BASE_URI, '/userSearch/dev/api/ispanregd');
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: 'Bearer $idToken'
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
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return '';
    //get auth
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    logger.d('Fetched user IDToken: ' + idToken);

    //build request
    final Uri _uri = Uri.https(ASIA_BASE_URI, '/encoderops/api/encrypt');
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: 'Bearer $idToken'
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
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return '';
    //get auth
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    logger.d('Fetched user IDToken: ' + idToken);

    //build request
    final Uri _uri = Uri.https(ASIA_BASE_URI, '/encoderops/api/decrypt');
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      HttpHeaders.authorizationHeader: 'Bearer $idToken'
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
    if (_baseUtil == null || _baseUtil.firebaseUser == null)
      return {'flag': false, 'fail_msg': 'Your ticket could not be redeemed'};

    //add auth
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    logger.d('Fetched user IDToken: ' + idToken);

    try {
      Uri _uri = Uri.https(
          ASIA_BASE_URI,
          '/goldenTicketOps/prod/api/redeemGoldenTicket',
          {'user_id': userId, 'gt_id': goldenTicketId});
      //post request
      http.Response _response = await http.post(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      logger.d(_response.body);
      if (_response.statusCode == 200) {
        //redemption successful
        try {
          Map<String, dynamic> parsed = jsonDecode(_response.body);
          if (parsed != null &&
              parsed['gtck_count'] != null &&
              parsed['gamt_win'] != null) {
            try {
              logger.d(parsed['gtck_count'].toString());
              logger.d(parsed['gamt_win'].toString());
              int goldenTckRewardCount = BaseUtil.toInt(parsed['gtck_count']);
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

  Future<bool> verifyPanSignzy(
      {String baseUrl,
      String panNumber,
      String panName,
      String authToken,
      String patronId}) async {
    SignzyIdentities _signzyIdentities;
    bool _isPanVerified = false;
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
            _isPanVerified = true;
          }
        } else if (res.statusCode == 404) {
          throw Exception('PAN not found');
        } else {
          throw Exception('Failed to get response from Signzy Verification Api');
        }
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to get response from Signzy Identity Api');
    }

    return _isPanVerified;
  }
}
