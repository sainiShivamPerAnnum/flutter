import 'package:felloapp/ui/widgets/button4.0/appBar_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreGames extends StatelessWidget {
  const MoreGames({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      height: SizeConfig.screenWidth * 0.218,
      width: SizeConfig.screenWidth * 0.901,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              height: SizeConfig.screenWidth * 0.170,
              width: SizeConfig.screenWidth * 0.170,
              child: Image.asset(
                'assets/images/game_01.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tamblo',
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
          Spacer(),
          AppBarButton(
            svgAsset: 'assets/svg/token_svg.svg',
            coin: '30',
            borderColor: Colors.white10,
            screenWidth: SizeConfig.screenWidth * 0.18,
            onTap: () {},
            style: GoogleFonts.sourceSansPro(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}