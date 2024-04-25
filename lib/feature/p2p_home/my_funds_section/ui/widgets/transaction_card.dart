import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.grey4,
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness12,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            color: Colors.black.withOpacity(.30),
          ),
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 2,
            color: Colors.black.withOpacity(.15),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding12,
        horizontal: SizeConfig.padding14,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: UiConstants.kArrowButtonBackgroundColor,
                  borderRadius: BorderRadius.circular(
                    SizeConfig.roundness8,
                  ),
                ),
                padding: EdgeInsets.all(SizeConfig.padding12),
                child: Column(
                  children: [
                    Text(
                      '8%',
                      style: TextStyles.rajdhaniB.body2.copyWith(
                        color: UiConstants.teal3,
                      ),
                    ),
                    Text(
                      'per annum',
                      style: TextStyles.sourceSans.body4.copyWith(
                        color: UiConstants.teal3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: SizeConfig.padding12,
              ),
              Text(
                '1 Month Plan',
                style: TextStyles.sourceSansSB.body1,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InvestmentInfo(
                title: 'Invested',
                subtitle: '₹30K',
              ),
              _InvestmentInfo(
                title: 'Current Value',
                subtitle: '₹39.7K',
              ),
              _InvestmentInfo(
                title: 'Lock-in till',
                subtitle: '12th April 2024',
              ),
            ],
          ),
          Divider(
            height: SizeConfig.padding25,
            thickness: .5,
            color: UiConstants.textGray70.withOpacity(.4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Re-Invest on maturity',
                style: TextStyles.sourceSans.body4.copyWith(
                  color: UiConstants.textGray60,
                ),
              ),
              Text(
                '+ 0.25% Returns',
                style: TextStyles.sourceSans.body4.copyWith(
                  color: UiConstants.yellow2,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _InvestmentInfo extends StatelessWidget {
  const _InvestmentInfo({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.sourceSans.body4.copyWith(
            color: UiConstants.textGray70,
          ),
        ),
        Text(
          subtitle,
          style: TextStyles.sourceSans.body3,
        )
      ],
    );
  }
}
