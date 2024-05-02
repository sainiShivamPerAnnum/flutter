import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/lendbox/withdrawal/lendbox_flexi.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return GestureDetector(
      onTap: () {
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addWidget,
          widget: const FlexiBalanceView(),
          page: FlexiBalancePageConfig,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: UiConstants.grey5,
          borderRadius: BorderRadius.circular(
            SizeConfig.roundness12,
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding12,
          horizontal: SizeConfig.padding18,
        ),
        child: Row(
          children: [
            const AppImage(
              Assets.p2pWallet,
              width: 60,
              height: 60,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.wallet,
                        style: TextStyles.rajdhaniSB.body1,
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding8,
                  ),
                  Text(
                    locale.walletInterest(8),
                    style: TextStyles.sourceSans.body3.copyWith(
                      color: UiConstants.grey1,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.walletCurrentValueLabel,
                        style: TextStyles.sourceSans.body3,
                      ),
                      Text(
                        locale.amount(
                          BaseUtil.formatCompactRupees(locator<UserService>()
                              .userPortfolio
                              .flo
                              .flexi
                              .balance
                              .toDouble()),
                        ),
                        style: TextStyles.sourceSansSB.body1,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
