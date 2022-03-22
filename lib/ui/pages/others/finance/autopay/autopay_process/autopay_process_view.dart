import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AutoPayProcessView extends StatefulWidget {
  const AutoPayProcessView({Key key}) : super(key: key);

  @override
  State<AutoPayProcessView> createState() => _AutoPayProcessViewState();
}

class _AutoPayProcessViewState extends State<AutoPayProcessView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<AutoPayProcessViewModel>(onModelReady: (model) {
      model.init();
    }, builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          child: Stack(
            children: [
              Column(
                children: [
                  FelloAppBar(
                    leading: model.isSubscriptionInProgress
                        ? SizedBox()
                        : FelloAppBarBackButton(),
                    title: "Set up UPI AutoPay",
                  ),
                  Expanded(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.padding40),
                          topRight: Radius.circular(SizeConfig.padding40),
                        ),
                        color: Colors.white,
                      ),
                      child: PageView(controller: model.pageController,
                          // physics: NeverScrollableScrollPhysics(),
                          children: [
                            addUpiIdUI(model),
                            pendingUI(model),
                            completedUI(model),
                            cancelledUI(model),
                            amountSetUI(model),
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  pendingUI(AutoPayProcessViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.1),
        Text(
          "STEP 2/3",
          style: TextStyles.body2.colour(Colors.black26).letterSpace(3),
        ),
        Spacer(),
        Lottie.asset(
          "assets/lotties/pending.json",
          height: SizeConfig.screenWidth / 2,
        ),
        Text(
          "Processing, please wait",
          style: TextStyles.title3.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding8),
        Text(
          "Open your UPI app and check and approve the subscription mandate",
          style: TextStyles.body2,
          textAlign: TextAlign.center,
        ),
        Spacer(
          flex: 2,
        )
      ],
    );
  }

  completedUI(AutoPayProcessViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Lottie.asset(
          "assets/lotties/complete.json",
          height: SizeConfig.screenWidth / 2,
        ),
        Text(
          "Yayy!",
          style: TextStyles.title3.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding8),
        Text(
          "Your UPI AutoPay Setup was successful!",
          style: TextStyles.body2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding24),
        Spacer(),
      ],
    );
  }

  cancelledUI(AutoPayProcessViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Lottie.asset(
          "assets/lotties/cancel.json",
          repeat: false,
          height: SizeConfig.screenWidth / 3,
        ),
        Text(
          "Oh no!",
          style: TextStyles.title3.bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding8),
        Text(
          "Your UPI AutoPay Setup was not successful!",
          style: TextStyles.body2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding24),
        Spacer(),
        SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.viewInsets.bottom != 0
                  ? 0
                  : SizeConfig.pageHorizontalMargins,
            ),
            child: FelloButtonLg(
              child: Text(
                "Try Again",
                style: TextStyles.body2.bold.colour(Colors.white),
              ),
              onPressed: () {
                model.tryAgain();
              },
            ),
          ),
        ),
      ],
    );
  }

  addUpiIdUI(AutoPayProcessViewModel model) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.1),
        Text(
          "STEP 1/3",
          style: TextStyles.body2.colour(Colors.black26).letterSpace(3),
        ),
        SizedBox(height: SizeConfig.padding24),
        Image.asset("assets/images/upisetup.png",
            height: SizeConfig.screenHeight * 0.16),
        SizedBox(height: SizeConfig.padding24),
        Row(
          children: [
            TextFieldLabel("Enter your UPI Id"),
          ],
        ),
        TextField(
          enabled: !model.isSubscriptionInProgress,
          controller: model.vpaController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Enter your upi address"),
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        Container(
          width: SizeConfig.screenWidth,
          child: Wrap(
            runSpacing: SizeConfig.padding8,
            spacing: SizeConfig.padding12,
            children: [
              upichips('@paytm', model),
              upichips('@upi', model),
              upichips('@apl', model),
              upichips('@fbl', model),
              upichips('@ybl', model),
              upichips('@okhdfcbank', model),
              upichips('@okaksis', model),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding24,
        ),
        FelloButtonLg(
          child: model.isSubscriptionInProgress
              ? SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20,
                )
              : Text(
                  "SUBSCRIBE",
                  style: TextStyles.body2.colour(Colors.white).bold,
                ),
          onPressed: () async {
            model.initiateCustomSubscription();
            FocusScope.of(context).unfocus();
          },
        ),
        Spacer(),
        Text(
          "Banks that supports UPI Autopay",
          style: TextStyles.body3.colour(Colors.grey),
        ),
        SizedBox(height: SizeConfig.padding16),
        Image.asset(
          "assets/images/autopaybanks.png",
          width: SizeConfig.screenWidth * 0.7,
        ),
        SizedBox(height: SizeConfig.padding12),
        RichText(
          text: new TextSpan(
            children: [
              new TextSpan(
                text: 'and ',
                style: TextStyles.body3.colour(Colors.black45),
              ),
              new TextSpan(
                text: '59 more...',
                style: TextStyles.body3.colour(UiConstants.primaryColor).bold,
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    Haptic.vibrate();
                    BaseUtil.launchUrl(
                        'https://www.npci.org.in/what-we-do/autopay/list-of-banks-and-apps-live-on-autopay');
                  },
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }

  amountSetUI(AutoPayProcessViewModel model) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.1),
        Text(
          "STEP 3/3",
          style: TextStyles.body2.colour(Colors.black26).letterSpace(3),
        ),
        SizedBox(height: SizeConfig.padding24),
        SvgPicture.asset("assets/vectors/addmoney.svg",
            height: SizeConfig.screenHeight * 0.16),
        SizedBox(height: SizeConfig.padding24),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Text(
            "How much would you like to save each day ?",
            style: TextStyles.title5.bold,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: SizeConfig.padding32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₹${model.sliderValue.toInt()}",
              style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.screenWidth / 4.8,
                  color: Colors.black),
            ),
            Text(
              '/day',
              style: TextStyles.title2
                  .colour(Colors.black38)
                  .light
                  .setHeight(5)
                  .setHeight(4),
            )
          ],
        ),
        Text(
          "You'll be saving ₹${model.saveAmount.toInt().toString().replaceAllMapped(model.reg, model.mathFunc)} every year",
          style: TextStyles.body2.bold.colour(Colors.black45),
        ),
        SizedBox(height: SizeConfig.padding16),
        Slider(
          value: model.sliderValue,
          onChanged: (val) {
            model.updateSliderValue(val);
          },
          inactiveColor: UiConstants.scaffoldColor,
          thumbColor: UiConstants.primaryColor,
          activeColor: UiConstants.primaryColor.withOpacity(0.5),
          min: 10,
          max: 5000,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Row(
            children: [
              Text("₹10"),
              Spacer(),
              Text("₹5000"),
            ],
          ),
        ),
        Spacer(),
        SafeArea(
          child: Column(
            children: [
              FelloButtonLg(
                child: model.isSubscriptionAmountUpdateInProgress
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 20,
                      )
                    : Text(
                        "Finish",
                        style: TextStyles.body2.bold.colour(Colors.white),
                      ),
                onPressed: () {
                  model.setSubscriptionAmount(
                      model.sliderValue.toInt().toDouble());
                },
              ),
              SizedBox(height: SizeConfig.padding6),
              TextButton(
                onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
                child: Text(
                  "Skip",
                  style: TextStyles.body1.colour(Colors.grey).light,
                ),
              ),
              SizedBox(
                height: SizeConfig.viewInsets.bottom != 0
                    ? 0
                    : SizeConfig.pageHorizontalMargins,
              ),
            ],
          ),
        )
      ],
    );
  }

  defaultUI(AutoPayProcessViewModel model) {
    return ListLoader();
  }

  upichips(String suffix, AutoPayProcessViewModel model) {
    return InkWell(
      onTap: () {
        model.vpaController.text =
            model.vpaController.text.trim().split('@').first + suffix;
      },
      child: Chip(label: Text(suffix)),
    );
  }
}
