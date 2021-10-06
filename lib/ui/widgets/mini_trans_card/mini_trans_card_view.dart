import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/transaction_details_dialog.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_vm.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniTransactionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<MiniTransactionCardViewModel>(
      onModelReady: (model) {
        model.getMiniTransactions();
      },
      builder: (ctx, model, child) {
        return Consumer<TransactionService>(
          builder: (ctx, m, child) {
            return Card(
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    child: model.state == ViewState.Busy || m.txnList == null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : (m.txnList.length == 0
                            ? Text("No Transactions")
                            : ListView.builder(
                                itemCount: m.txnList.length,
                                itemBuilder: (ctx, i) {
                                  return ListTile(
                                    onTap: () {
                                      Haptic.vibrate();

                                      showDialog(
                                          context: AppState.delegate
                                              .navigatorKey.currentContext,
                                          builder: (BuildContext context) {
                                            AppState.screenStack
                                                .add(ScreenItem.dialog);
                                            return TransactionDetailsDialog(
                                                m.txnList[i]);
                                          });
                                    },
                                    dense: true,
                                    leading: Container(
                                      padding: EdgeInsets.all(
                                          SizeConfig.blockSizeHorizontal * 2),
                                      height: SizeConfig.blockSizeVertical * 5,
                                      width: SizeConfig.blockSizeVertical * 5,
                                      child: model
                                          .getTileLead(m.txnList[i].tranStatus),
                                    ),
                                    title: Text(
                                      model.getTileTitle(
                                        m.txnList[i].subType.toString(),
                                      ),
                                      style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize,
                                      ),
                                    ),
                                    subtitle: Text(
                                      model.getTileSubtitle(m.txnList[i].type),
                                      style: TextStyle(
                                        color: model.getTileColor(
                                            m.txnList[i].tranStatus),
                                        fontSize: SizeConfig.smallTextSize,
                                      ),
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (m.txnList[i].type == "WITHDRAWAL"
                                                  ? "- "
                                                  : "+ ") +
                                              "₹ ${m.txnList[i].amount.toString()}",
                                          style: TextStyle(
                                            color: model.getTileColor(
                                                m.txnList[i].tranStatus),
                                            fontSize: SizeConfig.mediumTextSize,
                                          ),
                                        ),
                                        Text(
                                          model.getFormattedTime(
                                              m.txnList[i].timestamp),
                                          style: TextStyle(
                                              color: model.getTileColor(
                                                  m.txnList[i].tranStatus),
                                              fontSize:
                                                  SizeConfig.smallTextSize),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              )),
                  ),
                  Positioned(
                    bottom: 0,
                    width: SizeConfig.screenWidth,
                    child: Container(
                      height: SizeConfig.mediumTextSize * 4,
                      color: UiConstants.primaryColor,
                      child: FelloButton(
                        onPressed: () => model.viewAllTransaction(),
                        defaultButtonText: "View All",
                        defaultButtonColor: Colors.white,
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.mediumTextSize),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
