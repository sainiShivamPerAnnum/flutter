import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/model/FeedCard.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/game-poll-dialog.dart';
import 'package:felloapp/ui/dialogs/guide_dialog.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomePage extends StatefulWidget {
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
    if (!_isInit || baseProvider.feedCards.length == 0) {
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
                child: ListView(
                  controller: AppState.homeCardListController,
                  physics: BouncingScrollPhysics(),
                  children: (!baseProvider.isHomeCardsFetched ||
                          baseProvider.feedCards.length == 0)
                      ? _buildLoadingFeed()
                      : _buildHomeFeed(baseProvider.feedCards),
                ),
              ),
            )
          ],
        ));
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
    if (cards.length == 0) {
      return [
        Align(
          alignment: Alignment.bottomCenter,
          child: TextButton.icon(
            onPressed: _init,
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            label: Text(
              "Click to reload",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ];
    }
    List<Widget> _widget = [
      Container(
        height: kToolbarHeight,
      ),
      _buildProfileRow(),
    ];

    for (int i = 0; i < cards.length; i++) {
      _widget.add(HomeCard(
        title: cards[i].title,
        asset: cards[i].assetLocalLink,
        subtitle: cards[i].subtitle,
        buttonText: cards[i].btnText,
        isHighlighted: (baseProvider.show_home_tutorial &&
            cards[i].id == Constants.LEARN_FEED_CARD_ID),
        onPressed: () async {
          HapticFeedback.vibrate();
          delegate.parseRoute(Uri.parse(cards[i].actionUri));
        },
        gradient: [
          Color(cards[i].clrCodeA),
          Color(cards[i].clrCodeB),
        ],
        // "0/d-guide"
        //   "3"
        //   "1/d-gamePoll"
        //   "2/augDetails/editProfile/d-aboutus"
      ));
    }
    // for (FeedCard card in cards) {
    //  );
    // }

    return _widget;
  }

  Widget _buildProfileRow() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 5,
          vertical: SizeConfig.blockSizeHorizontal * 8),
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
                  width: 3,
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
          Expanded(
            child: Column(
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
                SizedBox(height: 5),
                FittedBox(
                  child: Text(
                    baseProvider.myUser.name,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.largeTextSize),
                  ),
                ),
              ],
            ),
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
  LocalDBModel localDbProvider;
  bool isHighlighted;

  HomeCard(
      {this.asset,
      this.buttonText,
      this.onPressed,
      this.subtitle,
      this.title,
      this.gradient,
      this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    localDbProvider = Provider.of<LocalDBModel>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(
          bottom: 20,
          left: SizeConfig.blockSizeHorizontal * 5,
          right: SizeConfig.blockSizeHorizontal * 5),
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
            padding: EdgeInsets.all(SizeConfig.screenWidth * 0.06),
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
                      shadows: [
                        Shadow(
                          color: gradient[0],
                          offset: Offset(1, 1),
                        ),
                      ],
                      fontSize: SizeConfig.mediumTextSize * 1.3,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 20,
                ),
                (isHighlighted)?ClipRRect(
                  borderRadius : BorderRadius.circular(100),
                  child : Shimmer(
                  enabled : true,
                  direction: ShimmerDirection.fromLeftToRight(),
                  child: GestureDetector(
                  onTap: (){
                    if(isHighlighted==true) {
                      isHighlighted = false;
                      localDbProvider.saveHomeTutorialComplete = true;
                      onPressed();
                    }
                  },
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
                          fontSize: SizeConfig.mediumTextSize * 1.3),
                    ),
                  ),
                ),
                )
                ):GestureDetector(
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
                          fontSize: SizeConfig.mediumTextSize * 1.3),
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
