import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/model/FeedCard.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/game-poll-dialog.dart';
import 'package:felloapp/ui/dialogs/guide_dialog.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  // final ValueChanged<int> tabChange;

  // HomePage({this.tabChange});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isImageLoading = false;
  BaseUtil baseProvider;
  DBModel dbProvider;
  AppState appState;
  bool _isInit = false;

  Future<void> getProfilePicUrl() async {
    baseProvider.myUserDpUrl =
        await dbProvider.getUserDP(baseProvider.myUser.uid);
    if (baseProvider.myUserDpUrl != null) {
      try {
        setState(() {
          isImageLoading = false;
        });
      } catch (e) {
        print('HomeScreen: SetState called after dispose');
      }
    }
  }

  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour >= 5 && hour <= 12) {
      return "Good Morning,";
    } else if (hour > 12 && hour <= 17) {
      return "Good Afternoon,";
    } else if (hour > 17 && hour <= 22) {
      return "Good Evening,";
    } else
      return "Hello,";
  }

  @override
  void initState() {
    super.initState();
    BaseAnalytics.analytics
        .setCurrentScreen(screenName: BaseAnalytics.PAGE_HOME);
  }

  _init() {
    if (!baseProvider.isHomeCardsFetched) {
      dbProvider.getHomeCards().then((cards) {
        baseProvider.feedCards = cards;
        _isInit = true;
        baseProvider.isHomeCardsFetched = true;
        setState(() {});
      });
    }
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
    if (!_isInit) {
      _init();
    }
    return Container(
        decoration: BoxDecoration(
          color: UiConstants.backgroundColor,
          borderRadius: SizeConfig.homeViewBorder,
        ),
        child: Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.45,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/home-asset.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: ClipRRect(
                borderRadius: SizeConfig.homeViewBorder,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 5),
                  child: ListView(
                    controller: AppState.homeCardListController,
                    physics: BouncingScrollPhysics(),
                    children: (!baseProvider.isHomeCardsFetched)
                        ? _buildLoadingFeed()
                        : _buildHomeFeed(baseProvider.feedCards),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Function getFixedAction(int id) {
    switch (id) {
      case 108:
        return () {
          showDialog(
            context: context,
            builder: (BuildContext context) => GuideDialog(),
          );
        };
      case 120:
        return () {
          appState.setCurrentTabIndex = 3;
        };
      case 140:
        return () {
          showDialog(
            context: context,
            builder: (BuildContext context) => GamePoll(),
          );
        };
      default:
        return () {
          showDialog(
            context: context,
            builder: (BuildContext context) => GuideDialog(),
          );
        };
    }
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  List<Widget> _buildLoadingFeed() {
    return [
      Container(
        height: kToolbarHeight,
      ),
      _buildProfileRow(),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: SpinKitWave(
          color: UiConstants.primaryColor,
        ),
      )
    ];
  }

  List<Widget> _buildHomeFeed(List<FeedCard> cards) {
    List<Widget> _widget = [
      Container(
        height: kToolbarHeight,
      ),
      _buildProfileRow(),
    ];
    for (FeedCard card in cards) {
      _widget.add(HomeCard(
        title: card.title,
        asset: card.assetLocalLink,
        subtitle: card.subtitle,
        buttonText: card.btnText,
        onPressed: () async {
          HapticFeedback.vibrate();
          delegate.parseRoute(Uri.parse(card.actionUri));
        },
        gradient: [
          Color(card.clrCodeA),
          Color(card.clrCodeB),
        ],
        // "0/d-guide"
        //   "3"
        //   "1/d-gamePoll"
        //   "2/augDetails/editProfile/d-aboutus"
      ));
    }

    return _widget;
  }

  Widget _buildProfileRow() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(
        top: SizeConfig.screenWidth * 0.10,
        bottom: SizeConfig.screenWidth * 0.08,
      ),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.25,
            width: SizeConfig.screenWidth * 0.25,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 5,
                )),
            child: isImageLoading
                ? Image.asset(
                    "images/profile.png",
                    fit: BoxFit.cover,
                  )
                : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: baseProvider.myUserDpUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          SizedBox(
            width: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting().toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.largeTextSize),
              ),
              Text(
                baseProvider.myUser.name,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white, fontSize: SizeConfig.largeTextSize),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final String asset, title, subtitle, buttonText;
  final Function onPressed;
  final List<Color> gradient;

  HomeCard(
      {this.asset,
      this.buttonText,
      this.onPressed,
      this.subtitle,
      this.title,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 30,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: new LinearGradient(
            colors: gradient,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: gradient[1].withOpacity(0.3),
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
                asset,
                //height: height * 0.25,
                width: SizeConfig.screenWidth * 0.5,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(SizeConfig.screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                  subtitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.mediumTextSize * 1.2,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: onPressed,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    child: Text(
                      buttonText,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.mediumTextSize),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
