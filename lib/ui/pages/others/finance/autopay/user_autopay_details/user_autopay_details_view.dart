import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/autosave_services.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_transaction/autopay_transactions_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/user_autopay_details/user_autopay_details_vm.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/static/blinker.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
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

class UserAutoSaveDetailsView extends StatelessWidget {
  const UserAutoSaveDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<UserAutoSaveDetailsViewModel>(
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
                      title: "Autosave Details",
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
  final UserAutoSaveDetailsViewModel model;
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins),
                  child: Text(
                    "How much would you like to save?",
                    style: TextStyles.title3.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: SizeConfig.padding24),
                Container(
                  decoration: BoxDecoration(
                    color: UiConstants.scaffoldColor,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  ),
                  padding: EdgeInsets.all(SizeConfig.padding6),
                  height: SizeConfig.padding54,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.decelerate,
                        left: model.isDaily
                            ? 0
                            : (SizeConfig.screenWidth / 2 -
                                SizeConfig.pageHorizontalMargins -
                                SizeConfig.padding6),
                        child: Container(
                          width: SizeConfig.screenWidth / 2 -
                              SizeConfig.pageHorizontalMargins -
                              SizeConfig.padding6,
                          height: SizeConfig.padding54 * 0.8,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                            color: UiConstants.primaryColor,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Haptic.vibrate();
                                  model.isDaily = true;
                                  model.onAmountValueChanged(
                                      model?.amountFieldController?.text);
                                },
                                child: SegmentChips(
                                  model: model,
                                  text: "Daily",
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Haptic.vibrate();
                                  model.isDaily = false;
                                  model.onAmountValueChanged(
                                      model.amountFieldController.text);
                                },
                                child: SegmentChips(
                                  model: model,
                                  text: "Weekly",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.padding24),
                Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: SizedBox()),
                      IntrinsicWidth(
                        child: Container(
                          height: SizeConfig.screenWidth / 4.2,
                          child: TextField(
                            controller: model.amountFieldController,
                            maxLines: null,
                            // maxLength: 4,

                            decoration: InputDecoration(
                                prefixText: "₹",
                                counterText: "",
                                prefixStyle: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.screenWidth / 4.8,
                                    color: Colors.black),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: -SizeConfig.padding4),
                                isDense: true,
                                isCollapsed: true,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                            // autofocus: true,
                            // cursorHeight: SizeConfig.padding20,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // enableInteractiveSelection: false,
                            keyboardType: TextInputType.number,
                            // cursorWidth: 0,
                            autofocus: true,
                            onChanged: (value) {
                              model.onAmountValueChanged(value);
                            },

                            style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold,
                                height: 0.9,
                                fontSize: SizeConfig.screenWidth / 4.8,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            model.isDaily ? '/day' : '/week',
                            style: GoogleFonts.sourceSansPro(
                                fontSize: SizeConfig.title3,
                                height: 2,
                                color: Colors.black38),
                          ),
                          SizedBox(height: SizeConfig.padding12)
                        ],
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.padding12),
                if (model.showMinAlert)
                  Text(
                    "Minimum investment amount is ₹ ${model.minValue}",
                    style: TextStyles.body3.bold.colour(Colors.red[300]),
                  ),
                SizedBox(height: SizeConfig.padding12),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding12,
                    horizontal: SizeConfig.pageHorizontalMargins,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.roundness12,
                    ),
                    color: UiConstants.tertiaryLight,
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RichText(
                        text: TextSpan(
                      text: "You'll be saving ",
                      children: [
                        TextSpan(
                            text:
                                "₹${model.saveAmount.toInt().toString().replaceAllMapped(model.reg, model.mathFunc)}",
                            style: TextStyles.body2.bold
                                .colour(UiConstants.tertiarySolid)),
                        TextSpan(text: " every year!")
                      ],
                      style: TextStyles.body2.colour(Colors.black),
                    )),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: model.isDaily
                        ? List.generate(
                            model.dailyChips.length,
                            (index) => AmountChips(
                                  amount: model.dailyChips[index].value,
                                  model: model,
                                  isBestSeller: model.dailyChips[index].best,
                                ))
                        : List.generate(
                            model.weeklyChips.length,
                            (index) => AmountChips(
                                  amount: model.weeklyChips[index].value,
                                  model: model,
                                  isBestSeller: model.weeklyChips[index].best,
                                )),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.3,
                )
              ],
            ),
          ),
        ),
        if (model.isInEditMode) AmountFreqUpdateButton(model: model),
      ],
    );
  }
}

class AmountFreqUpdateButton extends StatelessWidget {
  const AmountFreqUpdateButton({
    Key key,
    @required this.model,
  }) : super(key: key);

