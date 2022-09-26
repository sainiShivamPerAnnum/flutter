import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class BankAndPanService
    extends PropertyChangeNotifier<BankAndPanServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _paymentRepo = locator<PaymentRepository>();
  final _userRepo = locator<UserRepository>();
  String _userPan;

  get userPan => this._userPan;

  set userPan(value) {
    this._userPan = value;
    notifyListeners(BankAndPanServiceProperties.kycVerified);
  }

  BankAccountDetailsModel _activeBankAccountDetails;

  BankAccountDetailsModel get activeBankAccountDetails =>
      this._activeBankAccountDetails;

  set activeBankAccountDetails(value) {
    this._activeBankAccountDetails = value;
    notifyListeners(BankAndPanServiceProperties.bankDetailsVerified);
  }

  bool _isKYCVerified = false;
  bool _isBankDetailsAdded = false;
  bool _isSellButtonVisible = false;
  bool _isLockInReached = false;
  bool _isSellLocked = false;
  String _sellNotice;

  double _withdrawableQnt = 0.0;
  double _nonWithdrawableQnt = 0.0;

  get withdrawableQnt => this._withdrawableQnt;
  get nonWithdrawableQnt => this._nonWithdrawableQnt;
  get isLockInReached => this._isLockInReached;
  bool get isSimpleKycVerified => _userService.isSimpleKycVerified;
  bool get isKYCVerified => _isKYCVerified;
  bool get isBankDetailsAdded => _isBankDetailsAdded;
  bool get isSellButtonVisible => _isSellButtonVisible;
  get sellNotice => this._sellNotice;
  get isSellLocked => this._isSellLocked;

  set isKYCVerified(bool val) {
    _isKYCVerified = val;
    notifyListeners(BankAndPanServiceProperties.kycVerified);
  }

  set isBankDetailsAdded(bool val) {
    _isBankDetailsAdded = val;
    notifyListeners(BankAndPanServiceProperties.bankDetailsVerified);
  }

  set sellNotice(value) {
    this._sellNotice = value;
    notifyListeners(BankAndPanServiceProperties.augmontSellNotice);
  }

  set isSellLocked(value) {
    this._isSellLocked = value;
    notifyListeners(BankAndPanServiceProperties.augmontSellDisabled);
  }

  set isLockInReached(value) {
    this._isLockInReached = value;
  }

  set nonWithdrawableQnt(value) {
    this._nonWithdrawableQnt = value;
  }

  set withdrawableQnt(val) {
    this._withdrawableQnt = val;
  }

  init() async {
    await _userService.fetchUserAugmontDetail();
    await checkForUserBankAccountDetails();
    await checkForUserPanDetails();
    verifyKYCStatus();
    verifyBankDetails();
    checkForSellNotice();
    checkIfSellIsLocked();
  }

  checkForUserBankAccountDetails() async {
    if (activeBankAccountDetails != null) return;
    final res = await _paymentRepo.getActiveBankAccountDetails();
    if (res.isSuccess()) {
      activeBankAccountDetails = res.model;
      isBankDetailsAdded = true;
    }
  }

  checkForUserPanDetails() async {
    final res = await _userRepo.getUserPan();
    if (res.isSuccess()) {
      userPan = res.model;
    }
  }

  verifyBankDetails() async {
    if (activeBankAccountDetails != null &&
        activeBankAccountDetails.account != null &&
        activeBankAccountDetails.account.isNotEmpty) {
      isBankDetailsAdded = true;
    }
  }

  verifyKYCStatus() {
    isKYCVerified = _userService.baseUser.isSimpleKycVerified;
    print(_isKYCVerified);
    _logger.d('kyc verified! $isKYCVerified');
  }

  checkForSellNotice() {
    if (_userService.userAugmontDetails != null &&
        _userService.userAugmontDetails.sellNotice != null &&
        _userService.userAugmontDetails.sellNotice.isNotEmpty)
      sellNotice = _userService.userAugmontDetails.sellNotice;
  }

  checkIfSellIsLocked() {
    if (_userService.userAugmontDetails != null &&
        _userService.userAugmontDetails.sellNotice != null &&
        _userService.userAugmontDetails.sellNotice.isNotEmpty)
      sellNotice = _userService.userAugmontDetails.sellNotice;
  }

  bool getButtonAvailibility() {
    if (isKYCVerified &&
        isBankDetailsAdded &&
        !isSellLocked &&
        userPan != null &&
        activeBankAccountDetails != null) return true;
    return false;
  }
}
