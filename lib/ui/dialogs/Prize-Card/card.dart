//Project Imports
//Flutter & Dart Imports
import 'dart:io';
import 'dart:typed_data';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/Prize-Card/fold-card.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

//Flutter & Dart Imports
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
//Pub Imports
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class FCard extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  final bool isClaimed;
  final double unclaimedPrize;

  const FCard({
    Key key,
    this.isClaimed,
    this.unclaimedPrize,
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
  LocalDBModel localDBModel;
  bool _isPrizeProcessing = false;
  bool _tChoice;
  bool _isclaimed = false;
  UserService _userService = locator<UserService>();

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
    );
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    localDBModel = Provider.of<LocalDBModel>(context, listen: false);
    httpProvider = Provider.of<HttpModel>(context);
    bottomCard = buildBottomCard();
    middleCard = buildMiddleCard();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // _isclaimed
        //     ? Container(
        //         height: SizeConfig.screenWidth * 0.5,
        //         child: Transform.scale(
        //           scale: 0.2,
        //           child: ShareCard(
        //             dpUrl: baseProvider.myUserDpUrl,
        //             claimChoice: PrizeClaimChoice.AMZ_VOUCHER,
        //             prizeAmount:
        //                 baseProvider.userFundWallet.processingRedemptionBalance,
        //             username: baseProvider.myUser.name,
        //           ),
        //         ),
        //       )
        //     : SizedBox(),
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
                      : AppState.backButtonDispatcher.didPopRoute();
                } else {
                  BaseUtil.showNegativeAlert(
                      "Please wait", "Your prize is being processed");
                }
              }),
        ),
      ],
    );
  }

  List<FoldEntry> _getEntries() {
    return [
      FoldEntry(height: SizeConfig.screenHeight * 0.26, front: topCard),
      FoldEntry(
          height: SizeConfig.screenHeight * 0.26,
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
        image: DecorationImage(
            image: AssetImage("images/prize-share-bg.png"), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child:
                        Lottie.asset("images/lottie/clap.json", repeat: false),
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
          Row(
            children: [
              Image.asset(
                "images/fello-dark.png",
                width: SizeConfig.screenWidth * 0.12,
              ),
            ],
          ),
        ],
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
          Spacer(),
          FittedBox(
            fit: BoxFit.contain,
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
                fontSize: SizeConfig.cardTitleTextSize * 1.6,
              ),
            ),
          ),
          Spacer(),
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
                      if (BaseUtil.showNoInternetAlert()) return;

                      setState(() {
                        _isPrizeProcessing = true;
                      });
                      _registerClaimChoice(PrizeClaimChoice.AMZ_VOUCHER)
                          .then((flag) {
                        if (flag) {
                          _isclaimed = true;
                          _tChoice = true;
                          setState(() {
                            _isPrizeProcessing = false;
                            claimtype = PrizeClaimChoice.AMZ_VOUCHER;
                            frontCard = CloseCard(
                              claimtype: claimtype,
                              unclaimedPrize: widget.unclaimedPrize,
                              isClaimed: true,
                            );
                            _isOpen = false;
                          });
                        } else {
                          BaseUtil.showNegativeAlert('Failed to send claim',
                              'Please try again in some time');
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
                        "Amazon Gift Card",
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
                      if (BaseUtil.showNoInternetAlert()) return;
                      setState(() {
                        _isPrizeProcessing = true;
                      });
                      _registerClaimChoice(PrizeClaimChoice.GOLD_CREDIT)
                          .then((flag) {
                        _tChoice = true;
                        if (flag) {
                          _isclaimed = true;

                          setState(() {
                            _isPrizeProcessing = false;
                            claimtype = PrizeClaimChoice.GOLD_CREDIT;
                            frontCard = CloseCard(
                              claimtype: claimtype,
                              unclaimedPrize: widget.unclaimedPrize,
                              isClaimed: true,
                            );

                            _isOpen = false;
                          });
                        } else {
                          BaseUtil.showNegativeAlert('Failed to send claim',
                              'Please try again in some time');
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
                        "    Digital Gold    ",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
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
    Map<String, dynamic> response = await httpProvider.registerPrizeClaim(
        baseProvider.myUser.uid, widget.unclaimedPrize, choice);
    if (response['status'] != null && response['status']) {
      _userService.getUserFundWalletData();
      await localDBModel.savePrizeClaimChoice(choice);

      return true;
    }else{
      BaseUtil.showNegativeAlert('Withdrawal Failed', response['message']);
      return false;
    }
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
  LocalDBModel localDBModel;

  bool isCapturing = false;
  bool isSaving = false;

  bool isClaimChoiceLoading = true;
  String claimText = "";
  PrizeClaimChoice choice;
  getClaimChoice() async {
    choice = await localDBModel.getPrizeClaimChoice();
    if (choice == PrizeClaimChoice.AMZ_VOUCHER)
      claimText =
          'Your amazon gift card shall be sent to your registered email and mobile shortly!';
    else if (choice == PrizeClaimChoice.GOLD_CREDIT)
      claimText =
          'Your digital gold shall be credited to your Fello wallet shortly!';
    else
      claimText = "Your reward will be credited soon to your account";

    isClaimChoiceLoading = false;
    setState(() {});
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
                      ),
                      child: ProfileImageSE(radius: SizeConfig.padding40),
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
        gradient: choice == PrizeClaimChoice.AMZ_VOUCHER
            ? new LinearGradient(
                colors: [Colors.black, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)
            : new LinearGradient(colors: [
                FelloColorPalette.augmontFundPalette().primaryColor,
                FelloColorPalette.augmontFundPalette().primaryColor2,
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
                Spacer(),
                Text(
                  "Reward Claimed!",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.cardTitleTextSize,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                isClaimChoiceLoading
                    ? CircularProgressIndicator()
                    : Text(
                        claimText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize),
                      ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        AppState.backButtonDispatcher.didPopRoute();
                        AppState.screenStack.add(ScreenItem.dialog);
                        showDialog(
                          context: context,
                          builder: (ctx) => ShareCard(
                            dpUrl: baseProvider.myUserDpUrl,
                            claimChoice: widget.claimtype,
                            prizeAmount:
                                baseProvider.userFundWallet.prizeBalance,
                            username: baseProvider.myUser.name,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Wrap(
                          children: [
                            Text(
                              "Share  📢",
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
                Spacer()
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
    localDBModel = Provider.of<LocalDBModel>(context, listen: false);
    if (claimText.isEmpty && widget.isClaimed) {
      getClaimChoice();
    }
    return widget.isClaimed ? _buildEndCard(context) : _buildBeginCard(context);
  }

  saveCard(Uint8List image) async {
    try {
      setState(() {
        isSaving = false;
      });
      String dt = DateTime.now().toString();
      Directory directory;
      if (Platform.isAndroid) {
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
        if (await _requestPermission(Permission.storage)) {
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
        print('image path : ${imageFile.path}');
        await imageFile.writeAsBytes(image);
        if (Platform.isAndroid) {
          ImageGallerySaver.saveFile(imageFile.path);
        } else {
          ImageGallerySaver.saveFile(imageFile.path);
        }
        AppState.backButtonDispatcher.didPopRoute();
        AppState.backButtonDispatcher.didPopRoute();
        BaseUtil.showPositiveAlert("Saved Successfulyy",
            "Share card saved successfully to the gallery");
      }
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      AppState.backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(
          "Task Failed", "Unable to save the picture at the moment");
    }
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
