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
    return Container(
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
                      locale.amount(10.toString()),
                      style: TextStyles.sourceSansSB.body1,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
