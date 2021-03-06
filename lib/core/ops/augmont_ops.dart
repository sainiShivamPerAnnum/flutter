import 'dart:convert';

import 'package:felloapp/core/model/AugGoldRates.dart';
import 'package:felloapp/core/model/UserAugmontDetail.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/util/augmont_api_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AugmontModel extends ChangeNotifier {
  final Log log = new Log('AugmontModel');
  DBModel _dbModel = locator<DBModel>();
  RazorpayModel _rzpGateway = locator<RazorpayModel>();
  final String defaultBaseUri =
      'https://ug0949ai64.execute-api.ap-south-1.amazonaws.com/dev';
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

  bool isInit() => (_apiKey != null);

  String _constructUid(String pan) => 'fello$pan';

  String _constructUsername(String mobile) => 'fello$mobile';

  Future<UserAugmontDetail> createUser(
      String mobile, String pan, String stateId) async {
    String _uid = _constructUid(pan);
    String _uname = _constructUsername(mobile);
    var _params = {
      CreateUser.fldMobile: mobile,
      CreateUser.fldID: _uid,
      CreateUser.fldUserName: _uname,
      CreateUser.fldStateId: stateId,
    };

    var _request = http.Request(
        'GET', Uri.parse(constructRequest(CreateUser.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[CreateUser.resStatusCode].toString());
      resMap["flag"] = QUERY_PASSED;

      return UserAugmontDetail.newUser(_uid, _uname, stateId);
    }
  }

  Future<AugmontRates> getRates() async {
    var _request =
        http.Request('GET', Uri.parse(constructRequest(GetRates.path, null)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[CreateUser.resStatusCode].toString());
      resMap["flag"] = QUERY_PASSED;

      return AugmontRates.fromMap(resMap);
    }
  }

  //
  Future<Map<String, dynamic>> initiateGoldPurchase(
      AugmontRates rates, double amount) async {

  }

  String constructRequest(String subPath, Map<String, String> params) {
    String _path = '$_baseUri/$subPath';
    if (params != null && params.length > 0) {
      String _p = '';
      if (params.length == 1) {
        _p = params.keys.elementAt(0) +
            '=' +
            Uri.encodeComponent(params.values.elementAt(0));
        _path = '$_path?$_p';
      } else {
        params.forEach((key, value) {
          _p = '$_p$key=$value&';
        });
        _p = _p.substring(0, _p.length - 1);
        _path = '$_path?$_p';
      }
    }
    return _path;
  }

  Future<Map<String, dynamic>> processResponse(
      http.StreamedResponse response) async {
    if (response == null) {
      log.error('response is null');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      log.error(
          'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if (response.statusCode == 502)
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "Augmont did not respond correctly"
        };
      else
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "Unknown error occurred while sending request"
        };
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if (res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "The entered data was not accepted"
        };
      }
      var rMap = json.decode(res);
      rMap[INTERNAL_FAIL_FLAG] = true;
      return rMap;
    } catch (e) {
      log.error('Failed to decode json');
      return null;
    }
  }

// Future<List<Map<String, dynamic>>> processRates(
//     http.StreamedResponse response) async {
//   if (response == null) {
//     log.error('response is null');
//   }
//   if (response.statusCode != 200 && response.statusCode != 201) {
//     log.error(
//         'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
//     if (response.statusCode == 502)
//       return null;
//     else
//       return null;
//   }
//   try {
//     String res = await response.stream.bytesToString();
//     log.debug(res);
//     if (res == null || res.isEmpty || res == "\"\"") {
//       log.error('Returned empty response');
//       return null;
//     }
//     List<dynamic> rList = json.decode(res);
//     List<Map<String, dynamic>> refList = new List();
//     rList.forEach((element) {
//       refList.add({
//         GetRates.resRates: element[GetRates.path.resBankName],
//         GetBankRedemptionDetail.resCombinedAccountDetails: element[GetBankRedemptionDetail.resCombinedAccountDetails],
//         GetBankRedemptionDetail.resCombinedBankDetails: element[GetBankRedemptionDetail.resCombinedBankDetails],
//       });
//     });
//     log.debug(refList.toString());
//     return refList;
//   } catch (e) {
//     log.error('Failed to decode json');
//     return null;
//   }
// }
}
