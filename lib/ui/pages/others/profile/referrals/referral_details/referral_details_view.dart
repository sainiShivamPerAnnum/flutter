import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReferralDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<ReferralDetailsViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => Scaffold(
        body: HomeBackground(
          child: Stack(
            children: [
              Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    FelloAppBar(
                      leading: FelloAppBarBackButton(),
                      title: locale.dReferNEarn,
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
                          physics: BouncingScrollPhysics(),
                          children: [
                            SvgPicture.asset(
                              Assets.rAeMain,
                              height: SizeConfig.screenHeight * 0.2,
                            ),
                            SizedBox(height: SizeConfig.padding32),
                            Text(
                              "Earn ₹${model.referral_bonus} and ${model.referral_flc_bonus} Fello tokens for every referral. The referrer of the month wins a brand new iPhone 13!",
                              textAlign: TextAlign.center,
                              style: TextStyles.body2,
                            ),
                            SizedBox(height: SizeConfig.padding24),
                            // model.loadingUrl
                            //     ? SpinKitThreeBounce(
                            //         color: UiConstants.spinnerColor2,
                            //         size: 18.0,
                            //       )
                            //     : TextFormField(
                            //         initialValue: model.getuserUrlPrefix(),
                            //         style: TextStyles.body3.colour(Colors.grey),
                            //       ),
                            model.loadingUrl
                                ? SpinKitThreeBounce(
                                    color: UiConstants.spinnerColor2,
                                    size: 18.0,
                                  )
                                : Container(
                                    width: SizeConfig.navBarWidth,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: UiConstants.primaryColor
                                            .withOpacity(0.5),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          model.userUrlPrefix,
                                          style: TextStyles.body3,
                                        ),
                                        InkWell(
                                          onTap: () => model.copyReferCode,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.padding8,
                                              vertical: SizeConfig.padding8,
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color:
                                                    UiConstants.tertiarySolid),
                                            child: Text(
                                              model.userUrlCode,
                                              style: TextStyles.body2.bold
                                                  .colour(Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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
                                          height:
                                              SizeConfig.screenWidth * 0.144,
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
                                                Assets.whatsapp,
                                                width: SizeConfig.padding20,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                  width: SizeConfig.padding16),
                                              Text(
                                                locale.refWhatsapp,
                                                style: TextStyles.body2
                                                    .colour(Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                        loadingButtonUI: Container(
                                          width: SizeConfig.screenWidth * 0.422,
                                          height:
                                              SizeConfig.screenWidth * 0.144,
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
                                          height:
                                              SizeConfig.screenWidth * 0.144,
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
                                                  color:
                                                      UiConstants.primaryColor,
                                                  size: SizeConfig.body2,
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      Assets.whatsapp,
                                                      width:
                                                          SizeConfig.padding20,
                                                      color: Color(0xff25D366),
                                                    ),
                                                    SizedBox(
                                                        width: SizeConfig
                                                            .padding16),
                                                    Text(
                                                      locale.refWhatsapp,
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              Assets.plane,
                                              color: Colors.white,
                                              width: SizeConfig.padding20,
                                            ),
                                            SizedBox(
                                                width: SizeConfig.padding16),
                                            Text(
                                              locale.refShareLink,
                                              style: TextStyles.body2
                                                  .colour(Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
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
                                                    Assets.plane,
                                                    color: Colors.white,
                                                    width: SizeConfig.padding20,
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          SizeConfig.padding16),
                                                  Text(
                                                    locale.refShareLink,
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
                              locale.refHIW,
                              style: TextStyles.title4.bold,
                            ),
                            InfoTile(
                              title: locale.refstep1,
                              leadingAsset: Assets.paperClip,
                            ),
                            InfoTile(
                              title: "Your friend makes their first saving of ₹ ${model.unlock_referral_bonus} on the app.",
                              leadingAsset: Assets.wmtsaveMoney,
                            ),
                            InfoTile(
                              title:
                                  "You and your friend get ₹${model.referral_bonus} and ${model.referral_flc_bonus} Fello tokens in your account",
                              leadingAsset: Assets.tickets,
                            ),
                            SizedBox(height: SizeConfig.navBarHeight),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: SizeConfig.navBarHeight,
                  width: SizeConfig.screenWidth,
                  alignment: Alignment.center,
                  child: Container(
                    width: SizeConfig.screenWidth -
                        SizeConfig.pageHorizontalMargins * 2,
                    child: FelloButtonLg(
                      child: Text(
                        "My Referrals",
                        style: TextStyles.body2.colour(Colors.white),
                      ),
                      onPressed: () {
                        AppState.delegate.appState.currentAction = PageAction(
                            state: PageState.addPage,
                            page: ReferralHistoryPageConfig);
                      },
                    ),
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
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding6),
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
