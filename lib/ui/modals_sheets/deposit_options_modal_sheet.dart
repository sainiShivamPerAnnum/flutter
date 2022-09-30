import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DepositOptionModalSheet extends StatelessWidget {
  const DepositOptionModalSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher.didPopRoute();
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
              Text("Choose an asset to invest",
                  style: TextStyles.rajdhaniSB.title3),
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding4),
                child: Text(
                  "Your investments are safe and secure",
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
                    title: Text("Digital Gold",
                        style: TextStyles.rajdhaniB.title4),
                    subtitle: Text(
                      "Safest way to invest",
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextColor2),
                    ),
                    onTap: () {
                      AppState.backButtonDispatcher.didPopRoute();
                      BaseUtil().openRechargeModalSheet(
                          investmentType: InvestmentType.AUGGOLD99);
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
                    title:
                        Text("Fello Flo", style: TextStyles.rajdhaniB.title4),
                    subtitle: Text(
                      "Safest way to invest",
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextColor2),
                    ),
                    onTap: () {
                      AppState.backButtonDispatcher.didPopRoute();
                      BaseUtil().openRechargeModalSheet(
                          investmentType: InvestmentType.LENDBOXP2P);
                    }),
              )
            ]),
      ),
    );
  }
}
