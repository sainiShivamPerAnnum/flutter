import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class GoldBuySuccessView extends StatelessWidget {
  final _augTxnService = locator<AugmontTransactionService>();
  final _gtService = locator<GoldenTicketService>();
  GoldBuySuccessView({Key key}) : super(key: key);

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
                    Future.delayed(Duration(milliseconds: 500), () {
                      _gtService.showInstantGoldenTicketView(
                        amount: _augTxnService.currentTxnAmount,
                        title:
                            "You have successfully saved ₹${_augTxnService.getAmount(_augTxnService.currentTxnAmount)}",
                        source: GTSOURCE.deposit,
                      );
                    });
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
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Lottie.asset(
                    Assets.goldDepostSuccessLottie,
                    fit: BoxFit.cover,
                  ),
                ),
                if (_augTxnService.currentTxnAmount > 0)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.padding12,
                          bottom: SizeConfig.padding24),
                      child: Lottie.asset(
                        Assets.floatingTokenIslandLottie,
                        width: SizeConfig.screenWidth * 0.3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (GoldenTicketService.currentGT != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(
                        right: SizeConfig.padding12,
                        top: SizeConfig.padding24,
                      ),
                      child: Lottie.asset(
                        Assets.floatingGoldenTicketIslandLottie,
                        width: SizeConfig.screenWidth * 0.3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (_augTxnService.currentTxnTambolaTicketsCount > 0)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Lottie.asset(
                        Assets.floatingTambolaTicketIslandLottie,
                        width: SizeConfig.screenWidth * 0.3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
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
                left: SizeConfig.pageHorizontalMargins,
                right: SizeConfig.pageHorizontalMargins,
                top: SizeConfig.pageHorizontalMargins),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: UiConstants.kTextColor2),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConfig.roundness12),
                topLeft: Radius.circular(SizeConfig.roundness12),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.pageHorizontalMargins,
                          top: SizeConfig.padding16,
                          bottom: SizeConfig.padding16,
                          right: SizeConfig.padding8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Invested",
                              style: TextStyles.sourceSans.body2
                                  .colour(UiConstants.kTextColor2)),
                          SizedBox(height: SizeConfig.padding16),
                          Text(
                              "₹ ${BaseUtil.getIntOrDouble(_augTxnService.currentTxnAmount)}",
                              style: TextStyles.rajdhaniB.title3),
                          SizedBox(height: SizeConfig.padding12),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 3,
                    thickness: 0.5,
                    color: UiConstants.kTextColor2,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.pageHorizontalMargins,
                          top: SizeConfig.padding16,
                          bottom: SizeConfig.padding16,
                          right: SizeConfig.padding16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bought",
                              style: TextStyles.sourceSans.body2
                                  .colour(UiConstants.kTextColor2)),
                          SizedBox(height: SizeConfig.padding16),
                          Text("${_augTxnService.currentTxnGms} gms",
                              style: TextStyles.rajdhaniB.title4),
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
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.roundness12),
                bottomRight: Radius.circular(SizeConfig.roundness12),
              ),
              // color: UiConstants.kModalSheetSecondaryBackgroundColor,
              border: Border.all(width: 0.5, color: UiConstants.kTextColor2),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding12,
            ),
            child: Row(children: [
              Text(
                "Balance",
                style:
                    TextStyles.rajdhani.body3.colour(UiConstants.kTextColor3),
              ),
              Spacer(),
              UserFundQuantitySE(
                style:
                    TextStyles.sourceSans.body2.colour(UiConstants.kTextColor),
              )
            ]),
          ),
          Container(
            padding: EdgeInsets.only(
                top: SizeConfig.padding20,
                bottom: SizeConfig.padding20,
                right: SizeConfig.pageHorizontalMargins,
                left: SizeConfig.pageHorizontalMargins),
            child: Row(
              children: [
                WinningChips(
                    title: 'Fello Tokens',
                    tooltip: "Fello Tokens",
                    asset: Assets.token,
                    qty: _augTxnService.currentTxnAmount.toInt()),
                if (GoldenTicketService.currentGT != null)
                  SizedBox(width: SizeConfig.padding12),
                if (GoldenTicketService.currentGT != null)
                  WinningChips(
                      title: 'Golden Ticket',
                      tooltip: "Golden Tickets",
                      asset: Assets.unredemmedGoldenTicketBG,
                      qty: 1),
                if (_augTxnService.currentTxnTambolaTicketsCount > 0)
                  SizedBox(width: SizeConfig.padding12),
                if (_augTxnService.currentTxnTambolaTicketsCount > 0)
                  WinningChips(
                      title: 'Tambola Ticket',
                      tooltip: "Tambola Tickets",
                      asset: Assets.singleTmbolaTicket,
                      qty: _augTxnService.currentTxnTambolaTicketsCount)
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              AppState.backButtonDispatcher.didPopRoute();
              AppState.delegate.appState.setCurrentTabIndex = 1;
              Future.delayed(Duration(milliseconds: 500), () {
                _gtService.showInstantGoldenTicketView(
                  amount: _augTxnService.currentTxnAmount,
                  showAutoSavePrompt: true,
                  title:
                      "You have successfully saved ₹${_augTxnService.getAmount(_augTxnService.currentTxnAmount)}",
                  source: GTSOURCE.deposit,
                );
              });
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

class WinningChips extends StatelessWidget {
  final String title;
  final String asset;
  final int qty;
  final String tooltip;
  final EdgeInsets margin;

  const WinningChips(
      {Key key,
      @required this.title,
      @required this.asset,
      @required this.qty,
      @required this.tooltip,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: ((context, constraints) => Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message: tooltip,
              child: Container(
                // height: SizeConfig.padding80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  color: UiConstants.darkPrimaryColor2,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins,
                  vertical: SizeConfig.padding12,
                ),
                margin: margin ?? EdgeInsets.zero,
                child: constraints.maxWidth < SizeConfig.screenWidth / 3
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: TextStyles.sourceSans.body4),
                          SizedBox(height: SizeConfig.padding6),
                          Row(
                            children: [
                              SvgPicture.asset(
                                asset,
                                width: SizeConfig.padding20,
                                height: SizeConfig.padding20,
                              ),
                              SizedBox(
                                width: SizeConfig.padding6,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: SizeConfig.screenWidth * 0.08),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(qty.toString(),
                                      style: TextStyles.rajdhaniB.title3),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(
                              child: Text(title,
                                  style: TextStyles.sourceSans.body4),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: SizeConfig.padding12,
                                ),
                                SvgPicture.asset(
                                  asset,
                                  width: SizeConfig.padding20,
                                  height: SizeConfig.padding20,
                                ),
                                SizedBox(
                                  width: SizeConfig.padding6,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: SizeConfig.screenWidth * 0.09),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(qty.toString(),
                                        style: TextStyles.rajdhaniB.title3),
                                  ),
                                ),
                              ],
                            )
                          ]),
              ),
            )),
      ),
    );
  }
}
