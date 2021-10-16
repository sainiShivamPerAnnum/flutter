import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';

class ReferralDetailsViewModel extends BaseModel {
  Logger _logger = new Logger();
  final _baseUtil = locator<BaseUtil>();
  final _dbModel = locator<DBModel>();
  final _razorpayModel = locator<RazorpayModel>();
  final _fcmListener = locator<FcmListener>();
  final _userService = locator<UserService>();
  String referral_bonus =
      BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.REFERRAL_BONUS);
  String referral_ticket_bonus = BaseRemoteConfig.remoteConfig
      .getString(BaseRemoteConfig.REFERRAL_TICKET_BONUS);
  String _shareMsg;
  bool shareWhatsappInProgress = false;
  bool shareLinkInProgress = false;

  init() {
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

  shareLink() async {
    if (shareLinkInProgress) return;
    if (await BaseUtil.showNoInternetAlert()) return;
    _fcmListener.addSubscription(FcmTopic.REFERRER);
    BaseAnalytics.analytics.logShare(
        contentType: 'referral',
        itemId: _userService.baseUser.uid,
        method: 'message');
    shareLinkInProgress = true;
    refresh();
    _createDynamicLink(_userService.baseUser.uid, true, 'Other')
        .then((url) async {
      _logger.d(url);
      shareLinkInProgress = false;
      refresh();
      if (Platform.isIOS) {
        Share.share(_shareMsg + url);
      } else {
        FlutterShareMe().shareToSystem(msg: _shareMsg + url).then((flag) {
          _logger.d(flag);
        });
      }
    });
  }

  shareWhatsApp() async {
    ////////////////////////////////
    if (await BaseUtil.showNoInternetAlert()) return;
    _fcmListener.addSubscription(FcmTopic.REFERRER);
    BaseAnalytics.analytics.logShare(
        contentType: 'referral',
        itemId: _userService.baseUser.uid,
        method: 'whatsapp');
    shareWhatsappInProgress = true;
    refresh();
    String url;
    try {
      url =
          await _createDynamicLink(_userService.baseUser.uid, true, 'Whatsapp');
    } catch (e) {
      _logger.e('Failed to create dynamic link');
      _logger.e(e);
    }
    shareWhatsappInProgress = false;
    refresh();

    if (url == null)
      return;
    else
      _logger.d(url);
    try {
      FlutterShareMe().shareToWhatsApp(msg: _shareMsg + url).then((flag) {
        if (flag == "false") {
          FlutterShareMe()
              .shareToWhatsApp4Biz(msg: _shareMsg + url)
              .then((flag) {
            _logger.d(flag);
            if (flag == "false") {
              BaseUtil.showNegativeAlert(
                  "Whatsapp not detected", "Please use other option to share.");
            }
          });
        }
      });
    } catch (e) {
      _logger.d(e.toString());
    }

    // FlutterShareMe()
    //     .shareToWhatsApp4Biz(msg: _shareMsg + url)
    //     .then((value) {
    //   _logger.d(value);
    // }).catchError((err) {
    //  _logger.e('Share to whatsapp biz failed as well');
    // });
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

// class ShareOptions extends StatefulWidget {
//   const ShareOptions();

//   @override
//   _ShareOptionsState createState() => _ShareOptionsState();
// }

// class _ShareOptionsState extends State<ShareOptions> {
//   Log log = new Log('ReferScreen');
//   BaseUtil baseProvider;
//   DBModel dbProvider;
//   RazorpayModel rProvider;
//   FcmListener _fcmListener;
//   String referral_bonus =
//       BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.REFERRAL_BONUS);
//   String referral_ticket_bonus = BaseRemoteConfig.remoteConfig
//       .getString(BaseRemoteConfig.REFERRAL_TICKET_BONUS);
//   String _shareMsg;

//   _init() {
//     referral_bonus = (referral_bonus == null || referral_bonus.isEmpty)
//         ? '25'
//         : referral_bonus;
//     referral_ticket_bonus =
//         (referral_ticket_bonus == null || referral_ticket_bonus.isEmpty)
//             ? '10'
//             : referral_ticket_bonus;
//     _shareMsg =
//         'Hey I am gifting you ₹$referral_bonus and $referral_ticket_bonus free Tambola tickets. Lets start saving and playing together! ';
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     // if (_fcmListener != null) _fcmListener.addIncomingMessageListener(null, 2);
//   }

//   @override
//   Widget build(BuildContext context) {
//     baseProvider = Provider.of<BaseUtil>(context, listen: false);
//     dbProvider = Provider.of<DBModel>(context, listen: false);
//     rProvider = Provider.of<RazorpayModel>(context, listen: false);
//     _fcmListener = Provider.of<FcmListener>(context, listen: false);
//     _init();
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             border: Border.all(
//               width: 2,
//               color: Colors.white,
//             ),
//             color: Colors.transparent,
//             borderRadius: BorderRadius.circular(100),
//           ),
//           child: InkWell(
//             child: (!baseProvider.isReferralLinkBuildInProgressOther)
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'SHARE',
//                         style: GoogleFonts.montserrat(
//                           fontSize: SizeConfig.mediumTextSize * 0.9,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       SvgPicture.asset(
//                         "images/svgs/plane.svg",
//                         color: Colors.white,
//                         height: SizeConfig.blockSizeHorizontal * 4,
//                       )
//                     ],
//                   )
//                 : SpinKitThreeBounce(
//                     color: UiConstants.spinnerColor2,
//                     size: 18.0,
//                   ),
//             onTap: () async {
//               if (await baseProvider.showNoInternetAlert(context)) return;
//               _fcmListener.addSubscription(FcmTopic.REFERRER);
//               BaseAnalytics.analytics.logShare(
//                   contentType: 'referral',
//                   itemId: baseProvider.myUser.uid,
//                   method: 'message');
//               baseProvider.isReferralLinkBuildInProgressOther = true;
//               _createDynamicLink(baseProvider.myUser.uid, true, 'Other')
//                   .then((url) async {
//                 _logger.d(url);
//                 baseProvider.isReferralLinkBuildInProgressOther = false;
//                 setState(() {});
//                 if (Platform.isIOS) {
//                   Share.share(_shareMsg + url);
//                 } else {
//                   FlutterShareMe()
//                       .shareToSystem(msg: _shareMsg + url)
//                       .then((flag) {
//                     _logger.d(flag);
//                   });
//                 }
//               });
//               setState(() {});
//             },
//             highlightColor: Colors.orange.withOpacity(0.5),
//             splashColor: Colors.orange.withOpacity(0.5),
//           ),
//         ),
//         (Platform.isIOS)
//             ? SizedBox(width: 10)
//             : Text(
//                 "---",
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//         (Platform.isIOS)
//             ? Text('')
//             : Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width: 2,
//                     color: Colors.white,
//                   ),
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: InkWell(
//                   child: (!baseProvider.isReferralLinkBuildInProgressWhatsapp)
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Text(
//                             //   'WHATSAPP',
//                             //   style: GoogleFonts.montserrat(
//                             //     fontSize: SizeConfig.mediumTextSize * 0.9,
//                             //     color: Colors.white,
//                             //   ),
//                             // ),
//                             // SizedBox(
//                             //   width: 5,
//                             // ),
//                             SvgPicture.asset(
//                               "images/svgs/whatsapp.svg",
//                               color: Colors.white,
//                               height: SizeConfig.blockSizeHorizontal * 4,
//                             )
//                           ],
//                         )
//                       : SpinKitThreeBounce(
//                           color: UiConstants.spinnerColor2,
//                           size: 18.0,
//                         ),
//                   onTap: () async {
//                     ////////////////////////////////
//                     if (await baseProvider.showNoInternetAlert(context)) return;
//                     _fcmListener.addSubscription(FcmTopic.REFERRER);
//                     BaseAnalytics.analytics.logShare(
//                         contentType: 'referral',
//                         itemId: baseProvider.myUser.uid,
//                         method: 'whatsapp');
//                     baseProvider.isReferralLinkBuildInProgressWhatsapp = true;
//                     setState(() {});
//                     String url;
//                     try {
//                       url = await _createDynamicLink(
//                           baseProvider.myUser.uid, true, 'Whatsapp');
//                     } catch (e) {
//                       _logger.e('Failed to create dynamic link');
//                       _logger.e(e);
//                     }
//                     baseProvider.isReferralLinkBuildInProgressWhatsapp = false;
//                     setState(() {});
//                     if (url == null)
//                       return;
//                     else
//                       _logger.d(url);
//                     try {
//                       FlutterShareMe()
//                           .shareToWhatsApp(msg: _shareMsg + url)
//                           .then((flag) {
//                         if (flag == "false") {
//                           FlutterShareMe()
//                               .shareToWhatsApp4Biz(msg: _shareMsg + url)
//                               .then((flag) {
//                             _logger.d(flag);
//                             if (flag == "false") {
//                               baseProvider.showNegativeAlert(
//                                   "Whatsapp not detected",
//                                   "Please use other option to share.",
//                                   context);
//                             }
//                           });
//                         }
//                       });
//                     } catch (e) {
//                       _logger.d(e.toString());
//                     }

//                     // FlutterShareMe()
//                     //     .shareToWhatsApp4Biz(msg: _shareMsg + url)
//                     //     .then((value) {
//                     //   _logger.d(value);
//                     // }).catchError((err) {
//                     //  _logger.e('Share to whatsapp biz failed as well');
//                     // });
//                   },
//                   highlightColor: Colors.orange.withOpacity(0.5),
//                   splashColor: Colors.orange.withOpacity(0.5),
//                 ),
//               ),
//       ],
//     );
//   }

 
// }
