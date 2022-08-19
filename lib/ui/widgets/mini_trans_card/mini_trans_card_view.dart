import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/transaction_details_dialog.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_vm.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MiniTransactionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<MiniTransactionCardViewModel>(
      onModelReady: (model) {
        model.getMiniTransactions();
      },
      builder: (ctx, model, child) {
        return PropertyChangeConsumer<TransactionService,
            TransactionServiceProperties>(
          properties: [TransactionServiceProperties.transactionList],
          builder: (ctx, m, child) {
            return Column(
              children: [
                Container(
                  child: model.state == ViewState.Busy || m.txnList == null
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            bottom: SizeConfig.padding24,
                          ),
                          child: CircularProgressIndicator(),
                        )
                      : (m.txnList.length == 0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding24),
                              alignment: Alignment.center,
                              child: Transform.scale(
                                  scale: 0.8, child: NoTransactionsContent()),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding10),
                              child: Column(
                                children: List.generate(
                                  m.txnList.length < 4 ? m.txnList.length : 3,
                                  (i) {
                                    return ListTile(
                                      onTap: () {
                                        Haptic.vibrate();
                                        // bool freeBeerStatus = model.txnService
                                        //     .getBeerTicketStatus(m.txnList[i]);
                                        BaseUtil.openModalBottomSheet(
                                            addToScreenStack: true,
                                            isBarrierDismissable: true,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            content:
                                                TransactionDetailsBottomSheet(
                                                    transaction: m.txnList[i]));
                                      },
                                      dense: true,
                                      title: Text(
                                          model.txnService.getTileSubtitle(
                                            m.txnList[i].type.toString(),
                                          ),
                                          style: TextStyles.sourceSans.body3
                                              .colour(UiConstants.kTextColor)),
                                      subtitle: Text(
                                        model.txnService.getFormattedDate(
                                            m.txnList[i].timestamp),
                                        style: TextStyles.sourceSans.body4
                                            .colour(UiConstants.kTextColor2),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              model.txnService
                                                  .getFormattedTxnAmount(
                                                      m.txnList[i].amount),
                                              style: TextStyles
                                                  .sourceSansSB.body2
                                                  .colour(model.txnService
                                                      .getTransactionTypeColor(
                                                          model.txnList[i]
                                                              .type))),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )),
                ),
                m.txnList != null &&
                        m.txnList.isNotEmpty &&
                        m.txnList.length > 3
                    ? FelloButton(
                        onPressed: () => model.viewAllTransaction(),
                        defaultButtonText: "See All",
                        defaultButtonColor: Colors.white,
                        textStyle: TextStyles.body1.bold
                            .colour(UiConstants.primaryColor),
                      )
                    : SizedBox(),
              ],
            );
          },
        );
      },
    );
  }
}
