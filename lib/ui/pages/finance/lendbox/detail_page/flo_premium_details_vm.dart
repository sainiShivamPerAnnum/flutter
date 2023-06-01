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

  Offset _offset = Offset(0, 0);
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
  final String flo10Highlights = "P2P Asset  • 10% Returns • RBI Certified";

  final String flo12Highlights = "Nice Asset  • 12% Returns • Good For you";

  String flo10Description =
      "Fello Flo Premium 10% is a P2P Asset. The asset works in the way of a Fixed deposit but has a lock-in of just 3 months!";
  String flo12Description =
      "Fello Flo Premium 12% is a P2P Asset. The asset works in the way of a Fixed deposit but has a lock-in of just 6 months!";

  bool isInvested = false;

  List<bool> detStatus = [false, false, false];
  List<String?> faqHeaders = [
    "Where can I watch?",
    "Mauris id nibh eu fermentum mattis purus?",
    "Eros imperdiet rhoncus?"
  ];
  List<String?> faqResponses = [
    "Nibh quisque suscipit fermentum netus nulla cras porttitor euismod nulla. Orci, dictumst nec aliquet id ullamcorper venenatis. ",
    "Nibh quisque suscipit fermentum netus nulla cras porttitor euismod nulla. Orci, dictumst nec aliquet id ullamcorper venenatis. ",
    "Nibh quisque suscipit fermentum netus nulla cras porttitor euismod nulla. Orci, dictumst nec aliquet id ullamcorper venenatis. "
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
    final response = await _txnHistoryRepo.getUserTransactions(
      type: "DEPOSIT",
      subtype: "LENDBOXP2P",
      lbFundType: is12
          ? Constants.ASSET_TYPE_FLO_FIXED_6
          : Constants.ASSET_TYPE_FLO_FIXED_3,
    );
    if (response.isSuccess()) {
      transactionsList = response.model!.transactions!;
      notifyListeners();
    } else {
      BaseUtil.showNegativeAlert("Unable to fetch transactions",
          response.errorMessage ?? "Please try again");
    }
  }
}
