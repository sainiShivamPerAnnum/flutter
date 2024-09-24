import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/home/balance_page.dart';
import 'package:flutter/material.dart';

class PortfolioCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.delegate!.appState.currentAction = PageAction(
          page: BalancePageConfig,
          state: PageState.addWidget,
          widget: FelloBalancePage(),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18),
        margin: EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Portfolio Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white60,
                  size: 18,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '₹ 12,66,320.78',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_upward,
                  color: Colors.greenAccent,
                  size: 18,
                ),
                Text(
                  ' 11.3%',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
