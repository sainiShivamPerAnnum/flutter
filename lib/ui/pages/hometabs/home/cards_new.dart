import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/home/balance_page.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.delegate!.appState.currentAction = PageAction(
          page: BalancePageConfig,
          state: PageState.addWidget,
          widget: FelloBalanceScreen(),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding14,
          horizontal: SizeConfig.padding18,
        ),
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Portfolio Balance',
                      style: TextStyles.sourceSansSB.body3,
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: SizeConfig.body3,
                      color: UiConstants.kTextColor,
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.info,
                  size: SizeConfig.body6,
                  color: UiConstants.kTextColor,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.padding4),
            Selector<UserService, Portfolio>(
              builder: (_, portfolio, child) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    BaseUtil.formatIndianRupees(getTotalBalance(portfolio)),
                    style: TextStyles.sourceSansSB.title3,
                  ),
                  SizedBox(width: SizeConfig.padding8),
                  Transform.translate(
                    offset: Offset(0, SizeConfig.padding3),
                    child: Row(
                      children: [
                        RotatedBox(
                          quarterTurns:
                              portfolio.absolute.percGains < 0 ? 2 : 0,
                          child: AppImage(
                            Assets.arrow,
                            width: SizeConfig.body4,
                            color: portfolio.absolute.percGains < 0
                                ? Colors.red
                                : UiConstants.primaryColor,
                          ),
                        ),
                        Text(
                          " ${BaseUtil.digitPrecision(portfolio.absolute.percGains, 2, false)}%",
                          style: TextStyles.sourceSansSB.body3.colour(
                            portfolio.absolute.percGains < 0
                                ? Colors.red
                                : UiConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              selector: (_, userService) => userService.userPortfolio,
            ),
          ],
        ),
      ),
    );
  }

  int getTotalBalance(Portfolio portfolio) {
    if (portfolio.absolute.balance != 0) {
      return portfolio.absolute.balance.toInt();
    } else {
      String stringBalance =
          PreferenceHelper.getString(Constants.FELLO_BALANCE);

      double doubleBalance = double.tryParse(stringBalance) ?? 0.0;
      int intBalance = doubleBalance.toInt();
      return intBalance;
    }
  }
}
