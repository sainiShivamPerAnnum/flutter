import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingGames extends StatelessWidget {
  final String networkAsset;
  final String gameName;
  const TrendingGames({
    this.networkAsset,
    this.gameName,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal:SizeConfig.padding16),
      height: SizeConfig.screenWidth * 0.688,
      width: SizeConfig.screenWidth * 0.610,
      decoration: BoxDecoration(
        color: Color(0xff39393C),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: SizeConfig.padding4,left: SizeConfig.padding6,right: SizeConfig.padding6),
            height: SizeConfig.screenWidth * 0.309,
            width: SizeConfig.screenWidth*0.578,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.roundness8),
                topRight: Radius.circular(SizeConfig.roundness8),
              ),
              child: Image.network(
                networkAsset,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(left: SizeConfig.padding8,top: SizeConfig.padding12,bottom: SizeConfig.padding16),
                child: Text(
                  '$gameName ChampionShip',
                  style: GoogleFonts.rajdhani(
                    fontSize: SizeConfig.body2,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(right: SizeConfig.padding12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/token_logo.png',
                          height: SizeConfig.padding16,
                        ),
                        Text(
                          '30',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: SizeConfig.body3,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(left: SizeConfig.padding8),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/gift_svg.svg',
                      height: SizeConfig.padding16,
                    ),
                    Text(
                      'Win upto Rs.25,000',
                      style: GoogleFonts.sourceSansPro(
                        fontSize: SizeConfig.body4,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
