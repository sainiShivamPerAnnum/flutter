import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

import '../../../../../base_util.dart';

class FloPremiumDetailsViewModel extends BaseViewModel {
  final TransactionHistoryRepository _txnHistoryRepo =
      locator<TransactionHistoryRepository>();

  LendboxAssetConfiguration _config = AppConfigV2.instance.lendBoxP2P.first;

  LendboxAssetConfiguration get config => _config;

  set config(LendboxAssetConfiguration config) {
    _config = config;
    notifyListeners();
  }

  bool _isInvested = false;

  bool get isInvested => _isInvested;

  set isInvested(bool value) {
    _isInvested = value;
    notifyListeners();
  }

  void updateConfig(FundType fundType) {
    config = AppConfigV2.instance.lendBoxP2P.firstWhere(
      (element) => element.fundType == fundType,
    );
  }

  void init(FundType fundType) {
    config = AppConfigV2.instance.lendBoxP2P.firstWhere(
      (element) => element.fundType == fundType,
    );

    getTransactions();
  }

  List<(String, String)> faqs = [
    (
      "How safe is the invested money? Who is the money lent to?",
      "Your funds are safe and secure with our lending partner Lendbox. To safeguard the investments, a lender's money is distributed across borrowers who are assessed on 200+ parameters to check the creditworthiness of the borrowers to ensure the credibility of borrowers.",
    ),
    (
      "How does Lendbox (P2P Lending partner) manage the risk of default on my money?",
      "Lendbox follows a robust credit assessment policy to bring only the most creditworthy borrowers to the platform. They categorize borrowers by risk and allocate funds in a manner that reduces the risk of capital erosion for investors. In higher risk categories, lendbox invests as little as ₹100 per loan account and go only as high as ₹5,000 in low risk categories.",
    ),
    (
      "What happens to my money after maturity?",
      "Fello Flo Premium plans allow you to decide what happens to your money after maturity. You can choose what you want to do with your money while you invest. If you do not select a preference, we will contact you and confirm what you want to do with the corpus post maturity.",
    ),
    (
      "How can I withdraw my money after maturity?",
      "You can select the option 'Withdraw to Bank' when you save any amount and the money with the interest will be credited to your respective bank account. Make sure to fill in the bank account details before the end of maturity period.",
    ),
    (
      "How is maturity different from a lock-in?",
      "You can withdraw your money at any point post the end of a Lock-in period. In case of maturity, you need to decide before hand if your money can be re-invested into the same asset or a different asset or withdrawn to bank at the end of the period",
    ),
    (
      "Can I withdraw my money before Maturity in 10/12% returns?",
      "No, you can't withdraw your money before maturity or lock in period.",
    ),
  ];

  List<UserTransaction> transactionsList = [];

  void cleanTransactionsList() {
    transactionsList = [];
    notifyListeners();
  }

  Future<void> getTransactions() async {
    isInvested = false;
    final response = await _txnHistoryRepo.getUserTransactions(
      type: "DEPOSIT",
      subtype: "LENDBOXP2P",
      lbFundType: config.fundType.name,
    );

    if (response.isSuccess()) {
      transactionsList = response.model!.transactions!;
      if (transactionsList.isNotEmpty) {
        _isInvested = true;
      }
      notifyListeners();
    } else {
      BaseUtil.showNegativeAlert(
        "Unable to fetch transactions",
        response.errorMessage ?? "Please try again",
      );
    }
  }
}
