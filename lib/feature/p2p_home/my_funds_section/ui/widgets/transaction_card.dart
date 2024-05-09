import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/feature/p2p_home/home/widgets/percentage_chip.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/bloc/my_funds_section_bloc.dart';
import 'package:felloapp/feature/p2p_home/transactions_section/bloc/transaction_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transaction_details_view.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/analytics_events_constants.dart';
import '../../../../../core/service/analytics/analytics_service.dart';
import '../../../../../core/service/notifier_services/user_service.dart';
import '../../../../../util/constants.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    required this.transaction,
    required this.fundBloc,
    super.key,
  });

  final UserTransaction transaction;
  final MyFundsBloc fundBloc;

  void trackDepositCardInFloSlabTapped({
    required LendboxAssetConfiguration assetInformation,
    required num totalInvested,
    required num currentValue,
    required String maturityDate,
  }) {
    final kycStatus = locator<UserService>().baseUser!.isKycVerified;
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.depositCardInFloSlabTapped,
      properties: {
        "type": assetInformation.fundType,
        "interest": assetInformation.interest,
        "total_invested": totalInvested,
        // "total_transaction": ,
        "kyc_status": kycStatus,

        "asset_name": assetInformation.assetName,
        "new_user": locator<UserService>().userSegments.contains(
              Constants.NEW_USER,
            ),

        "current_amount": currentValue,
        "maturity_date": maturityDate
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    final assetInformation = AppConfigV2.instance.lendBoxP2P.firstWhere(
      (e) => e.fundType == transaction.lbMap.fundType,
    );
    bool isNewAsset = AppConfigV2.instance.lbV2.values
        .toList()
        .any((fund) => fund.fundType == transaction.lbMap.fundType);
    return GestureDetector(
      onTap: () {
        Haptic.vibrate();
        trackDepositCardInFloSlabTapped(
          assetInformation: assetInformation,
          totalInvested: transaction.amount,
          currentValue:
              transaction.amount + (transaction.lbMap.gainAmount ?? 0),
          maturityDate: DateFormat('dd/MMM/yyyy').format(
            DateTime.fromMicrosecondsSinceEpoch(
              transaction.lbMap.maturityAt!.microsecondsSinceEpoch,
            ),
          ),
        );
        final transactionBloc = context.read<TransactionBloc>();
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: TransactionDetailsPageConfig,
          widget: TransactionDetailsPage(
            txn: transaction,
            onUpdatePrefrence: () {
              fundBloc.reset();
              transactionBloc.reset();
            },
          ),
        );
      },
      child: Container(
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
                  showGainChip: true,
                  totalInvestment: transaction.amount,
                  avgGains: transaction.lbMap.gainAmount ?? 0,
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
                  transaction.lbMap.maturityPref == '1'
                      ? locale.reInvestOnMaturity
                      : isNewAsset
                          ? locale.movesToVault
                          : 'Moves to P2P Wallet',
                  style: TextStyles.sourceSans.body4.copyWith(
                    color: UiConstants.textGray60,
                  ),
                ),
                Text(
                  transaction.lbMap.maturityPref == '1'
                      ? isNewAsset
                          ? locale.extraReturns(
                              assetInformation.reinvestInterestGain,
                            )
                          : locale.reinvestInSamePlan
                      : isNewAsset
                          ? locale.loosingReturns(
                              assetInformation.reinvestInterestGain,
                            )
                          : locale.withdrawMaturity,
                  style: TextStyles.sourceSans.body4.copyWith(
                    color: transaction.lbMap.maturityPref == '1'
                        ? UiConstants.yellow2
                        : UiConstants.peach2,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _InvestmentInfo extends StatelessWidget {
  const _InvestmentInfo({
    required this.title,
    required this.subtitle,
    this.showGainChip = false,
    this.totalInvestment = 1,
    this.avgGains = 0,
  });

  final String title;
  final String subtitle;
  final bool showGainChip;
  final num totalInvestment;
  final num avgGains;

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
        Row(
          children: [
            Text(
              subtitle,
              style: TextStyles.sourceSans.body3,
            ),
            if (showGainChip)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: PercentageChip(
                  value: (avgGains / totalInvestment) * 100.toDouble(),
                ),
              ),
          ],
        )
      ],
    );
  }
}
