import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class MiniTransactionCardViewModel extends BaseModel {
  final Log dblog = new Log("DBModel");
  final Log bulog = new Log("BaseUtil");
  final dbProvider = locator<DBModel>();
  final baseProvider = locator<BaseUtil>();
  AppState appState;

  List<UserTransaction> txnList;

  getTransactions() async {
    bulog.debug("Getting mini transactions");
    setState(ViewState.Busy);
    if (baseProvider != null && dbProvider != null) {
      dbProvider
          .getFilteredUserTransactions(baseProvider.myUser, null, null,
              baseProvider.lastTransactionListDocument)
          .then((Map<String, dynamic> tMap) {
        if (baseProvider.userMiniTxnList == null ||
            baseProvider.userMiniTxnList.length == 0) {
          baseProvider.userMiniTxnList = List.from(tMap['listOfTransactions']);
          txnList = baseProvider.userMiniTxnList;
          notifyListeners();
          bulog.debug("Txnlist length: ${txnList.length}");
        }
      });
    }
    setState(ViewState.Idle);
  }

  Widget getTileLead(String type) {
    if (type == UserTransaction.TRAN_STATUS_COMPLETE) {
      return SvgPicture.asset("images/svgs/completed.svg",
          color: UiConstants.primaryColor, fit: BoxFit.contain);
    } else if (type == UserTransaction.TRAN_STATUS_CANCELLED) {
      return SvgPicture.asset("images/svgs/cancel.svg",
          color: Colors.redAccent, fit: BoxFit.contain);
    } else if (type == UserTransaction.TRAN_STATUS_PENDING) {
      return SvgPicture.asset("images/svgs/pending.svg",
          color: Colors.amber, fit: BoxFit.contain);
    }
    return Image.asset("images/fello_logo.png", fit: BoxFit.contain);
  }

  String getTileTitle(String type) {
    if (type == UserTransaction.TRAN_SUBTYPE_ICICI) {
      return "ICICI Prudential Fund";
    } else if (type == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD) {
      return "Augmont Gold";
    } else if (type == UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN) {
      return "Tambola Win";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REF_BONUS) {
      return "Referral Bonus";
    }
    return "Fund Name";
  }

  String getTileSubtitle(String type) {
    if (type == UserTransaction.TRAN_TYPE_DEPOSIT) {
      return "Deposit";
    } else if (type == UserTransaction.TRAN_TYPE_PRIZE) {
      return "Prize";
    } else if (type == UserTransaction.TRAN_TYPE_WITHDRAW) {
      return "Withdrawal";
    }
    return "";
  }

  Color getTileColor(String type) {
    if (type == UserTransaction.TRAN_STATUS_CANCELLED) {
      return Colors.redAccent;
    } else if (type == UserTransaction.TRAN_STATUS_COMPLETE) {
      return UiConstants.primaryColor;
    } else if (type == UserTransaction.TRAN_STATUS_PENDING) {
      return Colors.amber;
    }
    return Colors.blue;
  }

  String getFormattedTime(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('yyyy-MM-dd – kk:mm').format(now);
  }

  viewAllTransaction() async {
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: TransactionPageConfig);
  }
}
