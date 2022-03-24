import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_transaction/autopay_transactions_vm.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_transactions_details.dialog.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AutoPayTransactionsView extends StatelessWidget {
  const AutoPayTransactionsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AutopayTransactionsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      child: NoTransactionsContent(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Autopay Transaction History",
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: model.state == ViewState.Busy
                        ? Center(
                            child: SpinKitWave(
                              color: UiConstants.primaryColor,
                              size: SizeConfig.padding32,
                            ),
                          )
                        : Container(
                            width: SizeConfig.screenWidth,
                            child: Column(
                              children: [
                                Expanded(
                                  child: (model.filteredList == null ||
                                          model.filteredList?.length == 0
                                      ? child
                                      : ListView(
                                          physics: BouncingScrollPhysics(),
                                          padding: EdgeInsets.only(
                                              top: SizeConfig
                                                  .pageHorizontalMargins,
                                              left: SizeConfig
                                                      .pageHorizontalMargins /
                                                  2,
                                              right: SizeConfig
                                                  .pageHorizontalMargins),
                                          controller: model.tranListController,
                                          children: List.generate(
                                            model.filteredList?.length,
                                            (index) =>
                                                SubscriptionTransactionTile(
                                              // model: model,
                                              txn: model.filteredList[index],
                                            ),
                                          ),
                                        )),
                                ),
                                if (model.isMoreTxnsBeingFetched)
                                  Container(
                                    width: SizeConfig.screenWidth,
                                    padding:
                                        EdgeInsets.all(SizeConfig.padding12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SpinKitWave(
                                          color: UiConstants.primaryColor,
                                          size: SizeConfig.padding16,
                                        ),
                                        SizedBox(height: SizeConfig.padding4),
                                        Text(
                                          "Looking for more transactions, please wait ...",
                                          style: TextStyles.body4
                                              .colour(Colors.grey),
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SubscriptionTransactionTile extends StatelessWidget {
  // final AutopayTransactionsViewModel model;
  final AutopayTransactionModel txn;
  final _txnService = locator<TransactionService>();
  SubscriptionTransactionTile({
    // @required this.model,
    this.txn,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Haptic.vibrate();
        // bool freeBeerStatus = _txnService.getBeerTicketStatus(txn);
        showDialog(
            context: AppState.delegate.navigatorKey.currentContext,
            builder: (BuildContext context) {
              AppState.screenStack.add(ScreenItem.dialog);
              return AutopayTransactionDetailsDialog(txn);
            });
      },
      dense: true,
      leading: Container(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
        height: SizeConfig.blockSizeVertical * 5,
        width: SizeConfig.blockSizeVertical * 5,
        child: _txnService.getTileLead(txn.status),
      ),
      title: Text(
        _txnService.getTileTitle(
          UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD,
        ),
        style: TextStyle(
          fontSize: SizeConfig.mediumTextSize,
        ),
      ),
      subtitle: Text(
        _txnService.getTileSubtitle(UserTransaction.TRAN_TYPE_DEPOSIT),
        style: TextStyle(
          color: _txnService.getTileColor(txn.status),
          fontSize: SizeConfig.smallTextSize,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _txnService.getFormattedTxnAmount(txn.amount),
            style: TextStyle(
              // color: _txnService.getTileColor(txn.tranStatus),
              fontSize: SizeConfig.mediumTextSize,
            ),
          ),
          SizedBox(height: 4),
          Text(
            _txnService.getFormattedTime(txn.createdOn),
            style: TextStyle(
                // color: _txnService.getTileColor(txn.tranStatus),
                color: Colors.black45,
                fontSize: SizeConfig.smallTextSize),
          )
        ],
      ),
    );
  }
}
