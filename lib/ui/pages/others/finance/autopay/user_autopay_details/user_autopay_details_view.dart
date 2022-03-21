import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/user_autopay_details/user_autopay_details_vm.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transactions_history_view.dart';
import 'package:felloapp/ui/pages/static/blinker.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
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
                            : (model.activeSubscription != null
                                ? ListView(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            SizeConfig.pageHorizontalMargins),
                                    children: [
                                      TextFieldLabel("Subscription Id"),
                                      TextFormField(
                                        enabled: false,
                                        controller: model.subIdController,
                                      ),
                                      TextFieldLabel("Primary UPI"),
                                      TextFormField(
                                        enabled: false,
                                        controller: model.pUpiController,
                                        decoration: InputDecoration(
                                          suffixIcon: model.isVerified
                                              ? Icon(
                                                  Icons.verified,
                                                  color:
                                                      UiConstants.primaryColor,
                                                )
                                              : SizedBox(),
                                        ),
                                      ),
                                      TextFieldLabel("Subscribed Amount"),
                                      InkWell(
                                        onTap: () {
                                          BaseUtil.openDialog(
                                              addToScreenStack: true,
                                              isBarrierDismissable: false,
                                              hapticVibrate: true,
                                              content:
                                                  AutoPayAmountUpdateDialog());
                                        },
                                        child: TextFormField(
                                          controller: model.subAmountController,
                                          //maxLength: 10,
                                          enabled: false,
                                          decoration: InputDecoration(
                                            prefix: Text(
                                              "₹ ",
                                              style: TextStyles.body3.bold,
                                            ),
                                            suffix: Text(
                                              "CHANGE",
                                              style: TextStyles.body3.bold
                                                  .colour(
                                                      UiConstants.primaryColor)
                                                  .letterSpace(2),
                                            ),
                                          ),
                                          textCapitalization:
                                              TextCapitalization.characters,
                                        ),
                                      ),
                                      TextFieldLabel("Subscription Status"),
                                      TextFormField(
                                        controller: model.subStatusController,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          prefix: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Blinker(
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    UiConstants.primaryColor,
                                                radius: 5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : NoRecordDisplayWidget(
                                    text:
                                        "No Subscription Details at the moment.. Setup Autopay now->",
                                  )),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: SizeConfig.navBarHeight * 2,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                  ),
                ),
                if (model.state == ViewState.Idle &&
                    model.activeSubscription != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: Platform.isIOS
                                ? SizeConfig.padding8
                                : SizeConfig.pageHorizontalMargins / 2,
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FelloButtonLg(
                              child: Text(
                                "Pause AutoPay",
                                style:
                                    TextStyles.body2.bold.colour(Colors.white),
                              ),
                              onPressed: () {
                                BaseUtil.openModalBottomSheet(
                                  addToScreenStack: true,
                                  hapticVibrate: true,
                                  backgroundColor: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(SizeConfig.roundness32),
                                    topRight:
                                        Radius.circular(SizeConfig.roundness32),
                                  ),
                                  isBarrierDismissable: false,
                                  content: PauseAutoPayModal(),
                                );
                              },
                            ),
                            SizedBox(height: SizeConfig.padding8),
                            // TextButton(
                            //   onPressed: () {
                            //     BaseUtil.openDialog(
                            //       addToScreenStack: true,
                            //       hapticVibrate: true,
                            //       isBarrierDismissable: false,
                            //       content: FelloConfirmationDialog(
                            //         asset: Assets.signout,
                            //         title: 'Are you sure ?',
                            //         subtitle:
                            //             "You are making great profits. Try pausing it for some days instead.",
                            //         accept: "Cancle Subscription",
                            //         result: (res) {
                            //           Future.delayed(Duration(seconds: 3), () {
                            //             AppState.backButtonDispatcher
                            //                 .didPopRoute();
                            //             BaseUtil.showPositiveAlert(
                            //                 "Subscription cancelled successfully",
                            //                 "Hope you setup autopay again soon");
                            //           });
                            //         },
                            //         onAccept: () {},
                            //         onReject: () {
                            //           AppState.backButtonDispatcher
                            //               .didPopRoute();
                            //         },
                            //         reject: "Keep Investing",
                            //         rejectColor: Colors.grey.withOpacity(0.5),
                            //       ),
                            //     );
                            //   },
                            //   child: Text(
                            //     "CANCEL SUBSCRIPTION",
                            //     style: TextStyles.body2
                            //         .colour(Colors.red)
                            //         .light
                            //         .letterSpace(2),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        //shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
            text: "Today",
            radioValue: 1,
          ),
          pauseOptionTile(
            text: "2 Days",
            radioValue: 2,
          ),
          pauseOptionTile(
            text: "5 Days",
            radioValue: 3,
          ),
          SizedBox(height: SizeConfig.padding16),
          FelloButtonLg(
            child: Text(
              "PAUSE",
              style: TextStyles.body2.bold.colour(Colors.white),
            ),
            onPressed: () {
              AppState.backButtonDispatcher.didPopRoute();
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

class AutoPayAmountUpdateDialog extends StatefulWidget {
  @override
  State<AutoPayAmountUpdateDialog> createState() =>
      _AutoPayAmountUpdateDialogState();
}

class _AutoPayAmountUpdateDialogState extends State<AutoPayAmountUpdateDialog> {
  double sliderValue = 2000;
  updateSliderValue(value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FelloConfirmationDialog(
      content: Column(
        children: [
          SizedBox(height: SizeConfig.padding24),
          SvgPicture.asset("assets/vectors/addmoney.svg",
              height: SizeConfig.screenHeight * 0.16),
          SizedBox(height: SizeConfig.padding24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₹${sliderValue.toInt()}",
                style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.screenWidth * 0.16,
                    color: Colors.black),
              ),
              Text(
                '/day',
                style: TextStyles.title2
                    .colour(Colors.black38)
                    .light
                    .setHeight(2.4),
              )
            ],
          ),
          Slider(
            value: sliderValue,
            onChanged: (val) {
              setState(() {
                sliderValue = val;
              });
            },
            min: 10,
            max: 5000,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
            child: Row(
              children: [
                Text("₹10"),
                Spacer(),
                Text("₹5000"),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding40),
        ],
      ),
      accept: "Update",
      result: (res) {
        Future.delayed(Duration(seconds: 3), () {
          AppState.backButtonDispatcher.didPopRoute();
          BaseUtil.showPositiveAlert(
              "Amount Update successfully", "Effective from next payment");
        });
      },
      onReject: () {
        AppState.backButtonDispatcher.didPopRoute();
      },
      reject: "Cancel",
      rejectColor: UiConstants.tertiarySolid,
    );
  }
}
