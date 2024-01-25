import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/finance/augmont/shared/interest_gain_label.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoldBalanceBriefRow extends StatelessWidget {
  const GoldBalanceBriefRow({
    this.mini = false,
    super.key,
  });

  final bool mini;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, model, child) {
        final portfolio = model.userPortfolio;
        final goldAmount = portfolio.augmont.fd.leased.toDouble();
        final currentValue = portfolio.augmont.fd.currentValue.toDouble();
        final payout = portfolio.augmont.fd.payouts.toDouble();

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AmountLabelledText(
                  title: 'Gold Leased',
                  subTitle: '${BaseUtil.digitPrecision(goldAmount, 4)} gms',
                ),
                _AmountLabelledText(
                  title: 'Current Value',
                  subTitle:
                      '${BaseUtil.digitPrecision(currentValue, 4, false)}gms',
                ),
              ],
            ),
            if (payout != 0) ...[
              Divider(
                color: Colors.white.withOpacity(.40),
                thickness: .1,
                height: SizeConfig.padding24,
              ),
              InterestGainLabel(
                interestQuantity: payout,
              )
            ] else ...[
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Text(
                'Interest will be credited to Digital gold monthly',
                style: TextStyles.sourceSans.body3.copyWith(
                  color: UiConstants.yellow3,
                  height: 1,
                ),
              ),
            ]
          ],
        );
      },
    );
  }
}

class _AmountLabelledText extends StatelessWidget {
  final String title;
  final String subTitle;

  const _AmountLabelledText({
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyles.rajdhaniSB.body2.colour(
            UiConstants.textGray70,
          ),
        ),
        Text(
          subTitle,
          style: TextStyles.sourceSansSB.body1.colour(
            UiConstants.yellow3,
          ),
        ),
      ],
    );
  }
}
