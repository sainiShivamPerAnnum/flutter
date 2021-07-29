import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/fold-card.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/util/fundPalettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class FCard extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  final bool isClaimed;
  final double unclaimedPrize;
  final Function onComplete;

  const FCard({
    Key key,
    this.isClaimed,
    this.unclaimedPrize,
    this.onComplete,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TicketState();
}

class _TicketState extends State<FCard> {
  Widget frontCard;
  Widget topCard;
  Widget middleCard;
  Widget bottomCard;
  bool _isOpen;
  PrizeClaimChoice claimtype;
  BaseUtil baseProvider;
  HttpModel httpProvider;
  bool _isPrizeProcessing = false;
  bool _tChoice;

  LinearGradient cardGradient = const LinearGradient(
      //colors: [Color(0xff7F00FF), Color(0xffE100FF)],
      //colors: [Color(0xff01937C), Color(0xffB6C867)],
      colors: [Color(0xfffbc7d4), Color(0xff9796f0)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  Widget get backCard => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Color(0xff01937C),
        ),
      );

  @override
  void initState() {
    super.initState();
    AppState.screenStack.add(ScreenItem.dialog);
    _isOpen = false;
    _tChoice = widget.isClaimed;
    claimtype = PrizeClaimChoice.NA;
    frontCard = CloseCard(
      unclaimedPrize: widget.unclaimedPrize,
      claimtype: claimtype,
      isClaimed: widget.isClaimed,
      onClose: widget.onComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    httpProvider = Provider.of<HttpModel>(context);
    bottomCard = buildBottomCard();
    middleCard = buildMiddleCard();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FoldingCard(
            entries: _getEntries(), isOpen: _isOpen, onClick: _handleOnTap),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
              icon: Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                if (!_isPrizeProcessing) {
                  _isOpen
                      ? setState(() {
                          _isOpen = false;
                        })
                      : backButtonDispatcher.didPopRoute();
                }
              }),
        )
      ],
    );
  }

  List<FoldEntry> _getEntries() {
    return [
      FoldEntry(height: SizeConfig.screenHeight * 0.23, front: topCard),
      FoldEntry(
          height: SizeConfig.screenHeight * 0.23,
          front: middleCard,
          back: frontCard),
      FoldEntry(height: 100.0, front: bottomCard, back: backCard)
    ];
  }

  void _handleOnTap() {
    //widget.onClick();
    if (!_tChoice)
      setState(() {
        _isOpen = true;
        topCard = buildTopCard();
      });
  }

  Widget buildTopCard() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
      decoration: BoxDecoration(
        // gradient: cardGradient,
        image: DecorationImage(
            image: AssetImage("images/prize-share-bg.png"), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(
                  "images/fello-dark.png",
                  width: SizeConfig.screenWidth * 0.12,
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Lottie.asset("images/lottie/clap.json", repeat: false),
              ),
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
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
            ),
            SizedBox(height: 20),
            Text(
              "Your current prize balance is:",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget buildMiddleCard() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/prize-share-bg.png"), fit: BoxFit.cover),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "र ${widget.unclaimedPrize}",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  height: 1.3,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      color: Colors.black26,
                      blurRadius: 5,
                    )
                  ],
                  fontWeight: FontWeight.w800,
                  fontSize: SizeConfig.cardTitleTextSize * 2.4,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "How would you like to redeem it?",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.mediumTextSize,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.04),
                child: Lottie.asset(
                  "images/lottie/amazon.json",
                  height: SizeConfig.screenWidth * 0.12,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "OR",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Lottie.asset(
                "images/lottie/gold-prize.json",
                height: SizeConfig.screenWidth * 0.2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomCard() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/prize-share-bg.png"), fit: BoxFit.cover),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: _isPrizeProcessing
          ? Center(
              child: SpinKitThreeBounce(
                color: UiConstants.spinnerColor2,
                size: 18.0,
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isPrizeProcessing = true;
                      });
                      _registerClaimChoice(PrizeClaimChoice.AMZ_VOUCHER)
                          .then((flag) {
                        if (flag) {
                          _tChoice = true;
                          setState(() {
                            _isPrizeProcessing = false;
                            claimtype = PrizeClaimChoice.AMZ_VOUCHER;
                            frontCard = CloseCard(
                              claimtype: claimtype,
                              unclaimedPrize: widget.unclaimedPrize,
                              isClaimed: true,
                              onClose: widget.onComplete,
                            );
                            _isOpen = false;
                          });
                        } else {
                          baseProvider.showNegativeAlert('Failed to send claim',
                              'Please try again in some time', context);
                          setState(() {
                            _isPrizeProcessing = false;
                          });
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    child: FittedBox(
                      child: Text(
                        "Amazon Gift Card ",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isPrizeProcessing = true;
                      });
                      _registerClaimChoice(PrizeClaimChoice.GOLD_CREDIT)
                          .then((flag) {
                        _tChoice = true;
                        if (flag) {
                          setState(() {
                            _isPrizeProcessing = false;
                            claimtype = PrizeClaimChoice.GOLD_CREDIT;
                            frontCard = CloseCard(
                              claimtype: claimtype,
                              unclaimedPrize: widget.unclaimedPrize,
                              isClaimed: true,
                              onClose: widget.onComplete,
                            );

                            _isOpen = false;
                          });
                        } else {
                          baseProvider.showNegativeAlert('Failed to send claim',
                              'Please try again in some time', context);
                          setState(() {
                            _isPrizeProcessing = false;
                          });
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.amber),
                    ),
                    child: FittedBox(
                      child: Text(
                        "Digital Gold ",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<bool> _registerClaimChoice(PrizeClaimChoice choice) async {
    if (choice == PrizeClaimChoice.NA) return false;
    bool flag = await httpProvider.registerPrizeClaim(
        baseProvider.myUser.uid, widget.unclaimedPrize, choice);
    print('Claim choice saved: $flag');
    return flag;
  }
}

class CloseCard extends StatefulWidget {
  final PrizeClaimChoice claimtype;
  final double unclaimedPrize;
  final bool isClaimed;
  final Function onClose;

  CloseCard(
      {this.claimtype, this.unclaimedPrize, this.isClaimed, this.onClose});

  @override
  _CloseCardState createState() => _CloseCardState();
}

class _CloseCardState extends State<CloseCard> {
  BaseUtil baseProvider;
  DBModel dbProvider;

  bool isCapturing = false;
  bool isSaving = false;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  Future<Uint8List> convertWidgetToImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
        scr.currentContext.findRenderObject();
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List();
    return uint8list;
  }

  Widget _buildBeginCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xffF1F1F1),
      ),
      child: Container(
        padding: EdgeInsets.all(
          SizeConfig.blockSizeHorizontal * 4,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Lottie.asset(
                      "images/lottie/winner-crown.json",
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: UiConstants.primaryColor,
                          width: 3,
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: baseProvider.myUserDpUrl != null
                              ? NetworkImage(baseProvider.myUserDpUrl)
                              : AssetImage("images/profile.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3)
                ],
              ),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "Congratulations 🎉",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        color: Color(0xff194350),
                        fontSize: SizeConfig.cardTitleTextSize,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "You have र ${widget.unclaimedPrize} worth of unclaimed rewards!",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              UiConstants.primaryColor,
                              UiConstants.primaryColor.withBlue(200),
                            ],
                            begin: Alignment(0.5, -1.0),
                            end: Alignment(0.5, 1.0)),
                        // border: Border.all(
                        //     color: UiConstants.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 1,
                        vertical: SizeConfig.blockSizeHorizontal * 2),
                    child: FittedBox(
                      child: Text(
                        "Claim",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.mediumTextSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
      decoration: BoxDecoration(
        gradient: widget.claimtype == PrizeClaimChoice.AMZ_VOUCHER
            ? new LinearGradient(
                colors: [Colors.black, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)
            : new LinearGradient(colors: [
                augmontGoldPalette.primaryColor,
                augmontGoldPalette.primaryColor2,
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Lottie.asset(
                "images/lottie/reward-claimed.json",
                repeat: false,
              )),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reward Claimed!",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _getEndCardTitleText(widget.claimtype),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: isCapturing
                          ? SpinKitThreeBounce(
                              color: UiConstants.spinnerColor2,
                              size: 18.0,
                            )
                          : InkWell(
                              onTap: () async {
                                setState(() {
                                  isCapturing = true;
                                });
                                _buildShareCard();
                              },
                              child: Wrap(
                                children: [
                                  Text(
                                    "Brag  📢",
                                    style: GoogleFonts.montserrat(
                                        fontSize: SizeConfig.mediumTextSize,
                                        color: Colors.white,
                                        height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Text("     ", style: TextStyle(color: Colors.white)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: isSaving
                          ? SpinKitThreeBounce(
                              color: UiConstants.spinnerColor2,
                              size: 18.0,
                            )
                          : InkWell(
                              onTap: () async {
                                setState(() {
                                  isSaving = true;
                                });
                                _saveShareCard();
                              },
                              child: Wrap(
                                children: [
                                  Text(
                                    "Save  💾",
                                    style: GoogleFonts.montserrat(
                                        fontSize: SizeConfig.mediumTextSize,
                                        color: Colors.white,
                                        height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);

    print(widget.claimtype);
    return widget.isClaimed ? _buildEndCard(context) : _buildBeginCard(context);
  }

  String _getEndCardTitleText(PrizeClaimChoice choice) {
    if (choice == PrizeClaimChoice.AMZ_VOUCHER)
      return 'Your amazon gift card shall be sent to your registered email and mobile shortly!';
    else if (choice == PrizeClaimChoice.GOLD_CREDIT)
      return 'Your digital gold shall be credited to your Fello wallet shortly!';
    else
      return 'Your prize shall be credited to you soon!';
  }

  // _buildShareCard() async {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => Material(
  //       child: Container(
  //         color: Colors.black.withOpacity(0.5),
  //         child: Column(
  //           children: [
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   children: [
  //                     SizedBox(height: kToolbarHeight),
  //                     ShareCard(
  //                       dpUrl: baseProvider.myUserDpUrl,
  //                       claimChoice: widget.claimtype,
  //                       prizeAmount: baseProvider.userFundWallet.prizeBalance,
  //                       username: baseProvider.myUser.name,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               width: SizeConfig.screenWidth,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   Column(
  //                     children: [
  //                       IconButton(
  //                           onPressed: () => Navigator.pop(context),
  //                           icon: Icon(Icons.ios_share_rounded,
  //                               color: Colors.white)),
  //                       SizedBox(height: 8),
  //                       Text(
  //                         "Share",
  //                         style: GoogleFonts.montserrat(
  //                           color: Colors.white,
  //                           fontSize: SizeConfig.mediumTextSize,
  //                         ),
  //                       ),
  //                       SizedBox(height: 8)
  //                     ],
  //                   ),
  //                   // Expanded(
  //                   //   child: Column(
  //                   //     children: [
  //                   //       IconButton(
  //                   //           onPressed: () => Navigator.pop(context),
  //                   //           icon: Icon(Icons.save_alt_rounded,
  //                   //               color: Colors.white)),
  //                   //       SizedBox(height: 8),
  //                   //       Text(
  //                   //         "Save",
  //                   //         style: GoogleFonts.montserrat(
  //                   //           color: Colors.white,
  //                   //           fontSize: SizeConfig.mediumTextSize,
  //                   //         ),
  //                   //       )
  //                   //     ],
  //                   //   ),
  //                   //),
  //                   Column(
  //                     children: [
  //                       IconButton(
  //                           onPressed: () => Navigator.pop(context),
  //                           icon:
  //                               Icon(Icons.close_rounded, color: Colors.white)),
  //                       Text(
  //                         "Cancel",
  //                         style: GoogleFonts.montserrat(
  //                           color: Colors.white,
  //                           fontSize: SizeConfig.mediumTextSize,
  //                         ),
  //                       )
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  _buildShareCard() async {
    //////ADDING A PRE_CALL DUE TO SCREENSHOT PACKAGE BUG
    baseProvider.myUserDpUrl =
        await dbProvider.getUserDP(baseProvider.myUser.uid);
    await screenshotController.captureFromWidget(ShareCard(
      dpUrl: baseProvider.myUserDpUrl,
      claimChoice: widget.claimtype,
      prizeAmount: baseProvider.userFundWallet.processingRedemptionBalance,
      username: baseProvider.myUser.name,
    ));
    ////////////////////////////////////////////
    screenshotController
        .captureFromWidget(
            ShareCard(
              dpUrl: baseProvider.myUserDpUrl,
              claimChoice: widget.claimtype,
              prizeAmount:
                  baseProvider.userFundWallet.processingRedemptionBalance == 0
                      ? baseProvider.userFundWallet.prizeBalance
                      : baseProvider.userFundWallet.processingRedemptionBalance,
              username: baseProvider.myUser.name,
            ),
            delay: const Duration(seconds: 1))
        .then((Uint8List image) async {
      setState(() {
        isCapturing = false;
      });
      final directory = (await getExternalStorageDirectory()).path;
      String dt = DateTime.now().toString();
      File imgg = new File('$directory/fello-reward-$dt.png');
      imgg.writeAsBytesSync(image);
      Share.shareFiles(
        ['$directory/fello-reward-$dt.png'],
        subject: 'Fello Rewards',
        text:
            'Fello really is a very rewarding way to invest in assets and play games! You should try it out too: https://fello.in/download/android',
      );
    }).catchError((onError) {
      print(onError);
    });
  }

  _saveShareCard() async {
    //////ADDING A PRE_CALL DUE TO SCREENSHOT PACKAGE BUG
    baseProvider.myUserDpUrl =
        await dbProvider.getUserDP(baseProvider.myUser.uid);
    await screenshotController.captureFromWidget(ShareCard(
      dpUrl: baseProvider.myUserDpUrl,
      claimChoice: widget.claimtype,
      prizeAmount: baseProvider.userFundWallet.processingRedemptionBalance,
      username: baseProvider.myUser.name,
    ));
    ////////////////////////////////////////////
    screenshotController
        .captureFromWidget(
            ShareCard(
              dpUrl: baseProvider.myUserDpUrl,
              claimChoice: widget.claimtype,
              prizeAmount:
                  baseProvider.userFundWallet.processingRedemptionBalance == 0
                      ? baseProvider.userFundWallet.prizeBalance
                      : baseProvider.userFundWallet.processingRedemptionBalance,
              username: baseProvider.myUser.name,
            ),
            delay: const Duration(seconds: 2))
        .then((Uint8List image) async {
      setState(() {
        isSaving = false;
      });
      String dt = DateTime.now().toString();
      Directory directory;
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          print(directory.path);
          String newPath = "";
          List<String> folders = directory.path.split('/');
          for (int i = 1; i < folders.length; i++) {
            String folder = folders[i];
            if (folder != "Android")
              newPath += '/' + folder;
            else
              break;
          }
          newPath = newPath + "/Fello";
          print(newPath);
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else
          return false;
      }

      if (!await directory.exists()) await directory.create(recursive: true);
      if (await directory.exists()) {
        File imageFile = new File('${directory.path}/fello-reward-$dt.png');
        await imageFile.writeAsBytes(image);
        if (Platform.isAndroid) {
          ImageGallerySaver.saveFile(imageFile.path);
        } else {
          ImageGallerySaver.saveFile(imageFile.path, isReturnPathOfIOS: true);
        }
        backButtonDispatcher.didPopRoute();
        baseProvider.showPositiveAlert("Saved Successfulyy",
            "Share card saved successfully to the gallery", context);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var res = await permission.request();
      if (res == PermissionStatus.granted)
        return true;
      else
        return false;
    }
  }
}
