import 'package:felloapp/core/enums/sell_service_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SellService extends PropertyChangeNotifier<SellServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _saveRepo = locator<SaveRepo>();
  DBModel _dbModel = locator<DBModel>();
  final _paymentRepo = locator<PaymentRepository>();

  bool _isKYCVerified = false;
  bool _isVPAVerified = false;
  bool _isGoldSaleActive = false;
  bool _isOngoingTransaction = false;
  bool _isLockInReached = false;
  bool _isSellButtonVisible = false;

  bool get isKYCVerified => _isKYCVerified;
  bool get isVPAVerified => _isVPAVerified;
  bool get isGoldSaleActive => _isGoldSaleActive;
  bool get isOngoingTransaction => _isOngoingTransaction;
  bool get isLockInReached => _isLockInReached;
  bool get isSellButtonVisible => _isSellButtonVisible;

  set setKYCVerified(bool val) {
    _isKYCVerified = val;
    notifyListeners(SellServiceProperties.kycVerified);
  }

  set setVPAVerified(bool val) {
    _isVPAVerified = val;
    notifyListeners(SellServiceProperties.bankDetailsVerified);
  }

  set setGoldSaleActive(bool val) {
    _isGoldSaleActive = val;
    notifyListeners(SellServiceProperties.augmontSellDisabled);
  }
  //AugmontService - saleDisabled

  set setLockInReached(bool val) {
    _isLockInReached = val;
    notifyListeners(SellServiceProperties.reachedLockIn);
  }
  //Lock in - sellVM(witharwable quantity)

  set setOngoingTransaction(bool val) {
    _isOngoingTransaction = val;
    notifyListeners(SellServiceProperties.ongoingTransaction);
  }
  //Transaction - check last transaction status(TransactionService)

  init() {
    verifyVPAAddress();
    verifyKYCStatus();
    verifyAugmontSellStatus();
    verifyLockIn();
  }

  verifyVPAAddress() async {
    ApiResponse response =
        await _saveRepo.verifyVPAAddress(_userService.firebaseUser.uid);
    if (response.code == 200) {
      setVPAVerified = true;
      print(_isVPAVerified);
      _logger.d('vpa verified! $isVPAVerified');
    }
  }

  verifyKYCStatus() {
    setKYCVerified = _userService.isSimpleKycVerified;
    print(_isKYCVerified);
    _logger.d('kyc verified! $isKYCVerified');
  }

  verifyAugmontSellStatus() async {
    setGoldSaleActive = await _dbModel.isAugmontSellDisabled();
  }

  verifyOngoingTransaction() {}

  verifyLockIn() async {
    var response = await _paymentRepo.getWithdrawableAugGoldQuantity();
    double lockIn = response.model;
    if (lockIn > 0) {
      setLockInReached = true;
    } else {
      setLockInReached = false;
    }
  }

  bool getSellButtonVisibility() {
    print(_isKYCVerified && _isVPAVerified);
    //Both KYC and VPA is verified
    if (_isKYCVerified && _isVPAVerified) {
      return true;
    }
    if (_isKYCVerified && _isVPAVerified) {
      if (_isGoldSaleActive) {
        return true;
      }
      if (_isLockInReached) {
        return true;
      }
      if (_isOngoingTransaction) {
        return true;
      }
      return true;
    }
    return false;
  }
}
