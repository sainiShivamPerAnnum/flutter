import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/page_views/height_adaptive_pageview.dart';
import 'package:felloapp/ui/pages/finance/autosave/segmate_chip.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './autosave_details_vm.dart';

class AutosaveDetailsView extends StatelessWidget {
  const AutosaveDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<AutosaveDetailsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      // child: NoTransactionsContent(),
      builder: (ctx, model, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              locale.autoSaveDetails,
              style: TextStyles.rajdhaniSB.title4,
            ),
            centerTitle: false,
            backgroundColor: UiConstants.kBackgroundColor,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: UiConstants.kTextColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: UiConstants.kBackgroundColor,
          body: model.state == ViewState.Busy
              ? const Center(
                  child: FullScreenLoader(),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: model.activeSubscription == null
                          ? Center(
                              child: NoRecordDisplayWidget(
                                assetSvg: Assets.noTransactionAsset,
                                text: locale.autoSaveDetailsEmpty,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSaveDetailsCard(model: model),
                                Divider(
                                  indent: SizeConfig.padding32,
                                  endIndent: SizeConfig.padding32,
                                  height: SizeConfig.border1,
                                  color:
                                      const Color(0xFF999999).withOpacity(0.4),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: SizeConfig.padding24,
                                    top: SizeConfig.padding32,
                                    bottom: SizeConfig.padding10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Autosave Transactions",
                                        style: TextStyles.rajdhaniSB.title4,
                                      ),
                                      const Spacer(),
                                      if (!model.isFetchingTransactions &&
                                          (((model.currentPage == 0) &&
                                                  (model.augTxnList?.length ??
                                                          0) >
                                                      1) ||
                                              ((model.currentPage == 1) &&
                                                  (model.lbTxnList?.length ??
                                                          0) >
                                                      1)))
                                        GestureDetector(
                                          onTap: () {
                                            Haptic.vibrate();
                                            AppState.delegate!.appState
                                                .currentAction = PageAction(
                                              state: PageState.addWidget,
                                              widget: TransactionsHistory(
                                                investmentType: (model
                                                            .txnPageController!
                                                            .page!
                                                            .toInt() ==
                                                        1)
                                                    ? InvestmentType.LENDBOXP2P
                                                    : InvestmentType.AUGGOLD99,
                                                showAutosave: true,
                                              ),
                                              page:
                                                  TransactionsHistoryPageConfig,
                                            );
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: SizeConfig.padding2,
                                                ),
                                                child: Text(locale.btnSeeAll,
                                                    style: TextStyles
                                                        .rajdhaniSB.body2),
                                              ),
                                              SvgPicture.asset(
                                                Assets.chevRonRightArrow,
                                                height: SizeConfig.padding24,
                                                width: SizeConfig.padding24,
                                              ),
                                              SizedBox(
                                                width: SizeConfig.padding16,
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                model.isFetchingTransactions
                                    ? Center(
                                        child: FullScreenLoader(
                                          size: SizeConfig.padding80,
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: SizeConfig
                                                .pageHorizontalMargins),
                                        child: Column(
                                          children: [
                                            // Divider(color: Colors.white30),
                                            Container(
                                              height: SizeConfig.padding70,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Haptic.vibrate();
                                                        if (model.currentPage !=
                                                            0) {
                                                          model
                                                              .txnPageController!
                                                              .animateToPage(0,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  curve: Curves
                                                                      .decelerate);
                                                          model.currentPage = 0;
                                                        }
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Digital Gold",
                                                          style: TextStyles
                                                              .sourceSansSB
                                                              .body1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // VerticalDivider(
                                                  //   color: Colors.white30,
                                                  // ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Haptic.vibrate();
                                                        if (model.currentPage !=
                                                            1) {
                                                          model
                                                              .txnPageController!
                                                              .animateToPage(1,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  curve: Curves
                                                                      .decelerate);
                                                          model.currentPage = 1;
                                                        }
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Fello Flo",
                                                          style: TextStyles
                                                              .sourceSansSB
                                                              .body1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                AnimatedContainer(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  height: 4,
                                                  width: ((SizeConfig
                                                                  .screenWidth! -
                                                              SizeConfig
                                                                      .pageHorizontalMargins *
                                                                  2) /
                                                          2) *
                                                      model.currentPage,
                                                  curve: Curves.decelerate,
                                                ),
                                                Container(
                                                  width: (SizeConfig
                                                              .screenWidth! -
                                                          SizeConfig
                                                                  .pageHorizontalMargins *
                                                              2) /
                                                      2,
                                                  color:
                                                      UiConstants.primaryColor,
                                                  height: 4,
                                                )
                                              ],
                                            ),
                                            HeightAdaptivePageView(
                                                controller:
                                                    model.txnPageController,
                                                onPageChanged: (val) {
                                                  model.currentPage = val;
                                                },
                                                children: [
                                                  (model.augTxnList?.length ??
                                                              0) ==
                                                          0
                                                      ? Center(
                                                          child:
                                                              NoRecordDisplayWidget(
                                                          assetSvg: Assets
                                                              .noTransactionAsset,
                                                          text:
                                                              locale.txnsEmpty,
                                                        ))
                                                      : Container(
                                                          color: const Color(
                                                                  0xFF595F5F)
                                                              .withOpacity(
                                                                  0.14),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                SizeConfig
                                                                    .padding20,
                                                          ),
                                                          child:
                                                              ListView.builder(
                                                            itemCount: model
                                                                        .augTxnList!
                                                                        .length >
                                                                    5
                                                                ? 5
                                                                : model
                                                                    .augTxnList!
                                                                    .length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return SubTxnTile(
                                                                isLast: index ==
                                                                    model.augTxnList!
                                                                            .length -
                                                                        1,
                                                                txn: model
                                                                        .augTxnList![
                                                                    index],
                                                                type: Constants
                                                                    .ASSET_TYPE_AUGMONT,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                  (model.lbTxnList?.length ??
                                                              0) ==
                                                          0
                                                      ? Center(
                                                          child:
                                                              NoRecordDisplayWidget(
                                                          assetSvg: Assets
                                                              .noTransactionAsset,
                                                          text:
                                                              locale.txnsEmpty,
                                                        ))
                                                      : Container(
                                                          color: const Color(
                                                                  0xFF595F5F)
                                                              .withOpacity(
                                                                  0.14),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                SizeConfig
                                                                    .padding20,
                                                          ),
                                                          child:
                                                              ListView.builder(
                                                            itemCount: model
                                                                        .lbTxnList!
                                                                        .length >
                                                                    5
                                                                ? 5
                                                                : model
                                                                    .lbTxnList
                                                                    ?.length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return SubTxnTile(
                                                                isLast: index ==
                                                                    model.lbTxnList!
                                                                            .length -
                                                                        1,
                                                                txn: model
                                                                        .lbTxnList![
                                                                    index],
                                                                type: Constants
                                                                    .ASSET_TYPE_LENDBOX,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                ]),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  height: SizeConfig.padding80 * 2,
                                ),
                              ],
                            ),
                    ),
                    if (model.state == ViewState.Idle &&
                        model.activeSubscription != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            decoration: BoxDecoration(
                              // color: UiConstants.kSecondaryBackgroundColor,
                              gradient: LinearGradient(
                                colors: [
                                  UiConstants.kSecondaryBackgroundColor
                                      .withOpacity(0.2),
                                  UiConstants.kSecondaryBackgroundColor
                                      .withOpacity(0.9),
                                  UiConstants.kSecondaryBackgroundColor
                                      .withOpacity(0.2),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [
                                  0.02,
                                  0.8,
                                  1.0,
                                ],
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding40,
                              vertical: SizeConfig.pageHorizontalMargins,
                            ),
                            child: Consumer<SubService>(
                              builder: (context, subService, child) => Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:
                                    // (subService.autosaveState ==
                                    //         AutosaveState.PAUSED_FOREVER)
                                    //     ? _buildRestartAutoPay()
                                    //     :
                                    _buildUpdateAutoPay(subService, model),
                              ),
                            )),
                      ),
                  ],
                ),
        );
      },
    );
  }

