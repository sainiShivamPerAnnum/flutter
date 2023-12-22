import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

import '../../../../../base_util.dart';

class FloPremiumDetailsViewModel extends BaseViewModel {
  final TransactionHistoryRepository _txnHistoryRepo =
      locator<TransactionHistoryRepository>();
  List lendboxDetails = AppConfig.getValue(AppConfigKey.lendbox);
  bool _is12 = true;

  double _opacity = 1;

  Offset _offset = const Offset(0, 0);

  double get opacity => _opacity;

  set opacity(double value) {
    _opacity = value;
    notifyListeners();
  }

  Offset get offset => _offset;

  set offset(Offset value) {
    _offset = value;
    notifyListeners();
  }

  bool get is12 => _is12;

  set is12(bool value) {
    _is12 = value;
    notifyListeners();
  }

  final UserService userService = locator<UserService>();
  final String flo10Highlights = "P2P Asset  • 10% Returns • 3 months maturity";

  final String flo12Highlights = "P2P Asset  • 12% Returns • 6 months maturity";

  String flo10Description =
      "Fello Flo Premium 10% is a P2P Asset. The asset works in the way of a Fixed deposit but has a lock-in of just 3 months!";
  String flo12Description =
      "Fello Flo Premium 12% is a P2P Asset. The asset works in the way of a Fixed deposit but has a lock-in of just 6 months!";

  bool _isInvested = false;

  bool get isInvested => _isInvested;

  set isInvested(bool value) {
    _isInvested = value;
    notifyListeners();
  }

  List<bool> detStatus = List.filled(6, false);
  List<String?> faqHeaders = [
    "How safe is the invested money? Who is the money lent to?",
    "How does Lendbox (P2P Lending partner) manage the risk of default on my money?",
    "What happens to my money after maturity?",
    "How can I withdraw my money after maturity?",
    "How is maturity different from a lock-in?",
    "Can I withdraw my money before Maturity in 10/12% returns?",
  ];
  List<String?> faqResponses = [
    "Your funds are safe and secure with our lending partner Lendbox. To safeguard the investments, a lender's money is distributed across borrowers who are assessed on 200+ parameters to check the creditworthiness of the borrowers to ensure the credibility of borrowers.",
    "Lendbox follows a robust credit assessment policy to bring only the most creditworthy borrowers to the platform. They categorize borrowers by risk and allocate funds in a manner that reduces the risk of capital erosion for investors. In higher risk categories, lendbox invests as little as ₹100 per loan account and go only as high as ₹5,000 in low risk categories.",
    "Fello Flo Premium plans allow you to decide what happens to your money after maturity. You can choose what you want to do with your money while you invest. If you do not select a preference, we will contact you and confirm what you want to do with the corpus post maturity.",
    "You can select the option 'Withdraw to Bank' when you save any amount and the money with the interest will be credited to your respective bank account. Make sure to fill in the bank account details before the end of maturity period.",
    "You can withdraw your money at any point post the end of a Lock-in period. In case of maturity, you need to decide before hand if your money can be re-invested into the same asset or a different asset or withdrawn to bank at the end of the period",
    "No, you can't withdraw your money before maturity or lock in period.",
  ];

  List<UserTransaction> transactionsList = [];

  void init(bool is12View) {
    flo12Description = lendboxDetails[0]["descText"];
    flo10Description = lendboxDetails[1]["descText"];
    _is12 = is12View;
    getTransactions();
  }

  void dump() {}

  void updateDetStatus(int i, bool val) {
    detStatus[i] = val;
    notifyListeners();
  }

  void cleanTransactionsList() {
    transactionsList = [];
    notifyListeners();
  }

  Future<void> getTransactions() async {
    isInvested = false;
    final response = await _txnHistoryRepo.getUserTransactions(
      type: "DEPOSIT",
      subtype: "LENDBOXP2P",
      lbFundType: is12
          ? Constants.ASSET_TYPE_FLO_FIXED_6
          : Constants.ASSET_TYPE_FLO_FIXED_3,
    );
    if (response.isSuccess()) {
      transactionsList = response.model!.transactions!;
      if (transactionsList.isNotEmpty) {
        _isInvested = true;
      }
      notifyListeners();
    } else {
      BaseUtil.showNegativeAlert("Unable to fetch transactions",
          response.errorMessage ?? "Please try again");
    }
  }
}
