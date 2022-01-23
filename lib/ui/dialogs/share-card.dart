import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareCard extends StatelessWidget {
  final String dpUrl;
  final double prizeAmount;
  final PrizeClaimChoice claimChoice;

  ShareCard({
    this.claimChoice,
    this.dpUrl,
    this.prizeAmount,
  });

  getImage() {
    switch (claimChoice) {
      case PrizeClaimChoice.AMZ_VOUCHER:
        return "images/amazon-share.png";
        break;
      case PrizeClaimChoice.GOLD_CREDIT:
        return "images/augmont-share.png";
        break;
      default:
        return "assets/images/fello_prize.png";
    }
  }

  getTitle() {
    switch (claimChoice) {
      case PrizeClaimChoice.AMZ_VOUCHER:
        return "You've won an Amazon Gift Voucher\n worth";
        break;
      case PrizeClaimChoice.GOLD_CREDIT:
        return "You've won Digital Gold\n worth";
        break;
      default:
        return "You've won Fello Rewards\n worth";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Material(
        child: Container(
          width: 366,
          height: 480,
          decoration: BoxDecoration(
            color: UiConstants.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Image.asset(
                  Assets.splashBackground,
                  width: SizeConfig.screenWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Spacer(),
                      Image.asset("images/fello_logo.png", height: 36),
                      SizedBox(
                        width: 16,
                      )
                    ],
                  ),

                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      getImage(),
                      height: 140,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      getTitle(),
                      textAlign: TextAlign.center,
                      style: TextStyles.body1.bold
                          .colour(Colors.white)
                          .setHeight(1.6),
                    ),
                  ),

                  Container(
                    child: FittedBox(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "₹ ",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                color:
                                    UiConstants.tertiarySolid.withOpacity(0.3),
                              )
                            ],
                            fontWeight: FontWeight.w500,
                            fontSize: 80,
                          ),
                          children: [
                            TextSpan(
                              text: "${prizeAmount.toInt()}",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 10,
                                    color: UiConstants.tertiarySolid
                                        .withOpacity(0.3),
                                  )
                                ],
                                fontWeight: FontWeight.w600,
                                fontSize: 80,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Text(
                  //   "rewarded as",
                  //   style: GoogleFonts.montserrat(
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: SizeConfig.largeTextSize,
                  //   ),
                  // ),
                  Spacer(),
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
                          style: TextStyles.body3.colour(Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
