import 'dart:convert';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpModel extends ChangeNotifier {
  BaseUtil _baseUtil = locator<BaseUtil>(); //required to fetch client token
  final Log log = new Log('HttpModel');
  static const String WRAPPED_BASE_URI = 'fello-team.web.app';
  static const String ASIA_BASE_URI =
      'asia-south1-fello-d3a9c.cloudfunctions.net';
  static const String US_BASE_URI =
      'us-central1-fello-d3a9c.cloudfunctions.net';

  ///Returns the number of tickets that need to be added to user's balance
  Future<int> postUserReferral(
      String userId, String referee, String userName) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return -1;
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    log.debug('Fetched user IDToken: ' + idToken);
    try {
      Uri _uri = Uri.https(WRAPPED_BASE_URI, '/validateUserReferral',
          {'uid': userId, 'rid': referee, 'uname': userName});
      http.Response _response = await http.post(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      log.debug(_response.body);
      if (_response.statusCode == 200) {
        try {
          Map<String, dynamic> parsed = jsonDecode(_response.body);
          if (parsed != null && parsed['add_tickets_count'] != null) {
            try {
              log.debug(parsed['add_tickets_count'].toString());
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
          log.error('Failed to parse ticket update count');
          return -1;
        }
      } else {
        return -1;
      }
    } catch (e) {
      log.error('Http post failed: ' + e.toString());
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
    log.debug('Fetched user IDToken: ' + idToken);

    String amx = (amount * 100).round().toString();
    String _stage = Constants.activeRazorpayStage.value();
    Map<String, dynamic> queryMap = {'amount': amx};
    if (notes != null) queryMap['notes'] = Uri.encodeComponent(notes);

    final Uri _uri =
        Uri.https(US_BASE_URI, '/razorpayops/$_stage/api/orderid', queryMap);
    log.debug('URL: $_uri');

    try {
      http.Response response = await http.get(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      log.debug(response.body);
      Map<String, dynamic> parsed = jsonDecode(response.body);
      //log.debug(parsed);
      return parsed;
    } catch (e) {
      log.error('Http post failed: ' + e.toString());
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
    log.debug('Fetched user IDToken: ' + idToken);

    String _stage = Constants.activeRazorpayStage.value();
    final Uri _uri = Uri.https(
        US_BASE_URI,
        '/razorpayops/$_stage/api/signature',
        {'orderid': orderId, 'payid': paymentId});
    log.debug('URL: $_uri');

    try {
      http.Response response = await http.get(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      log.debug(response.body);
      Map<String, dynamic> parsed = jsonDecode(response.body);
      //log.debug(parsed);
      return parsed;
    } catch (e) {
      log.error('Http post failed: ' + e.toString());
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
    log.debug('URL: $_uri');

    String idToken;
    idToken = await _baseUtil.firebaseUser.getIdToken();
    log.debug('Fetched user IDToken: ' + idToken);

    try {
      http.Response response = await http.post(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      log.debug(response.body);
      Map<String, dynamic> parsed = jsonDecode(response.body);
      log.debug(parsed.toString());
      if (response.statusCode == 200 &&
          parsed['flag'] != null &&
          parsed['flag'] == true) {
        log.debug('Action successful');
        return true;
      }
      return false;
    } catch (e) {
      log.error('Http post failed: ' + e.toString());
      return false;
    }
  }

  ///Returns the number of tickets that need to be added to user's balance
  Future<bool> isEmailNotRegistered(String userId, String email) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return false;
    //get auth
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    log.debug('Fetched user IDToken: ' + idToken);

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
          log.error('Failed to parse email regd boolean field');
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      log.error('Http post failed: ' + e.toString());
      return false;
    }
  }

  Future<bool> isPanRegistered(String pan) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return false;
    //get auth
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    log.debug('Fetched user IDToken: ' + idToken);

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
          log.error('Failed to parse pan regd booleand field');
          return false;
        }
      } else {
        log.error("Response code: ${_response.statusCode}");
        return false;
      }
    } catch (e) {
      log.error('Http post failed: ' + e.toString());
      return false;
    }
  }

  ///encrypt text - used for pan
  Future<String> encryptText(String encText, int encVersion) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return '';
    //get auth
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    log.debug('Fetched user IDToken: ' + idToken);

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
          log.error('Failed to encryption $err');
          return '';
        }
      } else {
        return '';
      }
    } catch (e) {
      log.error('Http GET failed: ' + e.toString());
      return '';
    }
  }

  ///decrypt text - used for pan
  Future<String> decryptText(String decText, int decVersion) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return '';
    //get auth
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    log.debug('Fetched user IDToken: ' + idToken);

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
          log.error('Failed to decryption $err');
          return '';
        }
      } else {
        return '';
      }
    } catch (e) {
      log.error('Http GET failed: ' + e.toString());
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
    log.debug('Fetched user IDToken: ' + idToken);

    try {
      Uri _uri = Uri.https(
          ASIA_BASE_URI,
          '/goldenTicketOps/prod/api/redeemGoldenTicket',
          {'user_id': userId, 'gt_id': goldenTicketId});
      //post request
      http.Response _response = await http.post(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      log.debug(_response.body);
      if (_response.statusCode == 200) {
        //redemption successful
        try {
          Map<String, dynamic> parsed = jsonDecode(_response.body);
          if (parsed != null &&
              parsed['gtck_count'] != null &&
              parsed['gamt_win'] != null) {
            try {
              log.debug(parsed['gtck_count'].toString());
              log.debug(parsed['gamt_win'].toString());
              int goldenTckRewardCount = BaseUtil.toInt(parsed['gtck_count']);
              int goldenTckRewardAmt = BaseUtil.toInt(parsed['gamt_win']);
              return {
                'flag': true,
                'count': goldenTckRewardCount,
                'amt': goldenTckRewardAmt
              };
            } catch (ee) {
              log.error('$ee');
            }
          }
        } catch (err) {
          log.error('Failed to parse ticket update count');
          log.error('$err');
        }
      } else {
        try {
          Map<String, dynamic> parsed = jsonDecode(_response.body);
          if (parsed != null && parsed['msg'] != null) {
            try {
              log.debug(parsed['msg'].toString());
              return {'flag': false, 'fail_msg': parsed['msg']};
            } catch (ee) {
              return {
                'flag': false,
                'fail_msg': 'Your ticket could not be redeemed'
              };
            }
          }
        } catch (err) {
          log.error('Failed to parse ticket update count');
          log.error('$err');
        }
      }
    } catch (e) {
      log.error('Http post failed: ' + e.toString());
    }
    return {'flag': false, 'fail_msg': 'Your ticket could not be redeemed'};
  }
}
