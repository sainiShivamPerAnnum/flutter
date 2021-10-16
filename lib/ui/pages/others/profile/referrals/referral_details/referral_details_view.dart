import 'dart:io';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReferralDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ReferralDetailsViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => Scaffold(
        body: HomeBackground(
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: "Refer and Earn",
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins * 2),
                        child: Image.asset(
                          "images/share-card.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: SizeConfig.padding32),
                      Text(
                        "Earn ₹ 25 and 10 tickets for every referral and referrer of the month will get a brand new iphone 13",
                        textAlign: TextAlign.center,
                        style: TextStyles.body2,
                      ),
                      SizedBox(height: SizeConfig.padding24),
                      TextFormField(
                        initialValue: "https://fello.in/app/er4843",
                        style: TextStyles.body3.colour(Colors.grey),
                      ),
                      SizedBox(height: SizeConfig.padding24),
                      Row(
                        children: [
                          if (Platform.isAndroid)
                            Expanded(
                              child: Center(
                                child: FelloButton(
                                  onPressedAsync: model.shareWhatsApp,
                                  offlineButtonUI: Container(
                                    width: SizeConfig.screenWidth * 0.422,
                                    height: SizeConfig.screenWidth * 0.144,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "images/svgs/whatsapp.svg",
                                          width: SizeConfig.padding20,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: SizeConfig.padding16),
                                        Text(
                                          "Whatsapp",
                                          style: TextStyles.body2
                                              .colour(Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  loadingButtonUI: Container(
                                    width: SizeConfig.screenWidth * 0.422,
                                    height: SizeConfig.screenWidth * 0.144,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12),
                                      border: Border.all(
                                        color: UiConstants.primaryColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: SpinKitThreeBounce(
                                      color: UiConstants.primaryColor,
                                      size: SizeConfig.body2,
                                    ),
                                  ),
                                  activeButtonUI: Container(
                                    width: SizeConfig.screenWidth * 0.422,
                                    height: SizeConfig.screenWidth * 0.144,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12),
                                      border: Border.all(
                                        color: UiConstants.primaryColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: model.shareWhatsappInProgress
                                        ? SpinKitThreeBounce(
                                            color: UiConstants.primaryColor,
                                            size: SizeConfig.body2,
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "images/svgs/whatsapp.svg",
                                                width: SizeConfig.padding20,
                                                color: Color(0xff25D366),
                                              ),
                                              SizedBox(
                                                  width: SizeConfig.padding16),
                                              Text(
                                                "Whatsapp",
                                                style: TextStyles.body2,
                                              )
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Center(
                              child: FelloButton(
                                onPressedAsync: model.shareLink,
                                activeButtonUI: Container(
                                  width: Platform.isAndroid
                                      ? SizeConfig.screenWidth * 0.422
                                      : SizeConfig.screenWidth,
                                  height: SizeConfig.screenWidth * 0.144,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness12),
                                    color: UiConstants.primaryColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "images/svgs/plane.svg",
                                        color: Colors.white,
                                        width: SizeConfig.padding20,
                                      ),
                                      SizedBox(width: SizeConfig.padding16),
                                      Text(
                                        "Share Link",
                                        style: TextStyles.body2
                                            .colour(Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                offlineButtonUI: Container(
                                  width: Platform.isAndroid
                                      ? SizeConfig.screenWidth * 0.422
                                      : SizeConfig.screenWidth,
                                  height: SizeConfig.screenWidth * 0.144,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness12),
                                    color: Colors.grey,
                                  ),
                                  child: model.shareLinkInProgress
                                      ? SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: SizeConfig.body2,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "images/svgs/plane.svg",
                                              color: Colors.white,
                                              width: SizeConfig.padding20,
                                            ),
                                            SizedBox(
                                                width: SizeConfig.padding16),
                                            Text(
                                              "Share Link",
                                              style: TextStyles.body2
                                                  .colour(Colors.white),
                                            )
                                          ],
                                        ),
                                ),
                                loadingButtonUI: Container(
                                  width: Platform.isAndroid
                                      ? SizeConfig.screenWidth * 0.422
                                      : SizeConfig.screenWidth,
                                  height: SizeConfig.screenWidth * 0.144,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness12),
                                    color: UiConstants.primaryColor,
                                  ),
                                  child: SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: SizeConfig.body2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding40),
                      Text(
                        "How it works?",
                        style: TextStyles.title4.bold,
                      ),
                      InfoTile(
                        title:
                            "Your friend installs and signs up through your link",
                      ),
                      InfoTile(
                        title:
                            "Your friend makes a first saving of ₹ 25 on the app",
                      ),
                      InfoTile(
                        title:
                            "You and your friend gets ₹ 25 and 10 tickets in your account",
                      ),
                      SizedBox(height: SizeConfig.padding20),
                      FelloButtonLg(
                        child: Text(
                          "See Referral",
                          style: TextStyles.body2.colour(Colors.white),
                        ),
                        onPressed: () {
                          AppState.delegate.appState.currentAction = PageAction(
                              state: PageState.addPage,
                              page: ReferralHistoryPageConfig);
                        },
                      ),
                      SizedBox(height: SizeConfig.padding32),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String leadingAsset;
  final IconData leadingIcon;
  final String title;

  InfoTile({
    this.leadingIcon,
    this.leadingAsset,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: UiConstants.tertiarySolid.withOpacity(0.1),
            radius: SizeConfig.screenWidth * 0.067,
            child: leadingIcon != null
                ? Icon(
                    leadingIcon,
                    size: SizeConfig.padding32,
                    color: UiConstants.tertiarySolid,
                  )
                : SvgPicture.asset(
                    leadingAsset ?? "assets/vectors/icons/tickets.svg",
                    height: SizeConfig.padding32,
                    width: SizeConfig.padding32,
                    color: UiConstants.tertiarySolid,
                  ),
          ),
          SizedBox(
            width: SizeConfig.padding12,
          ),
          Expanded(
            child: Text(
              title ?? "title",
              style: TextStyles.body3,
            ),
          ),
        ],
      ),
    );
  }
}
