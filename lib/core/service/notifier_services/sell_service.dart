import 'package:felloapp/core/enums/sell_service_enum.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SellService extends PropertyChangeNotifier<SellServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _saveRepo = locator<SaveRepo>();
  final _txnService = locator<TransactionService>();

  bool _isKYCVerified = false;
  bool _isVPAVerified = false;
  bool _isOngoingTransaction = false;
  bool _isSellButtonVisible = false;

  bool get isKYCVerified => _isKYCVerified;
  bool get isVPAVerified => _isVPAVerified;
  bool get isOngoingTransaction => _isOngoingTransaction;
  bool get isSellButtonVisible => _isSellButtonVisible;

  set setKYCVerified(bool val) {
    _isKYCVerified = val;
    notifyListeners(SellServiceProperties.kycVerified);
  }

  set setVPAVerified(bool val) {
    _isVPAVerified = val;
    notifyListeners(SellServiceProperties.bankDetailsVerified);
  }

  set setOngoingTransaction(bool val) {
    _isOngoingTransaction = val;
    notifyListeners(SellServiceProperties.ongoingTransaction);
  }
  //Transaction - check last transaction status(TransactionService)

  init() async {
    verifyVPAAddress();
    verifyKYCStatus();
    verifyOngoingTransaction();
  }

  verifyVPAAddress() async {
    ApiResponse response =
        await _saveRepo.verifyVPAAddress(_userService.firebaseUser.uid);
    print(response.model);
    print(response.model['vpa'] != "");
    if ((response.code == 200) && (response.model['vpa'] != "")) {
      setVPAVerified = true;
      print(_isVPAVerified);
      _logger.d('vpa verified! $isVPAVerified');
    }
    print(_isVPAVerified);
  }

  verifyKYCStatus() {
    setKYCVerified = _userService.baseUser.isSimpleKycVerified;
    print(_isKYCVerified);
    _logger.d('kyc verified! $isKYCVerified');
  }

  verifyOngoingTransaction() async {
    await _txnService.updateTransactions();
    if (_txnService.txnList.length > 0) {
      setOngoingTransaction = _txnService.txnList
                  .where((element) => element.subType == 'WITHDRAWL')
                  .first
                  ?.tranStatus !=
              "COMPLETE" ??
          false;
    }
  }
}
