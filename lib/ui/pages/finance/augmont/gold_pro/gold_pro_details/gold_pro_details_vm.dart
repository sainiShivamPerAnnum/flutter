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
  List<bool> detStatus = [false, false, false, false, false];
  List<String?> faqHeaders = [
    "How safe is the invested money? Who is the money lent to?",
    "How does Lendbox (P2P Lending partner) manage the risk of default on my money?",
    "What happens to my money after maturity?",
    "How can I withdraw my money after maturity?",
    "How is maturity different from a lock-in?"
  ];
  List<String?> faqResponses = [
    "Your funds are safe and secure with our lending partner Lendbox. To safeguard the investments, a lender's money is distributed across borrowers who are assessed on 200+ parameters to check the creditworthiness of the borrowers to ensure the credibility of borrowers.",
    "Lendbox follows a robust credit assessment policy to bring only the most creditworthy borrowers to the platform. They categorize borrowers by risk and allocate funds in a manner that reduces the risk of capital erosion for investors. In higher risk categories, lendbox invests as little as ₹100 per loan account and go only as high as ₹5,000 in low risk categories.",
    "Fello Flo Premium plans allow you to decide what happens to your money after maturity. You can choose what you want to do with your money while you invest. If you do not select a preference, we will contact you and confirm what you want to do with the corpus post maturity.",
    "You can select the option 'Withdraw to Bank' when you save any amount and the money with the interest will be credited to your respective bank account. Make sure to fill in the bank account details before the end of maturity period.",
    "You can withdraw your money at any point post the end of a Lock-in period. In case of maturity, you need to decide before hand if your money can be re-invested into the same asset or a different asset or withdrawn to bank at the end of the period",
  ];

  void updateDetStatus(int i, bool val) {
    detStatus[i] = val;
    notifyListeners();
  }

  void init() {
    // getGoldProScheme();
    getGoldProTransactions();
  }

  void dump() {}

  // Future<void> getGoldProScheme() async {
  //   final res = await _paymentRepo.getGoldProScheme();
  //   if (res.isSuccess()) {
  //     _txnService.goldProScheme = res.model;
  //   } else {
  //     BaseUtil.showNegativeAlert(
  //         "Failed to fetch Gold Scheme", res.errorMessage);
  //   }
  // }

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