  final UserAutoSaveDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: SafeArea(
        child: Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            // vertical: SizeConfig.padding16,
          ),
          color: Colors.white,
          child: Column(
            children: [
              if (model.amountFieldController.text != null &&
                  model.amountFieldController.text.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.padding16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Every ${model.isDaily ? 'day' : 'week'} you'll recieve",
                          style: TextStyles.body2.bold,
                        ),
                        // Divider(
                        //   height: SizeConfig.padding24,
                        // ),
                        SizedBox(height: SizeConfig.padding12),
                        Container(
                          width: SizeConfig.screenWidth,
                          // height: SizeConfig.padding40,
                          child: Row(
                              // scrollDirection: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutosavePerks(
                                  svg: 'images/svgs/gold.svg',
                                  text: "Savings in gold",
                                ),
                                if (model.amountFieldController.text != null &&
                                    model.amountFieldController.text
                                        .isNotEmpty &&
                                    int.tryParse(model
                                            ?.amountFieldController?.text) >=
                                        100)
                                  AutosavePerks(
                                    svg: Assets.goldenTicket,
                                    text: "1 Golden ticket",
                                  ),
                                if (model.amountFieldController.text != null &&
                                    model.amountFieldController.text
                                        .isNotEmpty &&
                                    int.tryParse(model
                                                ?.amountFieldController?.text ??
                                            '0') >=
                                        0)
                                  AutosavePerks(
                                    svg: Assets.tokens,
                                    text:
                                        "${int.tryParse(model?.amountFieldController?.text)} Fello Tokens",
                                  )
                              ]),
                        )
                      ]),
                ),
              SizedBox(height: SizeConfig.padding16),
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
                          style: TextStyles.body2.bold.colour(Colors.white),
                        ),
                  onPressed: () {
                    model.setSubscriptionAmount(int.tryParse(
                            model.amountFieldController.text.isEmpty ||
                                    model.amountFieldController == null
                                ? '0'
                                : model.amountFieldController.text)
                        .toDouble());
                  },
                ),
              ),
              SizedBox(
                height: SizeConfig.viewInsets.bottom != 0
                    ? 0
                    : SizeConfig.pageHorizontalMargins,
              ),
            ],
          ),
        ),
      ),
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
        Haptic.vibrate();
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
                  color:
                      int.tryParse(model.amountFieldController.text) == amount
                          ? UiConstants.primaryColor
                          : UiConstants.primaryLight.withOpacity(0.5),
                  width: 1),
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
  final UserAutoSaveDetailsViewModel model;
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
                          gradient: AutosaveServices.getGradient(
                              model.activeSubscription),
                          color: UiConstants.autosaveColor,
                          child: Container(
                            width: SizeConfig.screenWidth,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(SizeConfig.padding8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      model.activeSubscription.status ==
                                              Constants.SUBSCRIPTION_ACTIVE
                                          ? "Autosave Active"
                                          : "Autosave Paused",
                                      style:
                                          TextStyles.body1.colour(Colors.white),
                                    ),
                                    if (model.activeSubscription.status ==
                                        Constants.SUBSCRIPTION_ACTIVE)
                                      Container(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                width: SizeConfig.padding4),
                                            Icon(
                                              Icons.verified_rounded,
                                              color: UiConstants.primaryColor,
                                              size: SizeConfig.iconSize2,
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "₹${model.activeSubscription.autoAmount.toInt() ?? 0.0}",
                                        style: GoogleFonts.sourceSansPro(
                                            fontSize: SizeConfig.title1,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 2,
                                            color: Colors.white)),
                                    Text(
                                      getFreq(model
                                          .activeSubscription.autoFrequency),
                                      style: GoogleFonts.sourceSansPro(
                                          fontSize: SizeConfig.title5,
                                          fontWeight: FontWeight.w300,
                                          height: 1.6,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
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
                                                      AutoSaveDetailsViewPageConfig);
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
                                    ? NoTransactionsContent(
                                        width: SizeConfig.screenWidth * 0.4,
                                      )
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
                                        page:
                                            AutosaveTransactionsViewPageConfig,
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
                      text: "No Autosave Details available",
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
                        "Update Autosave",
                        style: TextStyles.body2.bold.colour(Colors.white),
                      ),
                      onPressed: () {
                        model.isInEditMode = true;
                      },
                    ),
                  ),
                  model.isResumingInProgress
                      ? Container(
                          height: SizeConfig.padding40,
                          child: SpinKitThreeBounce(
                            size: SizeConfig.padding24,
                            color: UiConstants.tertiarySolid,
                          ),
                        )
                      : TextButton(
                          onPressed: () => model.pauseResume(model),
                          child: Text(
                            model.activeSubscription.status ==
                                    Constants.SUBSCRIPTION_INACTIVE
                                ? "RESUME AUTOSAVE"
                                : "PAUSE AUTOSAVE",
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
          )
      ],
    );
  }
}

class PauseAutoSaveModal extends StatefulWidget {
  final UserAutoSaveDetailsViewModel model;

  const PauseAutoSaveModal({Key key, this.model}) : super(key: key);

  @override
  State<PauseAutoSaveModal> createState() => _PauseAutoSaveModalState();
}

class _PauseAutoSaveModalState extends State<PauseAutoSaveModal> {
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
                "Pause AutoSave",
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
                    subtitle: "Your want to pause Autosave forever",
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
