import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class Transactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.primaryColor,
      body: HomeBackground(
        child: Column(
          children: [
            FelloAppBar(
              leading: FelloAppBarBackButton(),
              title: "Transactions",
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.scaffoldMargin),
                    Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.scaffoldMargin,
                          vertical: SizeConfig.scaffoldMargin / 2),
                      decoration: BoxDecoration(
                        color: Color(0xffF6F9FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        onTap: () {
                          AppState.delegate.appState.currentAction = PageAction(
                              state: PageState.addPage,
                              page: EditAugBankDetailsPageConfig);
                        },
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        leading: CircleAvatar(
                          radius: kToolbarHeight * 0.5,
                          backgroundColor: Color(0xffE3F4F7),
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: UiConstants.primaryColor,
                          ),
                        ),
                        title: Text(
                          "Bank Account Detail",
                          style: TextStyles.body1.bold,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: UiConstants.primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.scaffoldMargin,
                          vertical: SizeConfig.scaffoldMargin / 2),
                      decoration: BoxDecoration(
                        color: Color(0xffF6F9FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        onTap: () {
                          AppState.delegate.appState.currentAction = PageAction(
                              state: PageState.addPage,
                              page: TransactionsHistoryPageConfig);
                        },
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        leading: CircleAvatar(
                          radius: kToolbarHeight * 0.5,
                          backgroundColor: Color(0xffE3F4F7),
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: UiConstants.primaryColor,
                          ),
                        ),
                        title: Text(
                          "Transaction History",
                          style: TextStyles.body1.bold,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: UiConstants.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
