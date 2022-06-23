import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../util/styles/size_config.dart';
import '../button4.0/appBar_button.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      height: SizeConfig.screenWidth * 0.688,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.474,
            width: SizeConfig.screenWidth,
            child: SvgPicture.asset(
              'assets/svg/game_svg.svg',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: SizeConfig.screenWidth * 0.213,
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
                        fontSize: 22,
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
                            height: 22,
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
                Spacer(),
                AppBarButton(
                  svgAsset: 'assets/svg/token_svg.svg',
                  coin: '30',
                  borderColor: Colors.white10,
                  screenWidth: SizeConfig.screenWidth * 0.18,
                  onTap: () {},
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
