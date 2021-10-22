import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/texts/breathing_text_widget.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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

    return AspectRatio(
      aspectRatio: 366 / 600,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Material(
              child: Container(
                width: 366,
                height: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage("images/prize-confetti-bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Image.asset("images/fello-dark.png", height: 32),
                    SizedBox(height: 16),
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
                          fontSize: 32),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${widget.username.split(' ').first}!",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    widget.dpUrl != null
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(widget.dpUrl),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(width: 3, color: Colors.white),
                            ),
                          )
                        : SizedBox(height: 20),
                    Container(
                      child: FittedBox(
                        child: Text(
                          "र ${widget.prizeAmount}",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                color: Colors.black26,
                              )
                            ],
                            fontWeight: FontWeight.w700,
                            fontSize: 60,
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
                        widget.claimChoice == PrizeClaimChoice.AMZ_VOUCHER
                            ? "images/amazon-share.png"
                            : "images/augmont-share.png",
                        height: SizeConfig.screenHeight * 0.08,
                      ),
                    ),
                    Text(
                      widget.claimChoice == PrizeClaimChoice.AMZ_VOUCHER
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
            ),
          ),
        ],
      ),
    );
  }
}
