import 'dart:convert';
import 'dart:io';

import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpModel extends ChangeNotifier {
  final _userService = locator<UserService>();
  final logger = locator<CustomLogger>();

  final Log log = new Log('HttpModel');
  static final String ASIA_BASE_URI = FlavorConfig.instance.values.baseUriAsia;
  static final String US_BASE_URI = FlavorConfig.instance.values.baseUriUS;
  static final String _stage = FlavorConfig.getStage();

  void init() {
    if (_userService == null || _userService.idToken == null) {
      logger.i("Null received from user service for IdToken");
      return;
    }
    logger.d("Https Ops initialized");
  }

  Future<String> getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    logger.d(token);

    return token;
  }

  ///Returns the number of tickets that need to be added to user's balance
  Future<bool> postUserReferral(
    String userId,
    String referee,
    String userName,
  ) async {
    try {
      String _stage = FlavorConfig.getStage();
      Map<String, dynamic> _params = {
        'uid': userId,
        'rid': referee,
        'uname': userName
      };

      String _bearer = await getBearerToken();
      Uri _uri = Uri.https(
          ASIA_BASE_URI, '/referralOps/$_stage/api/v2/validate', _params);
      http.Response _response = await http.post(_uri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_bearer'});
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

  Future<Map<String, dynamic>> registerPrizeClaim(String userId,
      String userName, double amount, PrizeClaimChoice claimChoice) async {
    if (userId == null || amount == null || claimChoice == null) return null;

    final Uri _uri =
        Uri.https(US_BASE_URI, '/userTxnOps/$_stage/api/prize/claim', {
      'userId': userId,
      'userName': userName,
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
        return {'status': true};
      } else {
        return {
          'status': false,
          'message': parsed['message'] ??
              'Operation failed. Please try again in sometime'
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
}
