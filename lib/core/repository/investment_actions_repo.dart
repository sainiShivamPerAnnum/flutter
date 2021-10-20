import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/invest_deposit_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class InvestmentActions {
  final _userService = locator<UserService>();
  final _apiPaths = locator<ApiPath>();
  final _api = locator<Api>();
  final _logger = locator<Logger>();

  Future<ApiResponse<InvestmentDepositModel>> initiateUserDeposit(String txnId,
      Map<String, dynamic> initAugMap) async {

    Map<String, dynamic> _body = {
      'user_id': _userService.baseUser.uid,

    };
    _logger.d("completeUserDeposit : $_body");
    try {
      final response = await APIService.instance
          .postData(_apiPaths.kDepositComplete, body: _body);
      _logger.d(response.toString());
      InvestmentDepositModel _investmentDepositModel =
      InvestmentDepositModel.fromMap(response);
      return ApiResponse(model: _investmentDepositModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<InvestmentDepositModel>> completeUserDeposit(String txnId,
      Map<String, dynamic> rzpUpdates, Map<String, dynamic> augUpdates) async {

    Map<String, dynamic> _body = {
      'user_id': _userService.baseUser.uid,
      'amount': '100',
      'rzp_map[rOrderId]': '14703jj124222',
      'rzp_map[rPaymentId]': '111222333',
      'rzp_map[rStatus]': 'COMPLETED',
      'aug_map[aAugTranId]': '111AUG222TRAN333',
      'aug_map[aBlockId]': '212BLOCKID',
      'aug_map[aGoldBalance]': '0.100',
      'aug_map[aPaymode]': 'rzp',
      'aug_map[aGoldInTxn]': '0.02047513101426658',
      'aug_map[aTranId]': 'v5tamXBimFT7MySy1caQYn',
      'aug_map[aLockPrice]': '4579.2',
      'note': 'THIS IS DEPOSIT AND PENDING',
      'tran_id': 'o3bbtpotNhUB2qaumxIc'
    };
    _logger.d("completeUserDeposit : $_body");
    try {
      final response = await APIService.instance
          .postData(_apiPaths.kDepositComplete, body: _body);
      _logger.d(response.toString());
      InvestmentDepositModel _investmentDepositModel =
          InvestmentDepositModel.fromMap(response);
      return ApiResponse(model: _investmentDepositModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<InvestmentDepositModel>> cancelUserDeposit(String txnId) async {

    Map<String, dynamic> _body = {
      'user_id': _userService.baseUser.uid,
    };
    _logger.d("completeUserDeposit : $_body");
    try {
      final response = await APIService.instance
          .postData(_apiPaths.kDepositComplete, body: _body);
      _logger.d(response.toString());
      InvestmentDepositModel _investmentDepositModel =
      InvestmentDepositModel.fromMap(response);
      return ApiResponse(model: _investmentDepositModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
