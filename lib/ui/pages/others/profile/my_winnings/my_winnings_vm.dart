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
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/Prize-Card/card.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MyWinningsViewModel extends BaseModel {
  final _logger = locator<Logger>();
  final _httpModel = locator<HttpModel>();
  final _userService = locator<UserService>();
  final _localDBModel = locator<LocalDBModel>();
  final _dbModel = locator<DBModel>();
  PrizeClaimChoice _choice;
  get choice => this._choice;
  final GlobalKey imageKey = GlobalKey();

  UserService get userService => _userService;
  set choice(value) {
    this._choice = value;
    notifyListeners();
  }

  showConfirmDialog(PrizeClaimChoice choice) {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissable: false,
      hapticVibrate: true,
      content: FelloConfirmationDialog(
        result: (res) async {
          if (res) await claim(choice);
        },
        showCrossIcon: true,
        asset: Assets.prizeClaimConfirm,
        title: "Confirmation",
        subtitle:
            "Are you sure you want to invest Rs ${_userService.userFundWallet.prizeBalance} in amazon gift voucher?",
        accept: "Yes",
        reject: "No",
        acceptColor: UiConstants.primaryColor,
        rejectColor: Colors.grey.withOpacity(0.3),
        //onAccept: buyAmazonGiftCard,
        onReject: AppState.backButtonDispatcher.didPopRoute,
      ),
    );
  }

  showSuccessPrizeWithdrawalDialog(String subtitle) async {
    if (choice == null) await getClaimChoice();
    AppState.screenStack.add(ScreenItem.dialog);
    showDialog(
        context: AppState.delegate.navigatorKey.currentContext,
        builder: (ctx) {
          return Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RepaintBoundary(
                    key: imageKey,
                    child: ShareCard(
                      dpUrl: _userService.myUserDpUrl,
                      claimChoice: choice,
                      prizeAmount: _userService.userFundWallet.prizeBalance,
                      username: _userService.baseUser.name,
                    ),
                  ),
                ),
                FelloConfirmationDialog(
                  result: (res) async {
                    if (res) caputure();
                  },
                  showCrossIcon: false,
                  asset: Assets.goldenTicket,
                  title: "Congratulations",
                  subtitle: "Claimed successful",
                  accept: "Share on Whatsapp",
                  reject: "OK",
                  acceptColor: UiConstants.primaryColor,
                  rejectColor: UiConstants.tertiarySolid,
                  //onAccept: buyAmazonGiftCard,
                  onReject: AppState.backButtonDispatcher.didPopRoute,
                )
              ],
            ),
          );
        });
    // BaseUtil.openDialog(
    //   addToScreenStack: true,
    //   isBarrierDismissable: false,
    //   hapticVibrate: true,
    //   content: FelloDialog(
    //     showCrossIcon: true,
    //     content: Container(
    //       height: SizeConfig.screenHeight * 0.5,
    //       child: Column(
    //         children: [
    //           Container(
    //             height: SizeConfig.navBarHeight * 0.3,
    //             child: Expanded(
    // child: ShareCard(
    //   dpUrl: _userService.myUserDpUrl,
    //   claimChoice: choice,
    //   prizeAmount: _userService.userFundWallet.prizeBalance,
    //   username: _userService.baseUser.name,
    // ),
    //             ),
    //           ),
    //           SizedBox(
    //             height: SizeConfig.screenHeight * 0.04,
    //           ),
    //           Text(
    //             "Congratulations",
    //             style: TextStyles.title2.bold,
    //           ),
    //           SizedBox(height: SizeConfig.padding16),
    //           Text(
    //             subtitle,
    //             textAlign: TextAlign.center,
    //             style: TextStyles.body2.colour(Colors.grey),
    //           ),
    //           SizedBox(height: SizeConfig.screenHeight * 0.04),
    //           Column(
    //             children: [
    //               Container(
    //                 width: SizeConfig.screenWidth,
    //                 child: FelloButtonLg(
    //                   child: Text(
    //                     "Share on Whatsapp",
    //                     style: TextStyles.body3.bold.colour(Colors.white),
    //                   ),
    //                   color: UiConstants.primaryColor,
    //                   height: SizeConfig.padding54,
    //                   onPressed: shareOnWhatsapp,
    //                 ),
    //               ),
    //               SizedBox(height: SizeConfig.padding12),
    //               Container(
    //                 width: SizeConfig.screenWidth,
    //                 child: FelloButtonLg(
    //                   child: Text(
    //                     "OK",
    //                     style: TextStyles.body3.bold,
    //                   ),
    //                   color: UiConstants.tertiarySolid,
    //                   height: SizeConfig.padding54,
    //                   onPressed: AppState.backButtonDispatcher.didPopRoute,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  shareOnWhatsapp() {
    _logger.i("Whatsapp share trigerred");
    AppState.backButtonDispatcher.didPopRoute();
  }

  claim(PrizeClaimChoice choice) {
    _registerClaimChoice(choice).then((flag) {
      AppState.backButtonDispatcher.didPopRoute();
      // if (flag) {
      showSuccessPrizeWithdrawalDialog(choice == PrizeClaimChoice.AMZ_VOUCHER
          ? "You will recieve the voucher on your email soon"
          : "Your gold is invested successfully");
      // } else {
      //   BaseUtil.showNegativeAlert(
      //       'Failed to send claim', 'Please try again in some time');
      // }
    });
  }

  Future<bool> _registerClaimChoice(PrizeClaimChoice choice) async {
    if (choice == PrizeClaimChoice.NA) return false;
    bool flag = await _httpModel.registerPrizeClaim(_userService.baseUser.uid,
        _userService.userFundWallet.prizeBalance, choice);
    if (flag) _userService.getUserFundWalletData();
    if (flag) await _localDBModel.savePrizeClaimChoice(choice);
    print('Claim choice saved: $flag');
    return flag;
  }

  getClaimChoice() async {
    choice = await _localDBModel.getPrizeClaimChoice();
  }

  prizeBalanceAction(BuildContext context) async {
    HapticFeedback.vibrate();
    if (_userService.userFundWallet.isPrizeBalanceUnclaimed())
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: FCard(
                isClaimed:
                    !_userService.userFundWallet.isPrizeBalanceUnclaimed(),
                unclaimedPrize: _userService.userFundWallet.unclaimedBalance,
              ),
            ),
          );
        },
      );
    else {
      final choice = await getClaimChoice();
      AppState.screenStack.add(ScreenItem.dialog);
      showDialog(
        context: context,
        builder: (ctx) => ShareCard(
          dpUrl: _userService.myUserDpUrl,
          claimChoice: choice,
          prizeAmount: _userService.userFundWallet.prizeBalance,
          username: _userService.baseUser.name,
        ),
      );
    }
  }

  caputure() {
    Future.delayed(Duration(seconds: 1), () {
      captureCard().then((image) {
        AppState.backButtonDispatcher.didPopRoute();
        if (image != null) shareCard(image);
      });
    });
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
      if (_userService.baseUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Share reward card creation failed'
        };
        _dbModel.logFailure(_userService.baseUser.uid,
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
          if (_userService.baseUser.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _dbModel.logFailure(_userService.baseUser.uid,
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
          if (_userService.baseUser.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _dbModel.logFailure(_userService.baseUser.uid,
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
