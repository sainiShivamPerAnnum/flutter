import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/tabs/profile/edit_profile_page.dart';
import 'package:felloapp/ui/pages/tabs/profile/transactions.dart';
import 'package:felloapp/ui/pages/tabs/profile/referrals_page.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool isImageLoading = false;
  bool isPanFieldHidden = true;

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
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.02),
      decoration: BoxDecoration(
        color: UiConstants.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: AppBar().preferredSize.height * 1.6,
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfile(
                            prevImage: baseProvider.myUserDpUrl,
                          )),
                );
              },
              child: Container(
                height: SizeConfig.screenHeight * 0.24,
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 2),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "images/profile-card.png",
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                  width: double.infinity,
                  child: Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     IconButton(
                      //       icon: Icon(
                      //         Icons.edit,
                      //         color: Colors.white,
                      //       ),
                      //       onPressed: () {},
                      //     )
                      //   ],
                      // ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            isImageLoading
                                ? Image.asset(
                                    "images/profile.png",
                                    height: SizeConfig.screenWidth * 0.25,
                                    fit: BoxFit.cover,
                                  )
                                : ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: baseProvider.myUserDpUrl,
                                      height: SizeConfig.screenWidth * 0.25,
                                      width: SizeConfig.screenWidth * 0.25,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.05,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: SizeConfig.screenWidth * 0.5,
                                  child: Text(
                                    baseProvider.myUser.name,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: SizeConfig.cardTitleTextSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Member since ${_getUserMembershipDate()}',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: SizeConfig.smallTextSize,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: SizeConfig.blockSizeHorizontal * 4,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Tap to edit details",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 2,
              ),
              child: Column(
                children: [
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
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => MoreInfoDialog(
                                  text: Assets.infoWhyPan,
                                  title: 'Where is my PAN Number used?',
                                ));
                      }
                    },
                  ),
                  ProfileTabTile(
                    logo: "images/transaction.png",
                    title: "Transactions",
                    value: "See All",
                    onPress: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (ctx) => Transactions()));
                    },
                  ),
                  ProfileTabTile(
                    logo: "images/referrals.png",
                    title: "Referrals",
                    value: _myReferralCount.toString(),
                    onPress: () {
                      HapticFeedback.vibrate();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReferralsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            ShareCard(),
            SizedBox(
              height: 50,
            ),
            Social(),
            SizedBox(
              height: 50,
            ),
            _termsRow()
          ],
        ),
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
              Navigator.of(context).pushNamed('/tnc');
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
              Navigator.of(context).pushNamed('/faq').then(
                    (value) => Navigator.pushNamed(
                      context,
                      ('/refpolicy'),
                    ),
                  );
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
        width: SizeConfig.screenWidth,
        child: Column(children: [
          Text(
            "Connect With Us",
            style: GoogleFonts.montserrat(
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
                  style: GoogleFonts.montserrat(
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
                  style: GoogleFonts.montserrat(
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.white,
            ),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: MaterialButton(
            child: (!baseProvider.isReferralLinkBuildInProgressOther)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SHARE',
                        style: GoogleFonts.montserrat(
                          fontSize: SizeConfig.mediumTextSize * 0.8,
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
            onPressed: () async {
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
        Spacer(),
        (Platform.isIOS)
            ? Text('')
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: MaterialButton(
                  child: (!baseProvider.isReferralLinkBuildInProgressWhatsapp)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('SHARE ON WHATSAPP',
                                style: GoogleFonts.montserrat(
                                  fontSize: SizeConfig.mediumTextSize * 0.8,
                                  color: Colors.white,
                                )),
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
                  onPressed: () async {
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
              style: GoogleFonts.montserrat(
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
  final String logo, title, value;
  final Function onPress;

  ProfileTabTile({this.logo, this.onPress, this.title, this.value});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              logo,
              height: SizeConfig.screenHeight * 0.02,
              width: SizeConfig.screenHeight * 0.02,
            ),
            title: Text(
              title,
              style: GoogleFonts.montserrat(
                color: UiConstants.textColor,
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
            trailing: Text(
              value,
              style: GoogleFonts.montserrat(
                color: UiConstants.primaryColor,
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
            onTap: onPress,
          ),
          Divider(
            endIndent: width * 0.1,
            indent: width * 0.1,
          ),
        ],
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
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Column(
        children: [
          ListTile(
              leading: Image.asset(
                logo,
                height: SizeConfig.screenHeight * 0.02,
                width: SizeConfig.screenHeight * 0.02,
              ),
              title: Text(
                title,
                style: GoogleFonts.montserrat(
                  color: UiConstants.textColor,
                  fontSize: SizeConfig.mediumTextSize,
                ),
              ),
              trailing: isAvailable
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
                                color: UiConstants.primaryColor,
                              )),
                          onTap: onPress,
                        )
                      ],
                    )),
          Divider(
            endIndent: width * 0.1,
            indent: width * 0.1,
          ),
        ],
      ),
    );
  }
}
