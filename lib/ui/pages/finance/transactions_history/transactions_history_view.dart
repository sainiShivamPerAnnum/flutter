import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transaction_details_view.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transaction_history_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TransactionsHistory extends StatelessWidget {
  final InvestmentType? investmentType;
  final bool showAutosave;

  const TransactionsHistory(
      {Key? key, this.investmentType, this.showAutosave = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<TransactionsHistoryViewModel>(
      onModelReady: (model) {
        model.init(investmentType, showAutosave);
      },
      child: const NoTransactionsContent(),
      builder: (ctx, model, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: UiConstants.kBackgroundColor,
              elevation: 0,
              leading: const FelloAppBarBackButton(),
              title: Text(
                (investmentType == InvestmentType.AUGGOLD99
                        ? "Gold "
                        : "Flo ") +
                    locale.txnHistory,
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
                    physics: const NeverScrollableScrollPhysics(),
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
  final TransactionsHistoryViewModel? model;

  const SingleTransactionView({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.padding24),
          child: SizedBox(
            height: SizeConfig.padding40,
            width: SizeConfig.screenWidth! / 3.8,
            child: DropdownButtonFormField<String>(
              dropdownColor: UiConstants.kSecondaryBackgroundColor,
              iconSize: SizeConfig.padding20,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: UiConstants.kSecondaryBackgroundColor, width: 2),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: UiConstants.kSecondaryBackgroundColor, width: 2),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                filled: true,
                fillColor: UiConstants.kBackgroundColor,
              ),
              iconEnabledColor: UiConstants.kTextColor,
              elevation: 0,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              hint: Text(
                locale.type,
                style:
                    TextStyles.sourceSans.body4.colour(UiConstants.kTextColor),
              ),
              value: model!.filterValue ?? locale.type,
              items: model!.tranTypeFilterItems
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e!,
                        style: TextStyles.sourceSans.body4,
                      )))
                  .toList(),
              onChanged: (val) {
                model!.filterValue = val;
                model!.filter =
                    model!.tranTypeFilterItems.indexOf(model!.filterValue) + 1;
                model!.filterTransactions(update: true);
              },
            ),
          ),
        ),
        Expanded(
          child: model!.state == ViewState.Busy
              ? const Center(
                  child: FullScreenLoader(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: model!.filteredList!.length == 0
                          ? Column(
                              children: [
                                SizedBox(
                                    height: SizeConfig.screenHeight! * 0.16),
                                SvgPicture.asset(Assets.noTransactionAsset),
                                SizedBox(height: SizeConfig.padding16),
                                Text(
                                  locale.txnsEmpty,
                                  style: TextStyles.sourceSans.body2
                                      .colour(Colors.white),
                                ),
                                SizedBox(height: SizeConfig.padding32),
                              ],
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              controller: model!.tranListController,
                              children: List.generate(
                                model!.filteredList!.length,
                                (index) => TransactionTile(
                                  txn: model!.filteredList![index],
                                ),
                              ),
                            ),
                    ),
                    if (model!.isMoreTxnsBeingFetched)
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
                              locale.moretxns,
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
  final TransactionsHistoryViewModel? model;

  const SIPTransactionHistoryView({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return model!.state == ViewState.Busy
        ? const Center(
            child: FullScreenLoader(),
          )
        : Column(
            children: [
              Expanded(
                  child: (model!.filteredSIPList!.length == 0)
                      ? Column(
                          children: [
                            SizedBox(height: SizeConfig.padding54),
                            SvgPicture.asset(Assets.noTransactionAsset),
                            SizedBox(height: SizeConfig.padding16),
                            Text(
                              locale.txnsEmpty,
                              style: TextStyles.sourceSans.body2
                                  .colour(Colors.white),
                            ),
                            SizedBox(height: SizeConfig.padding32),
                          ],
                        )
                      : ListView(
                          physics: const BouncingScrollPhysics(),
                          controller: model!.sipScrollController,
                          children: List.generate(
                            model!.filteredSIPList!.length,
                            (index) => TransactionSIPTile(
                              model: model,
                              txn: model!.filteredSIPList![index],
                            ),
                          ),
                        )),
              if (model!.isMoreTxnsBeingFetched)
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
                        locale.moretxns,
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
  final double? width;

  const NoTransactionsContent({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.noTransaction,
            width: width ?? SizeConfig.screenWidth! * 0.8,
          ),
          const SizedBox(
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
  // final TransactionsHistoryViewModel model;
  final UserTransaction txn;
  final TxnHistoryService txnHistoryService = locator<TxnHistoryService>();

  TransactionTile({
    required this.txn,
    super.key,
  });

  String get getFormattedDate =>
      DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(
          txn.timestamp!.millisecondsSinceEpoch));

  String get formattedTime =>
      DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
          txn.timestamp!.millisecondsSinceEpoch));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(
            left: SizeConfig.padding20,
            right: SizeConfig.padding14,
          ),
          onTap: () {
            Haptic.vibrate();
            AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.addWidget,
              page: TransactionDetailsPageConfig,
              widget: TransactionDetailsPage(
                txn: txn,
              ),
            );
          },
          dense: true,
          title: Text(
              txnHistoryService.getTileSubtitle(
                txn.type.toString(),
              ),
              style:
                  TextStyles.sourceSans.body3.colour(UiConstants.kTextColor)),
          subtitle: Text(
            "${floSubtype()}$getFormattedDate at $formattedTime",
            style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor2),
            textAlign: TextAlign.start,
          ),
          trailing: Wrap(
            children: [
              TransactionStatusChip(
                color: txnHistoryService.getTileColor(txn.tranStatus),
                status: txn.tranStatus,
              ),
              Text(txnHistoryService.getFormattedTxnAmount(txn.amount),
                  style: TextStyles.sourceSansSB.body2),
              Padding(
                padding: EdgeInsets.all(SizeConfig.padding6),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: SizeConfig.iconSize2,
                  color: UiConstants.kTextColor,
                ),
              )
            ],
          ),
        ),
        SizedBox(
            width: SizeConfig.screenWidth! * 0.9,
            child: const Divider(
              color: UiConstants.kTextColor2,
            ))
      ],
    );
  }

  String floSubtype() {
    if (txn.subType == "LENDBOXP2P") {
      switch (txn.lbMap.fundType) {
        case Constants.ASSET_TYPE_FLO_FIXED_6:
          return "12% Flo on ";
        case Constants.ASSET_TYPE_FLO_FIXED_3:
          return "10% Flo on ";
        case Constants.ASSET_TYPE_FLO_FELXI:
          if (locator<UserService>()
              .userSegments
              .contains(Constants.US_FLO_OLD)) {
            return "10% Flo on ";
          } else {
            return "8% Flo on ";
          }
        default:
          return "10% Flo on ";
      }
    }
    return "";
  }
}

