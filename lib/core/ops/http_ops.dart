import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:felloapp/util/credentials_stage.dart';
import 'dart:io';
import 'dart:convert';

class HttpModel extends ChangeNotifier {
  BaseUtil _baseUtil = locator<BaseUtil>(); //required to fetch client token
  final Log log = new Log('HttpModel');
  static const String _homeuri = 'https://fello-team.web.app';
  static const String _rzphomeuri =
      'https://us-central1-fello-d3a9c.cloudfunctions.net/razorpayops';
  static const String _userTxnOpsUri =
      'https://us-central1-fello-d3a9c.cloudfunctions.net/userTxnOps';

  ///Returns the number of tickets that need to be added to user's balance
  Future<int> postUserReferral(
      String userId, String referee, String userName) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null) return -1;
    String idToken = await _baseUtil.firebaseUser.getIdToken();
    log.debug('Fetched user IDToken: ' + idToken);
    try {
      http.Response _response = await http.post(
          '$_homeuri/validateUserReferral?uid=$userId&rid=$referee&uname=$userName',
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
    String _uri = '$_rzphomeuri/$_stage/api/orderid?amount=$amx';
    if (notes != null) _uri = _uri + '&notes=${Uri.encodeComponent(notes)}';
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
    String _uri =
        '$_rzphomeuri/$_stage/api/signature?orderid=$orderId&payid=$paymentId';
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
      String userId, double amount, PrizeClaimChoice claimChoice) async{
    if (userId == null || amount == null || claimChoice == null) return null;
    String _uri =
        '$_userTxnOpsUri/api/registerPrizeClaim?userId=$userId&amount=$amount&redeemType=${claimChoice.value()}';
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
      if(response.statusCode == 200 && parsed['flag'] != null && parsed['flag'] == true) {
        log.debug('Action successful');
        return true;
      }
      return false;
    } catch (e) {
      log.error('Http post failed: ' + e.toString());
      return false;
    }
  }
}

