import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

enum GTicketStatus {
  none,
  redeemed,
  invalid,
  blocked,
}

class GoldenTicketClaimDialog extends StatefulWidget {
  @override
  _GoldenTicketClaimDialogState createState() =>
      _GoldenTicketClaimDialogState();
}

class _GoldenTicketClaimDialogState extends State<GoldenTicketClaimDialog> {
  GTicketStatus gtStatus;
  bool isRedeeming = false;
  bool showConfetti = false;
  TextEditingController codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  redeem() {
    if (!formKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() {
      isRedeeming = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        gtStatus = GTicketStatus.invalid;
        //showConfetti = true;
        isRedeeming = false;
      });
    }).then((value) {
      Future.delayed(Duration(seconds: 4), () {
        if (showConfetti)
          setState(() {
            showConfetti = false;
          });
      });
    });
  }

  getTitle() {
    if (gtStatus == GTicketStatus.none)
      return "Redeem your Golden Ticket";
    else if (gtStatus == GTicketStatus.redeemed)
      return "Redeem sucess";
    else if (gtStatus == GTicketStatus.invalid)
      return "Invalid Ticket";
    else if (gtStatus == GTicketStatus.blocked) return "Blocked Ticket";
  }

  tryAgain() {
    setState(() {
      gtStatus = GTicketStatus.none;
    });
  }

  @override
  void initState() {
    gtStatus = GTicketStatus.none;
    super.initState();
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            color: Color(0xffFFFABF),
                          ),
                          height: SizeConfig.largeTextSize * 3,
                          alignment: Alignment.center,
                          child: Text(
                            getTitle(),
                            style: TextStyle(
                              fontSize: SizeConfig.largeTextSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        getContent(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            color: Color(0xff08715E),
                          ),
                          height: SizeConfig.mediumTextSize * 4,
                          alignment: Alignment.center,
                          child: Text(
                            "Know more about Golden Ticket",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.wavy,
                                fontSize: SizeConfig.mediumTextSize,
                                color: Colors.white),
                          ),
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
                          if (!isRedeeming) {
                            AppState.backButtonDispatcher.didPopRoute();
                          }
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
                      fit: BoxFit.fitHeight, repeat: false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  getContent() {
    if (gtStatus == GTicketStatus.none)
      return redeemContent();
    else if (gtStatus == GTicketStatus.redeemed)
      return successRedeemContent();
    else if (gtStatus == GTicketStatus.invalid) return invalidContent();
  }

  Widget redeemContent() {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
          // image: DecorationImage(image: NetworkImage(""), fit: BoxFit.cover),
          ),
      child: Stack(
        children: [
          Positioned(
            bottom: -(SizeConfig.screenWidth * 0.3),
            child: Container(
              width: SizeConfig.screenWidth * 0.84,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 1,
                    child: Image.network(
                      "https://image.freepik.com/free-vector/lottery-isometric-design-concept-with-scratching-instant-cards-lottery-tickets-gift-boxes-rotating-drum_1284-61628.jpg",
                      width: SizeConfig.screenWidth * 0.84,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.84,
            padding: EdgeInsets.all(SizeConfig.globalMargin * 1.5),
            child: Column(
              children: [
                isRedeeming
                    ? SizedBox(
                        height: SizeConfig.screenHeight * 0.12,
                        child: Center(
                          child: SpinKitThreeBounce(
                            color: UiConstants.primaryColor,
                            size: 20,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "ENTER YOUR CODE",
                              style: TextStyle(
                                  letterSpacing: 5,
                                  fontSize: SizeConfig.mediumTextSize,
                                  color: Colors.black54),
                            ),
                          ),
                          Container(
                            width: SizeConfig.screenWidth * 0.6,
                            child: Form(
                              key: formKey,
                              child: TextFormField(
                                autofocus: true,
                                textAlign: TextAlign.center,
                                cursorColor: Colors.black,
                                cursorHeight: SizeConfig.cardTitleTextSize,
                                cursorWidth: 1,
                                showCursor: false,
                                textCapitalization:
                                    TextCapitalization.characters,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 5,
                                  decorationThickness: 0.0,
                                  decorationColor: Color(0xffFFFEF3),
                                  decoration: TextDecoration.none,
                                  fontSize: SizeConfig.cardTitleTextSize,
                                  color: Colors.brown[900],
                                ),
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.brown,
                                    ),
                                  ),
                                ),
                                controller: codeController,
                                validator: (val) {
                                  if (val.length != 5) {
                                    return "Please enter 5 digit code";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: augmontGoldPalette.primaryColor),
                            onPressed: () => redeem(),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Text(
                                  'Claim',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: SizeConfig.mediumTextSize,
                                  ),
                                )),
                          ),
                        ],
                      ),
                SizedBox(
                  height: SizeConfig.screenWidth * 0.36,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget successRedeemContent() {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
          // image: DecorationImage(image: NetworkImage(""), fit: BoxFit.cover),
          ),
      child: Stack(
        children: [
          // Positioned(
          //   right: -20,
          //   bottom: 0,
          //   child: Container(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Opacity(
          //           opacity: 0.8,
          //           child: Image.asset(
          //             "images/home-pick-card-asset.png",
          //             width: SizeConfig.screenWidth * 0.6,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Container(
            width: SizeConfig.screenWidth * 0.84,
            child: Column(
              children: [
                SizedBox(height: 16),
                Text(
                  "Congratulations",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.cardTitleTextSize,
                    color: UiConstants.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "15 new Tambola Tickets got\ncredited to your account"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.asset(
                    "images/doge.gif",
                    height: SizeConfig.screenWidth * 0.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Now you are even one step closer to win a\nFull House 😎",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.mediumTextSize,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget invalidContent() {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.asset(
            "images/gt-not-found.png",
            height: SizeConfig.screenWidth * 0.5,
          ),
        ),
        Text(
          "This ticket does not exist",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.largeTextSize,
            color: Colors.brown[900],
          ),
        ),
        InkWell(
          onTap: tryAgain,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              "TRY AGAIN",
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: SizeConfig.mediumTextSize,
                  color: UiConstants.primaryColor,
                  letterSpacing: 4),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
