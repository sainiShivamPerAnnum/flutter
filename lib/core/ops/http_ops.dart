import 'package:felloapp/base_util.dart';
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

  Future<http.Response> postReferral(String userId, String referee) async {
    String idToken;
    if (_baseUtil != null && _baseUtil.firebaseUser != null) {
      idToken = await _baseUtil.firebaseUser.getIdToken();
      log.debug('Fetched user IDToken: ' + idToken);
      try {
        return http.post('$_homeuri/validateReferral?uid=$userId&rid=$referee',
            headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'});
      } catch (e) {
        log.error('Http post failed: ' + e.toString());
        return null;
      }
    } else
      return null;
  }

  //amount must be integer
  //sample url: https://us-central1-fello-d3a9c.cloudfunctions.net/razorpayops/dev/api/orderid?amount=121&notes=hellp
  Future<Map<String, dynamic>> generateRzpOrderId(
      int amount, String notes) async {
    if (_baseUtil == null || _baseUtil.firebaseUser == null || amount == null)
      return null;

    String idToken;
    idToken = await _baseUtil.firebaseUser.getIdToken();
    log.debug('Fetched user IDToken: ' + idToken);

    String _stage = BaseUtil.activeRazorpayStage.value();
    String _uri = '$_rzphomeuri/$_stage/api/orderid?amount=$amount';
    if (notes != null) _uri = _uri + '&notes=$notes';
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

    String _stage = BaseUtil.activeRazorpayStage.value();
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
}
