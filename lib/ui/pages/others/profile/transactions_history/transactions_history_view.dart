import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/transaction_details_dialog.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transaction_history_vm.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
          appBar: AppBar(
            backgroundColor: UiConstants.kBackgroundColor,
            elevation: 0,
            leading: FelloAppBarBackButton(),
            title: Text(
              'Transaction History',
              style: TextStyles.rajdhaniSB.title5,
            ),
          ),
          backgroundColor: UiConstants.kBackgroundColor,
          body: Column(
            children: [
              SizedBox(
                height: SizeConfig.padding10,
              ),
              TransactionChoiceSelectionTab(),
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding34),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: SizeConfig.screenWidth * 0.08,
                    width: SizeConfig.screenWidth * 0.24,
                    child: DropdownButtonFormField<String>(
                        iconSize: SizeConfig.padding20,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: UiConstants.kSecondaryBackgroundColor,
                                width: 2),
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5),
                          ),
                          filled: true,
                          fillColor: UiConstants.kBackgroundColor,
                        ),
                        iconEnabledColor: UiConstants.kTextColor,
                        elevation: 0,
                        icon: Icon(
                          Icons.arrow_downward_rounded,
                        ),
                        hint: Text(
                          'Type',
                          style: TextStyles.sourceSans.body4
                              .colour(UiConstants.kTextColor),
                        ),
                        isDense: true,
                        value: model.filterValue,
                        items: model.tranTypeFilterItems
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          model.filterValue = val;
                        }),
                  ),
                ),
              ),
              Expanded(
                child: model.state == ViewState.Busy
                    ? Center(
                        child: SpinKitWave(
                          color: UiConstants.primaryColor,
                          size: SizeConfig.padding32,
                        ),
                      )
                    : Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: SizeConfig.padding24,
                            ),
                            Expanded(
                              child: (model.filteredList.length == 0
                                  ? child
                                  : ListView(
                                      physics: BouncingScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.padding28),
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
                                padding: EdgeInsets.all(SizeConfig.padding12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SpinKitWave(
                                      color: UiConstants.primaryColor,
                                      size: SizeConfig.padding16,
                                    ),
                                    SizedBox(height: SizeConfig.padding4),
                                    Text(
                                      "Looking for more transactions, please wait ...",
                                      style:
                                          TextStyles.body4.colour(Colors.grey),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TranChip extends StatelessWidget {
  final TransactionsHistoryViewModel model;
  final int chipId;
  final String title;

  TranChip({this.model, this.chipId, this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        model.filter = chipId;
        model.filterTransactions(update: true);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding16, vertical: SizeConfig.padding12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: UiConstants.primaryColor),
          color:
              model.filter == chipId ? UiConstants.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          title,
          style: model.filter == chipId
              ? TextStyles.body3.bold.colour(Colors.white)
              : TextStyles.body3.colour(
                  UiConstants.primaryColor,
                ),
        ),
      ),
    );
  }
}

class NoTransactionsContent extends StatelessWidget {
  final double width;
  NoTransactionsContent({this.width});
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.noTransaction,
            width: width ?? SizeConfig.screenWidth * 0.8,
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

class TransactionTile extends StatelessWidget {
  final TransactionsHistoryViewModel model;
  final UserTransaction txn;
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
        showModalBottomSheet(
            context: AppState.delegate.navigatorKey.currentContext,
            builder: (BuildContext context) {
              AppState.screenStack.add(ScreenItem.modalsheet);
              return TransactionDetailsBottomSheet(txn, freeBeerStatus);
            });
      },
      dense: true,
      title: Text(
          _txnService.getTileSubtitle(
            txn.type.toString(),
          ),
          style: TextStyles.sourceSans.body3),
      subtitle: Text(
        _txnService.getFormattedDate(txn.timestamp),
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor2),
      ),
      trailing: Text(
        _txnService.getFormattedTxnAmount(txn.amount),
        style: TextStyles.sourceSansM.body3,
      ),
    );
  }
}

class TransactionChoiceSelectionTab extends StatelessWidget {
  const TransactionChoiceSelectionTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenWidth * 0.09,
        width: SizeConfig.screenWidth * 0.54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Single', style: TextStyles.sourceSansSB.body2),
                SizedBox(
                  width: SizeConfig.padding64,
                ),
                Text('SIP', style: TextStyles.sourceSansSB.body2),
              ],
            ),
            SizedBox(height: SizeConfig.padding10),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 2,
                    color: UiConstants.kPrimaryColor,
                    thickness: 3,
                    indent: 10,
                  ),
                ),
                Expanded(
                  child: Divider(
                    height: 2,
                    color: UiConstants.kSecondaryBackgroundColor,
                    thickness: 3,
                    endIndent: 10,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class TransactionTypeChoiceSelector extends StatelessWidget {
  const TransactionTypeChoiceSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
