import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_type_enum.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_buy/gold_buy_success_view.dart';
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

  void showGtIfAvailable() {
    if (transactionType == TransactionType.DEPOSIT) {
      _txnService.showGtIfAvailable();
    }
  }

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
                    this.showGtIfAvailable();
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
                    Assets.floDepositSuccessLottie,
                    fit: BoxFit.cover,
                  ),
                ),
                if (_txnService.currentTxnAmount > 0)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: SizeConfig.padding12,
                        bottom: SizeConfig.padding24,
                      ),
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
                if (_txnService.currentTxnTambolaTicketsCount > 0)
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
          SizedBox(
            height: SizeConfig.padding20,
          ),
          Container(
            margin: EdgeInsets.only(
              left: SizeConfig.pageHorizontalMargins,
              right: SizeConfig.pageHorizontalMargins,
              top: SizeConfig.pageHorizontalMargins,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: UiConstants.kTextColor2),
              borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.roundness12),
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
                        right: SizeConfig.padding8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Invested",
                              style: TextStyles.sourceSans.body2
                                  .colour(UiConstants.kTextColor2)),
                          SizedBox(height: SizeConfig.padding16),
                          Text(
                            "₹ ${BaseUtil.getIntOrDouble(_txnService.currentTxnAmount)}",
                            style: TextStyles.rajdhaniB.title3,
                          ),
                          SizedBox(
                            height: SizeConfig.padding12,
                          ),
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
                          Text(
                            "Total Balance",
                            style: TextStyles.sourceSans.body2
                                .colour(UiConstants.kTextColor2),
                          ),
                          SizedBox(height: SizeConfig.padding16),
                          UserFundQuantitySE(
                            style: TextStyles.rajdhaniB.title3,
                            investmentType: InvestmentType.LENDBOXP2P,
                          ),
                          SizedBox(
                            height: SizeConfig.padding12,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: SizeConfig.padding20,
              bottom: SizeConfig.padding20,
              right: SizeConfig.pageHorizontalMargins,
              left: SizeConfig.pageHorizontalMargins,
            ),
            child: Row(
              children: [
                WinningChips(
                    title: 'Fello Tokens',
                    asset: Assets.token,
                    qty: _txnService.currentTxnAmount.toInt()),
                if (GoldenTicketService.currentGT != null)
                  SizedBox(width: SizeConfig.padding12),
                if (GoldenTicketService.currentGT != null)
                  WinningChips(
                      title: 'Golden Ticket',
                      asset: Assets.unredemmedGoldenTicketBG,
                      qty: 1),
                if (_txnService.currentTxnTambolaTicketsCount > 0)
                  SizedBox(width: SizeConfig.padding12),
                if (_txnService.currentTxnTambolaTicketsCount > 0)
                  WinningChips(
                    title: 'Tambola Ticket',
                    asset: Assets.singleTmbolaTicket,
                    qty: _txnService.currentTxnAmount.toInt(),
                  )
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              AppState.backButtonDispatcher.didPopRoute();
              AppState.delegate.appState.setCurrentTabIndex = 1;
              this.showGtIfAvailable();
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
