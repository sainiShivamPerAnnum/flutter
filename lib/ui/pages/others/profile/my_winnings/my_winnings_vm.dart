import 'dart:io';
import 'dart:typed_data';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MyWinningsViewModel extends BaseModel {
  //LOCATORS
  final _logger = locator<Logger>();
  final _httpModel = locator<HttpModel>();
  final _userService = locator<UserService>();
  final _localDBModel = locator<LocalDBModel>();
  final _dbModel = locator<DBModel>();

  // LOCAL VARIABLES
  PrizeClaimChoice _choice;
  get choice => this._choice;
  bool _isWinningHistoryLoading = false;
  final GlobalKey imageKey = GlobalKey();
  final userRepo = locator<UserRepository>();
  List<UserTransaction> _winningHistory;

  //GETTERS SETTERS
  get isWinningHistoryLoading => this._isWinningHistoryLoading;
  set isWinningHistoryLoading(value) {
    this._isWinningHistoryLoading = value;
    notifyListeners();
  }

  List<Color> colorList = [
    UiConstants.tertiarySolid,
    UiConstants.primaryColor,
    Color(0xff11192B)
  ];

  List<UserTransaction> get winningHistory => this._winningHistory;
  set winningHistory(List<UserTransaction> value) {
    this._winningHistory = value;
    notifyListeners();
  }

  UserService get userService => _userService;

  set choice(value) {
    this._choice = value;
    notifyListeners();
  }

  getWinningHistory() async {
    isWinningHistoryLoading = true;
    ApiResponse<List<UserTransaction>> temp =
        await userRepo.getWinningHistory(_userService.baseUser.uid);
    isWinningHistoryLoading = false;
    if (temp != null)
      winningHistory = temp.model;
    else
      BaseUtil.showNegativeAlert(
          "Winning History fetch failed", temp.errorMessage);
  }

  getWinningHistoryTitle(String subtype) {
    switch (subtype) {
      case "CRICKET":
        return "Cricket";
        break;
      case "AUGGOLD99":
        return "Augmont Gold";
        break;
      case "TAMBOLA":
        return "Tambola";
        break;
      case "AMZPAY":
        return "Amazon Pay";
        break;
      default:
        return "Fello Prize";
    }
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
        subtitle: choice == PrizeClaimChoice.AMZ_VOUCHER
            ? "Are you sure you want to redeem ₹ ${_userService.userFundWallet.unclaimedBalance} as an Amazon gift voucher?"
            : "Are you sure you want to redeem ₹ ${_userService.userFundWallet.unclaimedBalance} as Digital Gold?",
        accept: "Yes",
        reject: "No",
        acceptColor: UiConstants.primaryColor,
        rejectColor: Colors.grey.withOpacity(0.3),
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
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: RepaintBoundary(
                //     key: imageKey,
                //     child: ShareCard(
                //       dpUrl: _userService.myUserDpUrl,
                //       claimChoice: choice,
                //       prizeAmount: _userService.userFundWallet.prizeBalance,
                //       username: _userService.baseUser.name,
                //     ),
                //   ),
                // ),
                FelloConfirmationDialog(
                  result: (res) async {
                    if (res) {
                      AppState.backButtonDispatcher.didPopRoute();
                      BaseUtil.showPositiveAlert(
                          "Share to Whatsapp to be added",
                          "think of a sharable message");
                    }
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
  }

  shareOnWhatsapp() {
    _logger.i("Whatsapp share trigerred");
    AppState.backButtonDispatcher.didPopRoute();
  }

  claim(PrizeClaimChoice choice) {
    _registerClaimChoice(choice).then((flag) {
      AppState.backButtonDispatcher.didPopRoute();
      if (flag) {
        showSuccessPrizeWithdrawalDialog(choice == PrizeClaimChoice.AMZ_VOUCHER
            ? "You will receive the gift card on your registered email and mobile in the next 1-2 business days"
            : "The gold in grams shall be credited to your wallet in the next 1-2 business days");
      }
    });
  }

// SET AND GET CLAIM CHOICE
  Future<bool> _registerClaimChoice(PrizeClaimChoice choice) async {
    if (choice == PrizeClaimChoice.NA) return false;
    Map<String, dynamic> response = await _httpModel.registerPrizeClaim(
        _userService.baseUser.uid,
        _userService.userFundWallet.unclaimedBalance,
        choice);
    if (response['status'] != null && response['status']) {
      _userService.getUserFundWalletData();
      notifyListeners();
      await _localDBModel.savePrizeClaimChoice(choice);

      return true;
    } else {
      BaseUtil.showNegativeAlert('Withdrawal Failed', response['message']);
      return false;
    }
  }

  getClaimChoice() async {
    choice = await _localDBModel.getPrizeClaimChoice();
  }

// Capture Share card Logic
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
