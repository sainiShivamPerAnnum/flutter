import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserMiniTransaction.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  int selectedValue = 1;
  bool isLoading = true;
  BaseUtil baseProvider;
  DBModel dbProvider;
  List<UserMiniTransaction> transactionList;

  /// Will used to access the Animated list
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    //getTransactions();
    super.initState();
  }

  getTransactions() {
    // isLoading = true;
    if (baseProvider != null && dbProvider != null) {
      print(baseProvider.myUser.uid);
      dbProvider
          .getFilteredUserTransactions(baseProvider.myUser, null, null, 0)
          .then((value) {
        transactionList = value;
        if (isLoading) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    getTransactions();
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
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 3),
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
                    DropdownButton(
                        value: selectedValue,
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
                              "Invest",
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
                          DropdownMenuItem(
                              child: Text(
                                "ICICI",
                                style: GoogleFonts.montserrat(
                                    fontSize: SizeConfig.mediumTextSize),
                              ),
                              value: 4),
                          DropdownMenuItem(
                              child: Text(
                                "Augmont",
                                style: GoogleFonts.montserrat(
                                    fontSize: SizeConfig.mediumTextSize),
                              ),
                              value: 5),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        }),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : AnimatedList(
                        key: listKey,
                        initialItemCount: transactionList.length,
                        itemBuilder: (context, index, animation) {
                          return ListTile(
                            title: Text(
                              transactionList[index].updatedTime.toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: SizeConfig.mediumTextSize,
                              ),
                            ),
                            subtitle: Text(
                              transactionList[index].subType,
                              style: GoogleFonts.montserrat(
                                fontSize: SizeConfig.mediumTextSize,
                              ),
                            ),
                            trailing: Text(
                              transactionList[index].amount.toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: SizeConfig.mediumTextSize,
                              ),
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
