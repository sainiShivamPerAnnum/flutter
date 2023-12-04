import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/core/model/user_kyc_data_model.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class BankAndPanService
    extends PropertyChangeNotifier<BankAndPanServiceProperties> {
  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  final BankingRepository _bankingRepo = locator<BankingRepository>();
  String? _userPan;
  UserKycDataModel? _userKycData;

  UserKycDataModel? get userKycData => _userKycData;

  set userKycData(value) {
    _userKycData = value;
    notifyListeners(BankAndPanServiceProperties.kycVerified);
  }

  String? get userPan => _userPan;

  set userPan(value) {
    _userPan = value;
    notifyListeners(BankAndPanServiceProperties.kycVerified);
  }

  BankAccountDetailsModel? _activeBankAccountDetails;

  BankAccountDetailsModel? get activeBankAccountDetails =>
      _activeBankAccountDetails;

  set activeBankAccountDetails(BankAccountDetailsModel? value) {
    _activeBankAccountDetails = value;

    notifyListeners(BankAndPanServiceProperties.bankDetailsVerified);
    _logger.d("Bank Details Property Notified");
  }

  bool _isKYCVerified = false;
  bool _isBankDetailsAdded = false;
  bool _isSellButtonVisible = false;
  bool _isLockInReached = false;
  bool _isSellLocked = false;
  String? _sellNotice;
  bool isFromFloWithdrawFlow = false;

  double _withdrawableQnt = 0.0;
  double _nonWithdrawableQnt = 0.0;

  double get withdrawableQnt => _withdrawableQnt;

  double get nonWithdrawableQnt => _nonWithdrawableQnt;

  bool get isLockInReached => _isLockInReached;

  bool get isKYCVerified => _isKYCVerified;

  bool get isBankDetailsAdded => _isBankDetailsAdded;

  bool get isSellButtonVisible => _isSellButtonVisible;

  String? get sellNotice => _sellNotice;

  bool get isSellLocked => _isSellLocked;

  set isKYCVerified(bool val) {
    _isKYCVerified = val;
    notifyListeners(BankAndPanServiceProperties.kycVerified);
  }

  set isBankDetailsAdded(bool val) {
    _isBankDetailsAdded = val;
    notifyListeners(BankAndPanServiceProperties.bankDetailsVerified);
  }

  set sellNotice(value) {
    _sellNotice = value;
    notifyListeners(BankAndPanServiceProperties.augmontSellNotice);
  }

  set isSellLocked(value) {
    _isSellLocked = value;
    notifyListeners(BankAndPanServiceProperties.augmontSellDisabled);
  }

  set isLockInReached(value) {
    _isLockInReached = value;
  }

  set nonWithdrawableQnt(value) {
    _nonWithdrawableQnt = value;
  }

  set withdrawableQnt(val) {
    _withdrawableQnt = val;
  }

  Future<void> init() async {
    // await _userService.fetchUserAugmontDetail();
    await checkForUserBankAccountDetails();
    await checkForUserPanDetails();
    verifyBankDetails();
    checkForSellNotice();
    checkIfSellIsLocked();
  }

  void dump() {
    isBankDetailsAdded = false;
    isKYCVerified = false;
    isLockInReached = false;
    _isSellButtonVisible = false;
    isSellLocked = false;
    userPan = null;
    userKycData = null;
    activeBankAccountDetails = null;
  }

  Future<void> checkForUserPanDetails() async {
    if (userKycData != null) return;
    final res = await _bankingRepo.getUserKycInfo();

    if (res.isSuccess()) {
      if (res.model!.ocrVerified) {
        userPan = res.model!.pan;
        userKycData = res.model!;
        isKYCVerified = true;
      }
    }
  }

  Future<bool> verifyAugmontKyc() async {
    final res = await _bankingRepo.verifyAugmontKyc();
    return res.isSuccess();
  }

  Future<void> checkForUserBankAccountDetails({
    bool forceRefetch = false,
    bool withNetBankingValidation = false,
  }) async {
    if (forceRefetch) {
      _activeBankAccountDetails = null;
    }
    if (activeBankAccountDetails != null) return;
    final res = await _paymentRepo.getActiveBankAccountDetails(
      withNetBankingValidation: withNetBankingValidation,
    );
    if (res.isSuccess()) {
      activeBankAccountDetails = res.model;
      notifyListeners();
    }
  }

  void verifyBankDetails() {
    if (activeBankAccountDetails != null &&
        activeBankAccountDetails!.account.isNotEmpty) {
      isBankDetailsAdded = true;
    }
  }

  void checkForSellNotice() {
    sellNotice = _userService.userBootUp?.data?.banMap?.investments?.withdrawal
            ?.augmont?.reason ??
        '';
  }

  void checkIfSellIsLocked() {
    isSellLocked = _userService.userBootUp?.data?.banMap?.investments
            ?.withdrawal?.augmont?.isBanned ??
        false;
  }

  bool getButtonAvailibility() {
    if (isKYCVerified &&
        isBankDetailsAdded &&
        userKycData != null &&
        activeBankAccountDetails != null) return true;
    return false;
  }
}
