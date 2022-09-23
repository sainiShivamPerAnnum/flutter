import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
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
import 'package:flutter_svg/svg.dart';

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
                TransactionChoiceSelectionTab(model: model),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                Expanded(
                  child: PageView(
                    controller: model.pageController,
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    allowImplicitScrolling: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SingleTransactionView(
                        model: model,
                      ),
                      SIPTransactionHistoryView(
                        model: model,
                      )
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}

class SingleTransactionView extends StatelessWidget {
  final TransactionsHistoryViewModel model;

  const SingleTransactionView({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.padding24),
          child: Container(
            height: SizeConfig.padding40,
            width: SizeConfig.screenWidth / 3.8,
            child: DropdownButtonFormField<String>(
                dropdownColor: UiConstants.kSecondaryBackgroundColor,
                iconSize: SizeConfig.padding20,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: UiConstants.kSecondaryBackgroundColor, width: 2),
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: UiConstants.kSecondaryBackgroundColor, width: 2),
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                  filled: true,
                  fillColor: UiConstants.kBackgroundColor,
                ),
                iconEnabledColor: UiConstants.kTextColor,
                elevation: 0,
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                hint: Text(
                  'Type',
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kTextColor),
                ),
                value: model.filterValue ?? "Type",
                items: model.tranTypeFilterItems
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyles.sourceSans.body4,
                        )))
                    .toList(),
                onChanged: (val) {
                  model.filterValue = val;
                  model.filter =
                      model.tranTypeFilterItems.indexOf(model.filterValue) + 1;
                  model.filterTransactions(update: true);
                }),
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
              : Column(
                  children: [
                    Expanded(
                      child: (model.filteredList.length == 0
                          ? NoTransactionsContent()
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
                              style: TextStyles.body4.colour(Colors.grey),
                            )
                          ],
                        ),
                      )
                  ],
                ),
        ),
      ],
    );
  }
}

class SIPTransactionHistoryView extends StatelessWidget {
  final TransactionsHistoryViewModel model;

  const SIPTransactionHistoryView({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return model.state == ViewState.Busy
        ? Center(
            child: SpinKitWave(
              color: UiConstants.primaryColor,
              size: SizeConfig.padding32,
            ),
          )
        : Column(
            children: [
              Expanded(
                  child: (model.filteredSIPList.length == 0)
                      ? Center(child: NoTransactionsContent())
                      : ListView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding28),
                          controller: model.tranListController,
                          children: List.generate(
                            model.filteredSIPList.length,
                            (index) => TransactionSIPTile(
                              model: model,
                              txn: model.filteredSIPList[index],
                            ),
                          ),
                        )),
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
                        style: TextStyles.body4.colour(Colors.grey),
                      )
                    ],
                  ),
                )
            ],
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
  final _txnHistoryService = locator<TransactionHistoryService>();
  TransactionTile({
    @required this.model,
    this.txn,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Haptic.vibrate();
        BaseUtil.openModalBottomSheet(
            isScrollControlled: true,
            enableDrag: true,
            addToScreenStack: true,
            isBarrierDismissable: true,
            backgroundColor: Colors.transparent,
            content: TransactionDetailsBottomSheet(
              transaction: txn,
            ));
      },
      dense: true,
      title: Text(
          _txnHistoryService.getTileSubtitle(
            txn.type.toString(),
          ),
          style: TextStyles.sourceSans.body3),
      subtitle: Text(
        _txnHistoryService.getFormattedDate(txn.timestamp),
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor2),
      ),
      trailing: Text(
        _txnHistoryService.getFormattedTxnAmount(txn.amount),
        style: TextStyles.sourceSansM.body3,
      ),
    );
  }
}

class TransactionSIPTile extends StatelessWidget {
  final TransactionsHistoryViewModel model;
  final AutosaveTransactionModel txn;
  final _txnHistoryService = locator<TransactionHistoryService>();
  TransactionSIPTile({
    @required this.model,
    this.txn,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Haptic.vibrate();
      },
      dense: true,
      title: Text('AUTO SIP', style: TextStyles.sourceSans.body3),
      subtitle: Text(
        _txnHistoryService.getFormattedSIPDate(DateTime.parse(txn.txnDateTime)),
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor2),
      ),
      trailing: Text(
        _txnHistoryService.getFormattedTxnAmount(txn.amount),
        style: TextStyles.sourceSansM.body3,
      ),
    );
  }
}

class TransactionChoiceSelectionTab extends StatelessWidget {
  final TransactionsHistoryViewModel model;

  const TransactionChoiceSelectionTab({Key key, this.model}) : super(key: key);

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
                GestureDetector(
                    onTap: () {
                      model.tabIndex = 0;
                      model.pageController.animateToPage(0,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Container(
                        height: SizeConfig.padding24,
                        width: SizeConfig.padding44,
                        color: Colors.transparent,
                        child: Text('Single',
                            style: TextStyles.sourceSansSB.body2))),
                SizedBox(
                  width: SizeConfig.padding64,
                ),
                GestureDetector(
                    onTap: () {
                      model.tabIndex = 1;
                      model.pageController.animateToPage(1,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Container(
                        height: SizeConfig.padding24,
                        width: SizeConfig.padding32,
                        color: Colors.transparent,
                        child:
                            Text('SIP', style: TextStyles.sourceSansSB.body2))),
              ],
            ),
            SizedBox(height: SizeConfig.padding10),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 2,
                    color: model.tabIndex == 0
                        ? UiConstants.kPrimaryColor
                        : UiConstants.kSecondaryBackgroundColor,
                    thickness: 3,
                    indent: 10,
                  ),
                ),
                Expanded(
                  child: Divider(
                    height: 2,
                    color: model.tabIndex == 1
                        ? UiConstants.kPrimaryColor
                        : UiConstants.kSecondaryBackgroundColor,
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
