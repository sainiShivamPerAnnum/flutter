import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                      'P2P Wallet',
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
                  '8 % Returns on your investment',
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
                      'Current Value:',
                      style: TextStyles.sourceSans.body3.copyWith(
                        color: Color(0xffF5F5F8),
                      ),
                    ),
                    Text(
                      '₹10K',
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
