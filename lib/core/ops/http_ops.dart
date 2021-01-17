import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class HttpModel extends ChangeNotifier{
  BaseUtil _baseUtil = locator<BaseUtil>(); //required to fetch client token
  final Log log = new Log('HttpModel');
  String homeuri = 'https://fello-team.web.app';

  Future<http.Response> postReferral(String userId, String referee) async{
    String idToken;
    if(_baseUtil != null && _baseUtil.firebaseUser != null) {
      idToken = (await _baseUtil.firebaseUser.getIdToken()).token;
      log.debug('Fetched user IDToken: ' + idToken);
    }
    try {
      return http.post(
          '$homeuri/validateReferral?uid=$userId&rid=$referee',
          headers: {HttpHeaders.authorizationHeader: 'Bearer $idToken'}
      );
    }catch(e) {
      log.error('Http post failed: ' + e.toString());
      return null;
    }
  }
}