import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingGames extends StatelessWidget {
  const TrendingGames({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      height: SizeConfig.screenWidth * 0.688,
      width: SizeConfig.screenWidth * 0.610,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.309,
            width: SizeConfig.screenWidth,
            child: SvgPicture.asset(
              'assets/svg/game_svg.svg',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: SizeConfig.screenWidth * 0.160,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              color: Color(0xff39393C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    height: SizeConfig.screenWidth * 0.118,
                    width: SizeConfig.screenWidth * 0.117,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/game_svg.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cricket',
                      style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/gift_svg.svg',
                            height: 18,
                          ),
                          Text(
                            'Win upto Rs.25,000',
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'assets/images/token_logo.png',
                        height: 15,
                      ),
                      Text(
                        '30',
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
