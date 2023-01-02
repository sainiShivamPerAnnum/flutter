import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/core/model/user_kyc_data_model.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class BankAndPanService
    extends PropertyChangeNotifier<BankAndPanServiceProperties> {
  final CustomLogger? _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final PaymentRepository? _paymentRepo = locator<PaymentRepository>();
  final UserRepository _userRep = locator<UserRepository>();
  final BankingRepository _bankingRepo = locator<BankingRepository>();
  String? _userPan;
  UserKycDataModel? _userKycData;

  UserKycDataModel? get userKycData => this._userKycData;

  set userKycData(value) {
    this._userKycData = value;
    notifyListeners(BankAndPanServiceProperties.kycVerified);
  }

  get userPan => this._userPan;

  set userPan(value) {
    this._userPan = value;
    notifyListeners(BankAndPanServiceProperties.kycVerified);
  }

  BankAccountDetailsModel? _activeBankAccountDetails;

  BankAccountDetailsModel? get activeBankAccountDetails =>
      this._activeBankAccountDetails;

  set activeBankAccountDetails(value) {
    this._activeBankAccountDetails = value;

    notifyListeners(BankAndPanServiceProperties.bankDetailsVerified);
    _logger!.d("Bank Details Property Notified");
  }

  bool _isKYCVerified = false;
  bool _isBankDetailsAdded = false;
  bool _isSellButtonVisible = false;
  bool _isLockInReached = false;
  bool _isSellLocked = false;
  String? _sellNotice;

  double _withdrawableQnt = 0.0;
  double _nonWithdrawableQnt = 0.0;

  get withdrawableQnt => this._withdrawableQnt;
  get nonWithdrawableQnt => this._nonWithdrawableQnt;
  get isLockInReached => this._isLockInReached;
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
    // await _userService.fetchUserAugmontDetail();
    await checkForUserBankAccountDetails();
    await checkForUserPanDetails();
    verifyBankDetails();
    checkForSellNotice();
    checkIfSellIsLocked();
  }

  dump() {
    isBankDetailsAdded = false;
    isKYCVerified = false;
    isLockInReached = false;
    _isSellButtonVisible = false;
    isSellLocked = false;
    userPan = null;
    userKycData = null;
    activeBankAccountDetails = null;
  }

  checkForUserPanDetails() async {
    if (userKycData != null) return;
    final res = await _bankingRepo.getUserKycInfo();

    if (res.isSuccess()) {
      if (res.model!.ocrVerified) {
        userPan = res.model!.pan;
        userKycData = res.model!;
        isKYCVerified = true;
      }
    }
    // final res = await _userRep.getUserPan();
    // if (res.isSuccess()) {
    //   userPan = res.model;
    // }
  }

  checkForUserBankAccountDetails() async {
    if (activeBankAccountDetails != null) return;
    final res = await _paymentRepo!.getActiveBankAccountDetails();
    if (res.isSuccess()) {
      activeBankAccountDetails = res.model;
      isBankDetailsAdded = true;
    }
  }

  verifyBankDetails() async {
    if (activeBankAccountDetails != null &&
        activeBankAccountDetails!.account != null &&
        activeBankAccountDetails!.account!.isNotEmpty) {
      isBankDetailsAdded = true;
    }
  }

  checkForSellNotice() {
    // if (_userService.userAugmontDetails != null &&
    //     _userService.userAugmontDetails.sellNotice != null &&
    //     _userService.userAugmontDetails.sellNotice.isNotEmpty)
    sellNotice = _userService.userBootUp?.data?.banMap?.investments?.withdrawal
            ?.augmont?.reason ??
        '';
  }

  checkIfSellIsLocked() {
    // if (_userService.userAugmontDetails != null &&
    //     _userService.userAugmontDetails.sellNotice != null &&
    //     _userService.userAugmontDetails.sellNotice.isNotEmpty)
    isSellLocked = _userService.userBootUp?.data?.banMap?.investments
            ?.withdrawal?.augmont?.isBanned ??
        false;
  }

  bool getButtonAvailibility() {
    if (isKYCVerified &&
        isBankDetailsAdded &&
        !isSellLocked &&
        userKycData != null &&
        activeBankAccountDetails != null) return true;
    return false;
  }
}
