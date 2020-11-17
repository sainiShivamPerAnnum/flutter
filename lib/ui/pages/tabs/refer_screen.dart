
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/guide_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
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
                icon: Icon(Icons.settings),
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
                        '0',
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
                padding: EdgeInsets.only(top: 180),
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
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width-50,
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
                        FlutterShareMe().shareToWhatsApp(msg: 'Checkout: ' + url).then((flag) {
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
                width: MediaQuery.of(context).size.width-50,
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
                        FlutterShareMe().shareToWhatsApp(msg: 'Checkout: ' + url).then((flag) {
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
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child:Image(
                image: AssetImage(Assets.referGraphic),
                fit: BoxFit.contain,
              ),
            )
        )
      ],
    );
  }

  Future<String> _createDynamicLink(String userId, bool short, String source) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://fello.page.link',
      link: Uri.parse('https://fello.in/$userId'),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: '${Constants.APP_NAME} Referral',
        description: 'Download ${Constants.APP_NAME} and win big for both!',
        imageUrl: Uri.parse('https://fello.in/src/images/fello_logo_2_grey.png')
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