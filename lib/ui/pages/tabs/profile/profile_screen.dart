import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/Texts/marquee_text.dart';
import 'package:felloapp/ui/elements/custom-art/profile-card.dart';
import 'package:felloapp/ui/modals/share_info_modal.dart';
import 'package:felloapp/ui/widgets/network_bar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  BaseUtil baseProvider;
  DBModel dbProvider;
  HttpModel httpProvider;
  AppState appState;
  bool isPanFieldHidden = true;

  @override
  void initState() {
    super.initState();
    BaseAnalytics.analytics
        .setCurrentScreen(screenName: BaseAnalytics.PAGE_PROFILE);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    httpProvider = Provider.of<HttpModel>(context, listen: false);

    if (!baseProvider.userReferralInfoFetched)
      dbProvider.getUserReferralInfo(baseProvider.myUser.uid).then((value) {
        baseProvider.userReferralInfoFetched = true;
        if (value != null) baseProvider.myReferralInfo = value;

        if (baseProvider.myReferralInfo != null &&
            baseProvider.myReferralInfo.refCount != null &&
            baseProvider.myReferralInfo.refCount > 0) setState(() {});
      });
    // if (!baseProvider.referralsFetched) {
    //   dbProvider.getUserReferrals(baseProvider.myUser.uid).then((refList) {
    //     baseProvider.referralsFetched = true;
    //     baseProvider.userReferralsList = refList;
    //     if (baseProvider.userReferralsList != null &&
    //         baseProvider.userReferralsList.length > 0) setState(() {});
    //   });
    // }
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.backgroundColor,
        borderRadius: SizeConfig.homeViewBorder,
      ),
      child: ClipRRect(
        borderRadius: SizeConfig.homeViewBorder,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: kToolbarHeight,
            ),
            Consumer<BaseUtil>(
              builder: (ctx, bp, child) {
                return UserProfileCard();
              },
            ),
            Consumer<BaseUtil>(
              builder: (ctx, bp, child) {
                return const ShowEmailVerifyLink();
              },
            ),
            SizedBox(height: 16),
            Container(
              child: Column(
                children: [
                  Consumer<BaseUtil>(
                    builder: (ctx, bp, child) {
                      return baseProvider.myUser.username == null
                          ? Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.globalMargin * 1.4),
                                  leading: Icon(
                                    Icons.account_circle_outlined,
                                    size: SizeConfig.blockSizeHorizontal * 6,
                                    color: UiConstants.primaryColor,
                                  ),
                                  title: Text(
                                    "Username",
                                    style: GoogleFonts.montserrat(
                                      fontSize: SizeConfig.mediumTextSize,
                                    ),
                                  ),
                                  onTap: () {
                                    if (baseProvider.myUser.username == null)
                                      appState.currentAction = PageAction(
                                          state: PageState.addPage,
                                          page: ClaimUsernamePageConfig);
                                  },
                                  trailing: Wrap(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: UiConstants.primaryColor),
                                        onPressed: () {
                                          if (baseProvider.myUser.username ==
                                              null)
                                            appState.currentAction = PageAction(
                                                state: PageState.addPage,
                                                page: ClaimUsernamePageConfig);
                                        },
                                        child: Text(
                                          "Claim",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider()
                              ],
                            )
                          : SizedBox();
                    },
                  ),
                  ProfileTabTile(
                    leadIcon: "images/contact-book.png",
                    onPress: () => appState.currentAction = PageAction(
                        state: PageState.addPage,
                        page: UserProfileDetailsConfig),
                    title: "Account",
                    trailWidget: Icon(
                      Icons.arrow_forward_ios,
                      color: UiConstants.primaryColor,
                      size: SizeConfig.blockSizeHorizontal * 4,
                    ),
                  ),
                  ProfileTabTile(
                    leadIcon: "images/transaction.png",
                    title: "Transactions",
                    trailWidget: Text(
                      "See All",
                      style: GoogleFonts.montserrat(
                        color: UiConstants.primaryColor,
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                    onPress: () async {
                      if (await baseProvider.showNoInternetAlert(context))
                        return;
                      appState.currentAction = PageAction(
                          state: PageState.addPage,
                          page: TransactionPageConfig);
                    },
                  ),
                  ProfileTabTile(
                    leadIcon: "images/referrals.png",
                    title: "Referrals",
                    trailWidget: Text(
                      _myReferralCount.toString(),
                      style: GoogleFonts.montserrat(
                        color: UiConstants.primaryColor,
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                    onPress: () => _myReferralCount > 0
                        ? appState.currentAction = PageAction(
                            state: PageState.addPage, page: ReferralPageConfig)
                        : () {},
                  ),
                ],
              ),
            ),
            const ShareCard(),
            const Social(),
            const AppVersionRow(),
            const TermsRow(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  int get _myReferralCount {
    if (baseProvider == null ||
        baseProvider.myReferralInfo == null ||
        baseProvider.myReferralInfo.refCount == null) return 0;
    return baseProvider.myReferralInfo.refCount;
  }
}

class ShowEmailVerifyLink extends StatelessWidget {
  const ShowEmailVerifyLink({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseUtil baseProvider = Provider.of<BaseUtil>(context);
    return baseProvider.myUser.isEmailVerified == null ||
            baseProvider.myUser.isEmailVerified == false
        ? InkWell(
            onTap: () {
              AppState.delegate.appState.currentAction = PageAction(
                  state: PageState.addPage, page: VerifyEmailPageConfig);
            },
            child: const MarqueeText(
              infoList: [
                "Your email needs to be verified. Click here to complete this step."
              ],
              showBullet: false,
              textColor: Colors.red,
            ),
          )
        : SizedBox();
  }
}

class Social extends StatelessWidget {
  const Social();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 50),
        width: SizeConfig.screenWidth,
        child: Column(children: [
          Text(
            "Connect With Us",
            style: TextStyle(
              color: UiConstants.textColor,
              fontSize: SizeConfig.screenHeight * 0.02,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            socialButton("images/svgs/instagram.svg",
                "https://www.instagram.com/jointhefelloship/"),
            socialButton("images/svgs/linkedin.svg",
                "https://www.linkedin.com/company/fellofinance/"),
            socialButton("images/svgs/mail.svg", "mailto:hello@fello.in"),
            socialButton("images/svgs/web.svg", "https://fello.in"),
          ])
        ]));
  }

  Widget socialButton(String asset, String url) {
    return GestureDetector(
      onTap: () async => BaseUtil.launchUrl(url),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: UiConstants.primaryColor,
        ),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 6),
        child: SvgPicture.asset(
          asset,
          color: Colors.white,
          fit: BoxFit.contain,
          height: SizeConfig.blockSizeVertical * 1.5,
          width: SizeConfig.blockSizeVertical * 1.5,
        ),
      ),
    );
  }
}