  // List<Widget> _buildRestartAutoPay() {
  //   S locale = locator<S>();
  //   return [
  //     AppPositiveBtn(
  //       btnText: locale.btnRestartAutoSave,
  //       onPressed: () {
  //         AppState.delegate!.appState.currentAction = PageAction(
  //           page: AutosaveProcessViewPageConfig,
  //           widget: AutosaveProcessView(),
  //           state: PageState.replaceWidget,
  //         );
  //       },
  //       width: double.infinity,
  //     )
  //   ];
  // }

  _buildUpdateAutoPay(SubService subService, AutosaveDetailsViewModel model) {
    S locale = locator<S>();
    return [
      if (subService.autosaveState == AutosaveState.ACTIVE)
        AppPositiveBtn(
          btnText: "UPDATE AUTOSAVE",
          onPressed: () {
            //NOTE: CHECK IN EDIT MODE
            locator<AnalyticsService>()
                .track(eventName: AnalyticsEvents.asUpdateTapped);
            AppState.delegate!.appState.currentAction = PageAction(
              page: AutosaveUpdateViewPageConfig,
              state: PageState.addPage,
            );
          },
          width: double.infinity,
        ),
      Center(
        child: subService.autosaveState == AutosaveState.ACTIVE
            ? (subService.isPauseOrResuming
                ? Container(
                    height: SizeConfig.padding40,
                    child: SpinKitThreeBounce(
                      size: SizeConfig.padding24,
                      color: UiConstants.tertiarySolid,
                    ),
                  )
                : TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.zero),
                    ),
                    onPressed: model.pauseResume,
                    child: Text(locale.pauseAutoSave.toUpperCase(),
                        style: TextStyles.rajdhani.body3),
                  ))
            : ReactivePositiveAppButton(
                onPressed: model.pauseResume,
                btnText: locale.resumeAutoSave,
              ),
      ),
    ];
  }
}

