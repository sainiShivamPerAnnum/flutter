import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage("images/prize-share-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "images/fello_logo.png",
                    height: 40,
                  ),
                ],
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
                height: 150,
                child: Stack(
                  children: [
                    Center(
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          "images/prize-confetti-share.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "र $prizeAmount",
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          height: 1.3,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              color: Colors.white30,
                              blurRadius: 5,
                            )
                          ],
                          fontWeight: FontWeight.w800,
                          fontSize: SizeConfig.screenWidth * 0.12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
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
              )
            ],
          ),
        ),
      ],
    );
  }
}
