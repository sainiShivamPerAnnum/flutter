import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/base_util.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class DepositOptionModalSheet extends StatelessWidget {
  final int? amount;
  final bool? isSkipMl;
  DepositOptionModalSheet({this.amount, this.isSkipMl});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher!.didPopRoute();
        return Future.value(true);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            vertical: SizeConfig.pageHorizontalMargins),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(locale.chooseYourAsset, style: TextStyles.rajdhaniSB.title5),
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding4),
                child: Text(
                  locale.earnOneToken,
                  style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor2,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.padding16),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: UiConstants.kTextColor2, width: 0.5),
                    borderRadius:
                        BorderRadius.circular(SizeConfig.roundness12)),
                padding: EdgeInsets.all(SizeConfig.padding12),
                child: ListTile(
                    leading: Image.asset(Assets.digitalGoldBar),
                    title: Text(locale.digitalGoldText,
                        style: TextStyles.rajdhaniB.title4),
                    subtitle: Text(
                      locale.buyGold,
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextColor2),
                    ),
                    onTap: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                      BaseUtil().openRechargeModalSheet(
                        amt: amount,
                        isSkipMl: isSkipMl,
                        investmentType: InvestmentType.AUGGOLD99,
                      );
                    }),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: UiConstants.kTextColor2, width: 0.5),
                    borderRadius:
                        BorderRadius.circular(SizeConfig.roundness12)),
                padding: EdgeInsets.all(SizeConfig.padding12),
                child: ListTile(
                    leading: Image.asset(Assets.felloFlo),
                    title: Text(locale.felloFloText,
                        style: TextStyles.rajdhaniB.title4),
                    subtitle: Text(
                      locale.felloFloEarnTxt,
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextColor2),
                    ),
                    onTap: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                      BaseUtil().openRechargeModalSheet(
                        amt: amount,
                        isSkipMl: isSkipMl,
                        investmentType: InvestmentType.LENDBOXP2P,
                      );
                    }),
              )
            ]),
      ),
    );
  }
}
