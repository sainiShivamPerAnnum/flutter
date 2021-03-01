import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class AugmontModel extends ChangeNotifier {
  final Log log = new Log('AugmontModel');
  DBModel _dbModel = locator<DBModel>();
  final String defaultBaseUri = ''; //TODO
  String _baseUri;
  String _apiKey;
  var headers;

  Future<bool> init() async {
    if (_dbModel == null) return false;
    Map<String, String> cMap = await _dbModel.getActiveAwsAugmontApiKey();
    if (cMap == null) return false;

    _baseUri = (cMap['baseuri'] == null || cMap['baseuri'].isEmpty)
        ? defaultBaseUri
        : cMap['baseuri'];
    _apiKey = cMap['key'];
    headers = {'x-api-key': _apiKey};
    return true;
  }
}