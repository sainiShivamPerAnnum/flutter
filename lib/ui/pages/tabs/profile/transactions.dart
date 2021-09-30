import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/transaction_details_dialog.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  int subfilter = 1;
  int filter = 1;
  bool isLoading = false;
  bool isInit = true;
  BaseUtil baseProvider;
  DBModel dbProvider;
  List<UserTransaction> filteredList;
  ScrollController _scrollController = ScrollController();
  UserTransaction firstAugmontTransaction;

  /// Will used to access the Animated list
  // final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  getTransactions() {
    isLoading = true;
    if (baseProvider != null &&
        dbProvider != null &&
        baseProvider.hasMoreTransactionListDocuments) {
      dbProvider
          .getFilteredUserTransactions(baseProvider.myUser, null, null,
              baseProvider.lastTransactionListDocument)
          .then((Map<String, dynamic> tMap) {
        if (baseProvider.userMiniTxnList == null ||
            baseProvider.userMiniTxnList.length == 0) {
          baseProvider.userMiniTxnList = List.from(tMap['listOfTransactions']);
        } else {
          baseProvider.userMiniTxnList
              .addAll(List.from(tMap['listOfTransactions']));
        }
        filteredList = baseProvider.userMiniTxnList;
        if (tMap['lastDocument'] != null) {
          baseProvider.lastTransactionListDocument = tMap['lastDocument'];
        }
        if (tMap['length'] < 30) {
          baseProvider.hasMoreTransactionListDocuments = false;
          findFirstAugmontTransaction();
        }
        // print(
        //     "---------------------${baseProvider.userMiniTxnList}-----------------");
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  findFirstAugmontTransaction() {
    try {
      List<UserTransaction> reversedList =
          baseProvider.userMiniTxnList.reversed.toList();
      firstAugmontTransaction = reversedList.firstWhere((element) =>
          element.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
          element.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE &&
          element.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD);
    } catch (e) {
      log("No transaction found");
    }
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
    } else if (type == UserTransaction.TRAN_SUBTYPE_GLDN_TCK) {
      return "Golden Ticket";
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

  filterTransactions() {
    filteredList = List.from(baseProvider.userMiniTxnList);
    if (filter != 1 || subfilter != 1) {
      filteredList.clear();
      baseProvider.userMiniTxnList.forEach((txn) {
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
          if (subfilter != 1) {
            if (subfilter == 2) {
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
    if (isLoading) {
      setState(() {
        isLoading = false;
      });
    }
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    if (baseProvider.userMiniTxnList == null
        // || baseProvider.userMiniTxnList.isEmpty
        ) {
      getTransactions();
    }
    if (isInit) {
      if (baseProvider.userMiniTxnList != null
          // && baseProvider.userMiniTxnList.isNotEmpty
          ) {
        filteredList = List.from(baseProvider.userMiniTxnList);
      } else {
        filteredList = [];
      }
      _scrollController.addListener(() async {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          if (baseProvider.hasMoreTransactionListDocuments && !isLoading) {
            getTransactions();
          }
        }
      });
      isInit = false;
    }
    return Scaffold(
        appBar: BaseUtil.getAppBar(context, "Transactions"),
        body: Container(
          padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                height: SizeConfig.screenHeight * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "Filters",
                    //   style: TextStyle(
                    //       fontSize: SizeConfig.mediumTextSize,
                    //       fontWeight: FontWeight.w700),
                    // ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: UiConstants.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: filter,
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  "All",
                                  style: TextStyle(
                                      fontSize: SizeConfig.mediumTextSize),
                                ),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Deposit",
                                  style: TextStyle(
                                      fontSize: SizeConfig.mediumTextSize),
                                ),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                  child: Text(
                                    "Withdrawal",
                                    style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize),
                                  ),
                                  value: 3),
                              DropdownMenuItem(
                                  child: Text(
                                    "Prize",
                                    style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize),
                                  ),
                                  value: 4),
                            ],
                            onChanged: (value) {
                              filter = value;
                              isLoading = true;
                              setState(() {});
                              filterTransactions();
                            }),
                      ),
                    ),
                    SizedBox(width: 30),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: UiConstants.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: subfilter,
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  "All",
                                  style: TextStyle(
                                      fontSize: SizeConfig.mediumTextSize),
                                ),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                  child: Text(
                                    "ICICI",
                                    style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize),
                                  ),
                                  value: 2),
                              DropdownMenuItem(
                                  child: Text(
                                    "Augmont",
                                    style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize),
                                  ),
                                  value: 3),
                            ],
                            onChanged: (value) {
                              subfilter = value;
                              isLoading = true;
                              setState(() {});
                              filterTransactions();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (filteredList.length == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/no-transactions.png",
                                width: SizeConfig.screenWidth * 0.8,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "No transactions to show yet",
                                style: TextStyle(
                                  fontSize: SizeConfig.largeTextSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          )
                        : ListView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(10),
                            controller: _scrollController,
                            children: _getTxns(),
                          )),
              ),
            ],
          ),
        ));
  }

  bool offerStillValid(Timestamp time) {
    DateTime tTime =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    Duration difference = DateTime.now().difference(tTime);
    print(difference.inMinutes);
    if (difference.inMinutes <= 10) return true;
    return false;
  }

  bool getBeerTicketStatus(UserTransaction transaction) {
    if (firstAugmontTransaction != null &&
        firstAugmontTransaction == transaction &&
        transaction.amount >= 150.0 &&
        offerStillValid(transaction.timestamp)) return true;
    return false;
  }

  List<Widget> _getTxns() {
    List<ListTile> _tiles = [];
    for (int index = 0; index < filteredList.length; index++) {
      _tiles.add(ListTile(
        onTap: () {
          Haptic.vibrate();
          // if (filteredList[index].tranStatus !=
          //     UserTransaction.TRAN_STATUS_CANCELLED)
          showDialog(
              context: context,
              builder: (BuildContext context) {
                AppState.screenStack.add(ScreenItem.dialog);
                return TransactionDetailsDialog(filteredList[index],
                    getBeerTicketStatus(filteredList[index]));
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
          children: [
            Text(
              (filteredList[index].type == "WITHDRAWAL" ? "- " : "+ ") +
                  "₹ ${filteredList[index].amount.toString()}",
              style: TextStyle(
                color: getTileColor(filteredList[index].tranStatus),
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
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

  String _getFormattedTime(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('yyyy-MM-dd – kk:mm').format(now);
  }
}
