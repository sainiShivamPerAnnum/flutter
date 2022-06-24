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
      margin:  EdgeInsets.all(SizeConfig.padding16),
      height: SizeConfig.screenWidth * 0.688,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Column(
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.474,
            width: SizeConfig.screenWidth,
            child: Image.network(
              'https://fello-assets.s3.ap-south-1.amazonaws.com/cricket-thumbnail-2022.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: SizeConfig.screenWidth * 0.213,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              color: Color(0xff39393C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.roundness8),
                bottomRight: Radius.circular(SizeConfig.roundness8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                  child: Container(
                    height: SizeConfig.screenWidth * 0.118,
                    width: SizeConfig.screenWidth * 0.117,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(SizeConfig.padding4),
                    ),
                    child: Image.network(
                      'https://fello-assets.s3.ap-south-1.amazonaws.com/cricket-thumbnail-2022.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cricket',
                      style: GoogleFonts.rajdhani(
                        fontSize: SizeConfig.title5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/gift_svg.svg',
                          height: SizeConfig.padding20,
                        ),
                        Text(
                          'Win upto Rs.25,000',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: SizeConfig.body4,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                AppBarButton(
                  svgAsset: 'assets/svg/token_svg.svg',
                  coin: '30',
                  borderColor: Colors.transparent,
                  screenWidth: SizeConfig.screenWidth * 0.18,
                  onTap: () {},
                  style: GoogleFonts.sourceSansPro(
                    fontSize: SizeConfig.title4,
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