class TermsRow extends StatelessWidget {
  const TermsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              'Terms of Service',
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize * 1.2,
                  color: Colors.grey,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Haptic.vibrate();
              BaseUtil.launchUrl('https://fello.in/policy/tnc');

              // AppState.delegate.appState.currentAction =
              //     PageAction(state: PageState.addPage, page: TncPageConfig);
            },
          ),
        ),
        Text(
          '•',
          style: TextStyle(color: Colors.grey),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize * 1.2,
                  color: Colors.grey,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Haptic.vibrate();
              BaseUtil.launchUrl('https://fello.in/policy/privacy');
              // AppState.delegate.appState.currentAction = PageAction(
              //     state: PageState.addPage, page: RefPolicyPageConfig);
            },
          ),
        ),
        Text(
          '•',
          style: TextStyle(color: Colors.grey),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              'Referral Policy',
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize * 1.2,
                  color: Colors.grey,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Haptic.vibrate();
              // BaseUtil.launchUrl('https://fello.in/policy/privacy');
              AppState.delegate.appState.currentAction = PageAction(
                  state: PageState.addPage, page: RefPolicyPageConfig);
            },
          ),
        )
      ],
    );
  }
}

class AppVersionRow extends StatelessWidget {
  const AppVersionRow();

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Image.asset(
          //       "images/fello-short-logo.png",
          //       color: Colors.grey,
          //       width: SizeConfig.cardTitleTextSize * 0.9,
          //       height: SizeConfig.cardTitleTextSize * 0.9,
          //     ),
          //     SizedBox(width: 4),
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "Version 1.0.2",
          //           style: TextStyle(
          //               fontSize: SizeConfig.mediumTextSize,
          //               fontWeight: FontWeight.w700,
          //               color: Colors.grey),
          //         ),
          //         SizedBox(
          //           height: 4,
          //         ),
          //         Text(
          //           "Made for India ❤",
          //           style: TextStyle(
          //             fontSize: SizeConfig.smallTextSize,
          //             color: Colors.black54,
          //           ),
          //         ),
          //       ],
          //     )
          //   ],
          // ),
          Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Image(
              image: AssetImage(Assets.logoShortform),
              fit: BoxFit.contain,
            ),
            width: 10,
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Text(
              'v${BaseUtil.packageInfo.version}(${BaseUtil.packageInfo.buildNumber})',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeConfig.mediumTextSize,
                  fontWeight: FontWeight.w300,
                  color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }
}

class ShareCard extends StatelessWidget {
  const ShareCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.globalMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
          gradient: new LinearGradient(
            colors: [
              Color(0xff4E4376),
              Color(0xff2B5876),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          boxShadow: [
            BoxShadow(
                color: Color(0xff4E4376).withOpacity(0.2),
                offset: Offset(20, 5),
                blurRadius: 20,
                spreadRadius: 10),
          ]),
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                "images/share-card.png",
                // height: SizeConfig.screenHeight * 0.5,
                // width: SizeConfig.screenWidth * 0.5,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.globalMargin,
                vertical: SizeConfig.globalMargin * 1.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Invite your friends to Fello",
                        style: TextStyle(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(5, 5),
                                color: Colors.black26,
                                blurRadius: 10,
                              )
                            ],
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.cardTitleTextSize),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isDismissible: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                            ),
                            // backgroundColor: Colors.transparent,
                            context: context,
                            builder: (ctx) {
                              AppState.screenStack.add(ScreenItem.dialog);
                              return ShareInfoModalSheet();
                            });
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                RichText(
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                        text: 'Both you and your friend receive ',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize * 1.2),
                      ),
                      new TextSpan(
                        text: '₹ 25',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize * 1.2),
                      ),
                      new TextSpan(
                        text: ' and ',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize * 1.2),
                      ),
                      new TextSpan(
                        text: '10 gaming tickets',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize * 1.2),
                      ),
                      new TextSpan(
                        text: ' for every successful referral!',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize * 1.2),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const ShareOptions(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ShareOptions extends StatefulWidget {
  const ShareOptions();

  @override
  _ShareOptionsState createState() => _ShareOptionsState();
}

class _ShareOptionsState extends State<ShareOptions> {
  Log log = new Log('ReferScreen');
  BaseUtil baseProvider;
  DBModel dbProvider;
  RazorpayModel rProvider;
  FcmListener fcmProvider;
  String referral_bonus =
      BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.REFERRAL_BONUS);
  String referral_ticket_bonus = BaseRemoteConfig.remoteConfig
      .getString(BaseRemoteConfig.REFERRAL_TICKET_BONUS);
  String _shareMsg;

  _init() {
    referral_bonus = (referral_bonus == null || referral_bonus.isEmpty)
        ? '25'
        : referral_bonus;
    referral_ticket_bonus =
        (referral_ticket_bonus == null || referral_ticket_bonus.isEmpty)
            ? '10'
            : referral_ticket_bonus;
    _shareMsg =
        'Hey I am gifting you ₹$referral_bonus and $referral_ticket_bonus free Tambola tickets. Lets start saving and playing together! ';
  }

  @override
  void dispose() {
    super.dispose();
    // if (fcmProvider != null) fcmProvider.addIncomingMessageListener(null, 2);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    rProvider = Provider.of<RazorpayModel>(context, listen: false);
    fcmProvider = Provider.of<FcmListener>(context, listen: false);
    _init();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.white,
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: InkWell(
            child: (!baseProvider.isReferralLinkBuildInProgressOther)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SHARE',
                        style: GoogleFonts.montserrat(
                          fontSize: SizeConfig.mediumTextSize * 0.9,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SvgPicture.asset(
                        "images/svgs/plane.svg",
                        color: Colors.white,
                        height: SizeConfig.blockSizeHorizontal * 4,
                      )
                    ],
                  )
                : SpinKitThreeBounce(
                    color: UiConstants.spinnerColor2,
                    size: 18.0,
                  ),
            onTap: () async {
              if (await baseProvider.showNoInternetAlert(context)) return;
              fcmProvider.addSubscription(FcmTopic.REFERRER);
              BaseAnalytics.analytics.logShare(
                  contentType: 'referral',
                  itemId: baseProvider.myUser.uid,
                  method: 'message');
              baseProvider.isReferralLinkBuildInProgressOther = true;
              _createDynamicLink(baseProvider.myUser.uid, true, 'Other')
                  .then((url) async {
                log.debug(url);
                baseProvider.isReferralLinkBuildInProgressOther = false;
                setState(() {});
                if (Platform.isIOS) {
                  Share.share(_shareMsg + url);
                } else {
                  FlutterShareMe()
                      .shareToSystem(msg: _shareMsg + url)
                      .then((flag) {
                    log.debug(flag);
                  });
                }
              });
              setState(() {});
            },
            highlightColor: Colors.orange.withOpacity(0.5),
            splashColor: Colors.orange.withOpacity(0.5),
          ),
        ),
        (Platform.isIOS)
            ? SizedBox(width: 10)
            : Text(
                "---",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
        (Platform.isIOS)
            ? Text('')
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: InkWell(
                  child: (!baseProvider.isReferralLinkBuildInProgressWhatsapp)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text(
                            //   'WHATSAPP',
                            //   style: GoogleFonts.montserrat(
                            //     fontSize: SizeConfig.mediumTextSize * 0.9,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            SvgPicture.asset(
                              "images/svgs/whatsapp.svg",
                              color: Colors.white,
                              height: SizeConfig.blockSizeHorizontal * 4,
                            )
                          ],
                        )
                      : SpinKitThreeBounce(
                          color: UiConstants.spinnerColor2,
                          size: 18.0,
                        ),
                  onTap: () async {
                    ////////////////////////////////
                    if (await baseProvider.showNoInternetAlert(context)) return;
                    fcmProvider.addSubscription(FcmTopic.REFERRER);
                    BaseAnalytics.analytics.logShare(
                        contentType: 'referral',
                        itemId: baseProvider.myUser.uid,
                        method: 'whatsapp');
                    baseProvider.isReferralLinkBuildInProgressWhatsapp = true;
                    setState(() {});
                    String url;
                    try {
                      url = await _createDynamicLink(
                          baseProvider.myUser.uid, true, 'Whatsapp');
                    } catch (e) {
                      log.error('Failed to create dynamic link');
                      log.error(e);
                    }
                    baseProvider.isReferralLinkBuildInProgressWhatsapp = false;
                    setState(() {});
                    if (url == null)
                      return;
                    else
                      log.debug(url);
                    try {
                      FlutterShareMe()
                          .shareToWhatsApp(msg: _shareMsg + url)
                          .then((flag) {
                        if (flag == "false") {
                          FlutterShareMe()
                              .shareToWhatsApp4Biz(msg: _shareMsg + url)
                              .then((flag) {
                            log.debug(flag);
                            if (flag == "false") {
                              baseProvider.showNegativeAlert(
                                  "Whatsapp not detected",
                                  "Please use other option to share.",
                                  context);
                            }
                          });
                        }
                      });
                    } catch (e) {
                      log.debug(e.toString());
                    }

                    // FlutterShareMe()
                    //     .shareToWhatsApp4Biz(msg: _shareMsg + url)
                    //     .then((value) {
                    //   log.debug(value);
                    // }).catchError((err) {
                    //   log.error('Share to whatsapp biz failed as well');
                    // });
                  },
                  highlightColor: Colors.orange.withOpacity(0.5),
                  splashColor: Colors.orange.withOpacity(0.5),
                ),
              ),
      ],
    );
  }

  Future<String> _createDynamicLink(
      String userId, bool short, String source) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://fello.in/app/referral',
      link: Uri.parse('https://fello.in/$userId'),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Download ${Constants.APP_NAME}',
          description:
              'Fello makes saving fun, and investing a lot more simple!',
          imageUrl: Uri.parse(
              'https://fello-assets.s3.ap-south-1.amazonaws.com/ic_social.png')),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'referrals',
        medium: 'social',
        source: source,
      ),
      androidParameters: AndroidParameters(
        packageName: 'in.fello.felloapp',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
          bundleId: 'in.fello.felloappiOS',
          minimumVersion: '0',
          appStoreId: '1558445254'),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    return url.toString();
  }
}

