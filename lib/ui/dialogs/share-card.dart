import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareCard extends StatelessWidget {
  final String username, dpUrl;
  final double prizeAmount;
  final PrizeClaimChoice claimChoice;

  ShareCard({this.claimChoice, this.dpUrl, this.prizeAmount, this.username});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          width: SizeConfig.screenWidth * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage("images/prize-confetti-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Image.asset(
                "images/fello-dark.png",
                height: 40,
              ),
              SizedBox(height: 20),
              Text(
                "Congratulations",
                style: GoogleFonts.megrim(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        color: Colors.white24,
                        blurRadius: 2,
                      )
                    ],
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    fontSize: SizeConfig.cardTitleTextSize),
              ),
              SizedBox(height: 10),
              Text(
                "${username.split(' ').first}!",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.cardTitleTextSize,
                ),
              ),
              dpUrl != null
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      height: SizeConfig.screenWidth * 0.4,
                      width: SizeConfig.screenWidth * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(dpUrl),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(width: 5, color: Colors.white),
                      ),
                    )
                  : SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0),
                child: FittedBox(
                  child: Text(
                    "र $prizeAmount",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          color: Colors.black26,
                        )
                      ],
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.cardTitleTextSize * 2.4,
                    ),
                  ),
                ),
              ),
              Text(
                "rewarded as",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.largeTextSize,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  claimChoice == PrizeClaimChoice.AMZ_VOUCHER
                      ? "images/amazon-share.png"
                      : "images/augmont-share.png",
                  height: SizeConfig.screenHeight * 0.08,
                ),
              ),
              Text(
                claimChoice == PrizeClaimChoice.AMZ_VOUCHER
                    ? "Amazon Gift Voucher"
                    : "Augmont Digital Gold",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.largeTextSize,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "images/svgs/web.svg",
                      height: SizeConfig.mediumTextSize,
                      width: SizeConfig.mediumTextSize,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "fello.in",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: SizeConfig.smallTextSize * 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
