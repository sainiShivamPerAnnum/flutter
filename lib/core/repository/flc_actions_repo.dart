import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class FlcActionsRepo {
  final _userService = locator<UserService>();
  final _apiPaths = locator<ApiPath>();
  final _api = locator<Api>();
  final _logger = locator<Logger>();

  Future<String> _getBearerToken() async{
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  Future<ApiResponse<FlcModel>> getCoinBalance() async {
    try {
      final DocumentSnapshot response =
          await _api.getUserCoinWalletDocById(_userService.baseUser.uid);
      _logger.d(response.data().toString());
      return ApiResponse(model: FlcModel.fromMap(response.data()), code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<FlcModel>> substractFlc(int flcAmount) async {
    Map<String, dynamic> _body = {
      "user_id": _userService.baseUser.uid,
      "flc_amount": flcAmount,
      "type": "SUBTRACT",
      "sub_type": "GM_CRIC2020"
    };
    _logger.d("Substract FLC : $_body");
    try {
      final String _bearer = await _getBearerToken();
      final response = await APIService.instance
          .postData(_apiPaths.kSubstractFlcPreGameApi, body: _body, token: _bearer);
      _logger.d(response.toString());
      FlcModel _flcModel = FlcModel.fromMap(response);
      return ApiResponse(model: _flcModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<FlcModel>> completeUserDeposit(int flcAmount) async {
    Map<String, dynamic> _body = {
      "user_id": _userService.baseUser.uid,
      "flc_amount": flcAmount,
      "type": "SUBTRACT",
      "sub_type": "GM_CRIC2020"
    };
    _logger.d("completeUserDeposit : $_body");
    try {
      final String _bearer = await _getBearerToken();
      final response = await APIService.instance
          .postData(_apiPaths.kDepositComplete, body: _body, token: _bearer);
      _logger.d(response.toString());
      FlcModel _flcModel = FlcModel.fromMap(response);
      return ApiResponse(model: _flcModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<FlcModel>> buyTambolaTickets(
      {int cost, int noOfTickets, String userUid}) async {
    Map<String, dynamic> _body = {
      "user_id": userUid,
      "cost": cost,
      "no_of_tickets": noOfTickets,
    };
    _logger.d("buyTambolaTickets : $_body");
    try {
      final String _bearer = await _getBearerToken();
      final response = await APIService.instance
          .postData(_apiPaths.kBuyTambola, body: _body, token: _bearer);
      _logger.d(response.toString());
      FlcModel _flcModel = FlcModel.fromMap(response);
      return ApiResponse(model: _flcModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
