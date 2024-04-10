import 'package:collection/collection.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/enums/page_state_enum.dart';
import '../../../../../core/service/notifier_services/transaction_history_service.dart';
import '../../../../../core/service/notifier_services/user_service.dart';
import '../../../../../navigator/app_state.dart';
import '../../../../../navigator/router/ui_pages.dart';
import '../../../../../util/constants.dart';
import '../../../../../util/haptic.dart';
import '../../../../../util/localization/generated/l10n.dart';
import '../../../../../util/locator.dart';
import '../../../../architecture/base_view.dart';
import '../../../../elements/appbar/appbar.dart';
import '../../../static/app_widget.dart';
import '../../transactions_history/transactions_history_view.dart';
import 'lendbox_withdrawal_view.dart';
import 'lendbox_withdrawal_vm.dart';

class LendboxRetiredFlexi extends StatefulWidget {
  const LendboxRetiredFlexi({super.key});

  @override
  State<LendboxRetiredFlexi> createState() => _LendboxRetiredFlexiState();
}

class _LendboxRetiredFlexiState extends State<LendboxRetiredFlexi> {
  final UserService _usrService = locator<UserService>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Scaffold(
      backgroundColor: const Color(0xff151D22),
      appBar: FAppBar(
        title: null,
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
        action: Container(
          height: SizeConfig.avatarRadius * 2,
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            border: Border.all(
              color: Colors.white,
            ),
            color: Colors.transparent,
          ),
          child: TextButton(
            child: Text(
              locale.obNeedHelp,
              style: TextStyles.sourceSans.body3,
            ),
            onPressed: () {
              Haptic.vibrate();
              AppState.delegate!.appState.currentAction = PageAction(
                state: PageState.addPage,
                page: FreshDeskHelpPageConfig,
              );
            },
          ),
        ),
      ),
      body: BaseView<LendboxWithdrawalViewModel>(
        onModelReady: (model) => model.init(),
        builder: (ctx, model, child) {
          final String lastDate2 = (() {
            try {
              if (_txnHistoryService.txnList != null &&
                  _txnHistoryService.txnList!.isNotEmpty) {
                var transaction = _txnHistoryService.txnList!.firstWhereOrNull(
                  (e) => e.lbMap.fundType == Constants.ASSET_TYPE_FLO_FELXI,
                );
                if (transaction != null && transaction.timestamp != null) {
                  return DateFormat('dd MMM, yyyy').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      transaction.timestamp!.millisecondsSinceEpoch,
                    ),
                  );
                }
              }
              return "NA";
            } catch (e) {
              return "NA";
            }
          })();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(
                      Assets.felloFlo,
                      height: SizeConfig.padding26,
                    ),
                    Text(
                      locale.retiiredFlexi,
                      style: TextStyles.rajdhaniSB.body2
                          .colour(UiConstants.kTextColor),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                Text(
                  BaseUtil.formatIndianRupees(
                    _usrService.userPortfolio.flo.flexi.balance.toDouble(),
                  ),
                  style: TextStyles.rajdhaniB.title1
                      .colour(UiConstants.kTextColor),
                ),
                SizedBox(
                  height: SizeConfig.padding30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.flexiIvested,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kFAQsAnswerColor),
                        ),
                        Text(
                          BaseUtil.formatIndianRupees(
                            _usrService.userPortfolio.flo.flexi.principle
                                .toDouble(),
                          ),
                          style: TextStyles.sourceSans.body2
                              .colour(UiConstants.textGray70),
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                        Text(
                          locale.lastLockIn,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kFAQsAnswerColor),
                        ),
                        Text(
                          lastDate2,
                          style: TextStyles.sourceSans.body2
                              .colour(UiConstants.textGray70),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.withdrable,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kFAQsAnswerColor),
                        ),
                        Text(
                          BaseUtil.formatIndianRupees(
                            model.withdrawableQuantity?.amount ?? 0.toDouble(),
                          ),
                          style: TextStyles.sourceSans.body2
                              .colour(UiConstants.textGray70),
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                        Text(
                          locale.annualInterest,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kFAQsAnswerColor),
                        ),
                        Text(
                          '8%',
                          style: TextStyles.sourceSans.body2
                              .colour(UiConstants.textGray70),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
                  child: const Divider(
                    color: Color(0xff3E3E3E),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.transaction,
                      style: TextStyles.sourceSansSB.body2
                          .colour(UiConstants.kTextColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          widget: const TransactionsHistory(),
                          page: TransactionsHistoryPageConfig,
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            locale.saveViewAll,
                            style: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTabBorderColor),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: UiConstants.kTabBorderColor,
                            size: SizeConfig.body3,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding24),
                  child: MaterialButton(
                    minWidth: SizeConfig.padding300,
                    color: Colors.white,
                    height: SizeConfig.padding44,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
                    ),
                    onPressed: () {
                      Haptic.vibrate();
                      BaseUtil.openModalBottomSheet(
                        addToScreenStack: true,
                        enableDrag: false,
                        hapticVibrate: true,
                        isBarrierDismissible: false,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        content: LendboxWithdrawalView(),
                      );
                    },
                    child: Text(
                      locale.withdraw,
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
