import 'dart:io';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
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
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      floatingActionButton: keyboardIsOpen && Platform.isIOS
          ? FloatingActionButton(
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
              backgroundColor: UiConstants.tertiarySolid,
              onPressed: () => FocusScope.of(context).unfocus(),
            )
          : SizedBox(),
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
                      leadingAsset: Assets.wmtsaveMoney,
                      title: "Bank Account Details",
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                      onTap: () {
                        AppState.delegate.appState.currentAction = PageAction(
                          state: PageState.addPage,
                          page: EditAugBankDetailsPageConfig,
                        );
                      },
                    ),
                    FelloBriefTile(
                      leadingAsset: Assets.tickets,
                      title: "Transactions History and Invoice",
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                      onTap: () {
                        AppState.delegate.appState.currentAction = PageAction(
                          state: PageState.addPage,
                          page: TransactionsHistoryPageConfig,
                        );
                      },
                    ),
                    SizedBox(height: 50),
                    TextField(
                      decoration: InputDecoration(labelText: "Number"),
                      keyboardType: TextInputType.number,
                      onSubmitted: (cal) {},
                    ),
                    TextField(
                      decoration:
                          InputDecoration(labelText: "NumberWithOptions"),
                      keyboardType: TextInputType.numberWithOptions(),
                      onSubmitted: (cal) {},
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "NumberWithOptions(signed:true)"),
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                      onSubmitted: (cal) {},
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText:
                              "NumberWithOptions(signed:true,decimal:true)"),
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      onSubmitted: (cal) {},
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Phone"),
                      keyboardType: TextInputType.phone,
                      onSubmitted: (cal) {},
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText:
                              "TextInputAction.done with numberswithOption"),
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (cal) {},
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "TextInputAction.done with number"),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (cal) {},
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
