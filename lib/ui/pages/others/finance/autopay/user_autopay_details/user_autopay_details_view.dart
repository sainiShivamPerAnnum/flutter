import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_transaction/autopay_transactions_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/user_autopay_details/user_autopay_details_vm.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/static/blinker.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserAutoPayDetailsView extends StatelessWidget {
  const UserAutoPayDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<UserAutoPayDetailsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      child: NoTransactionsContent(),
      builder: (ctx, model, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: HomeBackground(
            child: Stack(
              children: [
                Column(
                  children: [
                    FelloAppBar(
                      leading: FelloAppBarBackButton(),
                      title: "UPI AutoPay Details",
                    ),
                    Expanded(
                      child: Container(
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          color: model.isInEditMode
                              ? Colors.white
                              : UiConstants.scaffoldColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: model.isInEditMode
                            ? UpdateDetailsView(
                                model: model,
                              )
                            : DetailsView(
                                model: model,
                              ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class UpdateDetailsView extends StatelessWidget {
  final UserAutoPayDetailsViewModel model;
  UpdateDetailsView({this.model});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.pageHorizontalMargins),
                SvgPicture.asset("assets/vectors/addmoney.svg",
                    height: SizeConfig.screenHeight * 0.16),
                SizedBox(height: SizeConfig.padding24),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins),
                  child: Text(
                    "How much would you like to save?",
                    style: TextStyles.title5.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: SizeConfig.padding24),
                Row(
                  children: [
                    Expanded(
                      child: SegmentChips(
                        model: model,
                        text: "Daily",
                      ),
                    ),
                    SizedBox(width: SizeConfig.padding16),
                    Expanded(
                      child: SegmentChips(
                        model: model,
                        text: "Weekly",
                      ),
                    ),
                  ],
                ),
                Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth / 2 +
                            SizeConfig.padding16 -
                            (model.isDaily ? 0 : SizeConfig.padding12),
                        child: TextField(
                          controller: model.amountFieldController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              isCollapsed: true,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                          // autofocus: true,
                          // cursorHeight: SizeConfig.screenWidth / 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.number,
                          cursorWidth: 0.5,
                          onChanged: (value) {
                            model.onAmountValueChanged(value);
                          },
                          textAlign: TextAlign.end,
                          style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.screenWidth / 4.8,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        width: SizeConfig.screenWidth / 2 -
                            SizeConfig.pageHorizontalMargins * 2 -
                            SizeConfig.padding16 +
                            (model.isDaily ? 0 : SizeConfig.padding12),
                        // height: SizeConfig.padding24,
                        child: Text(model.isDaily ? '/day' : '/week',
                            style: GoogleFonts.sourceSansPro(
                                fontSize: SizeConfig.title2,
                                fontWeight: FontWeight.w300,
                                height: SizeConfig.padding4,
                                color: Colors.black38)),
                      )
                    ],
                  ),
                ),
                Text(
                  "You'll be saving ₹${model.saveAmount.toInt().toString().replaceAllMapped(model.reg, model.mathFunc)} every year",
                  style: TextStyles.body2.bold.colour(Colors.black45),
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AmountChips(amount: 100, model: model),
                      AmountChips(
                          amount: 250,
                          model: model,
                          isBestSeller: model.isDaily ? true : false),
                      AmountChips(
                          amount: 500,
                          model: model,
                          isBestSeller: !model.isDaily ? true : false),
                      AmountChips(amount: 1000, model: model),
                      AmountChips(amount: 5000, model: model),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (model.isInEditMode)
          Positioned(
            bottom: 0,
            right: SizeConfig.pageHorizontalMargins,
            child: SafeArea(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth -
                          SizeConfig.pageHorizontalMargins * 2,
                      child: FelloButtonLg(
                        child: model.isSubscriptionAmountUpdateInProgress
                            ? SpinKitThreeBounce(
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                "Update",
                                style:
                                    TextStyles.body2.bold.colour(Colors.white),
                              ),
                        onPressed: () {
                          model.setSubscriptionAmount(
                              int.tryParse(model.amountFieldController.text)
                                  .toDouble());
                        },
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding6),
                    TextButton(
                      onPressed: () {
                        BaseUtil.openModalBottomSheet(
                          addToScreenStack: true,
                          hapticVibrate: true,
                          backgroundColor: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness32),
                            topRight: Radius.circular(SizeConfig.roundness32),
                          ),
                          isBarrierDismissable: false,
                          isScrollControlled: true,
                          content: PauseAutoPayModal(
                            model: model,
                          ),
                        );
                      },
                      child: Text(
                        "PAUSE SUBSCRIPTION",
                        style: TextStyles.body2
                            .colour(UiConstants.tertiarySolid)
                            .light,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.viewInsets.bottom != 0
                          ? 0
                          : SizeConfig.padding12,
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}

class AmountChips extends StatelessWidget {
  final model;
  final int amount;
  final bool isBestSeller;
  AmountChips({
    this.model,
    this.amount,
    this.isBestSeller = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        model.amountFieldController.text = amount.toString();
        model.onAmountValueChanged(amount.toString());
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding8,
                horizontal: SizeConfig.padding12),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isBestSeller
                      ? UiConstants.primaryColor
                      : UiConstants.primaryLight.withOpacity(0.5),
                  width: 0.5),
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              color: UiConstants.primaryLight.withOpacity(0.5),
            ),
            alignment: Alignment.center,
            child: Text(
              " ₹ ${amount.toInt()} ",
              style: TextStyles.body3.bold,
            ),
          ),
          if (isBestSeller)
            Transform.translate(
              offset: Offset(0, -SizeConfig.padding8),
              child: Container(
                decoration: BoxDecoration(
                  color: UiConstants.primaryColor,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding6,
                    vertical: SizeConfig.padding4),
                child: Text(
                  'BEST',
                  style: TextStyles.body5.bold
                      .colour(Colors.white)
                      .letterSpace(SizeConfig.padding2),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class DetailsView extends StatelessWidget {
  final UserAutoPayDetailsViewModel model;
  DetailsView({this.model});

  getFreq(String freq) {
    if (freq == "DAILY") return "/day";
    if (freq == "WEEKLY") return "/week";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        model.state == ViewState.Busy
            ? Center(
                child: SpinKitWave(
                  color: UiConstants.primaryColor,
                  size: SizeConfig.padding32,
                ),
              )
            : (model.activeSubscription != null
                ? ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.pageHorizontalMargins),
                    children: [
                      PropertyChangeConsumer<PaytmService,
                          PaytmServiceProperties>(
                        properties: [PaytmServiceProperties.ActiveSubscription],
                        builder: (context, model, property) =>
                            WinningsContainer(
                          shadow: false,
                          onTap: () {},
                          color: UiConstants.autopayColor,
                          child: Container(
                            width: SizeConfig.screenWidth,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(SizeConfig.padding8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Blinker(
                                      child: CircleAvatar(
                                        backgroundColor:
                                            model.activeSubscription.status ==
                                                    "ACTIVE"
                                                ? UiConstants.primaryColor
                                                : UiConstants.tertiarySolid,
                                        radius: SizeConfig.padding4,
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.padding4),
                                    Text(
                                      model.activeSubscription.status ==
                                              "ACTIVE"
                                          ? "Active Subscription"
                                          : "Subscription Paused",
                                      style:
                                          TextStyles.body1.colour(Colors.white),
                                    ),
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        "₹${model.activeSubscription.autoAmount.toInt() ?? 0.0}",
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: SizeConfig.title2,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2,
                                        color: Colors.white),
                                    children: [
                                      TextSpan(
                                        text: getFreq(model
                                            .activeSubscription.autoFrequency),
                                        style: GoogleFonts.sourceSansPro(
                                            fontSize: SizeConfig.title4,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness32),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.pageHorizontalMargins),
                        child: Column(
                          children: [
                            Container(
                              height: SizeConfig.screenWidth * 0.25,
                              decoration: BoxDecoration(
                                color: UiConstants.scaffoldColor,
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness16),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding16),
                              padding: EdgeInsets.all(SizeConfig.padding24),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: UiConstants.primaryLight,
                                    radius: SizeConfig.screenWidth * 0.067,
                                    child: SvgPicture.asset(
                                      "assets/vectors/icons/upi.svg",
                                      height: SizeConfig.screenWidth * 0.067,

                                      // width: SizeConfig.padding64,
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding12,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FittedBox(
                                          child: Row(
                                            children: [
                                              Text(
                                                model.activeSubscription.vpa ??
                                                    "Ille",
                                                style: TextStyles.body1.bold,
                                              ),
                                              SizedBox(
                                                  width: SizeConfig.padding4),
                                              SvgPicture.asset(
                                                "assets/vectors/check.svg",
                                                height: SizeConfig.iconSize1,
                                                // width: SizeConfig.padding64,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.padding4),
                                        FittedBox(
                                          child: Text(
                                            "Primary UPI",
                                            style: TextStyles.body3
                                                .colour(Colors.grey),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding12),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text:
                                          'Congratulations! your investments are on\n',
                                      style: TextStyles.body3
                                          .colour(Colors.black45)
                                          .italic,
                                    ),
                                    new TextSpan(
                                      text: 'auto-pilot mode',
                                      style: TextStyles.body3
                                          .colour(UiConstants.primaryColor)
                                          .bold
                                          .italic,
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Haptic.vibrate();

                                          AppState.delegate.appState
                                                  .currentAction =
                                              PageAction(
                                                  state: PageState.addPage,
                                                  page:
                                                      AutoPayDetailsViewPageConfig);
                                        },
                                    ),
                                    new TextSpan(
                                      text: ' now.',
                                      style: TextStyles.body3
                                          .colour(Colors.black45)
                                          .italic,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            Row(
                              children: [
                                SizedBox(width: SizeConfig.padding20),
                                Text(
                                  "History",
                                  style: TextStyles.title3.bold,
                                ),
                              ],
                            ),
                            model.filteredList == null
                                ? Center(
                                    child: SpinKitWave(
                                      color: UiConstants.primaryColor,
                                      size: SizeConfig.padding32,
                                    ),
                                  )
                                : (model.filteredList?.length == 0
                                    ? NoTransactionsContent()
                                    : ListView(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(
                                            top: SizeConfig
                                                .pageHorizontalMargins,
                                            left: SizeConfig
                                                    .pageHorizontalMargins /
                                                2,
                                            right: SizeConfig
                                                .pageHorizontalMargins),
                                        children: List.generate(
                                          model.filteredList?.length,
                                          (index) =>
                                              SubscriptionTransactionTile(
                                            // model: model,
                                            txn: model.filteredList[index],
                                          ),
                                        ),
                                      )),
                            !model.hasMoreTxns
                                ? SizedBox(
                                    height: SizeConfig.padding16,
                                  )
                                : FelloButton(
                                    onPressed: () {
                                      AppState.delegate.appState.currentAction =
                                          PageAction(
                                        state: PageState.addPage,
                                        page: AutopayTransactionsViewPageConfig,
                                      );
                                    },
                                    defaultButtonText: "View All",
                                    defaultButtonColor: Colors.white,
                                    textStyle: TextStyles.body1.bold
                                        .colour(UiConstants.primaryColor),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: NoRecordDisplayWidget(
                      assetLottie: Assets.noData,
                      text: "No UPI Autopay Details available",
                    ),
                  )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: SizeConfig.navBarHeight * 2,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white,
                Colors.white.withOpacity(0.0),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
            ),
          ),
        ),
        if (model.state == ViewState.Idle &&
            model.activeSubscription != null &&
            !model.isInEditMode)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: FelloButtonLg(
                      child: Text(
                        "Update Subscription",
                        style: TextStyles.body2.bold.colour(Colors.white),
                      ),
                      onPressed: () {
                        model.isInEditMode = true;
                      },
                    ),
                  ),
                  // SizedBox(height: SizeConfig.padding6),
                  // TextButton(
                  //   onPressed: () {
                  //     BaseUtil.openModalBottomSheet(
                  //       addToScreenStack: true,
                  //       hapticVibrate: true,
                  //       backgroundColor: Colors.white,
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(SizeConfig.roundness32),
                  //         topRight: Radius.circular(SizeConfig.roundness32),
                  //       ),
                  //       isBarrierDismissable: false,
                  //       content: PauseAutoPayModal(
                  //         model: model,
                  //       ),
                  //     );
                  //   },
                  //   child: Text(
                  //     "PAUSE",
                  //     style: TextStyles.body1.colour(Colors.grey).light,
                  //   ),
                  // ),
                  SizedBox(
                    height: SizeConfig.viewInsets.bottom != 0
                        ? 0
                        : SizeConfig.pageHorizontalMargins,
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}

class PauseAutoPayModal extends StatefulWidget {
  final UserAutoPayDetailsViewModel model;

  const PauseAutoPayModal({Key key, this.model}) : super(key: key);

  @override
  State<PauseAutoPayModal> createState() => _PauseAutoPayModalState();
}

class _PauseAutoPayModalState extends State<PauseAutoPayModal> {
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
                "Pause AutoPay",
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
          SizedBox(height: SizeConfig.padding8),
          Text(
            "Pause AutoPay for",
            style: TextStyles.body2.colour(Colors.grey),
          ),
          SizedBox(height: SizeConfig.padding8),
          pauseOptionTile(
            text: "1 Week",
            radioValue: 1,
          ),
          pauseOptionTile(
            text: "2 Week",
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
          SizedBox(height: SizeConfig.padding16),
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
              setState(() {
                isPausing = true;
              });
              await widget.model.pauseSubscription(pauseValue);
              setState(() {
                isPausing = false;
              });
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
