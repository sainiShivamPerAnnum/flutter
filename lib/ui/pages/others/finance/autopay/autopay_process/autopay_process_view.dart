import 'dart:developer';

import 'package:app_install_date/utils.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/amount_chips.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/segmate_chip.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/sub_process_text.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutosaveProcessView extends StatefulWidget {
  final int page;

  const AutosaveProcessView({Key key, this.page = 0}) : super(key: key);

  @override
  State<AutosaveProcessView> createState() => _AutosaveProcessViewState();
}

class _AutosaveProcessViewState extends State<AutosaveProcessView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<AutosaveProcessViewModel>(
      onModelReady: (model) {
        model.init(widget.page);
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (context, model, child) {
        log(model.currentPage.toString());
        return Scaffold(
          backgroundColor: UiConstants.kBackgroundColor,
          appBar: AppBar(
            backgroundColor: UiConstants.kBackgroundColor,
            elevation: 0.0,
            // title: Text(
            //   'Setup Autopay',
            //   style: TextStyles.rajdhaniSB.title4,
            // ),
            title: model.currentPage <= 2
                ? Text(
                    "${model.currentPage + 1}/3",
                    style: TextStyles.sourceSansL.body3,
                  )
                : Container(),
            centerTitle: true,

            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: UiConstants.kTextColor,
              ),
              onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
            ),
            actions: [],
          ),
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              NewSquareBackground(),
              SafeArea(
                child: PageView(
                  controller: model.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildEnterUpi(model),
                    _buildPendingUI(model),
                    _buildAmountSetUi(model),
                    _buildCompleteUI(model),
                    Center(
                      child: Text("cancelledUI",
                          style: TextStyles.rajdhaniSB.title4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnterUpi(AutosaveProcessViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.screenWidth * 0.184,
        ),
        Text(
          "SETUP AUTO PAY",
          style: TextStyles.sourceSans.body3.setOpecity(0.5),
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        Text(
          "Enter UPI ID",
          style: TextStyles.rajdhaniSB.title4,
        ),
        SizedBox(
          height: SizeConfig.screenWidth * 0.32,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFieldLabel(
                'Enter your UPI address:',
                leftPadding: SizeConfig.padding8,
              ),
              AppTextField(
                autoFocus: widget.page == 0,
                textEditingController: model.vpaController,
                isEnabled: !model.isSubscriptionInProgress,
                validator: (val) {
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@.-]")),
                ],
                hintText: "hello@upi",
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
        Container(
          width: SizeConfig.screenWidth * 0.8,
          child: Wrap(
            runSpacing: SizeConfig.padding8,
            spacing: SizeConfig.padding6,
            alignment: WrapAlignment.center,
            children: [
              _upichips('@upi', model),
              _upichips('@apl', model),
              _upichips('@fbl', model),
              _upichips('@ybl', model),
              _upichips('@paytm', model),
              _upichips('@okhdfcbank', model),
              _upichips('@okaxis', model),
            ],
          ),
        ),
        Spacer(),
        Text(
          "Supported by 60+ banks for AutoPay",
          style: TextStyles.sourceSansL.body4,
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        Image.asset(
          "assets/images/autosavebanks.png",
          width: SizeConfig.screenWidth * 0.7,
        ),
        SizedBox(
          height: SizeConfig.padding54,
        ),
        model.isSubscriptionInProgress
            ? SubProcessText()
            : AppPositiveBtn(
                btnText: 'submit',
                onPressed: () {
                  Haptic.vibrate();
                  model.initiateCustomSubscription();
                  FocusScope.of(context).unfocus();
                  // model.pageController.jumpToPage(1);
                },
                width: SizeConfig.screenWidth * 0.8,
              ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
      ],
    );
  }

  Widget _upichips(String suffix, AutosaveProcessViewModel model) {
    return InkWell(
      onTap: () {
        Haptic.vibrate();
        model.vpaController.text =
            model.vpaController.text.trim().split('@').first + suffix;
      },
      child: Container(
        decoration: BoxDecoration(
          // color: UiConstants.primaryLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          border: Border.all(
            color: Color(0xFFFEF5DC),
            width: SizeConfig.border0,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding12,
          vertical: SizeConfig.padding8,
        ),
        margin: EdgeInsets.only(bottom: SizeConfig.padding4),
        child: Text(
          suffix,
          style: TextStyles.sourceSansL.body2,
        ),
      ),
    );
  }

  Widget _buildPendingUI(AutosaveProcessViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.screenWidth * 0.184,
        ),
        Text(
          "SETUP AUTO PAY",
          style: TextStyles.sourceSans.body3.setOpecity(0.5),
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        Text(
          "Approve Request",
          style: TextStyles.rajdhaniSB.title4,
        ),
        SizedBox(
          height: SizeConfig.screenWidth * 0.32,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFieldLabel(
                'Entered UPI Id',
                leftPadding: SizeConfig.padding8,
              ),
              AppTextField(
                autoFocus: widget.page == 1,
                textEditingController: model.vpaController,
                isEnabled: false,
                validator: (val) {
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                suffixIcon: SvgPicture.asset(
                  'assets/temp/verified.svg',
                ),
                hintText: "Enter amount",
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.screenWidth * 0.1947,
        ),
        Text(
          "Approve payment\nrequest on your UPI app",
          style: TextStyles.sourceSans.body1,
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Text(
          "Do not press back until the paymet is completed",
          style: TextStyles.sourceSansL.body4.colour(Colors.red),
        ),
        SizedBox(
          height: SizeConfig.padding24,
        ),
        // if (model.showAppLaunchButton && PlatformUtils.isAndroid)
        AppPositiveBtn(
          btnText: 'Open ${getUpiAppName(model)}',
          onPressed: () async {
            Haptic.vibrate();
            await LaunchApp.openApp(
              androidPackageName: model.androidPackageName,
              iosUrlScheme: model.iosUrlScheme,
              openStore: false,
            );
            // model.pageController.jumpToPage(2);
          },
          width: SizeConfig.screenWidth * 0.8,
        ),
        SizedBox(
          height: SizeConfig.padding24,
        ),
        // if (model.pageController != null && model.pageController.page == 1.0)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Page Expires in",
              style: TextStyles.sourceSansL.body4,
            ),
            TweenAnimationBuilder<Duration>(
              duration: Duration(minutes: 8),
              tween: Tween(begin: Duration(minutes: 8), end: Duration.zero),
              onEnd: () {
                log('Timer ended');
              },
              builder: (BuildContext context, Duration value, Widget child) {
                final minutes = value.inMinutes;
                final seconds = value.inSeconds % 60;
                return Text(
                  " ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}s",
                  style: TextStyles.sourceSans.body4,
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
      ],
    );
  }

  String getUpiAppName(AutosaveProcessViewModel model) {
    final String upi = model.vpaController.text.split('@').last;
    switch (upi) {
      case 'upi':
        return 'BHIM';
      case 'paytm':
        return "Paytm";
      case 'ybl':
        return "PhonePe";
      case 'ibl':
        return "PhonePe";
      case 'axl':
        return "PhonePe";
      case 'okhdfcbank':
        return "Google Pay";
      case 'okaksix':
        return "Google Pay";
      case 'apl':
        return "Amazon Pay";
      case 'indus':
        return "BHIM Indus Pay";
      case 'boi':
        return "BHIM BOI UPI";
      case 'cnrb':
        return "BHIM Canara";
      default:
        return "preferred UPI App";
    }
  }

  Widget _buildAmountSetUi(AutosaveProcessViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.screenWidth * 0.184,
        ),
        Text(
          "SETUP AUTO PAY",
          style: TextStyles.sourceSans.body3.setOpecity(0.5),
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        Text(
          "Enter amount",
          style: TextStyles.rajdhaniSB.title4,
        ),
        SizedBox(
          height: SizeConfig.screenWidth * 0.144,
        ),
        Container(
          decoration: BoxDecoration(
            color: UiConstants.kAutopayAmountDeactiveTabColor,
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            border: Border.all(
              color: UiConstants.kBorderColor.withOpacity(0.22),
              width: SizeConfig.border1,
            ),
          ),
          width: SizeConfig.screenWidth * 0.5133,
          height: SizeConfig.screenWidth * 0.0987,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate,
                left: model.isDaily ? 0 : SizeConfig.screenWidth * 0.248,
                child: AnimatedContainer(
                  width: SizeConfig.screenWidth * 0.26,
                  height: SizeConfig.screenWidth * 0.094,
                  decoration: BoxDecoration(
                    color: UiConstants.kAutopayAmountActiveTabColor
                        .withOpacity(0.45),
                    borderRadius: model.isDaily
                        ? BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness5),
                            bottomLeft: Radius.circular(SizeConfig.roundness5),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(SizeConfig.roundness5),
                            bottomRight: Radius.circular(SizeConfig.roundness5),
                          ),
                  ),
                  duration: Duration(milliseconds: 500),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
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
                    child: GestureDetector(
                      onTap: () {
                        Haptic.vibrate();
                        model.isDaily = false;
                        model.onAmountValueChanged(
                          model.amountFieldController.text,
                        );
                      },
                      child: SegmentChips(
                        model: model,
                        text: "Weekly",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.screenWidth * 0.0693,
        ),
        Container(
          width: SizeConfig.screenWidth * 0.784,
          decoration: BoxDecoration(
            color: UiConstants.kTextFieldColor,
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            border: Border.all(
              color: UiConstants.kTextColor.withOpacity(0.1),
              width: SizeConfig.border1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "₹",
                      style: TextStyles.rajdhaniB
                          .size(SizeConfig.screenWidth * 0.1067),
                    ),
                    SizedBox(
                      width: ((SizeConfig.screenWidth * 0.065) *
                          model.amountFieldController.text.length.toDouble()),
                      child: AppTextField(
                        textEditingController: model.amountFieldController,
                        isEnabled: true,
                        validator: (val) {
                          return null;
                        },
                        onChanged: (val) {
                          model.onAmountValueChanged(val);
                        },
                        keyboardType: TextInputType.number,
                        inputDecoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          // isCollapsed: true,
                          isDense: true,
                        ),
                        textAlign: TextAlign.center,
                        textStyle: TextStyles.rajdhaniB
                            .size(SizeConfig.screenWidth * 0.1067),
                        // height: SizeConfig.screenWidth * 0.1706,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: SizeConfig.screenWidth * 0.0666,
                right: SizeConfig.screenWidth * 0.0666,
                child: Text(
                  model.isDaily ? "Daily" : "Weekly",
                  style: TextStyles.sourceSans.body4.setOpecity(0.4),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding32,
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
                    ),
                  )
                : List.generate(
                    model.weeklyChips.length,
                    (index) => AmountChips(
                      amount: model.weeklyChips[index].value,
                      model: model,
                      isBestSeller: model.weeklyChips[index].best,
                    ),
                  ),
          ),
        ),
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/temp/star.svg",
              width: SizeConfig.iconSize3,
              height: SizeConfig.iconSize3,
            ),
            SizedBox(
              width: SizeConfig.padding4,
            ),
            Text(
              "Additional Daily Benefits",
              style: TextStyles.sourceSans.body3.setOpecity(0.6),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
        _buildBenefits(),
        SizedBox(
          height: SizeConfig.padding40,
        ),
        model.isSubscriptionAmountUpdateInProgress
            ? SpinKitThreeBounce(
                color: Colors.white,
                size: 20,
              )
            : AppPositiveBtn(
                btnText: 'Set up',
                onPressed: () async {
                  Haptic.vibrate();
                  model.setSubscriptionAmount(
                    int.tryParse(
                      model.amountFieldController == null ||
                              model.amountFieldController?.text == null ||
                              model.amountFieldController.text.isEmpty
                          ? '0'
                          : model.amountFieldController?.text,
                    ).toDouble(),
                  );
                  // model.pageController.jumpToPage(3);
                },
                width: SizeConfig.screenWidth * 0.8,
              ),
        SizedBox(
          height: SizeConfig.padding64,
        ),
      ],
    );
  }

  Widget _buildCompleteUI(AutosaveProcessViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.padding20,
        ),
        Image.asset(
          "assets/temp/congratulation_dialog_logo.png",
          width: SizeConfig.screenWidth * 0.5333,
          height: SizeConfig.screenWidth * 0.5333,
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        Text(
          "Congrats!",
          style: TextStyles.rajdhaniSB.title1,
        ),
        SizedBox(
          height: SizeConfig.padding8,
        ),
        Text(
          "Your fello Autosave account has been\nsuccessfully setup!",
          style: TextStyles.sourceSans.body2,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          width: double.infinity,
          height: 157,
          decoration: BoxDecoration(
            color: Color(0xFF57A6B0).withOpacity(0.22),
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            border: Border.all(
              color: UiConstants.kTextColor.withOpacity(0.1),
              width: SizeConfig.border1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.padding40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(
                  //   width: SizeConfig.padding40,
                  // ),
                  Container(
                    width: SizeConfig.screenWidth * 0.05866,
                    height: SizeConfig.screenWidth * 0.05866,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness24),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/temp/upi_payment_logo.png",
                        width: SizeConfig.screenWidth * 0.032,
                        height: SizeConfig.screenWidth * 0.032,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding12,
                  ),
                  Text(
                    "${model.vpaController.text}",
                    style: TextStyles.sourceSansSB.body1,
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "₹${model.amountFieldController.text}/",
                      style: TextStyles.rajdhaniB
                          .size(SizeConfig.screenWidth * 0.1067),
                    ),
                    TextSpan(
                      text: "${model.isDaily ? "Daily" : "Weekly"}",
                      style: TextStyles.sourceSansSB.body1.setOpecity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefits() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/temp/sprout.svg",
              width: SizeConfig.iconSize5,
              height: SizeConfig.iconSize5,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Text(
              "Interest\non Gold",
              style: TextStyles.sourceSans.body4
                  .colour(UiConstants.kYellowTextColor.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(
          width: SizeConfig.padding12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/temp/horizotal_outlined_ticket.svg",
              width: SizeConfig.padding24,
              height: SizeConfig.padding24,
            ),
            SizedBox(
              height: SizeConfig.padding20,
            ),
            Text(
              "1 Golden\nTicket",
              style: TextStyles.sourceSans.body4
                  .colour(UiConstants.kYellowTextColor.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(
          width: SizeConfig.padding12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/temp/outline_token.svg",
              width: SizeConfig.padding24,
              height: SizeConfig.padding24,
            ),
            SizedBox(
              height: SizeConfig.padding20,
            ),
            Text(
              "50 Fello\nTokens",
              style: TextStyles.sourceSans.body4
                  .colour(UiConstants.kYellowTextColor.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
