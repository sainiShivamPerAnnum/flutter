import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/finance/mini_trans_card/mini_trans_card_vm.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transactions_history_view.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniTransactionCard extends StatelessWidget {
  final InvestmentType investmentType;

  const MiniTransactionCard({required this.investmentType, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<MiniTransactionCardViewModel>(
      onModelReady: (model) {
        model.getMiniTransactions(investmentType);
      },
      builder: (ctx, model, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOutCubic,
          child: Consumer<TxnHistoryService>(
            builder: (ctx, m, child) {
              final List<UserTransaction> txnList = m.txnList != null &&
                      m.txnList!.isNotEmpty
                  ? m.txnList!
                      .where(
                        (e) =>
                            e.subType == investmentType.name ||
                            e.subType ==
                                UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD_FD,
                      )
                      .toList()
                  : [];

              return Column(
                children: [
                  model.state == ViewState.Busy || m.txnList == null
                      ? SizedBox(
                          child: Row(children: [
                            TitleSubtitleContainer(
                                title: locale.txns, leadingPadding: false),
                            const Spacer(),
                            SizedBox(
                              width: SizeConfig.avatarRadius,
                              height: SizeConfig.avatarRadius,
                              child: const CircularProgressIndicator(
                                strokeWidth: 0.5,
                                color: UiConstants.primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.pageHorizontalMargins * 1.5,
                            )
                          ]),
                        )
                      : (m.txnList!.length == 0
                          ? SizedBox(height: SizeConfig.padding12)
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding10,
                                  vertical: SizeConfig.padding10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TitleSubtitleContainer(
                                          title: locale.txns,
                                          leadingPadding: false),
                                      const Spacer(),
                                      model.state == ViewState.Idle &&
                                              m.txnList != null &&
                                              m.txnList!.isNotEmpty &&
                                              m.txnList!.length > 3
                                          ? InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: SizeConfig.padding2,
                                                ),
                                                child: Text(
                                                  locale.btnSeeAll,
                                                  style: TextStyles
                                                      .rajdhaniSB.body2
                                                      .colour(UiConstants
                                                          .primaryColor),
                                                ),
                                              ),
                                              onTap: () =>
                                                  model.viewAllTransaction(
                                                      investmentType),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                        width: SizeConfig.pageHorizontalMargins,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.padding8),
                                  Column(
                                    children: List.generate(
                                      txnList.length < 4 ? txnList.length : 3,
                                      (i) => TransactionTile(
                                        txn: txnList[i],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  SizedBox(height: SizeConfig.padding12),
                  if (locator<SubService>().subscriptionData != null)
                    Container(
                      padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Haptic.vibrate();
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              state: PageState.addWidget,
                              widget: TransactionsHistory(
                                investmentType: investmentType,
                                showAutosave: true,
                              ),
                              page: TransactionsHistoryPageConfig,
                            );
                          },
                          child: Text(
                            "View SIP Transactions",
                            style: TextStyles.sourceSansM.body3
                                .colour(UiConstants.primaryColor),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
