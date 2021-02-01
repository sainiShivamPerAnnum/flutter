import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';


/**
 * To get KYC firebase document
 * baseProvider.kycDetail =
    await dbProvider.getUserKycDetails(baseProvider.myUser.uid);
 *
 * To UPDATE KYC firebase document
 * await dbProvider.updateUserKycDetails(
    baseProvider.myUser.uid, baseProvider.kycDetail);
 * */
class KYCModel extends ChangeNotifier {
  final Log log = new Log('KYCModel');
  DBModel _dbModel = locator<DBModel>();
  final String defaultBaseUri = 'https://multi-channel-preproduction.signzy.tech';
  String _baseUri;
  String _apiKey;
  var headers;

  Future<bool> init() async {
    if (_dbModel == null) return false;
    Map<String, String> cMap = await _dbModel.getActiveSignzyApiKey();
    if (cMap == null) return false;

    _baseUri = (cMap['baseuri'] == null || cMap['baseuri'].isEmpty)
        ? defaultBaseUri
        : cMap['baseuri'];
    _apiKey = cMap['key'];
    headers = {
      'Content-Type': 'application/json',
      'Authorization': _apiKey
    };
    return true;
  }

  bool isInit() => (_apiKey != null);

  //Future<Map<String, dynamic>> createOnboardingObj() async{}

}