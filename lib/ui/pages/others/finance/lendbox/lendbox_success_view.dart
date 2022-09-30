import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_type_enum.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class LendboxSuccessView extends StatelessWidget {
  final TransactionType transactionType;
  final _txnService = locator<LendboxTransactionService>();

  LendboxSuccessView({Key key, @required this.transactionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Lottie.asset(
              Assets.floDepostSuccessLottie,
            ),
          ),
          Text(
            "Congratulations!",
            style: TextStyles.rajdhaniB.title2,
          ),
          SizedBox(height: SizeConfig.padding12),
          Text(
            "Your investment was successfully processed",
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
            child: Row(
              children: [
                Text("Tokens Won", style: TextStyles.rajdhani.body1),
                Spacer(),
                SvgPicture.asset(
                  Assets.token,
                  width: SizeConfig.padding26,
                  height: SizeConfig.padding26,
                ),
                SizedBox(
                  width: SizeConfig.padding6,
                ),
                Text(
                  (_txnService.currentTxnAmount.toInt()).toString(),
                  style: TextStyles.rajdhaniB.title3,
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins * 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConfig.roundness12),
                topLeft: Radius.circular(SizeConfig.roundness12),
              ),
              color: UiConstants.darkPrimaryColor2,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                  vertical: SizeConfig.padding8,
                ),
                child: Row(
                  children: [
                    Text("Invested", style: TextStyles.sourceSans.body2),
                    Spacer(),
                    Text(
                      "₹ ${BaseUtil.getIntOrDouble(_txnService.currentTxnAmount)}",
                      style: TextStyles.rajdhaniB.title3,
                    ),
                    SizedBox(height: SizeConfig.padding12),
                  ],
                ),
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
            child: Row(
              children: [
                Text(
                  "Total Balance",
                  style: TextStyles.rajdhani.body3
                      .colour(UiConstants.kBackgroundColor),
                ),
                Spacer(),
                UserFundQuantitySE(
                  style: TextStyles.sourceSans.body2,
                  investmentType: InvestmentType.LENDBOXP2P,
                )
              ],
            ),
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
