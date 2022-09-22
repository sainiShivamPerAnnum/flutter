import 'package:felloapp/core/enums/sell_service_enum.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SellService extends PropertyChangeNotifier<SellServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _txnHistoryService = locator<TransactionHistoryService>();
  final _paymentRepo = locator<PaymentRepository>();
  final _bankingRepo = locator<BankingRepository>();
  final _userRepo = locator<UserRepository>();
  String _userPan;

  get userPan => this._userPan;

  set userPan(value) {
    this._userPan = value;
    notifyListeners(SellServiceProperties.kycVerified);
  }

  BankAccountDetailsModel _activeBankAccountDetails;

  BankAccountDetailsModel get activeBankAccountDetails =>
      this._activeBankAccountDetails;

  set activeBankAccountDetails(value) {
    this._activeBankAccountDetails = value;
    notifyListeners(SellServiceProperties.bankDetailsVerified);
  }

  bool _isKYCVerified = false;
  bool _isBankDetailsAdded = false;
  bool _isOngoingTransaction = false;
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
  bool get isOngoingTransaction => _isOngoingTransaction;
  bool get isSellButtonVisible => _isSellButtonVisible;
  get sellNotice => this._sellNotice;
  get isSellLocked => this._isSellLocked;

  set isKYCVerified(bool val) {
    _isKYCVerified = val;
    notifyListeners(SellServiceProperties.kycVerified);
  }

  set isBankDetailsAdded(bool val) {
    _isBankDetailsAdded = val;
    notifyListeners(SellServiceProperties.bankDetailsVerified);
  }

  set setOngoingTransaction(bool val) {
    _isOngoingTransaction = val;
    notifyListeners(SellServiceProperties.ongoingTransaction);
  }

  set sellNotice(value) {
    this._sellNotice = value;
    notifyListeners(SellServiceProperties.augmontSellNotice);
  }

  set isSellLocked(value) {
    this._isSellLocked = value;
    notifyListeners(SellServiceProperties.augmontSellDisabled);
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
  //Transaction - check last transaction status(AugmontTransactionService)

  init() async {
    await _userService.fetchUserAugmontDetail();
    await checkForUserBankAccountDetails();
    await checkForUserPanDetails();
    verifyKYCStatus();
    verifyBankDetails();
    verifyOngoingTransaction();
    checkForSellNotice();
    checkIfSellIsLocked();
  }

  checkForUserBankAccountDetails() async {
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

  verifyOngoingTransaction() async {
    await _txnHistoryService.updateTransactions();
    if (_txnHistoryService.txnList != null &&
        _txnHistoryService.txnList.length > 0) {
      UserTransaction ongoingTxn = _txnHistoryService.txnList.firstWhere(
          (element) =>
              element.subType == 'WITHDRAWL' &&
              element.tranStatus != "COMPLETE", orElse: () {
        return null;
      });
      setOngoingTransaction = ongoingTxn != null ? true : false;
    }
  }

  bool getButtonAvailibility() {
    if (isKYCVerified && isBankDetailsAdded && !isSellLocked) return true;
    return false;
  }

  // updateSellButtonDetails() async {
  //   _isKYCVerified = isKYCVerified ?? false;
  //   _isVPAVerified = isVPAVerified ?? false;
  //   if (withdrawableQnt <= nonWithdrawableQnt) {
  //     _isLockInReached = true;
  //   }
  //   _isGoldSaleActive = _baseUtil.augmontDetail?.isSellLocked ?? false;
  //   _isOngoingTransaction = isOngoingTransaction ?? false;
  //   notifyListeners();
  // }
}
