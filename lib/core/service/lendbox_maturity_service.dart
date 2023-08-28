import 'dart:developer';

import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/repository/lendbox_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class LendboxMaturityService extends ChangeNotifier {
  final LendboxRepo _lendboxRepo = locator<LendboxRepo>();

  bool _showPendingMaturity = false;
  int _pendingMaturityCount = 0;
  List<Deposit>? filteredDeposits;
  List<Deposit>? allDeposits;
  UserDecision _userDecision = UserDecision.NOTDECIDED;
  bool isLendboxOldUser = false;

  //========= Getters ==========//
  bool get showPendingMaturity => _showPendingMaturity;

  int get pendingMaturityCount => _pendingMaturityCount;

  UserDecision get userDecision => _userDecision;

  //========= Setters ==========//
  set showPendingMaturity(bool value) {
    _showPendingMaturity = value;
    notifyListeners();
  }

  set pendingMaturityCount(int value) {
    _pendingMaturityCount = value;
    notifyListeners();
  }

  set userDecision(UserDecision value) {
    _userDecision = value;
    notifyListeners();
  }

  //========= Methods ==========//
  Future<void> init() async {
    isLendboxOldUser =
        locator<UserService>().userSegments.contains(Constants.US_FLO_OLD);
    try {
      final res = await _lendboxRepo.getLendboxMaturity();

      if (res.isSuccess()) {
        final lendboxMaturityData = res.model?.data;

        if (lendboxMaturityData != null &&
            lendboxMaturityData.deposits != null &&
            lendboxMaturityData.deposits!.isNotEmpty) {
          allDeposits = lendboxMaturityData.deposits;

          filteredDeposits = lendboxMaturityData.deposits
              ?.where((element) => element.hasConfirmed == false)
              .toList();
          pendingMaturityCount = filteredDeposits!.length;

          if (filteredDeposits != null &&
              filteredDeposits?[0].decisionMade != null) {
            setDecision(filteredDeposits?[0].decisionMade ?? '3');
          }

          if (pendingMaturityCount > 0) {
            showPendingMaturity = true;
          }
        }
      }
    } on Exception catch (e) {
      log("Error in getting lendbox maturity data: $e",
          name: "LendboxMaturityService");
    }
  }

  Future<void> updateInvestmentPref(String pref) async {
    try {
      final deposit = filteredDeposits?[0];
      if (deposit != null) {
        final txnId = deposit.txnId;
        final res = await _lendboxRepo
            .updateUserInvestmentPreference(txnId!, pref, hasConfirmed: true);
        if (res.isSuccess()) {
          await init();
        }
      }
    } on Exception catch (e) {
      log("Error in updating investment pref: $e",
          name: "LendboxMaturityService");
    }
  }

  void setDecision(String val) {
    int? i = int.tryParse(val);

    if (i == 0) {
      userDecision = UserDecision.WITHDRAW;
    } else if (i == 1) {
      userDecision = UserDecision.REINVEST;
    } else if (i == 2) {
      userDecision = UserDecision.MOVETOFLEXI;
    } else {
      userDecision = UserDecision.NOTDECIDED;
    }
  }
}
