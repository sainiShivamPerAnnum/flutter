import 'package:felloapp/ui/widgets/button4.0/appBar_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreGames extends StatelessWidget {
  final String assetURL;
  final String gameName;
  const MoreGames({
    this.assetURL,
    this.gameName,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.all(SizeConfig.padding16),
      height: SizeConfig.screenWidth * 0.218,
      width: SizeConfig.screenWidth * 0.901,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Row(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            child: Container(
              height: SizeConfig.screenWidth * 0.170,
              width: SizeConfig.screenWidth * 0.170,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                child: Image.network(
                  assetURL,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gameName,
                style: GoogleFonts.rajdhani(
                  fontSize: SizeConfig.body2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/gift_svg.svg',
                    height: SizeConfig.padding16,
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
              fontSize: SizeConfig.body2,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}