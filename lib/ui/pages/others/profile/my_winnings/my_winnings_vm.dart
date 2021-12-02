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
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MyWinningsViewModel extends BaseModel {
  //LOCATORS
  final _logger = locator<Logger>();
  final _httpModel = locator<HttpModel>();
  final _userService = locator<UserService>();
  final _transactionService = locator<TransactionService>();
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
    temp.model.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    isWinningHistoryLoading = false;
    if (temp != null)
      winningHistory = temp.model;
    else
      BaseUtil.showNegativeAlert(
          "Winning History fetch failed", temp.errorMessage);
  }

  getWinningHistoryTitle(UserTransaction tran) {
    String redeemtype = tran.redeemType;
    String subtype = tran.subType;
    if (redeemtype != null && redeemtype != "") {
      switch (redeemtype) {
        case UserTransaction.TRAN_REDEEMTYPE_AUGMONT_GOLD:
          return "Digital Gold Redemption";
          break;
        case UserTransaction.TRAN_REDEEMTYPE_AMZ_VOUCHER:
          return "Amazon Voucher Redemption";
          break;
        default:
          return "Fello Rewards";
      }
    }

    if (subtype != null && subtype != "") {
      switch (subtype) {
        case UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD:
          return "Digital Gold";
          break;
        case UserTransaction.TRAN_SUBTYPE_GLDN_TCK:
          return "Fello Golden Ticket";
          break;
        case UserTransaction.TRAN_SUBTYPE_REF_BONUS:
          return "Referral Bonus";
          break;
        case UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN:
          return "Tambola Win";
          break;
        case UserTransaction.TRAN_SUBTYPE_CRICKET_WIN:
          return "Cricket Win";
          break;
        default:
          return "Fello Rewards";
      }
    }
    return "Fello Rewards";
  }

  getWinningHistoryLeadingBg(String subtype) {
    switch (subtype) {
      case "GOLD_CREDIT":
        return UiConstants.primaryColor;
      case "AMZ_VOUCHER":
        return UiConstants.tertiarySolid;
      default:
        return Color(0xff11192B);
    }
  }

  getWinningHistoryLeadingImage(String subtype) {
    switch (subtype) {
      case "GOLD_CREDIT":
        return Assets.digitalGold;
      case "AMZ_VOUCHER":
        return Assets.amazonGiftVoucher;
        break;
      default:
        return Assets.felloRewards;
    }
  }

  showConfirmDialog(PrizeClaimChoice choice) {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissable: false,
      hapticVibrate: true,
      content: FelloConfirmationDialog(
        result: (res) async {
          if (res)
            await claim(choice, _userService.userFundWallet.unclaimedBalance);
        },
        showCrossIcon: true,
        assetpng: choice == PrizeClaimChoice.AMZ_VOUCHER
            ? Assets.amazonGiftVoucher
            : Assets.digitalGold,
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

  showSuccessPrizeWithdrawalDialog(
      PrizeClaimChoice choice, String subtitle) async {
    AppState.screenStack.add(ScreenItem.dialog);
    showDialog(
        context: AppState.delegate.navigatorKey.currentContext,
        builder: (ctx) {
          return Stack(
            children: [
              FelloConfirmationDialog(
                result: (res) async {
                  if (res) {
                    try {
                      String url =
                          await _userService.createDynamicLink(true, 'Other');
                      caputure(
                          'Hey, I won ₹${_userService.userFundWallet.prizeBalance.toInt()} on Fello! \nLet\'s save and play together: $url');
                    } catch (e) {
                      _logger.e(e.toString());
                      BaseUtil.showNegativeAlert(
                          "An error occured!", "Please try again");
                    }
                  }
                },
                content: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    Container(
                      height: SizeConfig.screenHeight * 0.38,
                      width: SizeConfig.screenWidth,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: RepaintBoundary(
                          key: imageKey,
                          child: ShareCard(
                            dpUrl: _userService.myUserDpUrl,
                            claimChoice: choice,
                            prizeAmount:
                                _userService.userFundWallet.prizeBalance,
                            username: _userService.baseUser.name,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Congratulations!",
                        style: TextStyles.title2.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding16),
                    getSubtitleWidget(subtitle),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                  ],
                ),
                showCrossIcon: true,
                accept: "Share",
                reject: "Done",
                acceptColor: UiConstants.primaryColor,
                rejectColor: Colors.grey[300],
                onReject: AppState.backButtonDispatcher.didPopRoute,
              ),
            ],
          );
        });
  }

  shareOnWhatsapp() {
    _logger.i("Whatsapp share triggered");
    AppState.backButtonDispatcher.didPopRoute();
  }

  claim(PrizeClaimChoice choice, double claimPrize) {
    double _claimAmt = claimPrize;
    _registerClaimChoice(choice).then((flag) {
      AppState.backButtonDispatcher.didPopRoute();
      if (flag) {
        getWinningHistory();
        showSuccessPrizeWithdrawalDialog(
            choice, choice == PrizeClaimChoice.AMZ_VOUCHER ? "amazon" : "gold");
      }
    });
  }

// SET AND GET CLAIM CHOICE
  Future<bool> _registerClaimChoice(PrizeClaimChoice choice) async {
    if (choice == PrizeClaimChoice.NA) return false;
    Map<String, dynamic> response = await _httpModel.registerPrizeClaim(
        _userService.baseUser.uid,
        _userService.baseUser.username,
        _userService.userFundWallet.unclaimedBalance,
        choice);
    if (response['status'] != null && response['status']) {
      _userService.getUserFundWalletData();
      _transactionService.updateTransactions();
      notifyListeners();
      await _localDBModel.savePrizeClaimChoice(choice);

      return true;
    } else {
      BaseUtil.showNegativeAlert('Withdrawal Failed', response['message']);
      return false;
    }
  }

  showPrizeDetailsDialog(String type, double amount) async {
    String subtitle = "Fello Rewards";
    if (type == "AMZ_VOUCHER") {
      choice = PrizeClaimChoice.AMZ_VOUCHER;
      subtitle = "Amazon Gift Voucher";
    } else if (type == "GOLD_CREDIT") {
      choice = PrizeClaimChoice.GOLD_CREDIT;
      subtitle = "Digital Gold";
    } else
      choice = PrizeClaimChoice.FELLO_PRIZE;

    AppState.screenStack.add(ScreenItem.dialog);
    showDialog(
        context: AppState.delegate.navigatorKey.currentContext,
        builder: (ctx) {
          return Stack(
            children: [
              FelloConfirmationDialog(
                result: (res) async {
                  if (res) {
                    try {
                      String url =
                          await _userService.createDynamicLink(true, 'Other');
                      caputure(
                          'Hey, I won ₹${amount.toInt()} on Fello! \nLet\'s save and play together: $url');
                    } catch (e) {
                      _logger.e(e.toString());
                      BaseUtil.showNegativeAlert(
                          "An error occured!", "Please try again");
                    }
                  }
                },
                content: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    Container(
                      height: SizeConfig.screenHeight * 0.38,
                      width: SizeConfig.screenWidth,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: RepaintBoundary(
                          key: imageKey,
                          child: ShareCard(
                            dpUrl: _userService.myUserDpUrl,
                            claimChoice: choice,
                            prizeAmount: amount.abs(),
                            username: _userService.baseUser.name,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Congratulations!",
                        style: TextStyles.title2.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding16),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyles.body2.colour(Colors.grey),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                  ],
                ),
                showCrossIcon: true,
                accept: "Share",
                reject: "Done",
                acceptColor: UiConstants.primaryColor,
                rejectColor: Colors.grey[300],
                onReject: AppState.backButtonDispatcher.didPopRoute,
              ),
            ],
          );
        });
  }

  Widget getSubtitleWidget(String subtitle) {
    if (subtitle == "gold" || subtitle == "amazon")
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: subtitle == "gold"
              ? "The gold in grams shall be credited to your wallet in the next "
              : "You will receive the gift card on your registered email and mobile in the next ",
          style: TextStyles.body3.colour(Colors.grey),
          children: [
            TextSpan(
              text: "1-2 business working days",
              style: TextStyles.body3.bold.colour(Colors.grey),
            )
          ],
        ),
      );
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: TextStyles.body2.colour(Colors.grey),
    );
  }

// Capture Share card Logic
  caputure(String shareMessage) {
    Future.delayed(Duration(seconds: 1), () {
      captureCard().then((image) {
        AppState.backButtonDispatcher.didPopRoute();
        if (image != null)
          shareCard(image, shareMessage);
        else {
          if (Platform.isIOS) {
            Share.share(shareMessage);
          } else {
            FlutterShareMe().shareToSystem(msg: shareMessage).then((flag) {
              _logger.d(flag);
            });
          }
        }
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

  shareCard(Uint8List image, String shareMessage) async {
    try {
      if (Platform.isAndroid) {
        final directory = (await getExternalStorageDirectory()).path;
        String dt = DateTime.now().toString();
        File imgg = new File('$directory/fello-reward-$dt.png');
        imgg.writeAsBytesSync(image);
        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
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
        String dt = DateTime.now().toString();

        final directory = await getTemporaryDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);

        final File imgg =
            await new File('${directory.path}/fello-reward-$dt.jpg').create();
        imgg.writeAsBytesSync(image);

        _logger.d("Image file created and sharing, ${imgg.path}");

        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
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
