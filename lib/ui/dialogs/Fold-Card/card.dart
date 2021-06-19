import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/fold-card.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class FCard extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  final bool isClaimed;
  final double unclaimedPrize;

  const FCard({
    Key key,
    this.isClaimed,
    this.unclaimedPrize,
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
  HttpModel httpProvider;

  LinearGradient cardGradient = const LinearGradient(
      //colors: [Color(0xff7F00FF), Color(0xffE100FF)],
      colors: [Color(0xff01937C), Color(0xffB6C867)],
      //colors: [Color(0xfffbc7d4), Color(0xff9796f0)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  Widget get backCard => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Color(0xff01937C),
        ),
      );

  @override
  void initState() {
    super.initState();
    _isOpen = false;
    claimtype = PrizeClaimChoice.NA;
    frontCard = CloseCard(
      unclaimedPrize: widget.unclaimedPrize,
      claimtype: claimtype,
    );
    middleCard = buildMiddleCard();
    bottomCard = buildBottomCard();
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    httpProvider = Provider.of<HttpModel>(context);
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
                FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
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
                    )),
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
            "You Won र${widget.unclaimedPrize}",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
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
                _registerClaimChoice(PrizeClaimChoice.AMZ_VOUCHER).then((flag) {
                  if (flag) {
                    setState(() {
                      claimtype = PrizeClaimChoice.AMZ_VOUCHER;
                      frontCard = CloseCard(
                        claimtype: claimtype,
                        unclaimedPrize: widget.unclaimedPrize,
                      );
                      _isOpen = false;
                    });
                  } else {
                    //TODO
                  }
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
                _registerClaimChoice(PrizeClaimChoice.GOLD_CREDIT).then((flag) {
                  if (flag) {
                    setState(() {
                      claimtype = PrizeClaimChoice.GOLD_CREDIT;
                      frontCard = CloseCard(
                        claimtype: claimtype,
                        unclaimedPrize: widget.unclaimedPrize,
                      );

                      _isOpen = false;
                    });
                  } else {
                    //TODO
                  }
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

  Future<bool> _registerClaimChoice(PrizeClaimChoice choice) async {
    if (choice == PrizeClaimChoice.NA) return false;
    bool flag = await httpProvider.registerPrizeClaim(
        baseProvider.myUser.uid, widget.unclaimedPrize, choice);
    // bool flag = await httpProvider.registerPrizeClaim(
    //    'dummy', widget.unclaimedPrize, choice);
    print('Claim choice saved: $flag');
    return flag;
  }
}

class CloseCard extends StatefulWidget {
  final PrizeClaimChoice claimtype;
  final double unclaimedPrize;

  CloseCard({this.claimtype, this.unclaimedPrize});

  @override
  _CloseCardState createState() => _CloseCardState();
}

class _CloseCardState extends State<CloseCard> {
  BaseUtil baseProvider;
  int _counter = 0;
  Uint8List _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    print(widget.claimtype);
    return widget.claimtype != PrizeClaimChoice.NA
        ? Screenshot(
            controller: screenshotController,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Lottie.asset(
                              "images/lottie/reward-claimed.json")),
                      Expanded(
                          child: Lottie.asset(
                              "images/lottie/reward-claimed.json")),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reward Claimed",
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
                        widget.claimtype == PrizeClaimChoice.AMZ_VOUCHER
                            ? "Your amazon gift card shall be sent to your registered email and mobile shortly!"
                            : "Your digital gold shall be credited to your Fello wallet shortly!",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          screenshotController
                              .capture(
                            delay: Duration(milliseconds: 10),
                            pixelRatio: MediaQuery.of(context).devicePixelRatio,
                          )
                              .then((Uint8List image) async {
                            //Capture Done

                            setState(() {
                              _imageFile = image;
                            });

                            final directory =
                                (await getExternalStorageDirectory()).path;
                            // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                            // Uint8List pngBytes = byteData.buffer.asUint8List();
                            File imgFile =
                                new File('$directory/screenshot.png');
                            imgFile.writeAsBytes(image);
                            final RenderBox box = context.findRenderObject();
                            Share.shareFiles(['$directory/screenshot.png'],
                                subject: 'Share ScreenShot',
                                text: 'Hello, check your share files!',
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size);
                          }).catchError((onError) {
                            print(onError);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Wrap(
                            children: [
                              Text(
                                "Share with friends",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white, height: 1.3),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.share_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            "images/lottie/winner-crown.json",
                            height: 80,
                          ),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: UiConstants.primaryColor,
                                width: 3,
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: baseProvider.myUserDpUrl != null
                                    ? NetworkImage(baseProvider.myUserDpUrl)
                                    : AssetImage("images/profile.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 40)
                        ],
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "Congratulations 🎉",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff194350),
                                    fontSize: SizeConfig.cardTitleTextSize,
                                  ),
                                )),
                            SizedBox(height: 10),
                            Text(
                              " You have र${widget.unclaimedPrize} worth of unclaimed rewards from your past referrals and tambola winnings!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: UiConstants.primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: FittedBox(
                                  child: Text(
                                    "Claim",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
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
