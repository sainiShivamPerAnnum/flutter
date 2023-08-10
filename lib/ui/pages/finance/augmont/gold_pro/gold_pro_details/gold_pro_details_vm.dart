import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class GoldProDetailsViewModel extends BaseViewModel {
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  final UserService _userService = locator<UserService>();
  final _txnHistoryService = locator<TxnHistoryService>();
  final AugmontTransactionService _txnService =
      locator<AugmontTransactionService>();
  List<bool> detStatus = [false, false, false, false, false, false];
  List<String?> faqHeaders = [
    "What is Gold Pro?",
    "Who can invest in Gold Pro?",
    "How much can you invest in Gold Pro?",
    "What is the maximum investment you can do in Gold Pro?",
    "Is investing in Gold Pro secure?",
    "Is Gold Pro a legal investment option?"
  ];
  List<String?> faqResponses = [
    "Gold Pro is a gold leasing scheme offered in partnership with Fello and Augmont (India's largest gold refinery). It allows users to securely lease their gold through the Fello app and earn interests of upto 4.5%",
    "Any individual over 18 years with a valid PAN card and an active bank account can lease their digital gold on Gold Pro.",
    "The minimum quantity required for Gold Pro is 2 grams, while the maximum quantity is 10 grams.",
    "The maximum investment limit for Gold Pro is 10 grams.",
    "Yes, Gold Pro ensures security by leasing gold to reputable jeweller Divine Hira Jewellers Limited.",
    "Yes, Gold Pro is a legal investment scheme powered by Augmont "
  ];

  void updateDetStatus(int i, bool val) {
    detStatus[i] = val;
    notifyListeners();
  }

  void init() {
    getGoldProScheme();
    getGoldProTransactions();
  }

  void dump() {}

  Future<void> getGoldProScheme() async {
    final res = await _paymentRepo.getGoldProScheme();
    if (res.isSuccess()) {
      _txnService.goldProScheme = res.model;
    } else {
      BaseUtil.showNegativeAlert(
          "Failed to fetch Gold Scheme", res.errorMessage);
    }
  }

  Future<void> getGoldProTransactions() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      _txnHistoryService.getGoldProTransactions(forced: true).then((value) {});
    });
  }

  Future<void> pullToRefresh() async {
    await _userService.getUserFundWalletData();
    await _userService.updatePortFolio();
    // await getGoldProScheme();
    await _txnHistoryService.getGoldProTransactions(forced: true);
  }
}
