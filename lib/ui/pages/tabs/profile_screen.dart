import 'package:felloapp/util/ui_constants.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/ui/pages/transactions.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.02),
      decoration: BoxDecoration(
        color: Color(0xfff1f1f1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: AppBar().preferredSize.height * 1.5,
            ),
            Container(
              // margin: EdgeInsets.symmetric(
              //     horizontal: height * 0.008),
              height: height * 0.24,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "images/profile-card.png",
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(height * 0.008),
                width: double.infinity,
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     IconButton(
                    //       icon: Icon(
                    //         Icons.edit,
                    //         color: Colors.white,
                    //       ),
                    //       onPressed: () {},
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/profile.png",
                            height: width * 0.25,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: width * 0.5,
                                child: Text(
                                  "Username ",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: height * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Member since 1947",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: height * 0.015,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: SizeConfig.blockSizeHorizontal * 4,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Tap to edit details",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              child: Column(
                children: [
                  ProfileTabTile(
                    logo: "images/contact-book.png",
                    title: "Username",
                    value: "@HELPK0874L",
                    onPress: () {},
                  ),
                  ProfileTabTile(
                    logo: "images/transaction.png",
                    title: "Transactions",
                    value: "12",
                    onPress: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (ctx) => Transactions()));
                    },
                  ),
                  ProfileTabTile(
                    logo: "images/referrals.png",
                    title: "Referrals",
                    value: "06",
                    onPress: () {},
                  ),
                ],
              ),
            ),
            ShareCard(),
            SizedBox(
              height: 50,
            ),
            Social(),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class Social extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.screenWidth,
        child: Column(children: [
          Text(
            "Connect With us",
            style: GoogleFonts.montserrat(
              color: Color(0xff333333),
              fontSize: SizeConfig.screenHeight * 0.02,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(
              backgroundColor: UiConstants.primaryColor,
              child: Icon(
                FlatIcons.con_instagram,
                size: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            CircleAvatar(
              backgroundColor: UiConstants.primaryColor,
              child: Icon(
                FlatIcons.con_linkedin,
                size: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            CircleAvatar(
              backgroundColor: UiConstants.primaryColor,
              child: Icon(
                FlatIcons.worldwide,
                size: 16,
                color: Colors.white,
              ),
            ),
          ])
        ]));
  }
}

class ShareCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.25,
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2),
        height: SizeConfig.screenHeight * 0.24,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: new LinearGradient(
              colors: [
                Color(0xff4E4376),
                Color(0xff2B5876),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xff4E4376).withOpacity(0.3),
                offset: Offset(5, 5),
                blurRadius: 10,
              ),
              BoxShadow(
                color: Color(0xff2B5876).withOpacity(0.3),
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
                  "images/share-card.png",
                  height: SizeConfig.screenHeight * 0.25,
                  width: SizeConfig.screenWidth * 0.5,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹ 25 on every referal",
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
                  Text(
                    "Share Fello with your friends and family and get ₹25 each.",
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: SizeConfig.mediumTextSize),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardButton(
                        gradient: [
                          Color(0xff4E4376),
                          Color(0xff2B5876),
                        ],
                        icon: FlatIcons.share,
                        onPressed: () {},
                        text: "Share",
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      CardButton(
                        gradient: [
                          Color(0xff4E4376),
                          Color(0xff2B5876),
                        ],
                        icon: FlatIcons.con_whatsapp,
                        onPressed: () {},
                        text: "Share on whatsapp",
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final IconData icon;
  final List<Color> gradient;

  CardButton({this.gradient, this.icon, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
        child: Row(
          children: [
            Text(
              text,
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: SizeConfig.screenWidth * 0.035),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class ProfileTabTile extends StatelessWidget {
  final String logo, title, value;
  final Function onPress;

  ProfileTabTile({this.logo, this.onPress, this.title, this.value});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              logo,
              height: SizeConfig.screenHeight * 0.02,
              width: SizeConfig.screenHeight * 0.02,
            ),
            title: Text(
              title,
              style: GoogleFonts.montserrat(
                color: Color(0xff333333),
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
            trailing: Text(
              value,
              style: GoogleFonts.montserrat(
                color: UiConstants.primaryColor,
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
            onTap: onPress,
          ),
          Divider(
            endIndent: width * 0.1,
            indent: width * 0.1,
          ),
        ],
      ),
    );
  }
}