class AutosaveAssetDetailTile extends StatelessWidget {
  final String title, subtitle, asset, amt;
  const AutosaveAssetDetailTile({
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.amt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.padding12,
      ),
      child: Row(
        children: [
          Image.asset(
            asset,
            width: SizeConfig.padding70,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.sourceSansB.body1,
                ),
                Text(subtitle,
                    style: TextStyles.sourceSans.body3.colour(Colors.grey)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                SizeConfig.roundness5,
              ),
            ),
            height: SizeConfig.padding54,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: SizeConfig.padding10),
            width: SizeConfig.screenWidth! * 0.2,
            child: Text(
              amt,
              style: TextStyles.sourceSansB.body1,
            ),
          ),
        ],
      ),
    );
  }
}

class SubTxnTile extends StatelessWidget {
  SubTxnTile({
    required this.txn,
    required this.isLast,
    required this.type,
    Key? key,
  }) : super(key: key);
  final bool isLast;
  final SubscriptionTransactionModel txn;
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  final String type;

  String get getFormattedDate =>
      DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(
          txn.createdOn.millisecondsSinceEpoch));

  String get formattedTime =>
      DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
          txn.createdOn.millisecondsSinceEpoch));
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.padding20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    type == Constants.ASSET_TYPE_AUGMONT
                        ? "Gold Deposit"
                        : "Flo Deposit",
                    style: TextStyles.sourceSansM.body2,
                  ),
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  Text(
                    getFormattedDate + " at " + formattedTime,
                    style: TextStyles.sourceSansL.body4,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "₹${type == Constants.ASSET_TYPE_AUGMONT ? (txn.augMap?.amount ?? '0') : (txn.lbMap!.amount ?? '0')}",
                    style: TextStyles.sourceSansSB.body2,
                  ),
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  Text(
                    txn.status,
                    style: TextStyles.sourceSansM.body3.colour(
                      _txnHistoryService.getTileColor(txn.status),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: SizeConfig.border1,
            color: UiConstants.kTextColor.withOpacity(0.4),
          ),
      ],
    );
  }
}

