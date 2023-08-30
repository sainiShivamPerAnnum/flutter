import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/repository/lendbox_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/success_8_moved_sheet.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LendboxMaturityService extends ChangeNotifier {
  final LendboxRepo _lendboxRepo = locator<LendboxRepo>();

  int _pendingMaturityCount = 0;
  List<Deposit>? filteredDeposits;
  List<Deposit>? allDeposits;
  UserDecision _userDecision = UserDecision.NOTDECIDED;
  bool isLendboxOldUser = false;
  Deposit? _alreadyMaturedDeposit;

  //========= Getters ==========//
  int get pendingMaturityCount => _pendingMaturityCount;

  UserDecision get userDecision => _userDecision;

  Deposit? get alreadyMaturedDeposit => _alreadyMaturedDeposit;

  //========= Setters ==========//
  set pendingMaturityCount(int value) {
    _pendingMaturityCount = value;
    notifyListeners();
  }

  set userDecision(UserDecision value) {
    _userDecision = value;
    notifyListeners();
  }

  set alreadyMaturedDeposit(Deposit? value) {
    _alreadyMaturedDeposit = value;
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
          final now = DateTime.now();

          filteredDeposits = lendboxMaturityData.deposits
              ?.where((element) =>
                  element.hasConfirmed == false &&
                  element.maturityOn != null &&
                  element.maturityOn!.isAfter(now))
              .toList();
          pendingMaturityCount = filteredDeposits!.length;

          alreadyMaturedDeposit = lendboxMaturityData.deposits!.firstWhere(
              (element) =>
                  element.maturityOn != null &&
                  element.maturityOn!.isBefore(now) &&
                  (element.decisionMade == 'NA' || element.decisionMade == '2'),
              orElse: Deposit.new);

          if (filteredDeposits != null &&
              filteredDeposits!.isNotEmpty &&
              filteredDeposits?[0] != null &&
              filteredDeposits?[0].decisionMade != null) {
            setDecision(filteredDeposits?[0].decisionMade ?? '3');
          }
        }

        //if already matured, show modal sheet with details
        await _alreadyMaturityCheck();
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

  Future<void> _alreadyMaturityCheck() async {
    if (alreadyMaturedDeposit != Deposit() &&
        !(alreadyMaturedDeposit?.hasConfirmed ?? true)) {
      // check if the txnId is already present in the outdated list
      final outdatedListCacheDeposit = PreferenceHelper.getString(
          PreferenceHelper.CACHE_LIST_OUTDATED_FLO_ASSET);
      List<String> savedTxnId = [];

      // if the outdated list is not empty, then split the string and save it in a list
      if (outdatedListCacheDeposit.isNotEmpty) {
        savedTxnId = outdatedListCacheDeposit.split(",");
      }

      // if the txnId is already present in the outdated list, then don't show the modal sheet
      if (savedTxnId.contains(alreadyMaturedDeposit?.txnId)) {
        return;
      }

      // show modal sheet
      unawaited(
        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          enableDrag: false,
          hapticVibrate: true,
          isBarrierDismissible: false,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          content: Successful8MovedSheet(
            investAmount: alreadyMaturedDeposit?.investedAmt.toString() ?? "",
            maturityAmount: alreadyMaturedDeposit?.maturityAmt.toString() ?? "",
            maturityDate:
                formatDate(alreadyMaturedDeposit?.maturityOn ?? DateTime.now()),
            reInvestmentDate:
                formatDate(alreadyMaturedDeposit?.investedOn ?? DateTime.now()),
            defaultMovedTo8: true,
            fdDuration: alreadyMaturedDeposit?.fdDuration ?? "",
            roiPerc: alreadyMaturedDeposit?.roiPerc ?? "",
            title: alreadyMaturedDeposit
                    ?.decisionsAvailable?[0].onDecisionMade?.title ??
                "",
            topChipText: alreadyMaturedDeposit
                    ?.decisionsAvailable?[0].onDecisionMade?.topChipText ??
                "",
            footer: alreadyMaturedDeposit
                    ?.decisionsAvailable?[0].onDecisionMade?.footer ??
                "",
            isLendboxOldUser: isLendboxOldUser,
          ),
        ),
      );

      // save the txnId in the outdated list
      final stringToSave =
          "$outdatedListCacheDeposit,${alreadyMaturedDeposit!.txnId!}";
      await PreferenceHelper.setString(
          PreferenceHelper.CACHE_LIST_OUTDATED_FLO_ASSET, stringToSave);
    }
  }

  String formatDate(DateTime dateTime) {
    final format = DateFormat('dd MMM, yyyy');
    return format.format(dateTime);
  }

  // dump all the data in the service
  void dump() {
    _pendingMaturityCount = 0;
    filteredDeposits = [];
    allDeposits = [];
    _userDecision = UserDecision.NOTDECIDED;
    isLendboxOldUser = false;
    _alreadyMaturedDeposit = Deposit();
  }
}
