import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/modals_sheets/generate_invoice_modal_sheet.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/flavor_config.dart';

import 'package:felloapp/core/service/notifier_services/user_service.dart';

class Transactions extends StatelessWidget {
  final _userService = locator<UserService>();
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
                      leadingAsset: Assets.upiIcon,
                      title: "UPI Details",
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                      coloredIcon: false,
                      onTap: () => onTap(UserUpiDetailsViewPageConfig),
                    ),
                    FelloBriefTile(
                      leadingAsset: Assets.txnHistory,
                      title: "Transaction History and Invoice",
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                      onTap: () => onTap(TransactionsHistoryPageConfig),
                    ),
                    if (FlavorConfig.isDevelopment() ||
                        _userService.baseUser.mobile == "8050564530")
                      FelloBriefTile(
                        leadingAsset: Assets.repeat,
                        title: "Generate Transaction Invoice",
                        subtitle: "Just for BP",
                        trailingIcon: Icons.arrow_forward_ios_rounded,
                        onTap: () {
                          BaseUtil.openModalBottomSheet(
                              addToScreenStack: true,
                              isScrollControlled: true,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(SizeConfig.padding24),
                                topRight: Radius.circular(SizeConfig.padding24),
                              ),
                              isBarrierDismissable: false,
                              backgroundColor: Colors.white,
                              content: GenerateInvoiceModalSheet());
                        },
                      ),
                    // FelloBriefTile(
                    //   leadingAsset: Assets.txnHistory,
                    //   title: "Autosave transactions",
                    //   trailingIcon: Icons.arrow_forward_ios_rounded,
                    //   onTap: () => onTap(AutosaveTransactionsViewPageConfig),
                    // ),
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
