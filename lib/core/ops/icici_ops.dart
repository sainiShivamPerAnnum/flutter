import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:felloapp/util/icici_api_util.dart';

class ICICIModel extends ChangeNotifier{
  final Log log = new Log('ICICIModel');
  BaseUtil _baseUtil = locator<BaseUtil>(); //required to fetch client token
  DBModel _dbModel = locator<DBModel>();
  final String defaultBaseUri = 'https://r3bb6bx3p6.execute-api.ap-south-1.amazonaws.com/dev';
  String _baseUri;
  String _apiKey;

  Future<bool> init() async{
    if(_dbModel == null) return false;
    Map<String,String> cMap = await _dbModel.getActiveAwsApiKey();
    if(cMap == null) return false;

    _baseUri = (cMap['baseuri'] == null || cMap['baseuri'].isEmpty)?defaultBaseUri:cMap['baseuri'];
    _apiKey = cMap['key'];
    return true;
  }

  getTaxStatus() async{
    var headers = {
      'x-api-key': _apiKey
    };
    var request = http.Request('GET',
        Uri.parse(constructRequest(GetTaxStatus.path, null)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      log.debug(await response.stream.bytesToString());
    }
    else {
      log.error(response.reasonPhrase);
    }
  }

  getKycStatus(String panNumber) async{
    var headers = {
      'x-api-key': _apiKey
    };
    var request = http.Request('GET',
        Uri.parse(constructRequest(GetKycStatus.path, {GetKycStatus.fldPan: panNumber})));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      log.debug(await response.stream.bytesToString());
    }
    else {
      log.error(response.reasonPhrase);
    }
  }

  submitPanDetails(String panNumber, String fullName) async{
    var headers = {
      'x-api-key': _apiKey
    };
    var request = http.Request('GET',
        Uri.parse(constructRequest(SubmitPanDetail.path,
            {
              SubmitPanDetail.fldPan: panNumber,
              SubmitPanDetail.fldName: fullName
            })
        ));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      log.debug(await response.stream.bytesToString());
    }
    else {
      log.error(response.reasonPhrase);
    }
  }

  String constructRequest(String subPath, Map<String, String> params) {
    String _path = '$_baseUri/$subPath';
    if(params != null && params.length>0) {
      String _p = '';
      if(params.length == 1) {
        _p = params.keys.elementAt(0) + '=' + Uri.encodeComponent(params.values.elementAt(0));
        _path = '$_path?$_p';
      }else{
        params.forEach((key, value) {
          _p = '$_p$key=$value&';
        });
        _p = _p.substring(0, _p.length-2);
        _path = '$_path?$_p';
      }
    }
    return _path;
  }

}