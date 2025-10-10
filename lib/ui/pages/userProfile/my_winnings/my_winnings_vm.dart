import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/prizing_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MyWinningsViewModel extends BaseViewModel {
  //LOCATORS
  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final TxnHistoryService _transactionHistoryService =
      locator<TxnHistoryService>();

  // final LocalDBModel? _localDBModel = locator<LocalDBModel>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  final PrizingRepo _prizingRepo = locator<PrizingRepo>();
  final ScratchCardService _gtService = locator<ScratchCardService>();
  S locale = locator<S>();

  // LOCAL VARIABLES
  PrizeClaimChoice? _choice;

  PrizeClaimChoice? get choice => _choice;
  final GlobalKey imageKey = GlobalKey();
  final UserRepository? userRepo = locator<UserRepository>();

  //GETTERS SETTERS

  UserService get userService => _userService;

  // AugmontTransactionService get txnService => _GoldTransactionService;

  set choice(value) {
    _choice = value;
    notifyListeners();
  }

  void init() {
    setState(ViewState.Busy);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _gtService.isLastPageForScratchCards = false;
      _gtService.scratchCardsListLastIndex = 0;
      await _gtService.fetchScratchCards();
      setState(ViewState.Idle);
    });
  }

  void fetchMoreCards() {
    _gtService.fetchScratchCards(more: true);
  }

  void trackScratchCardsOpen() {
    _analyticsService
        .track(eventName: AnalyticsEvents.scratchCardSectionOpen, properties: {
      "Unscratched tickets count": _gtService.unscratchedTicketsCount,
      "Scratched tickets count": _gtService.activeScratchCards.length,
      "total prize won": _userService.userFundWallet!.prizeLifetimeWin,
      "Referred count (total)": AnalyticsProperties.getTotalReferralCount(),
      "Referred count success": AnalyticsProperties.getSuccessReferralCount(),
    });
  }

  String getWinningHistoryTitle(UserTransaction tran) {
    String? redeemtype = tran.redeemType;
    String? subtype = tran.subType;
    if (redeemtype != null && redeemtype != "") {
      switch (redeemtype) {
        case UserTransaction.TRAN_REDEEMTYPE_AUGMONT_GOLD:
          return "Digital Gold Redemption";
        case UserTransaction.TRAN_REDEEMTYPE_AMZ_VOUCHER:
          return "Amazon Voucher Redemption";
        default:
          return "Fello Rewards";
      }
    }

    if (subtype != null && subtype != "") {
      switch (subtype) {
        case UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD:
          return "Digital Gold";
        case UserTransaction.TRAN_SUBTYPE_GLDN_TCK:
          return "Fello Scratch Card";
        case UserTransaction.TRAN_SUBTYPE_REF_BONUS:
          return "Referral Bonus";
        case UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN:
          return "Tambola Win";
        case UserTransaction.TRAN_SUBTYPE_CRICKET_WIN:
          return "Cricket Win";
        default:
          return "Fello Rewards";
      }
    }
    return "Fello Rewards";
  }

  Color getWinningHistoryLeadingBg(String subtype) {
    switch (subtype) {
      case "GOLD_CREDIT":
        return UiConstants.primaryColor;
      case "AMZ_VOUCHER":
        return UiConstants.tertiarySolid;
      default:
        return const Color(0xff11192B);
    }
  }

  void shareOnWhatsapp() {
    _logger.i("Whatsapp share triggered");
    AppState.backButtonDispatcher!.didPopRoute();
  }

// SET AND GET CLAIM CHOICE
  Future<bool> _registerClaimChoice(PrizeClaimChoice choice) async {
    if (choice == PrizeClaimChoice.NA) return false;
    final response = await _prizingRepo.claimPrize(
      _userService.userFundWallet!.unclaimedBalance,
      choice,
    );

    if (response.isSuccess()) {
      await _userService.getUserFundWalletData();
      await _transactionHistoryService
          .updateTransactions(InvestmentType.AUGGOLD99);
      notifyListeners();
      // await _localDBModel!.savePrizeClaimChoice(choice);

      return true;
    } else {
      BaseUtil.showNegativeAlert(
        locale.withDrawalFailed,
        response.errorMessage ?? locale.tryLater,
      );
      return false;
    }
  }

  Widget getSubtitleWidget(String subtitle) {
    if (subtitle == "gold" || subtitle == "amazon") {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: subtitle == "gold"
              ? locale.goldCreditedInWallet
              : locale.giftCard,
          style: TextStyles.body3.colour(Colors.grey),
          children: [
            TextSpan(
              text: " ${locale.businessDays}",
              style: TextStyles.body3.bold.colour(UiConstants.tertiarySolid),
            )
          ],
        ),
      );
    }
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: TextStyles.body2.colour(Colors.grey),
    );
  }

