import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/transaction_history_service_enum.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/transaction_details_dialog.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_vm.dart';
import 'package:felloapp/ui/widgets/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MiniTransactionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<MiniTransactionCardViewModel>(
      onModelReady: (model) {
        model.getMiniTransactions();
      },
      builder: (ctx, model, child) {
        return PropertyChangeConsumer<TransactionHistoryService,
            TransactionHistoryServiceProperties>(
          properties: [
            TransactionHistoryServiceProperties.TransactionHistoryList
          ],
          builder: (ctx, m, child) {
            return Column(
              children: [
                Container(
                  child: model.state == ViewState.Busy || m.txnList == null
                      ? SizedBox()
                      // Container(
                      //     height: SizeConfig.screenWidth * 0.5,
                      //     alignment: Alignment.center,
                      //     child: Center(child: FullScreenLoader()),
                      //   )
                      : (m.txnList.length == 0
                          ? SizedBox()
                          // Container(
                          //     padding: EdgeInsets.symmetric(
                          //         vertical: SizeConfig.padding24),
                          //     alignment: Alignment.center,
                          //     child: Transform.scale(
                          //         scale: 0.8, child: NoTransactionsContent()),
                          //   )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: SizeConfig.padding24,
                                  ),
                                  TitleSubtitleContainer(title: 'Transactions'),
                                  Column(
                                    children: List.generate(
                                      m.txnList.length < 4
                                          ? m.txnList.length
                                          : 3,
                                      (i) {
                                        return ListTile(
                                          onTap: () {
                                            Haptic.vibrate();
                                            BaseUtil.openModalBottomSheet(
                                                addToScreenStack: true,
                                                isBarrierDismissable: true,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                content:
                                                    TransactionDetailsBottomSheet(
                                                        transaction:
                                                            m.txnList[i]));
                                          },
                                          dense: true,
                                          title: Text(
                                              model.txnHistoryService
                                                  .getTileSubtitle(
                                                m.txnList[i].type.toString(),
                                              ),
                                              style: TextStyles.sourceSans.body3
                                                  .colour(
                                                      UiConstants.kTextColor)),
                                          subtitle: Text(
                                            model.txnHistoryService
                                                .getFormattedDate(
                                                    m.txnList[i].timestamp),
                                            style: TextStyles.sourceSans.body4
                                                .colour(
                                                    UiConstants.kTextColor2),
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                  model.txnHistoryService
                                                      .getFormattedTxnAmount(
                                                          m.txnList[i].amount),
                                                  style: TextStyles
                                                      .sourceSansSB.body2
                                                      .colour(model
                                                          .txnHistoryService
                                                          .getTransactionTypeColor(
                                                              model.txnList[i]
                                                                  .type))),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )),
                ),
                model.state == ViewState.Idle &&
                        m.txnList != null &&
                        m.txnList.isNotEmpty &&
                        m.txnList.length > 3
                    ? TextButton(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.padding2,
                              ),
                              child: Text('See All',
                                  style: TextStyles.rajdhaniSB.body2),
                            ),
                            SvgPicture.asset(Assets.chevRonRightArrow,
                                height: SizeConfig.padding24,
                                width: SizeConfig.padding24,
                                color: Colors.white)
                          ],
                        ),
                        onPressed: () => model.viewAllTransaction(),
                      )
                    : SizedBox(),
                SizedBox(height: SizeConfig.padding12),
              ],
            );
          },
        );
      },
    );
  }
}
