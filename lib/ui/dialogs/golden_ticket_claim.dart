import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GoldenTicketClaimDialog extends StatefulWidget {
  final int ticketCount;
  final String failMsg;

  GoldenTicketClaimDialog({@required this.ticketCount, this.failMsg});

  @override
  _GoldenTicketClaimDialogState createState() =>
      _GoldenTicketClaimDialogState();
}

class _GoldenTicketClaimDialogState extends State<GoldenTicketClaimDialog> {
  bool showConfetti, showStamp;
  double stampOpacity = 0;
  DBModel dbProvider;
  BaseUtil baseProvider;

  @override
  void initState() {
    showConfetti = false;
    showStamp = false;
    print(widget.ticketCount);
    if (widget.ticketCount > 0) animateStamp();
    super.initState();
  }

  animateStamp() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted)
          setState(() {
            showStamp = true;
          });
      }).then((value) {
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted)
            setState(() {
              stampOpacity = 1;
            });
        }).then((value) {
          if (mounted)
            setState(() {
              showConfetti = true;
            });
        }).then((value) {
          Future.delayed(Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                showConfetti = false;
              });
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    dbProvider = Provider.of<DBModel>(context, listen: false);
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    return Theme(
      data: ThemeData(
          primaryColor: UiConstants.primaryColor,
          textTheme: GoogleFonts.montserratTextTheme()),
      child: Container(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Color(0xffFFFEF3),
                  child: Container(
                    padding: EdgeInsets.all(SizeConfig.globalMargin),
                    height: SizeConfig.screenWidth * 0.84,
                    child: widget.ticketCount > 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.all(SizeConfig.globalMargin),
                                alignment: Alignment.center,
                                height: SizeConfig.cardTitleTextSize * 2,
                                child: Text(
                                  "Congratulations! 🎉 ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: UiConstants.primaryColor,
                                    fontSize: SizeConfig.largeTextSize * 1.2,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.globalMargin,
                              ),
                              Container(
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.screenWidth * 0.4,
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "images/gticket.png",
                                          width: SizeConfig.screenWidth / 1.5,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedOpacity(
                                          opacity: stampOpacity,
                                          duration: Duration(seconds: 1),
                                          child: Image.asset(
                                            "images/gtredeem.png",
                                            color: Color(0xff08715E),
                                            width: SizeConfig.screenWidth / 2.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (showStamp)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Lottie.asset(
                                              "images/lottie/stamp.json",
                                              repeat: false,
                                              frameRate: FrameRate(60),
                                              width:
                                                  SizeConfig.screenWidth / 1.8),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "You won ${widget.ticketCount} free tickets",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeConfig.largeTextSize),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal:
                                            SizeConfig.screenWidth * 0.05),
                                    child: Text(
                                      "Your Golden Ticket has been successfully redeemed. Tickets have been credited to your wallet.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox()
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.all(SizeConfig.globalMargin),
                                alignment: Alignment.center,
                                height: SizeConfig.cardTitleTextSize * 2,
                                child: Text(
                                  "Redeem Failed",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: SizeConfig.largeTextSize * 1.2,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Image.asset("images/gt-not-found.png"),
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    "Rewards were not credited",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeConfig.largeTextSize),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal:
                                            SizeConfig.screenWidth * 0.05),
                                    child: Text(
                                      widget.failMsg ??
                                          'There was an issue with your Golden Ticket',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          AppState.backButtonDispatcher.didPopRoute();
                          return dbProvider
                              .getUserTicketWallet(baseProvider.myUser.uid)
                              .then((value) {
                            if (value != null)
                              baseProvider.userTicketWallet = value;
                          });
                        }),
                  ),
                ),
              ],
            ),
            if (showConfetti)
              Positioned(
                bottom: 0,
                right: SizeConfig.screenWidth * 0.24,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  child: Lottie.asset("images/lottie/confetti.json",
                      fit: BoxFit.fitHeight, repeat: true),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
