import 'package:confetti/confetti.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GoldenTicketClaimDialog extends StatefulWidget {
  @override
  _GoldenTicketClaimDialogState createState() =>
      _GoldenTicketClaimDialogState();
}

class _GoldenTicketClaimDialogState extends State<GoldenTicketClaimDialog> {
  bool showConfetti, showStamp;
  double stampOpacity = 0;

  @override
  void initState() {
    showConfetti = false;
    showStamp = false;
    animateStamp();
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
                    height: SizeConfig.screenWidth * 0.84,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(SizeConfig.globalMargin),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            color: Color(0xff08715E),
                          ),
                          alignment: Alignment.center,
                          height: SizeConfig.cardTitleTextSize * 2,
                          child: Text(
                            "🎉 Congratulations! 🎊",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.largeTextSize,
                              fontWeight: FontWeight.w500,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/gticket.png",
                                    width: SizeConfig.screenWidth / 1.5,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Lottie.asset("images/lottie/stamp.json",
                                        repeat: false,
                                        frameRate: FrameRate(60),
                                        width: SizeConfig.screenWidth / 1.8),
                                  ],
                                )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Golden Ticket",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: SizeConfig.largeTextSize),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: SizeConfig.screenWidth * 0.05),
                              child: Text(
                                "You have successfully redeemed your golden ticket. Tickets will be credited shortly",
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
