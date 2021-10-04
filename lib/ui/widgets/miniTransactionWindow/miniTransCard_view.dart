import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/ui/dialogs/transaction_details_dialog.dart';
import 'package:felloapp/ui/widgets/buttons/flatButton/flatButton_view.dart';
import 'package:felloapp/ui/widgets/miniTransactionWindow/miniTransCard_viewModel.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class MiniTransactionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<MiniTransactionCardViewModel>(
      onModelReady: (model) {
        model.getTransactions();
      },
      builder: (ctx, model, child) {
        return Card(
          child: Stack(
            children: [
              Container(
                height: 200,
                child: model.state == ViewState.Busy || model.txnList == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (model.txnList.length == 0
                        ? Text("No Transactions")
                        : ListView.builder(
                            itemCount: model.txnList.length,
                            itemBuilder: (ctx, i) {
                              return ListTile(
                                onTap: () {
                                  Haptic.vibrate();

                                  showDialog(
                                      context: AppState
                                          .delegate.navigatorKey.currentContext,
                                      builder: (BuildContext context) {
                                        AppState.screenStack
                                            .add(ScreenItem.dialog);
                                        return TransactionDetailsDialog(
                                            model.txnList[i]);
                                      });
                                },
                                dense: true,
                                leading: Container(
                                  padding: EdgeInsets.all(
                                      SizeConfig.blockSizeHorizontal * 2),
                                  height: SizeConfig.blockSizeVertical * 5,
                                  width: SizeConfig.blockSizeVertical * 5,
                                  child: model
                                      .getTileLead(model.txnList[i].tranStatus),
                                ),
                                title: Text(
                                  model.getTileTitle(
                                    model.txnList[i].subType.toString(),
                                  ),
                                  style: TextStyle(
                                    fontSize: SizeConfig.mediumTextSize,
                                  ),
                                ),
                                subtitle: Text(
                                  model.getTileSubtitle(model.txnList[i].type),
                                  style: TextStyle(
                                    color: model.getTileColor(
                                        model.txnList[i].tranStatus),
                                    fontSize: SizeConfig.smallTextSize,
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (model.txnList[i].type == "WITHDRAWAL"
                                              ? "- "
                                              : "+ ") +
                                          "₹ ${model.txnList[i].amount.toString()}",
                                      style: TextStyle(
                                        color: model.getTileColor(
                                            model.txnList[i].tranStatus),
                                        fontSize: SizeConfig.mediumTextSize,
                                      ),
                                    ),
                                    Text(
                                      model.getFormattedTime(
                                          model.txnList[i].timestamp),
                                      style: TextStyle(
                                          color: model.getTileColor(
                                              model.txnList[i].tranStatus),
                                          fontSize: SizeConfig.smallTextSize),
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
                  child: FBtn(
                    onPressed: () => model.viewAllTransaction(),
                    text: "View All",
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
  }
}
