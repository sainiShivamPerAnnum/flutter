import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/transaction_details_dialog.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

enum TranFilterType { Type, Subtype }

class TransactionsHistoryViewModel extends BaseModel {
  final _logger = locator<Logger>();
  int _subfilter = 1;
  int _filter = 1;
  bool _init = true;
  Map<String, int> _tranTypeFilterItems = {
    "All": 1,
    "Deposit": 2,
    "Withdrawal": 3,
    "Prize": 4
  };
  Map<String, int> _tranSubTypeFilterItems = {
    "All": 1,
    "ICICI": 2,
    "Augmont": 3
  };
  List<UserTransaction> _filteredList;
  final ScrollController _scrollController = ScrollController();

  int get subFilter => _subfilter;

  int get filter => _filter;

  Map<String, int> get tranTypeFilterItems => _tranTypeFilterItems;

  Map<String, int> get tranSubTypeFilterItems => _tranSubTypeFilterItems;

  List<UserTransaction> get filteredList => _filteredList;

  ScrollController get tranListController => _scrollController;

  set subFilter(int val) {
    _subfilter = val;
    notifyListeners();
  }

  set filter(int val) {
    _filter = val;
    notifyListeners();
  }

  set filteredList(List<UserTransaction> val) {
    _filteredList = val;
    notifyListeners();
  }

  final Log dblog = new Log("DBModel");
  final Log bulog = new Log("BaseUtil");
  final dbProvider = locator<DBModel>();
  final baseProvider = locator<BaseUtil>();
  final TransactionService _transactionService = locator<TransactionService>();

  getTransactions() async {
    setState(ViewState.Busy);
    await _transactionService.fetchTransactions(30);
    _filteredList = _transactionService.txnList;
    filterTransactions();
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
      return "Digital Gold";
    } else if (type == UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN) {
      return "Tambola Win";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REF_BONUS) {
      return "Referral Bonus";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REWARD_REDEEM) {
      return "Rewards Redeemed";
    }
    return "Fello Rewards";
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

  filterTransactions() {
    setState(ViewState.Busy);
    filteredList = List.from(_transactionService.txnList);
    if (filter != 1 || subFilter != 1) {
      filteredList.clear();
      _transactionService.txnList.forEach((txn) {
        bool addItemFlag = true;
        if (filter != 1) {
          if (filter == 2) {
            //only deposits
            if (txn.type == UserTransaction.TRAN_TYPE_DEPOSIT)
              addItemFlag = true;
            else
              addItemFlag = false;
          } else if (filter == 3) {
            //only withdrawals
            if (txn.type == UserTransaction.TRAN_TYPE_WITHDRAW)
              addItemFlag = true;
            else
              addItemFlag = false;
          } else {
            //only prizes
            if (txn.type == UserTransaction.TRAN_TYPE_PRIZE)
              addItemFlag = true;
            else
              addItemFlag = false;
          }
        } else {
          addItemFlag = true;
        }
        if (addItemFlag) {
          if (subFilter != 1) {
            if (subFilter == 2) {
              //only ICICI
              if (txn.subType == UserTransaction.TRAN_SUBTYPE_ICICI)
                addItemFlag = true;
              else
                addItemFlag = false;
            } else {
              //only Augmont
              if (txn.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD)
                addItemFlag = true;
              else
                addItemFlag = false;
            }
          } else {
            addItemFlag = true;
          }
        }

        if (addItemFlag) filteredList.add(txn);
      });
    }
    setState(ViewState.Idle);
  }

  String _getFormattedTime(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('yyyy-MM-dd – kk:mm').format(now);
  }

  List<Widget> getTxns() {
    List<ListTile> _tiles = [];
    for (int index = 0; index < filteredList.length; index++) {
      _tiles.add(ListTile(
        onTap: () {
          Haptic.vibrate();
          // if (filteredList[index].tranStatus !=
          //     UserTransaction.TRAN_STATUS_CANCELLED)
          bool freeBeerStatus = getBeerTicketStatus(filteredList[index]);
          showDialog(
              context: AppState.delegate.navigatorKey.currentContext,
              builder: (BuildContext context) {
                AppState.screenStack.add(ScreenItem.dialog);
                return TransactionDetailsDialog(
                    filteredList[index], freeBeerStatus);
              });
        },
        dense: true,
        leading: Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
          height: SizeConfig.blockSizeVertical * 5,
          width: SizeConfig.blockSizeVertical * 5,
          child: getTileLead(filteredList[index].tranStatus),
        ),
        title: Text(
          getTileTitle(
            filteredList[index].subType.toString(),
          ),
          style: TextStyle(
            fontSize: SizeConfig.mediumTextSize,
          ),
        ),
        subtitle: Text(
          getTileSubtitle(filteredList[index].type),
          style: TextStyle(
            color: getTileColor(filteredList[index].tranStatus),
            fontSize: SizeConfig.smallTextSize,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              (filteredList[index].type == "WITHDRAWAL" ? "- " : "+ ") +
                  "₹ ${filteredList[index].type == "WITHDRAWAL" ? (filteredList[index].amount * -1).toString() : filteredList[index].amount.toString()}",
              style: TextStyle(
                color: getTileColor(filteredList[index].tranStatus),
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _getFormattedTime(filteredList[index].timestamp),
              style: TextStyle(
                  color: getTileColor(filteredList[index].tranStatus),
                  fontSize: SizeConfig.smallTextSize),
            )
          ],
        ),
      ));
    }

    return _tiles;
  }

  init() {
    if (_transactionService.txnList == null ||
        _transactionService.txnList.length < 5) {
      getTransactions();
    }
    if (_init) {
      if (_transactionService.txnList != null) {
        filteredList = List.from(_transactionService.txnList);
      } else {
        filteredList = [];
      }
      _scrollController.addListener(() async {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          if (_transactionService.hasMoreTransactionListDocuments &&
              state == ViewState.Idle) {
            getTransactions();
          }
        }
      });
      _init = false;
    }
  }

//TODO added in 2 different places! here and mini_trans_card_vm.dart
  bool isOfferStillValid(Timestamp time) {
    String _timeoutMins = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.OCT_FEST_OFFER_TIMEOUT);
    if (_timeoutMins == null || _timeoutMins.isEmpty) _timeoutMins = '10';
    int _timeout = int.tryParse(_timeoutMins);

    DateTime tTime =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    Duration difference = DateTime.now().difference(tTime);
    if (difference.inSeconds <= _timeout * 60) {
      return true;
    }
    return false;
  }

  bool getBeerTicketStatus(UserTransaction transaction) {
    _logger.d(baseProvider.firstAugmontTransaction);
    if (baseProvider.firstAugmontTransaction != null &&
        baseProvider.firstAugmontTransaction == transaction &&
        transaction.amount >= 150.0 &&
        isOfferStillValid(transaction.timestamp)) return true;
    return false;
  }
}
