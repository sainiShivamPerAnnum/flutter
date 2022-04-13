import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
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
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.padding40),
                    topRight: Radius.circular(SizeConfig.padding40),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.scaffoldMargin),
                    FelloBriefTile(
                      leadingAsset: Assets.bank,
                      title: "Bank Account Details",
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                      onTap: () => onTap(EditAugBankDetailsPageConfig),
                    ),
                    FelloBriefTile(
                      leadingAsset: Assets.txnHistory,
                      title: "Transaction History and Invoice",
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                      onTap: () => onTap(TransactionsHistoryPageConfig),
                    ),
                    // FelloBriefTile(
                    //   leadingAsset: Assets.repeat,
                    //   title: "AutoSave UPI Details",
                    //   trailingIcon: Icons.arrow_forward_ios_rounded,
                    //   onTap: () => onTap(UserAutoSaveDetailsViewPageConfig),
                    // ),
                    FelloBriefTile(
                      leadingAsset: Assets.txnHistory,
                      title: "AutoSave transactions",
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                      onTap: () => onTap(AutosaveTransactionsViewPageConfig),
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

  onTap(PageConfiguration config) {
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: config,
    );
  }
}
