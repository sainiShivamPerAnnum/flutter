import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoTransactions extends StatelessWidget {
  NoTransactions({super.key});
  final locale = locator<S>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: SizeConfig.padding252,
          child: Text(
            locale.noP2Pinvestment,
            style: TextStyles.rajdhaniSB.body2.colour(
              UiConstants.textGray70,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(SizeConfig.padding16),
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding12)
              .copyWith(top: SizeConfig.padding16),
          decoration: BoxDecoration(
            color: UiConstants.grey4,
            borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.padding12),
            ),
          ),
          child: Column(
            children: [
              const AppImage(Assets.p2pNonInvest),
              SizedBox(height: SizeConfig.padding12),
              Selector<BankAndPanService, bool>(
                selector: (p0, p1) => p1.isKYCVerified,
                builder: (ctx, isKYCVerified, child) {
                  return MaterialButton(
                    height: SizeConfig.padding44,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness5)),
                    minWidth: SizeConfig.screenWidth! -
                        SizeConfig.pageHorizontalMargins * 2,
                    color: Colors.white,
                    onPressed: () {
                      if (isKYCVerified) {
                        DefaultTabController.of(context).animateTo(1);
                      } else {
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addPage,
                          page: KycDetailsPageConfig,
                        );
                      }
                    },
                    child: Text(
                      isKYCVerified ? locale.investP2p : locale.verifyKyc,
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
