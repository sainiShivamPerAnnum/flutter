import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    required this.transaction,
    super.key,
  });

  final UserTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    final assetInformation = AppConfigV2.instance.lendBoxP2P.firstWhere(
      (e) => e.fundType == transaction.lbMap.fundType,
    );
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
                      locale.percentage(assetInformation.interest),
                      style: TextStyles.rajdhaniB.body2.copyWith(
                        color: UiConstants.teal3,
                      ),
                    ),
                    Text(
                      locale.perAnnumLabel,
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
                assetInformation.assetName,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InvestmentInfo(
                title: locale.invested,
                subtitle: locale.amount(
                  BaseUtil.formatCompactRupees(transaction.amount),
                ),
              ),
              _InvestmentInfo(
                title: locale.currentValue,
                subtitle: locale.amount(
                  BaseUtil.formatCompactRupees(
                    transaction.amount + (transaction.lbMap.gainAmount ?? 0),
                  ),
                ),
              ),
              _InvestmentInfo(
                title: locale.lockInTill,
                subtitle: BaseUtil.formatDateWithOrdinal(
                  DateTime.fromMicrosecondsSinceEpoch(
                    transaction.lbMap.maturityAt!.microsecondsSinceEpoch,
                  ),
                ),
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
                locale.reInvestOnMaturity,
                style: TextStyles.sourceSans.body4.copyWith(
                  color: UiConstants.textGray60,
                ),
              ),
              Text(
                locale.extraReturns(.35),
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
