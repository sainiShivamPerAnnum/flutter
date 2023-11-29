import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class GoldSellSuccessView extends StatelessWidget {
  final GoldSellViewModel model;
  final AugmontTransactionService augTxnservice;

  const GoldSellSuccessView(
      {required this.model, required this.augTxnservice, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
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
                    AppState.backButtonDispatcher!.didPopRoute();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Lottie.network(
              Assets.goldSellCompleteLottie,
            ),
          ),
          Text(
            locale.btnCongratulations,
            style: TextStyles.rajdhaniB.title2,
          ),
          SizedBox(height: SizeConfig.padding12),
          Text(
            locale.txnWithDrawalSuccess,
            style: TextStyles.sourceSans.body2.setOpacity(0.7),
          ),
          if (model.deductedTokensCount != null &&
              model.deductedTokensCount! > 0)
            Container(
              margin: EdgeInsets.only(
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
                Text('Tickets Deducted', style: TextStyles.rajdhani.body1),
                const Spacer(),
                SvgPicture.asset(
                  Assets.singleTmbolaTicket,
                  width: SizeConfig.padding26,
                  height: SizeConfig.padding26,
                ),
                SizedBox(
                  width: SizeConfig.padding6,
                ),
                Text(model.deductedTokensCount.toString(),
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
                          left: SizeConfig.padding24,
                          top: SizeConfig.padding16,
                          bottom: SizeConfig.padding16,
                          right: SizeConfig.padding16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.sold, style: TextStyles.sourceSans.body2),
                          SizedBox(height: SizeConfig.padding16),
                          Text("${augTxnservice.currentTxnGms}" + locale.gm,
                              style: TextStyles.rajdhaniB.title4),
                          SizedBox(height: SizeConfig.padding12),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 3),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.padding24,
                          top: SizeConfig.padding16,
                          bottom: SizeConfig.padding16,
                          right: SizeConfig.padding8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.received,
                              style: TextStyles.sourceSans.body2),
                          SizedBox(height: SizeConfig.padding16),
                          Text(
                              "₹ ${BaseUtil.digitPrecision(augTxnservice.currentTxnAmount!, 2)}",
                              style: TextStyles.rajdhaniB.title3),
                          SizedBox(height: SizeConfig.padding12),
                        ],
                      ),
                    ),
                  ),
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
              Text(locale.saveGoldBalancelabel,
                  style: TextStyles.rajdhani.body3
                      .colour(UiConstants.kBackgroundColor)),
              const Spacer(),
              UserFundQuantitySE(
                style: TextStyles.sourceSans.body2,
              )
            ]),
          ),
          SizedBox(height: SizeConfig.padding24),
          TextButton(
            onPressed: () {
              AppState.backButtonDispatcher!.didPopRoute();
            },
            child: Text(
              locale.obDone,
              style:
                  TextStyles.rajdhaniSB.body0.colour(UiConstants.primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
