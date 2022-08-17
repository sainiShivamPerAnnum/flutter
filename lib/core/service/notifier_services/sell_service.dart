import 'package:felloapp/core/enums/sell_service_enum.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SellService extends PropertyChangeNotifier<SellServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _saveRepo = locator<SaveRepo>();

  bool _isKYCVerified = false;
  bool _isVPAVerified = false;
  bool _isGoldSaleActive = false;
  bool _isOngoingTransaction = false;
  bool _isLockInReached = false;
  bool _isSellButtonVisible = false;

  bool get isKYCVerified => _isKYCVerified;
  bool get isVPAVerified => _isVPAVerified;
  bool get isGoldSaleActive => _isVPAVerified;
  bool get isOngoingTransaction => _isVPAVerified;
  bool get isLockInReached => _isVPAVerified;
  bool get isSellButtonVisible => _isVPAVerified;

  set isKYCVerified(bool val) {
    _isKYCVerified = val;
    notifyListeners(SellServiceProperties.kycVerified);
  }

  set isVPAVerified(bool val) {
    _isVPAVerified = val;
    notifyListeners(SellServiceProperties.bankDetailsVerified);
  }

  set isGoldSaleActive(bool val) {
    _isGoldSaleActive = val;
    notifyListeners(SellServiceProperties.augmontSellDisabled);
  }

  set isLockInReached(bool val) {
    _isLockInReached = val;
    notifyListeners(SellServiceProperties.reachedLockIn);
  }

  set isOngoingTransaction(bool val) {
    _isOngoingTransaction = val;
    notifyListeners(SellServiceProperties.ongoingTransaction);
  }

  init() {
    verifyVPAAddress();
    verifyKYCStatus();
  }

  verifyVPAAddress() async {
    ApiResponse response =
        await _saveRepo.verifyVPAAddress(_userService.firebaseUser.uid);
    if (response.code == 200) {
      isVPAVerified = true;
      _logger.d('vpa verified! $_isVPAVerified');
    }
  }

  verifyKYCStatus() {
    isKYCVerified = _userService.isSimpleKycVerified;
    _logger.d('kyc verified! $_isKYCVerified');
  }

  bool updateSellButtonVisibility() {
    print(isKYCVerified && isVPAVerified);
    //Both KYC and VPA is verified
    if (isKYCVerified && isVPAVerified) {
      return false;
    }
    //Kyc is verified but VPA is not verified
    if (isKYCVerified && !isVPAVerified) {
      return true;
    }
    //Kyc is not verified but VPA is verified
    if (!isKYCVerified && isVPAVerified) {
      return true;
    }
    return true;
  }
}
