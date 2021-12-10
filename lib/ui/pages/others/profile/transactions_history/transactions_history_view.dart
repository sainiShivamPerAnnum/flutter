import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/transaction_details_dialog.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transaction_history_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TransactionsHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<TransactionsHistoryViewModel>(
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
                  title: "Transaction History",
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
                            padding: EdgeInsets.only(
                                right: SizeConfig.blockSizeHorizontal * 3),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 2),
                                  height: SizeConfig.screenHeight * 0.08,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FilterOption(
                                        filterItems: model.tranTypeFilterItems,
                                        type: TranFilterType.Type,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: (model.filteredList.length == 0
                                      ? child
                                      : ListView(
                                          physics: BouncingScrollPhysics(),
                                          padding: EdgeInsets.all(10),
                                          controller: model.tranListController,
                                          children: List.generate(
                                            model.filteredList.length,
                                            (index) => TransactionTile(
                                              model: model,
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

class NoTransactionsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.noTransaction,
            width: SizeConfig.screenWidth * 0.8,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            locale.noTransaction,
            style: TextStyle(
              fontSize: SizeConfig.largeTextSize,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  final Map<String, int> filterItems;
  final TranFilterType type;
  FilterOption({this.filterItems, this.type});

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> items = [];

    filterItems.forEach((key, value) {
      items.add(
        DropdownMenuItem(
          child: Text(
            key,
            style: TextStyle(fontSize: SizeConfig.mediumTextSize),
          ),
          value: value,
        ),
      );
    });

    return Consumer<TransactionsHistoryViewModel>(builder: (ctx, model, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: UiConstants.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              value: model.filter,
              items: items,
              onChanged: (value) {
                model.filter = value;
                model.filterTransactions(update: true);
              }),
        ),
      );
    });
  }
}

class TransactionTile extends StatelessWidget {
  final TransactionsHistoryViewModel model;
  final txn;
  final _txnService = locator<TransactionService>();
  TransactionTile({
    @required this.model,
    this.txn,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Haptic.vibrate();
        bool freeBeerStatus = _txnService.getBeerTicketStatus(txn);
        showDialog(
            context: AppState.delegate.navigatorKey.currentContext,
            builder: (BuildContext context) {
              AppState.screenStack.add(ScreenItem.dialog);
              return TransactionDetailsDialog(txn, freeBeerStatus);
            });
      },
      dense: true,
      leading: Container(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
        height: SizeConfig.blockSizeVertical * 5,
        width: SizeConfig.blockSizeVertical * 5,
        child: _txnService.getTileLead(txn.tranStatus),
      ),
      title: Text(
        _txnService.getTileTitle(
          txn.subType.toString(),
        ),
        style: TextStyle(
          fontSize: SizeConfig.mediumTextSize,
        ),
      ),
      subtitle: Text(
        _txnService.getTileSubtitle(txn.type),
        style: TextStyle(
          color: _txnService.getTileColor(txn.tranStatus),
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
              color: _txnService.getTileColor(txn.tranStatus),
              fontSize: SizeConfig.mediumTextSize,
            ),
          ),
          SizedBox(height: 4),
          Text(
            _txnService.getFormattedTime(txn.timestamp),
            style: TextStyle(
                color: _txnService.getTileColor(txn.tranStatus),
                fontSize: SizeConfig.smallTextSize),
          )
        ],
      ),
    );
  }
}