// Capture Share card Logic
  capture(String shareMessage) {
    Future.delayed(const Duration(seconds: 1), () {
      captureCard().then((image) {
        AppState.backButtonDispatcher!.didPopRoute();
        if (image != null) {
          shareCard(image, shareMessage);
        } else {
          try {
            if (Platform.isIOS) {
              Share.share(shareMessage).catchError((onError) {
                if (_userService.baseUser!.uid != null) {
                  Map<String, dynamic> errorDetails = {
                    'error_msg': 'Share reward text in My winnings failed'
                  };
                  _internalOpsService.logFailure(_userService.baseUser!.uid,
                      FailType.FelloRewardTextShareFailed, errorDetails);
                }
                _logger.e(onError);
              });
            } else {
              Share.share(shareMessage).catchError((onError) {
                if (_userService.baseUser!.uid != null) {
                  Map<String, dynamic> errorDetails = {
                    'error_msg': 'Share reward text in My winnings failed'
                  };
                  _internalOpsService.logFailure(_userService.baseUser!.uid,
                      FailType.FelloRewardTextShareFailed, errorDetails);
                }
                _logger.e(onError);
              });
            }
          } catch (e) {
            _logger.e(e.toString());
          }
        }
      });
    });
  }

  Future<Uint8List?> captureCard() async {
    try {
      RenderRepaintBoundary imageObject =
          imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await imageObject.toImage(pixelRatio: 2);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      if (_userService.baseUser!.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Share reward card creation failed'
        };
        await _internalOpsService.logFailure(_userService.baseUser!.uid,
            FailType.FelloRewardCardShareFailed, errorDetails);
      }

      await AppState.backButtonDispatcher!.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(locale.taskFailed, locale.unableToCapture);
    }
    return null;
  }

  shareCard(Uint8List image, String? shareMessage) async {
    try {
      if (Platform.isAndroid) {
        final directory = (await getExternalStorageDirectory())!.path;
        String dt = DateTime.now().toString();
        File imageFile = File('$directory/fello-reward-$dt.png');
        imageFile.writeAsBytesSync(image);
        unawaited(Share.shareXFiles(
          [XFile(imageFile.path)],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
        ).catchError((onError) {
          if (_userService.baseUser!.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _internalOpsService.logFailure(_userService.baseUser!.uid,
                FailType.FelloRewardCardShareFailed, errorDetails);
          }
          print(onError);
        }));
      } else if (Platform.isIOS) {
        String dt = DateTime.now().toString();

        final directory = await getTemporaryDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);

        final File imageFile =
            await File('${directory.path}/fello-reward-$dt.jpg').create();
        imageFile.writeAsBytesSync(image);

        _logger.d("Image file created and sharing, ${imageFile.path}");

        unawaited(Share.shareXFiles(
          [XFile(imageFile.path)],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
        ).catchError((onError) {
          if (_userService.baseUser!.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _internalOpsService.logFailure(_userService.baseUser!.uid,
                FailType.FelloRewardCardShareFailed, errorDetails);
          }
          print(onError);
        }));
      }
    } catch (e) {
      // backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(locale.taskFailed, locale.unableToCapture);
    }
  }

  void trackTabClicked(String tab) {
    _analyticsService.track(
      eventName: AnalyticsEvents.rewardsSectionTab,
      properties: {
        "tab": tab,
      },
    );
  }

  void trackHowToEarnCard(String title, String description, String count,
      String url, String balance, String order) {
    _analyticsService.track(
      eventName: AnalyticsEvents.howToEarnRewards,
      properties: {
        "Title": title,
        "Description": description,
        "Tickets/Rupees": count,
        "Action URL": url,
        "Rewards Balance": balance,
        "Priority order": order
      },
    );
  }

  void trackEarnRewardsClicked() {
    _analyticsService.track(
      eventName: AnalyticsEvents.earnRewardsClicked,
    );
  }
}
