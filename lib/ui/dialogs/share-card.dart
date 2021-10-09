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

  ShareCard({this.claimChoice, this.dpUrl, this.prizeAmount, this.username});

  @override
  _ShareCardState createState() => _ShareCardState();
}

class _ShareCardState extends State<ShareCard> {
  final GlobalKey imageKey = GlobalKey();
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool isCapturing = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 1), () {
        captureCard().then((image) => image != null ? shareCard(image) : () {});
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (baseProvider != null) super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher.didPopRoute();
        return Future.value(true);
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Wrap(
              children: [
                Transform.scale(
                  scale: 0.7,
                  child: RepaintBoundary(
                    key: imageKey,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        child: Container(
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
                                "${widget.username.split(' ').first}!",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  height: 1.3,
                                  fontWeight: FontWeight.w700,
                                  fontSize: SizeConfig.cardTitleTextSize,
                                ),
                              ),
                              widget.dpUrl != null
                                  ? Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      height: SizeConfig.screenWidth * 0.4,
                                      width: SizeConfig.screenWidth * 0.4,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              widget.dpUrl),
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(
                                            width: 5, color: Colors.white),
                                      ),
                                    )
                                  : SizedBox(height: 20),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 0),
                                child: FittedBox(
                                  child: Text(
                                    "र ${widget.prizeAmount}",
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
                                      fontSize:
                                          SizeConfig.cardTitleTextSize * 2.4,
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
                                  widget.claimChoice ==
                                          PrizeClaimChoice.AMZ_VOUCHER
                                      ? "images/amazon-share.png"
                                      : "images/augmont-share.png",
                                  height: SizeConfig.screenHeight * 0.08,
                                ),
                              ),
                              Text(
                                widget.claimChoice ==
                                        PrizeClaimChoice.AMZ_VOUCHER
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
                                        fontSize:
                                            SizeConfig.smallTextSize * 1.2,
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
                  ),
                ),
              ],
            ),
          ),
          isCapturing
              ? Positioned(
                  bottom: SizeConfig.screenHeight * 0.1,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      alignment: Alignment.center,
                      child: Text(
                        "Please wait..",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.largeTextSize,
                        ),
                      ),
                    ),
                  ),
                )
              : Text("")
          // Align(
          //   alignment: Alignment.center,
          //   child: Material(
          //     color: Colors.transparent,
          //     child: isCapturing
          //         ? Container(
          //             padding: EdgeInsets.all(8),
          //             width: 50,
          //             height: 50,
          //             decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(8)),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 SpinKitThreeBounce(
          //                   color: UiConstants.primaryColor,
          //                   size: 16,
          //                 )
          //               ],
          //             ),
          //           )
          //         : SizedBox,
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<Uint8List> captureCard() async {
    try {
      RenderRepaintBoundary imageObject =
          imageKey.currentContext.findRenderObject();
      final image = await imageObject.toImage(pixelRatio: 2);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      if (baseProvider.myUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Share reward card creation failed'
        };
        dbProvider.logFailure(baseProvider.myUser.uid,
            FailType.FelloRewardCardShareFailed, errorDetails);
      }

      AppState.backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(
          "Task Failed", "Unable to capture the card at the moment");
    }
    return null;
  }

  shareCard(Uint8List image) async {
    try {
      setState(() {
        isCapturing = false;
      });
      if (Platform.isAndroid) {
        final directory = (await getExternalStorageDirectory()).path;
        String dt = DateTime.now().toString();
        File imgg = new File('$directory/fello-reward-$dt.png');
        imgg.writeAsBytesSync(image);
        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text:
              'Fello is a really rewarding way to play games and invest in assets! Save and play with me and get rewarded: https://fello.in/download/app',
        ).catchError((onError) {
          if (baseProvider.myUser.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            dbProvider.logFailure(baseProvider.myUser.uid,
                FailType.FelloRewardCardShareFailed, errorDetails);
          }
          print(onError);
        });
      } else if (Platform.isIOS) {
        final directory = (await getTemporaryDirectory());
        if (!await directory.exists()) await directory.create(recursive: true);
        String dt = DateTime.now().toString();
        File imgg = new File('${directory.path}/fello-reward-$dt.png');
        imgg.writeAsBytesSync(image);
        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text:
              'Fello is a really rewarding way to play games and invest in assets! Save and play with me and get rewarded: https://fello.in/download/app',
        ).catchError((onError) {
          if (baseProvider.myUser.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            dbProvider.logFailure(baseProvider.myUser.uid,
                FailType.FelloRewardCardShareFailed, errorDetails);
          }
          print(onError);
        });
      }
    } catch (e) {
      // backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(
          "Task Failed", "Unable to share the picture at the moment");
    }
  }
}
