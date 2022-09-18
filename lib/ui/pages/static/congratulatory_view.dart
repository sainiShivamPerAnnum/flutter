import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/paytm_models/deposit_fcm_response_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/seprator.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class CongratulatoryView extends StatelessWidget {
  CongratulatoryView({Key key}) : super(key: key);
  // final TransactionService _txnService = locator<TransactionService>();
  final _userservice = locator<UserService>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.padding32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Lottie.asset(
              Assets.goldDepostSuccessLottie,
            ),
          ),
          Text(
            "Congratulations!",
            style: TextStyles.rajdhaniB.title2,
          ),
          SizedBox(height: SizeConfig.padding12),
          Text(
            "Your recharge was successfully processed",
            style: TextStyles.sourceSans.body2.setOpecity(0.7),
          ),
          Container(
            margin: EdgeInsets.only(
              top: SizeConfig.padding24,
              bottom: SizeConfig.padding12,
              left: SizeConfig.pageHorizontalMargins * 2,
              right: SizeConfig.pageHorizontalMargins * 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              color: UiConstants.darkPrimaryColor2,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding12,
            ),
            child: Row(children: [
              Text("Tokens Won", style: TextStyles.rajdhani.body1),
              Spacer(),
              SvgPicture.asset(
                'assets/temp/Tokens.svg',
                width: SizeConfig.padding26,
                height: SizeConfig.padding26,
              ),
              SizedBox(
                width: SizeConfig.padding6,
              ),
              Text((AppState.currentTxnAmount.toInt()).toString(),
                  style: TextStyles.rajdhaniB.title3),
            ]),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins * 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConfig.roundness12),
                topLeft: Radius.circular(SizeConfig.roundness12),
              ),
              color: UiConstants.darkPrimaryColor2,
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.padding16,
                          top: SizeConfig.padding16,
                          bottom: SizeConfig.padding16,
                          right: SizeConfig.padding8),
                      child: Column(
                        children: [
                          Text("Invested", style: TextStyles.sourceSans.body2),
                          SizedBox(height: SizeConfig.padding16),
                          Text(
                              "₹ ${BaseUtil.getIntOrDouble(AppState.currentTxnAmount)}",
                              style: TextStyles.rajdhaniB.title3),
                          SizedBox(height: SizeConfig.padding12),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(width: 3),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.padding8,
                          top: SizeConfig.padding16,
                          bottom: SizeConfig.padding16,
                          right: SizeConfig.padding16),
                      child: Column(
                        children: [
                          Text("Bought", style: TextStyles.sourceSans.body2),
                          SizedBox(height: SizeConfig.padding16),
                          Text("${AppState.currentTxnGms} gms",
                              style: TextStyles.rajdhaniB.title3),
                          SizedBox(height: SizeConfig.padding12),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: SizeConfig.pageHorizontalMargins * 2,
              right: SizeConfig.pageHorizontalMargins * 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.roundness12),
                bottomRight: Radius.circular(SizeConfig.roundness12),
              ),
              color: UiConstants.kModalSheetSecondaryBackgroundColor,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding12,
            ),
            child: Row(children: [
              Text("Tokens Won",
                  style: TextStyles.rajdhani.body3
                      .colour(UiConstants.kBackgroundColor)),
              Spacer(),
              UserGoldQuantitySE(
                style: TextStyles.sourceSans.body2,
              )
            ]),
          ),
          SizedBox(height: SizeConfig.padding24),
          TextButton(
            onPressed: () {
              AppState.backButtonDispatcher.didPopRoute();
              AppState.delegate.appState.setCurrentTabIndex = 1;
            },
            child: Text(
              "START PLAYING",
              style:
                  TextStyles.rajdhaniSB.body0.colour(UiConstants.primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
