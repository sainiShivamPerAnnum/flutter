import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ICICIModel extends ChangeNotifier{
  BaseUtil _baseUtil = locator<BaseUtil>(); //required to fetch client token
  final Log log = new Log('ICICIModel');
  final String baseUri = 'https://r3bb6bx3p6.execute-api.ap-south-1.amazonaws.com/dev/';
  String _apiKey;

  init(BuildContext context) {
    String awsKeyIndex = BaseUtil.remoteConfig.getString('aws_key_index');
    if(awsKeyIndex == null || awsKeyIndex.isEmpty)awsKeyIndex = '1';
    int keyIndex = 1;
    try {
      keyIndex = int.parse(awsKeyIndex);
    }catch(e) {
      log.error('Aws Index key parsing failed: ' + e.toString());
      keyIndex = 1;
    }
  }
}