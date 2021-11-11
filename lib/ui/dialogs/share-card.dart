import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ShareCard extends StatefulWidget {
  final String username, dpUrl;
  final double prizeAmount;
  final PrizeClaimChoice claimChoice;

  ShareCard({
    this.claimChoice,
    this.dpUrl,
    this.prizeAmount,
    this.username,
  });

  @override
  _ShareCardState createState() => _ShareCardState();
}

class _ShareCardState extends State<ShareCard> {
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool isCapturing = true;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);

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
                  Image.asset("images/fello-dark.png", height: 50),
                  SizedBox(height: 16),
                  // Text(
                  //   "Congratulations",
                  //   style: GoogleFonts.megrim(
                  //       color: Colors.white,
                  //       shadows: [
                  //         Shadow(
                  //           offset: Offset(2, 2),
                  //           color: Colors.white24,
                  //           blurRadius: 2,
                  //         )
                  //       ],
                  //       fontWeight: FontWeight.w700,
                  //       letterSpacing: 3,
                  //       fontSize: 32),
                  // ),
                  // SizedBox(height: 8),
                  // Text(
                  //   "${widget.username.split(' ').first}!",
                  //   style: GoogleFonts.montserrat(
                  //     color: Colors.white,
                  //     height: 1.3,
                  //     fontWeight: FontWeight.w700,
                  //     fontSize: 28,
                  //   ),
                  // ),
                  // widget.dpUrl != null
                  //     ? Container(
                  //         margin: EdgeInsets.symmetric(vertical: 20),
                  //         height: 120,
                  //         width: 120,
                  //         decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           image: DecorationImage(
                  //             image: CachedNetworkImageProvider(
                  //                 widget.dpUrl),
                  //             fit: BoxFit.cover,
                  //           ),
                  //           border:
                  //               Border.all(width: 3, color: Colors.white),
                  //         ),
                  //       )
                  //     : SizedBox(height: 20),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      widget.claimChoice == PrizeClaimChoice.AMZ_VOUCHER
                          ? "images/amazon-share.png"
                          : "images/augmont-share.png",
                      height: 140,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      widget.claimChoice == PrizeClaimChoice.AMZ_VOUCHER
                          ? "I won Amazon Gift Voucher\nof worth"
                          : "I won Augmont Digital Gold\nof worth",
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
                          text: "र ",
                          style: GoogleFonts.sourceSansPro(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                color: Colors.black26,
                              )
                            ],
                            fontWeight: FontWeight.w500,
                            fontSize: 60,
                          ),
                          children: [
                            TextSpan(
                              text: "${widget.prizeAmount.round()}",
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