class AutoSaveDetailsCard extends StatelessWidget {
  final AutosaveDetailsViewModel model;

  const AutoSaveDetailsCard({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();

    return Container(
      width: SizeConfig.screenWidth! * 0.8426,
      margin: EdgeInsets.only(
        right: SizeConfig.padding32,
        left: SizeConfig.padding32,
        top: SizeConfig.padding10,
      ),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding16,
      ),
      child: Consumer<SubService>(
        builder: (context, _subService, property) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "You are saving",
                style: TextStyles.sourceSans.body3
                    .setOpacity(0.6)
                    .letterSpace(SizeConfig.padding2),
              ),
              SizedBox(height: SizeConfig.padding10),
              RichText(
                text: TextSpan(
                  text: '₹${_subService.subscriptionData!.amount}',
                  style: TextStyles.rajdhaniB.title1,
                  children: [
                    TextSpan(
                        text:
                            '/${_subService.subscriptionData!.frequency!.toCamelCase().frequencyRename()}',
                        style: TextStyles.rajdhaniT.title2)
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.padding12),
              Divider(
                height: SizeConfig.padding12,
                color: UiConstants.kAutosaveBalanceColor.withOpacity(0.4),
              ),
              if (int.tryParse(_subService.subscriptionData!.lbAmt ?? '0') != 0)
                AutosaveAssetDetailTile(
                  asset: Assets.felloFlo,
                  title: "Fello Flo",
                  subtitle: "P2P Fund | 10% Returns",
                  amt: "₹" + (_subService.subscriptionData!.lbAmt ?? '-'),
                ),
              if (int.tryParse(_subService.subscriptionData!.augAmt ?? '0') !=
                  0)
                AutosaveAssetDetailTile(
                  asset: Assets.digitalGoldBar,
                  title: "Digital Gold",
                  subtitle: "Safe and Stable Returns",
                  amt: "₹" + (_subService.subscriptionData!.augAmt ?? '-'),
                ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Divider(
                height: SizeConfig.padding12,
                color: UiConstants.kAutosaveBalanceColor.withOpacity(0.4),
              ),
              SizedBox(height: SizeConfig.padding10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: locale.yourAutoSave,
                      style: TextStyles.sourceSans.body4
                          .setOpacity(0.4)
                          .copyWith(fontStyle: FontStyle.italic),
                    ),
                    TextSpan(
                      text: getRichText(_subService.autosaveState,
                          _subService.subscriptionData!),
                      style: TextStyles.sourceSans.body4.colour(
                        getRichTextColor(_subService.autosaveState,
                            _subService.subscriptionData!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  getRichTextColor(AutosaveState autosaveState, SubscriptionModel subdata) {
    if (autosaveState == AutosaveState.ACTIVE) {
      return UiConstants.primaryColor;
    } else if (autosaveState == AutosaveState.PAUSED) {
      if (subdata.resumeDate != TimestampModel.none()) {
        return UiConstants.tertiarySolid;
      } else {
        return Colors.red;
      }
    }
  }

  getRichText(AutosaveState autosaveState, SubscriptionModel subdata) {
    if (autosaveState == AutosaveState.ACTIVE) {
      return "verified and active";
    } else if (autosaveState == AutosaveState.PAUSED) {
      if (subdata.resumeDate != TimestampModel.none()) {
        return "verified and paused till " +
            "${DateFormat.MMMEd().format(subdata.resumeDate!.toDate())} ";
      } else {
        return "currently inactive";
      }
    }
  }
}
