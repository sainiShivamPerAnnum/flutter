import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/tabs/profile/transactions/tran_viewModel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Transactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("rebuild occured");
    return ChangeNotifierProvider<TranViewModel>(
      create: (_) => locator<TranViewModel>(),
      child: Consumer<TranViewModel>(
        child: BaseUtil.getAppBar(context, "Transactions"),
        builder: (context, model, child) {
          model.init();
          return Scaffold(
              appBar: child,
              body: model.state == TranState.Busy
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 3),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 2),
                            height: SizeConfig.screenHeight * 0.08,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: UiConstants.primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        value: model.filter,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text(
                                              "All",
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                      .mediumTextSize),
                                            ),
                                            value: 1,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              "Deposit",
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                      .mediumTextSize),
                                            ),
                                            value: 2,
                                          ),
                                          DropdownMenuItem(
                                              child: Text(
                                                "Withdrawal",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                        .mediumTextSize),
                                              ),
                                              value: 3),
                                          DropdownMenuItem(
                                              child: Text(
                                                "Prize",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                        .mediumTextSize),
                                              ),
                                              value: 4),
                                        ],
                                        onChanged: (value) {
                                          model.filter = value;
                                          model.filterTransactions();
                                        }),
                                  ),
                                ),
                                SizedBox(width: 30),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: UiConstants.primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        value: model.subFilter,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text(
                                              "All",
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                      .mediumTextSize),
                                            ),
                                            value: 1,
                                          ),
                                          DropdownMenuItem(
                                              child: Text(
                                                "ICICI",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                        .mediumTextSize),
                                              ),
                                              value: 2),
                                          DropdownMenuItem(
                                              child: Text(
                                                "Augmont",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                        .mediumTextSize),
                                              ),
                                              value: 3),
                                        ],
                                        onChanged: (value) {
                                          model.subFilter = value;
                                          model.filterTransactions();
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: (model.filteredList.length == 0
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
                                    controller: model.tranListController,
                                    children: model.getTxns(),
                                  )),
                          ),
                        ],
                      ),
                    ));
        },
      ),
    );
  }
}
