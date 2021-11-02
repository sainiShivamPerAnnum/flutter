import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PrizeSection extends StatelessWidget {
  const PrizeSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
        gradient: LinearGradient(
          colors: [Color(0xff7C83FD), Color(0xff96BAFF)],
          begin: Alignment.bottomCenter,
          end: Alignment.topRight,
        ),
      ),
      margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Opacity(
              opacity: 0.2,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(SizeConfig.cardBorderRadius),
                child: SvgPicture.asset(
                  "images/Tambola/gifts.svg",
                  width: SizeConfig.screenWidth,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: Text(
                    "Prizes",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/Tambola/p-rows.png"),
                          SizedBox(height: 10),
                          Text(
                            "Any Row",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "₹ ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_WIN_TOP)}",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: SizeConfig.cardTitleTextSize * 1.4,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: Offset(4, 4),
                                        spreadRadius: 2,
                                        blurRadius: 2)
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 2),
                            decoration: BoxDecoration(
                                color: Color(0xff5B51E7),
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.apps,
                              color: Colors.white,
                              size: SizeConfig.screenWidth * 0.14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Full House",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              '₹ ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_WIN_FULL)}',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: SizeConfig.cardTitleTextSize * 2,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(4, 4),
                                        spreadRadius: 4,
                                        blurRadius: 4)
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 1),
                            decoration: BoxDecoration(
                                color: Color(0xffE9E9E9),
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.border_outer_rounded,
                              color: Color(0xff264653),
                              size: SizeConfig.screenWidth * 0.1,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Corners",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "₹ ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_WIN_CORNER)}",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: SizeConfig.cardTitleTextSize,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: Offset(4, 4),
                                        spreadRadius: 4,
                                        blurRadius: 4)
                                  ]),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
