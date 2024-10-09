import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/home/balance_page.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

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
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding18),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '₹ 12,66,320.78',
                  style: TextStyles.sourceSansSB.title3,
                ),
                 SizedBox(width: SizeConfig.padding8),
                Icon(
                  Icons.arrow_upward,
                  color: UiConstants.kTabBorderColor,
                  size: SizeConfig.body6,
                ),
                Text(
                  ' 11.3%',
                  style: TextStyles.sourceSansSB.body3.colour(
                    UiConstants.kTabBorderColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
