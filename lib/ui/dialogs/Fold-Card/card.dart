import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/fold-card.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
  PrizeClaimChoice claimtype;
  BaseUtil baseProvider;

  Widget get backCard => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Color(0xfffeddbe),
        ),
      );

  @override
  void initState() {
    super.initState();
    _isOpen = false;
    claimtype = PrizeClaimChoice.NA;
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
      FoldEntry(height: 250.0, front: topCard),
      FoldEntry(height: 250.0, front: middleCard, back: frontCard),
      FoldEntry(height: 80.0, front: bottomCard, back: backCard)
    ];
  }

  void _handleOnTap() {
    //widget.onClick();
    if (claimtype == PrizeClaimChoice.NA)
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
        color: Color(0xfffcecdd),
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
                  padding: EdgeInsets.all(20),
                  child: Lottie.asset(
                    "images/lottie/clap.json",
                    height: 100,
                  ),
                ),
                Text(
                  "Congratulations",
                  style: GoogleFonts.megrim(
                    color: Color(0xff4a1c40),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    fontSize: 32,
                  ),
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
                        color: Colors.black,
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
        color: Color(0xfffcecdd),
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
          Text(
            "You Won \$50",
            style: GoogleFonts.montserrat(
              color: UiConstants.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 35,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "How would you like to redeem it?",
            style: GoogleFonts.montserrat(
              color: UiConstants.primaryColor,
              fontSize: 20,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("images/lottie/amazon.json",
                  height: 100, width: 100),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "OR",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Lottie.asset("images/lottie/gold-prize.json",
                  height: 150, width: 150),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomCard() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xfffcecdd),
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
                  claimtype = PrizeClaimChoice.AMZ_VOUCHER;
                  frontCard = CloseCard(claimtype: claimtype);
                  _isOpen = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: Text(
                "Amazon Gift Card ",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
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
                  claimtype = PrizeClaimChoice.GOLD_CREDIT;
                  frontCard = CloseCard(claimtype: claimtype);

                  _isOpen = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber),
              ),
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
        ],
      ),
    );
  }
}

class CloseCard extends StatelessWidget {
  final PrizeClaimChoice claimtype;
  BaseUtil baseProvider;
  CloseCard({this.claimtype});
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    print(claimtype);
    return claimtype != PrizeClaimChoice.NA
        ? Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
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
                      style: GoogleFonts.montserrat(
                        color: UiConstants.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 50,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      claimtype == PrizeClaimChoice.AMZ_VOUCHER
                          ? "You claimed for amazon gift card"
                          : "You claimed for augmont gold",
                      style: GoogleFonts.montserrat(
                        color: UiConstants.primaryColor,
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
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.black,
                          size: 30,
                        )),
                  ],
                ),
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
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 45,
                              left: 5,
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: UiConstants.primaryColor,
                                    width: 3,
                                  ),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: baseProvider.myUserDpUrl != null
                                          ? NetworkImage(
                                              baseProvider.myUserDpUrl)
                                          : AssetImage("images/profile.png")),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: -5,
                              child: Transform.rotate(
                                angle: -0.2,
                                child: Lottie.asset(
                                  "images/lottie/winner-crown.json",
                                  height: 80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Congratulations 🎉",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff194350),
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "You were one of the tambola winners last week!",
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
                              child: Text(
                                "Redeem your prize",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
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