class TransactionStatusChip extends StatelessWidget {
  final Color color;
  final String? status;

  const TransactionStatusChip(
      {super.key, this.color = Colors.white, this.status = "NA"});

  @override
  Widget build(BuildContext context) {
    return status != UserTransaction.TRAN_STATUS_COMPLETE
        ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: color.withOpacity(0.2)),
            child: Text(
              status!,
              style: TextStyles.sourceSans.body5.colour(color),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding8,
              vertical: SizeConfig.padding6,
            ),
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
          )
        : const SizedBox();
  }
}

class TransactionSIPTile extends StatelessWidget {
  final TransactionsHistoryViewModel? model;
  final SubscriptionTransactionModel? txn;
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();

  TransactionSIPTile({
    required this.model,
    super.key,
    this.txn,
  });

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return ListTile(
      onTap: () {
        Haptic.vibrate();
      },
      contentPadding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      dense: true,
      title: Text(locale.btnDeposit.toUpperCase(),
          style: TextStyles.sourceSans.body3),
      subtitle: Text(
        _txnHistoryService.getFormattedSIPDate(
            DateTime.parse(txn!.createdOn.toDate().toString())),
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor2),
      ),
      trailing: Wrap(
        children: [
          TransactionStatusChip(
            color: _txnHistoryService.getTileColor(txn!.status),
            status: txn!.status,
          ),
          Text(
            _txnHistoryService.getFormattedTxnAmount(double.tryParse(
                    model!.investmentType == InvestmentType.AUGGOLD99
                        ? txn!.augMap?.amount.toString() ?? '0'
                        : txn!.lbMap?.amount.toString() ?? '0') ??
                0),
            style: TextStyles.sourceSansM.body3,
          ),
        ],
      ),
    );
  }
}

class TransactionChoiceSelectionTab extends StatelessWidget {
  final TransactionsHistoryViewModel? model;

  const TransactionChoiceSelectionTab({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return SizedBox(
        height: SizeConfig.screenWidth! * 0.09,
        width: SizeConfig.screenWidth! * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      model!.tabIndex = 0;
                      model!.pageController!.animateToPage(0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Container(
                        height: SizeConfig.padding24,
                        // width: SizeConfig.padding44,
                        color: Colors.transparent,
                        child: Text(locale.single,
                            style: TextStyles.sourceSansSB.body2))),
                SizedBox(
                  width: SizeConfig.padding64,
                ),
                GestureDetector(
                  onTap: () {
                    model!.tabIndex = 1;
                    model!.pageController!.animateToPage(1,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear);
                  },
                  child: Container(
                    height: SizeConfig.padding24,
                    // width: SizeConfig.padding32,
                    color: Colors.transparent,
                    child: Text(locale.sipText,
                        style: TextStyles.sourceSansSB.body2),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.padding10),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 2,
                    color: model!.tabIndex == 0
                        ? UiConstants.kPrimaryColor
                        : UiConstants.kSecondaryBackgroundColor,
                    thickness: 3,
                    indent: 10,
                  ),
                ),
                Expanded(
                  child: Divider(
                    height: 2,
                    color: model!.tabIndex == 1
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
  const TransactionTypeChoiceSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
