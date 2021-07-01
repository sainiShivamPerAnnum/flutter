import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/marquee_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  BaseUtil baseProvider;
  DBModel dbProvider;
  AppState appState;
  bool isImageLoading = false;
  bool isPanFieldHidden = true;
  double picSize = SizeConfig.screenWidth * 0.24;

  Future<void> getProfilePicUrl() async {
    try {
      baseProvider.myUserDpUrl =
          await dbProvider.getUserDP(baseProvider.myUser.uid);
      if (baseProvider.myUserDpUrl != null) {
        setState(() {
          isImageLoading = false;
        });
        print("got the image");
      }
    } catch (e) {}
  }

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
    if (baseProvider.myUserDpUrl == null) {
      isImageLoading = true;
      getProfilePicUrl();
    }
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
              height: kToolbarHeight * 1.6,
            ),
            InkWell(
              onTap: () {
                appState.currentAction = PageAction(
                    state: PageState.addPage, page: EditProfileConfig);
                // showDialog(
                //     context: context,
                //     builder: (ctx) {
                //       return Dialog(
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(30),
                //           ),
                //           child: Wrap(
                //             children: [
                //               Column(
                //                 children: [
                //                   Container(
                //                     width: double.infinity,
                //                     padding: EdgeInsets.symmetric(
                //                         vertical: 16,
                //                         horizontal:
                //                             SizeConfig.blockSizeHorizontal * 5),
                //                     decoration: BoxDecoration(
                //                         color: UiConstants.primaryColor),
                //                     child: Text(
                //                       "Edit Name",
                //                       style: GoogleFonts.montserrat(
                //                         fontSize: SizeConfig.cardTitleTextSize,
                //                         fontWeight: FontWeight.w500,
                //                         color: Colors.white,
                //                       ),
                //                     ),
                //                   ),
                //                   SizedBox(
                //                     height: 24,
                //                   ),
                //                   Text(
                //                     "Name",
                //                     style: TextStyle(color: Colors.grey),
                //                   ),
                //                   TextFormField(
                //                     //controller: _nameFieldController,
                //                     keyboardType: TextInputType.text,
                //                     style: TextStyle(
                //                       fontSize: SizeConfig.largeTextSize,
                //                       fontWeight: FontWeight.w700,
                //                     ),
                //                     decoration: InputDecoration(
                //                       enabledBorder: UnderlineInputBorder(
                //                         borderSide: BorderSide(
                //                             color: UiConstants.primaryColor),
                //                       ),
                //                       focusedBorder: UnderlineInputBorder(
                //                         borderSide: BorderSide(
                //                             color: UiConstants.primaryColor),
                //                       ),
                //                       focusedErrorBorder: UnderlineInputBorder(
                //                         borderSide:
                //                             BorderSide(color: Colors.red),
                //                       ),
                //                       errorBorder: UnderlineInputBorder(
                //                         borderSide:
                //                             BorderSide(color: Colors.red),
                //                       ),
                //                       border: UnderlineInputBorder(
                //                         borderSide: BorderSide(
                //                             color: UiConstants.primaryColor),
                //                       ),
                //                     ),
                //                     onChanged: (val) {
                //                       AppState.unsavedChanges = true;
                //                     },
                //                     validator: (value) {
                //                       return value.isEmpty
                //                           ? 'Please enter your name'
                //                           : null;
                //                     },
                //                     onFieldSubmitted: (v) {
                //                       FocusScope.of(context).nextFocus();
                //                     },
                //                   ),
                //                   SizedBox(
                //                     height: 20,
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     });
              },
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight * 0.24,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "images/profile-card.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            appState.currentAction = PageAction(
                                state: PageState.addPage,
                                page: EditProfileConfig);
                          },
                          label: Text(
                            "Edit",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 3,
                        )
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 5,
                          ),
                          Container(
                            height: picSize,
                            width: picSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Stack(
                              children: [
                                isImageLoading
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
                                // Positioned(
                                //   bottom: 0,
                                //   right: 0,
                                //   child: CircleAvatar(
                                //     backgroundColor: Colors.white,
                                //     radius: SizeConfig.blockSizeHorizontal * 4,
                                //     child: Icon(
                                //       Icons.camera_alt_rounded,
                                //       color: UiConstants.primaryColor,
                                //       size: SizeConfig.blockSizeHorizontal * 4,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: SizeConfig.screenWidth * 0.5,
                                child: Text(
                                  baseProvider.myUser.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.cardTitleTextSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              baseProvider.myUser.username != null
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 16, top: 8),
                                      child: Text(
                                        "@${baseProvider.myUser.username}",
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
                          )
                        ],
                      ),
                    ),
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
                        // Icon(
                        //   Icons.edit,
                        //   color: Colors.white,
                        //   size: SizeConfig.mediumTextSize,
                        // ),
                        // SizedBox(
                        //   width: 8,
                        // ),
                        // Text(
                        //   "Tap to edit name",
                        //   style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: SizeConfig.mediumTextSize),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  baseProvider.myUser.isEmailVerified == null ||
                          baseProvider.myUser.isEmailVerified == false
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 24),
                          width: SizeConfig.screenWidth -
                              SizeConfig.blockSizeHorizontal * 16,
                          child: MarqueeWidget(
                            pauseDuration: Duration(seconds: 2),
                            animationDuration: Duration(seconds: 3),
                            backDuration: Duration(seconds: 3),
                            direction: Axis.horizontal,
                            child: InkWell(
                              onTap: () {
                                appState.currentAction = PageAction(
                                    state: PageState.addPage,
                                    page: VerifyEmailPageConfig);
                              },
                              child: Text(
                                "Your email is not verified yet. Tap here to verify it now else you won't be able to use any of the services",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red[300],
                                  fontSize: SizeConfig.mediumTextSize,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  baseProvider.myUser.username == null
                      ? ProfileTabTile(
                          leadWidget: Icon(
                            Icons.account_circle_outlined,
                            size: SizeConfig.blockSizeHorizontal * 5,
                            color: UiConstants.primaryColor,
                          ),
                          title: "Username",
                          onPress: () {},
                          trailWidget: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: Colors.orange, width: 2),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            child: GestureDetector(
                              // style: ElevatedButton.styleFrom(
                              //   primary: UiConstants.primaryColor,
                              //   shadowColor:
                              //       UiConstants.primaryColor.withOpacity(0.3),
                              // ),
                              onTap: () {
                                appState.currentAction = PageAction(
                                    state: PageState.addPage,
                                    page: ClaimUsernamePageConfig);
                              },
                              child: Text(
                                "Claim!",
                                style: GoogleFonts.montserrat(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.mediumTextSize),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  ProfileTabTilePan(
                    logo: "images/contact-book.png",
                    title: "PAN Number",
                    value: baseProvider.myUser.pan,
                    isHidden: isPanFieldHidden,
                    isAvailable: (baseProvider.myUser.pan != null &&
                        baseProvider.myUser.pan.isNotEmpty),
                    onPress: () {
                      HapticFeedback.vibrate();
                      if (baseProvider.myUser.pan != null &&
                          baseProvider.myUser.pan.isNotEmpty) {
                        isPanFieldHidden = !isPanFieldHidden;
                        setState(() {});
                      } else {
                        delegate.parseRoute(Uri.parse("d-panInfo"));
                      }
                    },
                  ),
                  ProfileTabTile(
                      leadWidget: Image.asset(
                        "images/transaction.png",
                        height: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      title: "Transactions",
                      trailWidget: Text(
                        "See All",
                        style: GoogleFonts.montserrat(
                          color: UiConstants.primaryColor,
                          fontSize: SizeConfig.mediumTextSize,
                        ),
                      ),
                      onPress: () => appState.currentAction = PageAction(
                          state: PageState.addPage,
                          page: TransactionPageConfig)),
                  ProfileTabTile(
                      leadWidget: Image.asset(
                        "images/referrals.png",
                        height: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      title: "Referrals",
                      trailWidget: Text(
                        _myReferralCount.toString(),
                        style: GoogleFonts.montserrat(
                          color: UiConstants.primaryColor,
                          fontSize: SizeConfig.mediumTextSize,
                        ),
                      ),
                      onPress: () => appState.currentAction = PageAction(
                          state: PageState.addPage, page: ReferralPageConfig)),
                ],
              ),
            ),
            ShareCard(),
            Social(),
            _appVersionRow(),
            _termsRow(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _appVersionRow() {
    return Center(
      child: Row(
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

  Widget _termsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
          child: InkWell(
            child: Text(
              'Terms of Service',
              style: TextStyle(
                  color: Colors.grey, decoration: TextDecoration.underline),
            ),
            onTap: () {
              HapticFeedback.vibrate();
              appState.currentAction =
                  PageAction(state: PageState.addPage, page: TncPageConfig);
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
                  color: Colors.grey, decoration: TextDecoration.underline),
            ),
            onTap: () {
              HapticFeedback.vibrate();
              // Navigator.of(context).pushNamed('/faq').then(
              //       (value) => Navigator.pushNamed(
              //         context,
              //         ('/refpolicy'),
              //       ),
              //     );
              appState.currentAction = PageAction(
                  state: PageState.addPage, page: RefPolicyPageConfig);
            },
          ),
        )
      ],
    );
  }

  String _getUserMembershipDate() {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    if (baseProvider.userCreationTimestamp != null) {
      int month = baseProvider.userCreationTimestamp.month;
      int year = baseProvider.userCreationTimestamp.year;
      int yearShort = year % 2000;

      return '${months[month - 1]}\'$yearShort';
    } else {
      return '\'Unavailable\'';
    }
  }

  int get _myReferralCount {
    if (baseProvider == null ||
        baseProvider.myReferralInfo == null ||
        baseProvider.myReferralInfo.refCount == null) return 0;
    return baseProvider.myReferralInfo.refCount;
  }
}

class Social extends StatelessWidget {
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
                "https://www.instagram.com/fellofinance/"),
            socialButton("images/svgs/linkedin.svg",
                "https://www.linkedin.com/company/fellofinance/"),
            socialButton(
                "images/svgs/whatsapp.svg",
                Platform.isAndroid
                    ? "https://wa.me/${917993252690}/?text=Hello Fello"
                    : "https://api.whatsapp.com/send?phone=${917993252690}=Hello Fello"),
            socialButton("images/svgs/mail.svg", "mailto:hello@fello.in"),
            socialButton("images/svgs/web.svg", "https://fello.in"),
          ])
        ]));
  }

  Widget socialButton(String asset, String url) {
    return GestureDetector(
      onTap: () async => launchUrl(url),
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

void launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ShareCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
              color: Color(0xff4E4376).withOpacity(0.3),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Color(0xff2B5876).withOpacity(0.3),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
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
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Both get ₹ 25 on every referral",
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  "You and your friend also receive 10 game tickets that week!",
                  style: TextStyle(
                      color: Colors.white, fontSize: SizeConfig.mediumTextSize),
                ),
                SizedBox(height: 20),
                ShareOptions(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ShareOptions extends StatefulWidget {
  @override
  _ShareOptionsState createState() => _ShareOptionsState();
}

class _ShareOptionsState extends State<ShareOptions> {
  Log log = new Log('ReferScreen');
  BaseUtil baseProvider;
  DBModel dbProvider;
  RazorpayModel rProvider;
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
        SizedBox(width: 10),
        (Platform.isIOS)
            ? Text('')
            : Container(
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
                  child: (!baseProvider.isReferralLinkBuildInProgressWhatsapp)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SHARE ON WHATSAPP',
                              style: GoogleFonts.montserrat(
                                fontSize: SizeConfig.mediumTextSize * 0.9,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
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

                    FlutterShareMe()
                        .shareToWhatsApp(msg: _shareMsg + url)
                        .then((flag) {
                      log.debug(flag);
                    }).catchError((err) {
                      log.error('Share to whatsapp failed');
                      log.error(err);
                      FlutterShareMe()
                          .shareToWhatsApp4Biz(msg: _shareMsg + url)
                          .then((value) {
                        log.debug(value);
                      }).catchError((err) {
                        log.error('Share to whatsapp biz failed as well');
                      });
                    });
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
      ),
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

class CardButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final IconData icon;
  final List<Color> gradient;

  CardButton({this.gradient, this.icon, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
                color: gradient[0].withOpacity(0.2),
                blurRadius: 20,
                offset: Offset(5, 5),
                spreadRadius: 10),
          ],
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.screenWidth * 0.035),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class ProfileTabTile extends StatelessWidget {
  final String title;
  final Widget leadWidget, trailWidget;
  final Function onPress;

  ProfileTabTile({this.leadWidget, this.onPress, this.title, this.trailWidget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 5),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
            Row(
              children: [
                leadWidget,
                SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
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

class ProfileTabTilePan extends StatelessWidget {
  final String logo, title, value;
  final bool isHidden;
  final bool isAvailable;
  final Function onPress;

  ProfileTabTilePan(
      {this.logo,
      this.onPress,
      this.title,
      this.value,
      this.isHidden,
      this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
          Row(
            children: [
              Image.asset(
                logo,
                height: SizeConfig.blockSizeHorizontal * 5,
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 5,
              ),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: UiConstants.textColor,
                  fontSize: SizeConfig.mediumTextSize,
                ),
              ),
              Spacer(),
              isAvailable
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isHidden ? '**********' : value,
                          style: GoogleFonts.montserrat(
                            color: UiConstants.primaryColor,
                            fontSize: SizeConfig.mediumTextSize,
                          ),
                        ),
                        InkWell(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                color: UiConstants.primaryColor,
                              )),
                          onTap: onPress,
                        )
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ' - ',
                          style: GoogleFonts.montserrat(
                            color: UiConstants.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.mediumTextSize,
                          ),
                        ),
                        InkWell(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                              child: Icon(
                                Icons.info_outline,
                                size: SizeConfig.largeTextSize,
                                color: UiConstants.primaryColor,
                              )),
                          onTap: onPress,
                        )
                      ],
                    ),
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
          Divider()
        ],
      ),
    );
  }
}
