import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// class ReferralDetailsView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     S locale = S.of(context);
//     return BaseView<ReferralDetailsViewModel>(
//       onModelReady: (model) => model.init(),
//       builder: (ctx, model, child) => Scaffold(
//         body: HomeBackground(
//           child: Stack(
//             children: [
//               Container(
//                 height: SizeConfig.screenHeight,
//                 width: SizeConfig.screenWidth,
//                 child: Column(
//                   children: [
//                     FelloAppBar(
//                       leading: FelloAppBarBackButton(),
//                       title: locale.dReferNEarn,
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: SizeConfig.pageHorizontalMargins),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(40),
//                             topRight: Radius.circular(40),
//                           ),
//                           color: Colors.white,
//                         ),
//                         child: ListView(
//                           physics: BouncingScrollPhysics(),
//                           children: [
//                             SvgPicture.asset(
//                               Assets.rAeMain,
//                               height: SizeConfig.screenHeight * 0.15,
//                             ),
//                             SizedBox(height: SizeConfig.padding32),
//                             RichText(
//                               textAlign: TextAlign.center,
//                               text: TextSpan(
//                                   text:
//                                       "Earn upto ₹50 and 200 tokens from every Golden Ticket. The ",
//                                   style: TextStyles.body2
//                                       .colour(UiConstants.textColor),
//                                   children: [
//                                     new TextSpan(
//                                       text: 'referrer of the month*',
//                                       style: TextStyles.body3
//                                           .colour(UiConstants.primaryColor)
//                                           .bold,
//                                       recognizer: new TapGestureRecognizer()
//                                         ..onTap = () {
//                                           Haptic.vibrate();
//                                           BaseUtil.openDialog(
//                                               addToScreenStack: true,
//                                               hapticVibrate: true,
//                                               isBarrierDismissable: false,
//                                               content: MoreInfoDialog(
//                                                   title:
//                                                       "To be eligible for referrer of the month",
//                                                   imagePath: Assets.ipad,
//                                                   imageSize: Size(
//                                                     SizeConfig.padding80,
//                                                     SizeConfig.padding80,
//                                                   ),
//                                                   text:
//                                                       "In a month, user must refer at least 100 people who have saved ₹100 or above on the app."));
//                                         },
//                                     ),
//                                     TextSpan(
//                                         text: " wins a brand new iPad Air!")
//                                   ]),
//                             ),
//                             SizedBox(height: SizeConfig.padding24),
//                             model.loadingRefCode
//                                 ? SpinKitThreeBounce(
//                                     color: UiConstants.spinnerColor2,
//                                     size: 18.0,
//                                   )
//                                 : InkWell(
//                                     onTap: model.copyReferCode,
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: SizeConfig.padding24,
//                                         vertical: SizeConfig.padding8,
//                                       ),
//                                       height: SizeConfig.padding54,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(
//                                           SizeConfig.padding12,
//                                         ),
//                                         border: Border.all(
//                                           color: UiConstants.primaryColor
//                                               .withOpacity(0.5),
//                                         ),
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             child: Text(model.refCode,
//                                                 style: GoogleFonts.ubuntu(
//                                                     fontWeight: FontWeight.w800,
//                                                     fontSize: SizeConfig.title3,
//                                                     color: Colors.black54,
//                                                     letterSpacing: 5)
//                                                 // TextStyles.title3.bold
//                                                 //     .colour(Colors.black)
//                                                 //     .copyWith(letterSpacing: 5),
//                                                 ),
//                                           ),
//                                           Container(
//                                             alignment: Alignment.center,
//                                             child: Text(
//                                               "Tap to copy",
//                                               style: TextStyles.body2.bold
//                                                   .colour(
//                                                     UiConstants.tertiarySolid
//                                                         .withOpacity(0.7),
//                                                   )
//                                                   .letterSpace(2),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                             SizedBox(height: SizeConfig.padding24),
//                             if (!model.loadingRefCode)
//                               Row(
//                                 children: [
//                                   if (Platform.isAndroid)
//                                     Expanded(
//                                       child: Center(
//                                         child: FelloButton(
//                                           onPressedAsync: model.shareWhatsApp,
//                                           offlineButtonUI: Container(
//                                             width:
//                                                 SizeConfig.screenWidth * 0.422,
//                                             height:
//                                                 SizeConfig.screenWidth * 0.144,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       SizeConfig.roundness12),
//                                               border: Border.all(
//                                                 color: Colors.grey,
//                                                 width: 1,
//                                               ),
//                                             ),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 SvgPicture.asset(
//                                                   Assets.whatsapp,
//                                                   width: SizeConfig.padding20,
//                                                   color: Colors.grey,
//                                                 ),
//                                                 SizedBox(
//                                                     width:
//                                                         SizeConfig.padding16),
//                                                 Text(
//                                                   locale.refWhatsapp,
//                                                   style: TextStyles.body2
//                                                       .colour(Colors.grey),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           loadingButtonUI: Container(
//                                             width:
//                                                 SizeConfig.screenWidth * 0.422,
//                                             height:
//                                                 SizeConfig.screenWidth * 0.144,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       SizeConfig.roundness12),
//                                               border: Border.all(
//                                                 color: UiConstants.primaryColor,
//                                                 width: 1,
//                                               ),
//                                             ),
//                                             child: SpinKitThreeBounce(
//                                               color: UiConstants.primaryColor,
//                                               size: SizeConfig.body2,
//                                             ),
//                                           ),
//                                           activeButtonUI: Container(
//                                             width:
//                                                 SizeConfig.screenWidth * 0.422,
//                                             height:
//                                                 SizeConfig.screenWidth * 0.144,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       SizeConfig.roundness12),
//                                               border: Border.all(
//                                                 color: UiConstants.primaryColor,
//                                                 width: 1,
//                                               ),
//                                             ),
//                                             child: model.shareWhatsappInProgress
//                                                 ? SpinKitThreeBounce(
//                                                     color: UiConstants
//                                                         .primaryColor,
//                                                     size: SizeConfig.body2,
//                                                   )
//                                                 : Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       SvgPicture.asset(
//                                                         Assets.whatsapp,
//                                                         width: SizeConfig
//                                                             .padding20,
//                                                         color:
//                                                             Color(0xff25D366),
//                                                       ),
//                                                       SizedBox(
//                                                           width: SizeConfig
//                                                               .padding16),
//                                                       Text(
//                                                         locale.refWhatsapp,
//                                                         style: TextStyles.body2,
//                                                       )
//                                                     ],
//                                                   ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   Expanded(
//                                     child: Center(
//                                       child: FelloButton(
//                                         onPressedAsync: model.shareLink,
//                                         offlineButtonUI: Container(
//                                           width: Platform.isAndroid
//                                               ? SizeConfig.screenWidth * 0.422
//                                               : SizeConfig.screenWidth,
//                                           height:
//                                               SizeConfig.screenWidth * 0.144,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                                 SizeConfig.roundness12),
//                                             color: Colors.grey,
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               SvgPicture.asset(
//                                                 Assets.plane,
//                                                 color: Colors.white,
//                                                 width: SizeConfig.padding20,
//                                               ),
//                                               SizedBox(
//                                                   width: SizeConfig.padding16),
//                                               Text(
//                                                 locale.refShareLink,
//                                                 style: TextStyles.body2
//                                                     .colour(Colors.white),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         activeButtonUI: Container(
//                                           width: Platform.isAndroid
//                                               ? SizeConfig.screenWidth * 0.422
//                                               : SizeConfig.screenWidth,
//                                           height:
//                                               SizeConfig.screenWidth * 0.144,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                                 SizeConfig.roundness12),
//                                             color: UiConstants.primaryColor,
//                                           ),
//                                           child: model.shareLinkInProgress
//                                               ? SpinKitThreeBounce(
//                                                   color: Colors.white,
//                                                   size: SizeConfig.body2,
//                                                 )
//                                               : Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     SvgPicture.asset(
//                                                       Assets.plane,
//                                                       color: Colors.white,
//                                                       width:
//                                                           SizeConfig.padding20,
//                                                     ),
//                                                     SizedBox(
//                                                         width: SizeConfig
//                                                             .padding16),
//                                                     Text(
//                                                       locale.refShareLink,
//                                                       style: TextStyles.body2
//                                                           .colour(Colors.white),
//                                                     )
//                                                   ],
//                                                 ),
//                                         ),
//                                         loadingButtonUI: Container(
//                                           width: Platform.isAndroid
//                                               ? SizeConfig.screenWidth * 0.422
//                                               : SizeConfig.screenWidth,
//                                           height:
//                                               SizeConfig.screenWidth * 0.144,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                                 SizeConfig.roundness12),
//                                             color: UiConstants.primaryColor,
//                                           ),
//                                           child: SpinKitThreeBounce(
//                                             color: Colors.white,
//                                             size: SizeConfig.body2,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             SizedBox(height: SizeConfig.padding32),
//                             Text(
//                               locale.refHIW,
//                               style: TextStyles.title4.bold,
//                             ),
//                             InfoTile(
//                               title: locale.refstep1,
//                               leadingAsset: Assets.paperClip,
//                             ),
//                             InfoTile(
//                               title:
//                                   "Once your friend completes their KYC verification, you receive a new Golden Ticket.",
//                               leadingAsset: Assets.wmtsaveMoney,
//                             ),
//                             InfoTile(
//                               title:
//                                   "Once your friend makes their first investment of ₹${model.unlockReferralBonus}, you receive a new Golden Ticket.",
//                               leadingAsset: Assets.tickets,
//                             ),
//                             SizedBox(height: SizeConfig.padding8),
//                             InfoTile(
//                               title:
//                                   "Once your friend plays Cricket or Pool Club more than 10 times, you receive a new Golden Ticket.",
//                               leadingAsset: Assets.wmtShare,
//                             ),
//                             SizedBox(height: SizeConfig.padding8),
//                             Center(
//                               child: Text(
//                                 "You can win upto ₹150 and 600 Fello tokens from each referral!",
//                                 style: TextStyles.body3.bold,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             SizedBox(height: SizeConfig.navBarHeight * 1.2),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: Container(
//                   height: SizeConfig.navBarHeight,
//                   width: SizeConfig.screenWidth,
//                   alignment: Alignment.center,
//                   child: Container(
//                     width: SizeConfig.screenWidth -
//                         SizeConfig.pageHorizontalMargins * 2,
//                     child: FelloButtonLg(
//                       child: Text(
//                         "My Referrals",
//                         style: TextStyles.body2.colour(Colors.white),
//                       ),
//                       onPressed: () {
//                         AppState.delegate.appState.currentAction = PageAction(
//                             state: PageState.addPage,
//                             page: ReferralHistoryPageConfig);
//                       },
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ReferralDetailsView extends StatelessWidget {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<ReferralDetailsViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => Scaffold(
        body: Stack(
          children: [
            NewSquareBackground(),
            SingleChildScrollView(
              controller: _controller,
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  AppBar(
                    elevation: 0.0,
                    automaticallyImplyLeading: false,
                    backgroundColor: UiConstants.kArowButtonBackgroundColor,
                    leading: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: UiConstants.kArowButtonBackgroundColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(SizeConfig.roundness12),
                        bottomRight: Radius.circular(SizeConfig.roundness12),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding54,
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: SvgPicture.asset(Assets.referAndEarn,
                                height: SizeConfig.padding90 +
                                    SizeConfig.padding20),
                          ),
                          SizedBox(
                            height: SizeConfig.padding28,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Earn upto Rs.50 and',
                                    style: TextStyles.sourceSans.body3
                                        .colour(UiConstants.kTextColor3)),
                                WidgetSpan(
                                    child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding4),
                                  height: 17,
                                  width: 17,
                                  child: SvgPicture.asset(
                                    Assets.aFelloToken,
                                  ),
                                )),
                                TextSpan(
                                    text:
                                        '200 from every Golden Ticket. Win an iPad every month.',
                                    style: TextStyles.sourceSans.body3
                                        .colour(UiConstants.kTextColor3)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.padding28,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding32,
                                    vertical: SizeConfig.padding6),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(SizeConfig.roundness8),
                                    ),
                                    border: Border.all(
                                        color: Colors.white, width: 0.6)),
                                child: Text(
                                  model.loadingRefCode ? '-' : model.refCode,
                                  style: TextStyles.title2.extraBold
                                      .colour(Colors.white),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        model.copyReferCode();
                                      },
                                      icon: Icon(
                                        Icons.copy,
                                        color: UiConstants.kTabBorderColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        model.shareLink();
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        color: UiConstants.kTabBorderColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.padding32,
                          )
                        ],
                      ),
                    ),
                  ),
                  HowToEarnComponment(
                    model: model,
                    locale: locale,
                    onStateChanged: () {
                      _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HowToEarnComponment extends StatefulWidget {
  HowToEarnComponment({
    @required this.onStateChanged,
    @required this.model,
    @required this.locale,
    Key key,
  }) : super(key: key);

  Function onStateChanged;
  ReferralDetailsViewModel model;
  var locale;

  @override
  State<HowToEarnComponment> createState() => _InfoComponentState();
}

class _InfoComponentState extends State<HowToEarnComponment> {
  bool isBoxOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.padding20,
          ),
          TextButton(
            onPressed: () {
              //Chaning the state of the box on click

              setState(() {
                isBoxOpen = !isBoxOpen;
              });

              Future.delayed(const Duration(milliseconds: 200), () {
                widget.onStateChanged();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.locale.refHIW,
                  style: TextStyles.rajdhaniSB.title5,
                ),
                SizedBox(
                  width: SizeConfig.padding24,
                ),
                Icon(
                  isBoxOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          isBoxOpen
              ? Column(
                  children: [
                    InfoTile(
                      title: widget.locale.refstep1,
                      leadingAsset: Assets.paperClip,
                    ),
                    InfoTile(
                      title:
                          "Once your friend completes their KYC verification, you receive a new Golden Ticket.",
                      leadingAsset: Assets.wmtsaveMoney,
                    ),
                    InfoTile(
                      title:
                          "Once your friend makes their first investment of ₹${widget.model.unlockReferralBonus}, you receive a new Golden Ticket.",
                      leadingAsset: Assets.tickets,
                    ),
                    SizedBox(height: SizeConfig.padding8),
                    InfoTile(
                      title:
                          "Once your friend plays Cricket or Pool Club more than 10 times, you receive a new Golden Ticket.",
                      leadingAsset: Assets.wmtShare,
                    ),
                    SizedBox(height: SizeConfig.padding8),
                    Center(
                      child: Text(
                        "You can win upto ₹150 and 600 Fello tokens from each referral!",
                        style: TextStyles.body3.bold.colour(Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String leadingAsset;
  final IconData leadingIcon;
  final String title;
  final double leadSize;

  InfoTile({this.leadingIcon, this.leadingAsset, this.title, this.leadSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: UiConstants.kTabBorderColor.withOpacity(0.1),
            radius: leadSize ?? SizeConfig.padding24,
            child: leadingIcon != null
                ? Icon(
                    leadingIcon,
                    size: SizeConfig.padding20,
                    color: UiConstants.tertiarySolid,
                  )
                : SvgPicture.asset(
                    leadingAsset ?? "assets/vectors/icons/tickets.svg",
                    height: SizeConfig.padding20,
                    width: SizeConfig.padding20,
                    color: UiConstants.kTabBorderColor,
                  ),
          ),
          SizedBox(
            width: SizeConfig.padding12,
          ),
          Expanded(
            child: Text(
              title ?? "title",
              style: TextStyles.body3.colour(UiConstants.kFAQsAnswerColor),
            ),
          ),
        ],
      ),
    );
  }
}
