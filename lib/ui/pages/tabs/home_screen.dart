import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
          color: Color(0xfff1f1f1),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: height * 0.45,
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
                  padding: EdgeInsets.only(left: width * 0.05),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        height: height * 0.08,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.only(
                          top: 100,
                          bottom: 50,
                        ),
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              height: width * 0.25,
                              width: width * 0.25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 5,
                                  )),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset("images/profile.png",
                                    fit: BoxFit.cover),
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
                                  "GOOD MORNING!",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: height * 0.03),
                                ),
                                Text(
                                  "Robert",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: height * 0.02),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      HomeCard(
                        title: "SAVE | PLAY | EARN",
                        asset: "images/tickets.png",
                        subtitle:
                            "New to Fello?? No worries.\nLet's get started with a new way of saving money.",
                        buttonText: "Learn how Fello works",
                        onPressed: () {},
                        gradient: [
                          Color(0xffACB6E5),
                          Color(0xff74EBD5),
                        ],
                      ),
                      HomeCard(
                        title: "Want more tambola tickets?",
                        asset: "images/referral-asset.png",
                        subtitle:
                            "Refer a friend Fello and we'll throw tickets worth of ₹1000 to both the accounts",
                        buttonText: "Share now",
                        onPressed: () {},
                        gradient: [
                          Color(0xffD4AC5B),
                          Color(0xffDECBA4),
                        ],
                      ),
                      HomeCard(
                        title: "Suggest us another game",
                        asset: "images/puzzle.png",
                        subtitle:
                            "What other games you'd like to paly on Fello? We are planning to add another game.",
                        buttonText: "Vote now",
                        onPressed: () {},
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(
        bottom: 30,
        right: width * 0.05,
      ),
      height: height * 0.28,
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
                height: height * 0.25,
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
                      fontSize: width * 0.08),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontSize: width * 0.035),
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
