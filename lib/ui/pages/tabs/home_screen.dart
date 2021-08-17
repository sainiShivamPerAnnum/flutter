import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/model/FeedCard.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/pick_draw.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (baseProvider == null || baseProvider.myUser == null) return;
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
        if (cards.length > 0) {
          baseProvider.feedCards = cards;
          _isInit = true;
          baseProvider.isHomeCardsFetched = true;
          setState(() {});
        } else {
          setState(() {});
        }
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
        height: SizeConfig.screenHeight * 0.04,
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
              style: GoogleFonts.montserrat(
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
        height: SizeConfig.screenHeight * 0.04,
      ),
      _buildProfileRow(),
      TambolaHomeCard(),
      ScoreHomeCard()
    ];

    for (int i = 0; i < cards.length; i++) {
      _widget.add(_buildFeedCard(cards[i]));
    }

    return _widget;
  }

  Widget _buildFeedCard(FeedCard card) {
    if (card == null) return Container();
    switch (card.type) {
      case Constants.LEARN_FEED_CARD_TYPE:
        return HomeCard(
          title: card.title,
          asset: card.assetLocalLink,
          subtitle: card.subtitle,
          buttonText: card.btnText,
          isHighlighted: (baseProvider.show_home_tutorial),
          onPressed: () async {
            HapticFeedback.vibrate();
            delegate.parseRoute(Uri.parse(card.actionUri));
          },
          gradient: [
            Color(card.clrCodeA),
            Color(card.clrCodeB),
          ],
        );
      case Constants.TAMBOLA_FEED_CARD_TYPE:
        return Container();
      case Constants.PRIZE_FEED_CARD_TYPE:
        return Container();
      case Constants.DEFAULT_FEED_CARD_TYPE:
      default:
        return HomeCard(
          title: card.title,
          asset: card.assetLocalLink,
          subtitle: card.subtitle,
          buttonText: card.btnText,
          isHighlighted: false,
          onPressed: () async {
            HapticFeedback.vibrate();
            delegate.parseRoute(Uri.parse(card.actionUri));
          },
          gradient: [
            Color(card.clrCodeA),
            Color(card.clrCodeB),
          ],
        );
    }
  }

  Widget _buildProfileRow() {
    return InkWell(
      onTap: () {
        delegate.appState.setCurrentTabIndex = 3;
        delegate.appState.currentAction = PageAction(
            state: PageState.addPage, page: UserProfileDetailsConfig);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 5,
            vertical: SizeConfig.blockSizeHorizontal * 5),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: SizeConfig.screenWidth * 0.2,
              width: SizeConfig.screenWidth * 0.2,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  )),
              child: baseProvider.myUserDpUrl == null
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
                  const SizedBox(height: 5),
                  FittedBox(
                    child: Text(
                      baseProvider.myUser?.name ?? 'NA',
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
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final String asset, title, subtitle, buttonText;
  final Function onPressed;
  final List<Color> gradient;
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
    LocalDBModel localDbProvider =
        Provider.of<LocalDBModel>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(
          bottom: 20,
          left: SizeConfig.blockSizeHorizontal * 5,
          right: SizeConfig.blockSizeHorizontal * 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
          gradient: new LinearGradient(
            colors: gradient,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          boxShadow: [
            BoxShadow(
                color: gradient[0].withOpacity(0.2),
                offset: Offset(2, 2),
                blurRadius: 10,
                spreadRadius: 2),
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
                (isHighlighted)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Shimmer(
                          enabled: true,
                          direction: ShimmerDirection.fromLeftToRight(),
                          child: GestureDetector(
                            onTap: () {
                              if (isHighlighted == true) {
                                isHighlighted = false;
                                localDbProvider.saveHomeTutorialComplete = true;
                                onPressed();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
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
                        ))
                    : GestureDetector(
                        onTap: onPressed,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
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

class TambolaHomeCard extends StatelessWidget {
  BaseUtil baseProvider;
  LocalDBModel _localDBModel;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    _localDBModel = Provider.of<LocalDBModel>(context);
    return Container(
      margin: EdgeInsets.only(
          bottom: 20,
          left: SizeConfig.blockSizeHorizontal * 5,
          right: SizeConfig.blockSizeHorizontal * 5),
      decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [Color(0xff595260), Color(0xffA35D6A)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
          boxShadow: [
            BoxShadow(
                color: Color(0xff343A40).withOpacity(0.2),
                offset: Offset(2, 2),
                blurRadius: 10,
                spreadRadius: 2),
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
                "images/homw-pick-card-asset.png",
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
                  "Win upto ₹ 10,000 this week 🎉",
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
                  height: 10,
                ),
                Text(
                  "Join in for a round of tambola!",
                  style: TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Color(0xff343A40),
                          offset: Offset(1, 1),
                        ),
                      ],
                      fontSize: SizeConfig.mediumTextSize * 1.3,
                      fontWeight: FontWeight.w100),
                ),
                SizedBox(
                  height: 30,
                ),
                DailyPicksTimer(
                  alignment: MainAxisAlignment.start,
                  bgColor: Color(0xff50445B).withOpacity(0.8),
                  replacementWidget: GestureDetector(
                    onTap: () async {
                      if (await baseProvider.getDrawaStatus()) {
                        await _localDBModel
                            .saveDailyPicksAnimStatus(DateTime.now().weekday)
                            .then(
                              (value) => print(
                                  "Daily Picks Draw Animation Save Status Code: $value"),
                            );
                        delegate.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          page: TPickDrawPageConfig,
                          widget: PicksDraw(
                            picks: baseProvider.todaysPicks ??
                                List.filled(baseProvider.dailyPicksCount, -1),
                          ),
                        );
                      } else
                        delegate.appState.currentAction = PageAction(
                            state: PageState.addPage, page: THomePageConfig);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff197163).withOpacity(0.2),
                              blurRadius: 20,
                              offset: Offset(5, 5),
                              spreadRadius: 10),
                        ],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "View Leaderboard",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize * 1.3),
                      ),
                    ),
                  ),
                  additionalWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Today's draws coming in",
                      style: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color(0xff343A40),
                              offset: Offset(1, 1),
                            ),
                          ],
                          fontSize: SizeConfig.mediumTextSize,
                          fontWeight: FontWeight.w500),
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

class ScoreHomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: 20,
          left: SizeConfig.blockSizeHorizontal * 5,
          right: SizeConfig.blockSizeHorizontal * 5),
      decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [Color(0xff197163), Color(0xff158467)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
          boxShadow: [
            BoxShadow(
                color: Color(0xff343A40).withOpacity(0.2),
                offset: Offset(2, 2),
                blurRadius: 10,
                spreadRadius: 2),
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
                "images/home-score-card-asset.png",
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
                // SizedBox(
                //   height: 20,
                // ),
                Text(
                  "Last week's tally",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Color(0xff197163),
                        offset: Offset(1, 1),
                      ),
                    ],
                    fontSize: SizeConfig.mediumTextSize * 1.3,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    getSection("500", "players"),
                    getSection("15", "winners"),
                    getSection("₹ 5000+", "in prizes"),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    delegate.appState.setCurrentTabIndex = 1;
                    delegate.appState.setCurrentGameTabIndex = 1;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff197163).withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(5, 5),
                            spreadRadius: 10),
                      ],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "View Leaderboard",
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

  getSection(String title, String subtitle) {
    return Expanded(
      child: Column(
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
          SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.mediumTextSize * 1.3,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
