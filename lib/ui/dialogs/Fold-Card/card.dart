import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/fold-card.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

enum claim { na, amazon, augmont }

class FCard extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  // final Function onClick;

  const FCard({
    Key key,
    // @required this.boardingPass,
    // @required this.onClick
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TicketState();
}

class _TicketState extends State<FCard> {
  Widget frontCard;
  Widget topCard;
  Widget middleCard;
  Widget bottomCard;
  bool _isOpen;
  claim claimtype;
  BaseUtil baseProvider;

  LinearGradient cardGradient = const LinearGradient(
      colors: [Color(0xff7F00FF), Color(0xffE100FF)],
      //colors: [Color(0xfffbc7d4), Color(0xff9796f0)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  Widget get backCard => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Color(0xff493240),
        ),
      );

  @override
  void initState() {
    super.initState();
    _isOpen = false;
    claimtype = claim.na;
    frontCard = CloseCard(
      claimtype: claimtype,
    );
    middleCard = buildMiddleCard();
    bottomCard = buildBottomCard();
  }

  @override
  Widget build(BuildContext context) {
    return FoldingCard(
        entries: _getEntries(), isOpen: _isOpen, onClick: _handleOnTap);
  }

  List<FoldEntry> _getEntries() {
    return [
      FoldEntry(height: 230.0, front: topCard),
      FoldEntry(height: 230.0, front: middleCard, back: frontCard),
      FoldEntry(height: 80.0, front: bottomCard, back: backCard)
    ];
  }

  void _handleOnTap() {
    //widget.onClick();
    if (claimtype == claim.na)
      setState(() {
        _isOpen = true;
        topCard = buildTopCard();
      });
  }

  Widget buildTopCard() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Lottie.asset(
                    "images/lottie/clap.json",
                    height: 100,
                  ),
                ),
                Text(
                  "Congratulations",
                  style: GoogleFonts.megrim(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          color: Colors.white,
                          blurRadius: 5,
                        )
                      ],
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      fontSize: SizeConfig.cardTitleTextSize),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "images/fello_logo.png",
                      width: 40,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isOpen = false;
                        });
                        // Future.delayed(Duration(milliseconds: 800))
                        //     .then((value) => Navigator.pop(context));
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildMiddleCard() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "You Won \$50",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.largeTextSize,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "How would you like to redeem it?",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: SizeConfig.mediumTextSize,
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Lottie.asset(
                    "images/lottie/amazon.json",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "OR",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Lottie.asset(
                  "images/lottie/gold-prize.json",
                ),
              ),
            ],
          ),
          Spacer()
        ],
      ),
    );
  }

  Widget buildBottomCard() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  claimtype = claim.amazon;
                  frontCard = CloseCard(claimtype: claimtype);
                  _isOpen = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: FittedBox(
                child: Text(
                  "Amazon Gift Card ",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  claimtype = claim.augmont;
                  frontCard = CloseCard(claimtype: claimtype);

                  _isOpen = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber),
              ),
              child: FittedBox(
                child: Text(
                  "Augmont Gold ",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CloseCard extends StatelessWidget {
  final claim claimtype;
  BaseUtil baseProvider;
  CloseCard({this.claimtype});
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    print(claimtype);
    return claimtype != claim.na
        ? Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
            decoration: BoxDecoration(
              color: Colors.black,

              // gradient: new LinearGradient(colors: [
              //   Color(0xffFEAC5E),
              //   Color(0xffC779D0),
              //   Color(0xff4BC0C8),
              // ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Lottie.asset("images/lottie/reward-claimed.json"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Reward Claimed",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      claimtype == claim.amazon
                          ? "You claimed for amazon gift card"
                          : "You claimed for augmont gold",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Future.delayed(Duration(milliseconds: 800))
                        //     .then((value) => Navigator.pop(context));
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                //   Row(children: [
                //  claimtype == claim.amazon ? Padding(padding: EdgeInsets.all(20),child: Lottie.asset("images/"),)
                //   ],)
              ],
            ),
          )
        : Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xfff9f3f3),
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: -0.2,
                              child: Lottie.asset(
                                "images/lottie/winner-crown.json",
                                height: 80,
                              ),
                            ),
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: UiConstants.primaryColor,
                                  width: 3,
                                ),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: baseProvider.myUserDpUrl != null
                                        ? NetworkImage(baseProvider.myUserDpUrl)
                                        : AssetImage("images/profile.png")),
                              ),
                            ),
                            SizedBox(height: 40)
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Winner Winner",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff194350),
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "You are a winner for last week",
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: UiConstants.primaryColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: FittedBox(
                                child: Text(
                                  "Claim you prize",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
