import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserMiniTransaction.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  int subfilter = 1;
  int filter = 1;
  bool isLoading = true;
  BaseUtil baseProvider;
  DBModel dbProvider;
  List<UserMiniTransaction> transactionList, filteredList;

  /// Will used to access the Animated list
  // final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  getTransactions() async {
    // isLoading = true;
    if (baseProvider != null && dbProvider != null && isLoading == true) {
      print(baseProvider.myUser.uid);
      transactionList = await dbProvider.getFilteredUserTransactions(
          baseProvider.myUser, null, null, 30);
      print(transactionList.length);
      filteredList = transactionList;
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget getTileLead(String type) {
    if (type == "COMPLETE") {
      return SvgPicture.asset("images/svgs/completed.svg",
          color: UiConstants.primaryColor, fit: BoxFit.contain);
    } else if (type == "CANCELLED") {
      return SvgPicture.asset("images/svgs/cancel.svg",
          color: Colors.redAccent, fit: BoxFit.contain);
    } else if (type == "PENDING") {
      return SvgPicture.asset("images/svgs/pending.svg",
          color: Colors.amber, fit: BoxFit.contain);
    }
    return Image.asset("images/fello_logo.png", fit: BoxFit.contain);
  }

  String getTileTitle(String type) {
    if (type == "ICICI1565") {
      return "ICICI Prudential Fund";
    } else if (type == "AUG99") {
      return "Augmont Gold";
    } else if (type == "TMB_WIN") {
      return "Tambola Win";
    }
    return "Fund Name";
  }

  String getTileSubtitle(String type) {
    if (type == "DEPOSIT") {
      return "Deposit";
    } else if (type == "PRIZE") {
      return "Prize";
    } else if (type == "WITHDRAWAL") {
      return "Withdrawal";
    }
    return "";
  }

  Color getTileColor(String type) {
    if (type == "CANCELLED") {
      return Colors.redAccent;
    } else if (type == "COMPLETE") {
      return UiConstants.primaryColor;
    } else if (type == "PENDING") {
      return Colors.amber;
    }
    return Colors.blue;
  }

  filterTransactions() {
    switch (subfilter) {
      case 1:
        filteredList = transactionList;
        break;
      case 2:
        print("helll");
        filteredList.clear();
        transactionList.forEach((element) {
          if (element.type == "DEPOSIT") {
            filteredList.add(element);
          }
        });
        if (isLoading) {
          isLoading = false;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    if (transactionList == null) {
      getTransactions();
    }
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            "Transactions",
            style: GoogleFonts.montserrat(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 3),
                height: SizeConfig.screenHeight * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "Filters",
                    //   style: GoogleFonts.montserrat(
                    //       fontSize: SizeConfig.mediumTextSize,
                    //       fontWeight: FontWeight.w700),
                    // ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: UiConstants.primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: filter,
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  "All",
                                  style: GoogleFonts.montserrat(
                                      fontSize: SizeConfig.mediumTextSize),
                                ),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Deposit",
                                  style: GoogleFonts.montserrat(
                                      fontSize: SizeConfig.mediumTextSize),
                                ),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                  child: Text(
                                    "Withdrawal",
                                    style: GoogleFonts.montserrat(
                                        fontSize: SizeConfig.mediumTextSize),
                                  ),
                                  value: 3),
                            ],
                            onChanged: (value) {
                              setState(() {
                                filter = value;
                                isLoading = true;
                                filterTransactions();
                              });
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: subfilter,
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  "All",
                                  style: GoogleFonts.montserrat(
                                      fontSize: SizeConfig.mediumTextSize),
                                ),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                  child: Text(
                                    "ICICI",
                                    style: GoogleFonts.montserrat(
                                        fontSize: SizeConfig.mediumTextSize),
                                  ),
                                  value: 2),
                              DropdownMenuItem(
                                  child: Text(
                                    "Augmont",
                                    style: GoogleFonts.montserrat(
                                        fontSize: SizeConfig.mediumTextSize),
                                  ),
                                  value: 3),
                            ],
                            onChanged: (value) {
                              setState(() {
                                subfilter = value;
                                isLoading = true;
                                filterTransactions();
                              });
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
                    : AnimatedList(
                        initialItemCount: filteredList.length,
                        itemBuilder: (context, index, animation) {
                          return ListTile(
                            dense: true,
                            leading: Container(
                              padding: EdgeInsets.all(
                                  SizeConfig.blockSizeHorizontal * 2),
                              height: SizeConfig.blockSizeVertical * 5,
                              width: SizeConfig.blockSizeVertical * 5,
                              child:
                                  getTileLead(filteredList[index].tranStatus),
                            ),
                            title: Text(
                              getTileTitle(
                                filteredList[index].subType.toString(),
                              ),
                              style: GoogleFonts.montserrat(
                                fontSize: SizeConfig.mediumTextSize,
                              ),
                            ),
                            subtitle: Text(
                              getTileSubtitle(filteredList[index].type),
                              style: GoogleFonts.montserrat(
                                color: getTileColor(
                                    filteredList[index].tranStatus),
                                fontSize: SizeConfig.smallTextSize,
                              ),
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  (filteredList[index].type == "WITHDRAWAL"
                                          ? "- "
                                          : "+ ") +
                                      "₹ ${filteredList[index].amount.toString()}",
                                  style: GoogleFonts.montserrat(
                                    color: getTileColor(
                                        filteredList[index].tranStatus),
                                    fontSize: SizeConfig.mediumTextSize,
                                  ),
                                ),
                                Text(
                                  filteredList[index].updatedTime.toString(),
                                  style: GoogleFonts.montserrat(
                                      color: getTileColor(
                                          filteredList[index].tranStatus),
                                      fontSize: SizeConfig.smallTextSize),
                                )
                              ],
                            ),
                          ); // Refer step 3
                        },
                      ),
              ),
            ],
          ),
        ));
  }
}
