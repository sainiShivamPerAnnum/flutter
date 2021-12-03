import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/transaction_service.dart';
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
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : (m.txnList.length == 0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding20),
                              alignment: Alignment.center,
                              child: Transform.scale(
                                  scale: 0.8, child: NoTransactionsContent()),
                            )
                          : Column(
                              children: List.generate(
                                m.txnList.length < 5 ? m.txnList.length : 4,
                                (i) {
                                  return ListTile(
                                    onTap: () {
                                      Haptic.vibrate();
                                      bool freeBeerStatus = model
                                          .getBeerTicketStatus(m.txnList[i]);
                                      showDialog(
                                          context: AppState.delegate
                                              .navigatorKey.currentContext,
                                          builder: (BuildContext context) {
                                            AppState.screenStack
                                                .add(ScreenItem.dialog);
                                            return TransactionDetailsDialog(
                                                m.txnList[i], freeBeerStatus);
                                          });
                                    },
                                    dense: true,
                                    leading: Container(
                                      padding: EdgeInsets.all(
                                          SizeConfig.blockSizeHorizontal * 2),
                                      height: SizeConfig.blockSizeVertical * 5,
                                      width: SizeConfig.blockSizeVertical * 5,
                                      child: model.txnService
                                          .getTileLead(m.txnList[i].tranStatus),
                                    ),
                                    title: Text(
                                      model.txnService.getTileTitle(
                                        m.txnList[i].subType.toString(),
                                      ),
                                      style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize,
                                      ),
                                    ),
                                    subtitle: Text(
                                      model.txnService
                                          .getTileSubtitle(m.txnList[i].type),
                                      style: TextStyle(
                                        color: model.txnService.getTileColor(
                                            m.txnList[i].tranStatus),
                                        fontSize: SizeConfig.smallTextSize,
                                      ),
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
                                          style: TextStyle(
                                            color: model.txnService
                                                .getTileColor(
                                                    m.txnList[i].tranStatus),
                                            fontSize: SizeConfig.mediumTextSize,
                                          ),
                                        ),
                                        Text(
                                          model.txnService.getFormattedTime(
                                              m.txnList[i].timestamp),
                                          style: TextStyle(
                                              color: model.txnService
                                                  .getTileColor(
                                                      m.txnList[i].tranStatus),
                                              fontSize:
                                                  SizeConfig.smallTextSize),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )),
                ),
                m.txnList == null || m.txnList.isEmpty
                    ? SizedBox()
                    : FelloButton(
                        onPressed: () => model.viewAllTransaction(),
                        defaultButtonText: "View All",
                        defaultButtonColor: Colors.white,
                        textStyle: TextStyles.body1.bold
                            .colour(UiConstants.primaryColor),
                      ),
                SizedBox(
                  height: 8,
                )
              ],
            );
          },
        );
      },
    );
  }
}
