
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/guide_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ReferScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  Log log = new Log('ReferScreen');
  BaseUtil baseProvider;
  DBModel dbProvider;
  FcmHandler fcmProvider;
  String referral_bonus = BaseUtil.remoteConfig.getString('referral_bonus');
  String referral_ticket_bonus = BaseUtil.remoteConfig.getString('referral_ticket_bonus');
  String _shareMsg;

  _init() {
    referral_bonus = (referral_bonus==null||referral_bonus.isEmpty)?'25':referral_bonus;
    referral_ticket_bonus = (referral_ticket_bonus==null||referral_ticket_bonus.isEmpty)?'10':referral_ticket_bonus;
    _shareMsg = 'Hey I am gifting you ₹$referral_bonus and $referral_ticket_bonus free Tambola tickets. Lets start saving and playing together! ';

    if(fcmProvider != null && baseProvider != null && dbProvider != null) {
      fcmProvider.addIncomingMessageListener((valueMap) {
        if(valueMap['title'] != null && valueMap['body'] != null){
          baseProvider.showPositiveAlert(valueMap['title'], valueMap['body'], context, seconds: 5);
        }
      },2);

      if(!baseProvider.referCountFetched)dbProvider.getReferCount(baseProvider.myUser.uid).then((count) {
        baseProvider.referCountFetched = true;
        baseProvider.referCount = count;
        if(count > 0)setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(fcmProvider != null) fcmProvider.addIncomingMessageListener(null,2);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    fcmProvider = Provider.of<FcmHandler>(context);

    _init();
    return Scaffold(
      //debugShowCheckedModeBanner: false,
      //padding: EdgeInsets.only(top: 48.0),
        body: Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.6],
                  colors: [
                    UiConstants.primaryColor.withGreen(190),
                    UiConstants.primaryColor,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(
                      MediaQuery.of(context).size.width * 0.50, 18),
                  bottomRight: Radius.elliptical(
                      MediaQuery.of(context).size.width * 0.50, 18),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 5,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.menu),
                onPressed: () {
                  HapticFeedback.vibrate();
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
            ),
            Positioned(
              top: 30,
              right: 5,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.help_outline),
                onPressed: () {
                  HapticFeedback.vibrate();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => GuideDialog()
                  );
                },
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 70),
                  child: Column(
                    children: [
                      Text(
                        baseProvider.referCount.toString(),
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),

                      ),
                      Text(
                        'referrals',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                )
            ),
            SafeArea(child: Padding(
                padding: EdgeInsets.only(top: 125),
                child: _buildReferCanvas(context))
            ),
          ],
        )
      //),
    );
  }

  Widget _buildReferCanvas(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 0),
              child:SizedBox(
                child: Image(
                  image: AssetImage(Assets.referGraphic),
                  fit: BoxFit.contain,
                ),
                width: 300,
                height: 300,
              ),
            )
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black12,
                        offset: Offset.fromDirection(20, 7),
                        blurRadius: 3.0,
                        spreadRadius: 0.1
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.4],
                      colors: [Colors.white, Colors.white],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Share Fello with your friends',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: UiConstants.primaryColor,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('You both receive ₹$referral_bonus in your account along with $referral_ticket_bonus extra Tambola tickets!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.2,
                              color: UiConstants.accentColor,
                              fontWeight: FontWeight.w300
                            )
                          )
                        ]),
                  )
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width-60,
                height: 50.0,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        UiConstants.primaryColor,
                        UiConstants.primaryColor.withBlue(190),
                      ],
                      begin: Alignment(0.5, -1.0),
                      end: Alignment(0.5, 1.0)
                  ),
                  borderRadius: new BorderRadius.circular(10.0),
                  // boxShadow: [
                  //   new BoxShadow(
                  //     color: Colors.black12,
                  //     offset: Offset.fromDirection(20, 7),
                  //     blurRadius: 3.0,
                  //   )
                  // ],
                ),
                child: new Material(
                  child: MaterialButton(
                    child: (!baseProvider.isReferralLinkBuildInProgressWhatsapp)?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SHARE ON WHATSAPP',
                          style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          child: Image(
                            image: AssetImage(Assets.whatsappIcon),
                            fit: BoxFit.contain,
                          ),
                          width: 15,
                        )
                      ],
                    ):SpinKitThreeBounce(
                      color: UiConstants.spinnerColor2,
                      size: 18.0,
                    ),
                    onPressed: () async{
                      baseProvider.isReferralLinkBuildInProgressWhatsapp = true;
                      _createDynamicLink(baseProvider.myUser.uid, true, 'Whatsapp').then((url) async{
                        baseProvider.isReferralLinkBuildInProgressWhatsapp = false;
                        log.debug(url);
                        setState(() {});
                        FlutterShareMe().shareToWhatsApp(msg: _shareMsg + url).then((flag) {
                          log.debug(flag);
                        });
                      });
                      setState(() {});
                    },
                    highlightColor: Colors.orange.withOpacity(0.5),
                    splashColor: Colors.orange.withOpacity(0.5),
                  ),
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width-60,
                height: 50.0,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.blueGrey,
                        Colors.blueGrey[600],
                      ],
                      begin: Alignment(0.5, -1.0),
                      end: Alignment(0.5, 1.0)
                  ),
                  borderRadius: new BorderRadius.circular(10.0),
                  // boxShadow: [
                  //   new BoxShadow(
                  //     color: Colors.black12,
                  //     offset: Offset.fromDirection(20, 7),
                  //     blurRadius: 3.0,
                  //   )
                  // ],
                ),
                child: new Material(
                  child: MaterialButton(
                    child: (!baseProvider.isReferralLinkBuildInProgressOther)?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SHARE',
                          style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
                        )
                      ],
                    ):SpinKitThreeBounce(
                      color: UiConstants.spinnerColor2,
                      size: 18.0,
                    ),
                    onPressed: () async{
                      baseProvider.isReferralLinkBuildInProgressOther = true;
                      _createDynamicLink(baseProvider.myUser.uid, true, 'Other').then((url) async{
                        log.debug(url);
                        baseProvider.isReferralLinkBuildInProgressOther = false;
                        setState(() {});
                        FlutterShareMe().shareToSystem(msg: _shareMsg + url).then((flag) {
                          log.debug(flag);
                        });
                      });
                      setState(() {});
                    },
                    highlightColor: Colors.orange.withOpacity(0.5),
                    splashColor: Colors.orange.withOpacity(0.5),
                  ),
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<String> _createDynamicLink(String userId, bool short, String source) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://fello.page.link',
      link: Uri.parse('https://fello.in/$userId'),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Download ${Constants.APP_NAME}',
        description: 'Fello makes saving a lot more fun, and investing a lot more simple!',
        imageUrl: Uri.parse('https://play-lh.googleusercontent.com/yA_k3_efLEwy4slB6RUa-aBzJNuS5Bta7LudVRxYAThc0wnU0jgNih7lt95gHDgR_Ew=s360-rw')
      ),
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
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
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

  @override
  void initState() {
    super.initState();
  }
}