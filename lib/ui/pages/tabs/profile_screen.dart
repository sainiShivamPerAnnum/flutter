import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(height * 0.016),
      decoration: BoxDecoration(
        color: Color(0xfff1f1f1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: ListView(
        children: [
          SizedBox(
            height: height * 0.07,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      )
                    ],
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
                      Text(
                        "Tap for more details",
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
                  onPress: () {},
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
        ],
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
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              logo,
              height: 30,
              width: 30,
            ),
            title: Text(
              title,
              style: GoogleFonts.montserrat(
                color: Color(0xff333333),
                fontSize: height * 0.02,
              ),
            ),
            trailing: Text(
              value,
              style: GoogleFonts.montserrat(
                color: UiConstants.primaryColor,
                fontSize: height * 0.02,
              ),
            ),
            onTap: onPress,
            contentPadding: EdgeInsets.symmetric(
              vertical: 8,
            ),
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
