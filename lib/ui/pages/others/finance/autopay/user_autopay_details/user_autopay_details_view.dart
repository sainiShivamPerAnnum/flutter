import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/user_autopay_details/user_autopay_details_vm.dart';
import 'package:felloapp/ui/pages/others/finance/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserAutosaveDetailsView extends StatelessWidget {
  const UserAutosaveDetailsView({Key key}) : super(key: key);

  getFreq(String freq) {
    if (freq == "DAILY") return "/day";
    if (freq == "WEEKLY") return "/week";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return BaseView<UserAutosaveDetailsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      // child: NoTransactionsContent(),
      builder: (ctx, model, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'Autopay Details',
              style: TextStyles.rajdhaniSB.title4,
            ),
            centerTitle: true,
            backgroundColor: UiConstants.kBackgroundColor,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: UiConstants.kTextColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: UiConstants.kBackgroundColor,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: model.state == ViewState.Busy
                    ? Center(
                        child: FullScreenLoader(
                          size: SizeConfig.padding32,
                        ),
                      )
                    : model.activeSubscription == null
                        ? Center(
                            child: NoRecordDisplayWidget(
                              assetSvg: Assets.noTransactionAsset,
                              text: "No Autosave Details available",
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAmountSavedCard(model),
                              SizedBox(
                                height: SizeConfig.padding40,
                              ),
                              _buildPaymentMethod(model),
                              SizedBox(
                                height: SizeConfig.padding32,
                              ),
                              Divider(
                                height: SizeConfig.border1,
                                color: Color(0xFF999999).withOpacity(0.4),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: SizeConfig.padding20,
                                  top: SizeConfig.padding20,
                                  bottom: SizeConfig.padding20,
                                ),
                                child: Text(
                                  "Recent Transaction",
                                  style: TextStyles.rajdhaniSB.body1,
                                ),
                              ),
                              model.filteredList == null
                                  ? Center(
                                      child: FullScreenLoader(
                                      size: SizeConfig.padding80,
                                    ))
                                  : model.filteredList?.length == 0
                                      ? Center(
                                          child: NoTransactionsContent(
                                            width: SizeConfig.screenWidth * 0.8,
                                          ),
                                        )
                                      : Container(
                                          color: Color(0xFF595F5F)
                                              .withOpacity(0.14),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.padding20,
                                          ),
                                          child: ListView.builder(
                                            itemCount:
                                                model.filteredList?.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return TransationTile(
                                                isLast: index ==
                                                    model.filteredList.length -
                                                        1,
                                                txn: model.filteredList[index],
                                              );
                                            },
                                          ),
                                        ),
                              SizedBox(
                                height: SizeConfig.padding80 * 2,
                              ),
                            ],
                          ),
              ),
              // Positioned(
              //   bottom: 0,
              //   child: Container(
              //     width: SizeConfig.screenWidth,
              //     height: 120,
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //           begin: Alignment.bottomCenter,
              //           end: Alignment.topCenter,
              //           colors: [
              //             UiConstants.kSecondaryBackgroundColor
              //                 .withOpacity(0.8),
              //             UiConstants.kSecondaryBackgroundColor
              //                 .withOpacity(0.2),
              //           ],
              //           stops: [
              //             0.8,
              //             1
              //           ]),
              //     ),
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              //     ),
              //   ),
              // ),
              if (model.state == ViewState.Idle &&
                  model.activeSubscription != null &&
                  !model.isInEditMode)
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
                        stops: [
                          0.02,
                          0.8,
                          1.0,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding40,
                      vertical: SizeConfig.padding10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: (model.activeSubscription.status ==
                                  Constants.SUBSCRIPTION_INACTIVE &&
                              model.activeSubscription.resumeDate.isEmpty)
                          ? _buildRestartAutoPay()
                          : _buildUpdateAutoPay(model),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Padding _buildPaymentMethod(UserAutosaveDetailsViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment Method",
            style: TextStyles.rajdhaniSB.body1,
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.padding54,
                height: SizeConfig.padding54,
                decoration: BoxDecoration(
                  color: Color(0xFFC4C4C4).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.upiIcon,
                    width: SizeConfig.iconSize0,
                    height: SizeConfig.iconSize0,
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.padding12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        model.activeSubscription.vpa ?? "hello@upi",
                        style: TextStyles.sourceSans.body1,
                      ),
                      SizedBox(
                        width: SizeConfig.padding8,
                      ),
                      Icon(
                        Icons.verified,
                        color: UiConstants.primaryColor,
                        size: SizeConfig.padding20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding6,
                  ),
                  Text(
                    "Primary UPI",
                    style: TextStyles.sourceSansSB.body3.setOpecity(0.5),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSavedCard(UserAutosaveDetailsViewModel model) {
    return Container(
      // height: SizeConfig.screenWidth * 0.5433,
      width: SizeConfig.screenWidth * 0.8426,
      decoration: BoxDecoration(
        color: UiConstants.kAutosaveBalanceColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
      ),
      margin: EdgeInsets.only(
        right: SizeConfig.padding32,
        left: SizeConfig.padding32,
        top: SizeConfig.padding10,
      ),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding16,
      ),
      child: PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
        properties: [PaytmServiceProperties.ActiveSubscription],
        builder: (context, m, property) {
          return (m.activeSubscription.status ==
                      Constants.SUBSCRIPTION_INACTIVE &&
                  m.activeSubscription.resumeDate.isEmpty)
              ? Center(
                  child: Text(
                    "Autosave Inactive",
                    style: TextStyles.title3.bold.colour(Colors.white),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding16,
                        ),
                        child: Text(
                          "AMOUNT SAVED",
                          style: TextStyles.rajdhani.body3
                              .setOpecity(0.6)
                              .letterSpace(SizeConfig.padding2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
                    RichText(
                      text: TextSpan(
                          text: '₹${m.activeSubscription.autoAmount.toInt()}',
                          style: TextStyles.rajdhaniB.title1,
                          children: [
                            TextSpan(
                                text:
                                    '${getFreq(m.activeSubscription.autoFrequency)}',
                                style: TextStyles.rajdhaniT.title2)
                          ]),
                    ),
                    // Text(
                    //   '₹${m.activeSubscription.autoAmount.toInt()} ${getFreq(m.activeSubscription.autoFrequency)}',
                    //   style: TextStyles.sourceSans.body3.setOpecity(0.5),
                    // ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    ),
                    Divider(
                      height: SizeConfig.border0,
                      color: UiConstants.kAutosaveBalanceColor.withOpacity(0.4),
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Your Autosave account is ',
                            style: TextStyles.sourceSans.body4
                                .setOpecity(0.4)
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: model.getRichText(),
                            style: TextStyles.sourceSans.body4
                                .colour(
                                  model.getRichTextColor(),
                                )
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                          // TextSpan(
                          //   text: ' now',
                          //   style: TextStyles.sourceSans.body4
                          //       .setOpecity(0.4)
                          //       .copyWith(fontStyle: FontStyle.italic),
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  List<Widget> _buildRestartAutoPay() {
    return [
      AppPositiveBtn(
        btnText: "Restart Autosave",
        onPressed: () {
          AppState.delegate.appState.currentAction = PageAction(
            page: AutosaveProcessViewPageConfig,
            widget: AutosaveProcessView(page: 2),
            state: PageState.replaceWidget,
          );
        },
        width: double.infinity,
      )
    ];
  }

  _buildUpdateAutoPay(UserAutosaveDetailsViewModel model) {
    return [
      if (model.activeSubscription.status == Constants.SUBSCRIPTION_ACTIVE)
        AppPositiveBtn(
          btnText: 'Update',
          onPressed: () {
            //NOTE: CHECK IN EDIT MODE
            AppState.delegate.appState.currentAction = PageAction(
              page: AutosaveProcessViewPageConfig,
              widget: AutosaveProcessView(page: 2),
              state: PageState.replaceWidget,
            );
          },
          width: double.infinity,
        ),
      model.isResumingInProgress
          ? Container(
              height: SizeConfig.padding40,
              child: SpinKitThreeBounce(
                size: SizeConfig.padding24,
                color: UiConstants.tertiarySolid,
              ),
            )
          : Center(
              child: TextButton(
                onPressed: () => model.pauseResume(model),
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                ),
                child: Text(
                  model.activeSubscription.status ==
                          Constants.SUBSCRIPTION_INACTIVE
                      ? "RESUME AUTOSAVE"
                      : "PAUSE AUTOSAVE",
                  style: TextStyles.rajdhani.body3,
                ),
              ),
            ),
      // SizedBox(
      //   height: SizeConfig.padding54,
      // ),
    ];
  }
}

class TransationTile extends StatelessWidget {
  TransationTile({
    Key key,
    @required this.txn,
    @required this.isLast,
  }) : super(key: key);
  final bool isLast;
  final AutosaveTransactionModel txn;
  final _txnHistoryService = locator<TransactionHistoryService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _txnHistoryService.getTileTitle(
                      UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD,
                    ),
                    style: TextStyles.rajdhaniM.body2,
                  ),
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  Text(
                    _txnHistoryService.getFormattedTime(txn.createdOn),
                    style: TextStyles.rajdhaniL.body3,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _txnHistoryService.getFormattedTxnAmount(txn.amount),
                    style: TextStyles.rajdhaniSB.body2,
                  ),
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  Text(
                    txn.status,
                    style: TextStyles.rajdhaniM.body3.colour(
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

class PauseAutosaveModal extends StatefulWidget {
  final UserAutosaveDetailsViewModel model;

  const PauseAutosaveModal({Key key, this.model}) : super(key: key);

  @override
  State<PauseAutosaveModal> createState() => _PauseAutosaveModalState();
}

class _PauseAutosaveModalState extends State<PauseAutosaveModal> {
  int pauseValue = 1;
  setPauseValue(value) {
    setState(() {
      pauseValue = value;
    });
  }

  bool isPausing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Wrap(
        //shrinkWrap: true,
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Pause Autosave",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.black,
                child: IconButton(
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                  },
                  icon: Icon(
                    Icons.close,
                    size: SizeConfig.iconSize1,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: SizeConfig.padding24,
            thickness: 2,
          ),
          SizedBox(height: SizeConfig.padding16),
          pauseOptionTile(
            text: "1 Week",
            radioValue: 1,
          ),
          pauseOptionTile(
            text: "2 Weeks",
            radioValue: 2,
          ),
          pauseOptionTile(
            text: "1 Month",
            radioValue: 3,
          ),
          pauseOptionTile(
            text: "Forever",
            radioValue: 4,
          ),
          Container(height: SizeConfig.padding16),
          FelloButtonLg(
            child: isPausing
                ? SpinKitThreeBounce(
                    color: Colors.white,
                    size: SizeConfig.padding16,
                  )
                : Text(
                    "PAUSE",
                    style: TextStyles.body2.bold.colour(Colors.white),
                  ),
            onPressed: () async {
              if (pauseValue == 4) {
                BaseUtil.openDialog(
                  addToScreenStack: true,
                  isBarrierDismissable: false,
                  hapticVibrate: true,
                  content: FelloConfirmationDialog(
                    title: "Are you sure ?",
                    subtitle:
                        "You will lose out on automated savings & many exclusive rewards⏸️",
                    reject: "No",
                    acceptColor: Colors.grey.withOpacity(0.5),
                    rejectColor: UiConstants.primaryColor,
                    acceptTextColor: Colors.black,
                    rejectTextColor: Colors.white,
                    onReject: () {
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                    accept: "Yes",
                    onAccept: () async {
                      if (isPausing) return;
                      setState(() {
                        isPausing = false;
                      });
                      await widget.model.pauseSubscription(pauseValue);
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                  ),
                );
              } else {
                if (isPausing) return;
                setState(() {
                  isPausing = true;
                });
                await widget.model.pauseSubscription(pauseValue);
                setState(() {
                  isPausing = false;
                });
              }
            },
          ),
          SizedBox(height: SizeConfig.pageHorizontalMargins / 2),
        ],
      ),
    );
  }

  pauseOptionTile({
    @required text,
    @required radioValue,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setPauseValue(radioValue);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
        decoration: BoxDecoration(
            border: Border.all(
              width: pauseValue == radioValue ? 0.5 : 0,
              color: pauseValue == radioValue
                  ? UiConstants.primaryColor
                  : Colors.black26,
            ),
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            color: pauseValue == radioValue
                ? UiConstants.primaryLight.withOpacity(0.5)
                : Colors.transparent),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding4,
        ),
        child: ListTile(
          title: Text(text),
          trailing: Radio(
            value: radioValue,
            groupValue: pauseValue,
            onChanged: (value) {
              setPauseValue(value);
            },
            activeColor: UiConstants.primaryColor,
          ),
        ),
      ),
    );
  }
}
