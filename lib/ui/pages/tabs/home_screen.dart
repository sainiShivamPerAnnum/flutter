import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/dialogs/game-poll-dialog.dart';
import 'package:felloapp/ui/dialogs/guide_dialog.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int> tabChange;

  HomePage({this.tabChange});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isImageLoading = false;
  BaseUtil baseProvider;
  DBModel dbProvider;

  Future<void> getProfilePicUrl() async {
    baseProvider.myUserDpUrl =
    await dbProvider.getUserDP(baseProvider.myUser.uid);
    if (baseProvider.myUserDpUrl != null) {
      setState(() {
        isImageLoading = false;
      });
      print("got the image");
    }
  }

  String getGreeting() {
    int hour = DateTime
        .now()
        .hour;
    if (hour >= 5 && hour <= 12) {
      return "Good Morning,";
    } else if (hour > 12 && hour <= 17) {
      return "Good Afternoon,";
    } else if (hour >= 18 && hour <= 22) {
      return "Good Evening,";
    } else
      return "Hello,";
  }


  @override
  void initState() {
    super.initState();
    BaseAnalytics.analytics.setCurrentScreen(
        screenName: BaseAnalytics.PAGE_HOME);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    if (baseProvider.myUserDpUrl == null) {
      isImageLoading = true;
      getProfilePicUrl();
    }
    return Container(
        decoration: BoxDecoration(
          color: UiConstants.backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.05),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        height: AppBar().preferredSize.height,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.only(
                          top: 70,
                          bottom: 50,
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
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: SizeConfig.largeTextSize),
                                ),
                                Text(
                                  baseProvider.myUser.name,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: SizeConfig.largeTextSize),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      HomeCard(
                        title: "SAVE | PLAY | WIN",
                        asset: "images/tickets.png",
                        subtitle:
                        "New to Fello? \nLearn a little more about how to play and win big, just by saving!",
                        buttonText: "Learn how Fello works",
                        onPressed: () async {
                          HapticFeedback.vibrate();
                          //////DUMMY//////////
                          int _temp = baseProvider.userTicketWallet.augGold99Tck;
                          // baseProvider.userTicketWallet = await dbProvider.updateAugmontGoldUserTicketCount(baseProvider.myUser.uid, baseProvider.userTicketWallet, 2);
                          print(baseProvider.userTicketWallet.augGold99Tck);
                          print(baseProvider.userTicketWallet.getActiveTickets());
                          /////////////////////
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) => GuideDialog(),
                          // );
                        },
                        gradient: [
                          Color(0xffACB6E5),
                          Color(0xff74EBD5),
                        ],
                      ),
                      HomeCard(
                        title: "More tickets, more prizes",
                        asset: "images/referral-asset.png",
                        subtitle:
                        "By referring, you and your friend will both receive 10 game tickets and ₹25 in rewards!",
                        buttonText: "Share now",
                        onPressed: () => widget.tabChange(3),
                        //() => widget.tabChange(3),
                        gradient: [
                          Color(0xffD4AC5B),
                          Color(0xffDECBA4),
                        ],
                      ),
                      HomeCard(
                        title: "We're looking for suggestions",
                        asset: "images/puzzle.png",
                        subtitle:
                        "Vote for the next game that you would like to play on Fello",
                        buttonText: "Vote now",
                        onPressed: () async {
                          HapticFeedback.vibrate();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => GamePoll(),
                          );
                        },
                        gradient: [
                          Color(0xff2495B2),
                          Color(0xff67D0E8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');
}

class HomeCard extends StatelessWidget {
  final String asset, title, subtitle, buttonText;
  final Function onPressed;
  final List<Color> gradient;

  HomeCard({this.asset,
    this.buttonText,
    this.onPressed,
    this.subtitle,
    this.title,
    this.gradient});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Container(
      margin: EdgeInsets.only(
        bottom: 30,
        right: width * 0.05,
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
                width: width * 0.5,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                  subtitle,
                  style: GoogleFonts.montserrat(
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
                    padding: EdgeInsets.all(15),
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
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: width * 0.035),
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