class ProfileTabTile extends StatelessWidget {
  final String title, leadIcon;
  final Widget trailWidget;
  final Function onPress;

  const ProfileTabTile(
      {this.leadIcon, this.onPress, this.title, this.trailWidget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.globalMargin * 1.6),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
            Row(
              children: [
                Image.asset(
                  leadIcon,
                  height: SizeConfig.blockSizeHorizontal * 5,
                ),
                SizedBox(width: SizeConfig.globalMargin),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: SizeConfig.mediumTextSize,
                  ),
                ),
                Spacer(),
                trailWidget,
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
            Divider()
          ],
        ),
      ),
    );
  }
}

class UserProfileCard extends StatelessWidget {
  BaseUtil baseProvider;
  DBModel dbProvider;
  final double picSize = SizeConfig.screenWidth * 0.24;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return InkWell(
      onTap: () => AppState.delegate.appState.currentAction =
          PageAction(state: PageState.addPage, page: UserProfileDetailsConfig),
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth * 0.4,
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [Color(0xff299F8F), UiConstants.primaryColor],
            begin: Alignment.bottomLeft,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.globalMargin,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
          child: CustomPaint(
            painter: ShapePainter(),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4,
                  vertical: SizeConfig.blockSizeHorizontal * 2.5),
              child: Column(
                children: [
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: picSize,
                        width: picSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: baseProvider.myUserDpUrl == null
                            ? Image.asset(
                                "images/profile.png",
                                height: picSize,
                                width: picSize,
                                fit: BoxFit.cover,
                              )
                            : ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: baseProvider.myUserDpUrl,
                                  height: picSize,
                                  width: picSize,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      SizedBox(
                        width: SizeConfig.globalMargin,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: SizeConfig.screenWidth * 0.5,
                              child: Text(
                                baseProvider.myUser.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.cardTitleTextSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            baseProvider.myUser.username != null
                                ? Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      "@${baseProvider.myUser.username.replaceAll('@', '.')}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: SizeConfig.mediumTextSize,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 8,
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Member since ${_getUserMembershipDate()}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.smallTextSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getUserMembershipDate() {
    if (baseProvider.userCreationTimestamp != null) {
      return DateFormat("MMMM, yyyy")
          .format(baseProvider.userCreationTimestamp);
    } else {
      return '\'Unavailable\'';
    }
  }
}
