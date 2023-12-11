import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/referral_response_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/repository/prizing_repo.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/hometabs/my_account/redeem_sucessfull_screen.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralService extends ChangeNotifier {
  final ReferralRepo _refRepo = locator<ReferralRepo>();
  final UserService _userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final PrizingRepo _prizingRepo = locator<PrizingRepo>();
  final TxnHistoryService _transactionHistoryService =
      locator<TxnHistoryService>();
  final AppFlyerAnalytics _appFlyer = locator<AppFlyerAnalytics>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  // ignore: cancel_subscriptions, unused_field
  StreamSubscription<PendingDynamicLinkData>? _dynamicLinkSubscription;
  final S locale = locator<S>();
  final GlobalKey imageKey = GlobalKey();
  String? _minWithdrawPrize;
  String? _refUnlock;
  int? _refUnlockAmt;
  String refCode = "---";
  String? appShareMessage;
  String? referralShortLink;

  set refUnlockAmt(value) {
    _refUnlockAmt = value;
  }

  String? shareMsg;
  int? _minWithdrawPrizeAmt;

  String? get minWithdrawPrize => _minWithdrawPrize;

  String? get refUnlock => _refUnlock;

  int? get refUnlockAmt => _refUnlockAmt;

  int? get minWithdrawPrizeAmt => _minWithdrawPrizeAmt;
  bool _isShareAlreadyClicked = false;

  bool get isShareAlreadyClicked => _isShareAlreadyClicked;

  bool shareWhatsappInProgress = false;
  bool shareLinkInProgress = false;
  bool _isShareLoading = false;

  bool get isShareLoading => _isShareLoading;
  final String _refUrl = "";

  String get refUrl => _refUrl;

  void init() {
    fetchBasicConstantValues();
    // fetchReferralCode();
  }

  Future<void> fetchReferralCode() async {
    final ApiResponse<ReferralResponse> res = await _refRepo.getReferralCode();
    if (res.code == 200) {
      refCode = res.model!.referralData?.code ?? "";
      appShareMessage = res.model?.referralData?.referralMessage ?? '';
      referralShortLink = res.model?.referralData?.referralShortLink ?? '';
    }
    shareMsg = (appShareMessage != null && appShareMessage!.isNotEmpty)
        ? appShareMessage
        : 'Hey I am gifting you ₹${AppConfig.getValue(AppConfigKey.referralBonus)} and '
            '${AppConfig.getValue(AppConfigKey.referralBonus)} gaming tokens. '
            'Lets start saving and playing together! Share this code: $refCode with your friends.\n';

    notifyListeners();
  }

  Future<void> shareLink({String? customMessage}) async {
    // _isShareAlreadyClicked = true;
    // notifyListeners();
    Haptic.vibrate();
    // _getterrepo.getScratchCards(); //TR

    if (shareLinkInProgress || _isShareAlreadyClicked == true) return;
    if (await BaseUtil.showNoInternetAlert()) return;

    unawaited(BaseAnalytics.analytics!.logShare(
      contentType: 'referral',
      itemId: _userService.baseUser!.uid!,
      method: 'message',
    ));

    _analyticsService
        .track(eventName: AnalyticsEvents.shareReferalCode, properties: {
      "Referrred Count Success": AnalyticsProperties.getSuccessReferralCount(),
      "Referred count (total)": AnalyticsProperties.getTotalReferralCount(),
      "code": refCode,
    });
    shareLinkInProgress = true;
    notifyListeners();

    // String? url = await createDynamicLink(true);

    String? url = referralShortLink;

    shareLinkInProgress = false;
    notifyListeners();

    if (url == null) {
      BaseUtil.showNegativeAlert(locale.generatingLinkFailed, locale.tryLater);
    } else {
      _isShareAlreadyClicked = true;
      notifyListeners();

      if (customMessage != null) {
        await Share.share(customMessage + url);
      } else {
        await Share.share(shareMsg! + url);
      }
    }

    Future.delayed(const Duration(seconds: 3), () {
      _isShareAlreadyClicked = false;
      notifyListeners();
    });
  }

  startShareLoading() {
    _isShareLoading = true;
    notifyListeners();
  }

  stopShareLoading() {
    _isShareLoading = false;
    notifyListeners();
  }

  void copyReferCode() {
    Haptic.vibrate();
    _analyticsService
        .track(eventName: AnalyticsEvents.copyReferalCode, properties: {
      "Referrred Count Success": AnalyticsProperties.getSuccessReferralCount(),
      "Referred count (total)": AnalyticsProperties.getTotalReferralCount(),
      "code": refCode,
    });
    Clipboard.setData(ClipboardData(text: refCode)).then((_) {
      BaseUtil.showPositiveAlert("Code: $refCode", "Copied to Clipboard");
    });
  }

  Future<String?> generateLink() async {
    if (_refUrl != "") return _refUrl;

    String? url;
    try {
      final link = await _appFlyer.inviteLink();
      if (link['status'] == 'success') {
        url = link['payload']['userInviteUrl'];
        url ??= link['payload']['userInviteURL'];
      }
      _logger.d('appflyer invite link as $url');
    } catch (e) {
      _logger.e(e);
    }
    return url;
  }

  sharePrizeDetails(double prizeAmount) async {
    startShareLoading();
    try {
      // String? url = await createDynamicLink(true);

      // final link = await _appFlyer!.inviteLink();
      // if (link['status'] == 'success') {
      //   url = link['payload']['userInviteUrl'];
      //   url ??= link['payload']['userInviteURL'];
      // }

      String? url = referralShortLink;

      if (url != null) {
        caputure(
            'Hey, I won ₹${prizeAmount.toInt()} on Fello! \nLet\'s save and play together: $url');
      }
    } catch (e) {
      _logger.e(e.toString());
      BaseUtil.showNegativeAlert(locale.errorOccured, locale.tryLater);
    }
    stopShareLoading();
  }

  Future<dynamic> verifyReferral() async {
    if (BaseUtil.referrerUserId != null) {
      if (PreferenceHelper.getBool(
        PreferenceHelper.REFERRAL_PROCESSED,
        def: false,
      )) return;

      await _refRepo.createReferral(
        _userService.baseUser!.uid,
        BaseUtil.referrerUserId,
      );
      _logger.d('referral processed from link');
      await PreferenceHelper.setBool(PreferenceHelper.REFERRAL_PROCESSED, true);
    } else if (BaseUtil.manualReferralCode != null) {
      if (BaseUtil.manualReferralCode!.length == 4) {
        await _verifyFirebaseManualReferral();
      } else {
        await _verifyOneLinkManualReferral();
      }
    }
  }

  Future<dynamic> _verifyOneLinkManualReferral() async {
    final referrerId = await _refRepo
        .getUserIdByRefCode(BaseUtil.manualReferralCode!.toUpperCase());

    if (referrerId.code == 200) {
      await _refRepo.createReferral(
        _userService.baseUser!.uid,
        referrerId.model,
      );
    } else {
      BaseUtil.showNegativeAlert(referrerId.errorMessage, '');
    }
  }

  Future<dynamic> _verifyFirebaseManualReferral() async {
    try {
      PendingDynamicLinkData? dynamicLinkData =
          await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(
              '${FlavorConfig.instance!.values.dynamicLinkPrefix}/app/referral/${BaseUtil.manualReferralCode}'));
      Uri? deepLink = dynamicLinkData?.link;
      _logger.d(deepLink.toString());
      if (deepLink != null) {
        return _processDynamicLink(_userService.baseUser!.uid, deepLink);
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<bool> _submitReferral(
      String? userId, String? userName, String deepLink) async {
    try {
      String prefix = 'https://fello.in/';
      if (deepLink.startsWith(prefix)) {
        String referee = deepLink.replaceAll(prefix, '');
        _logger.d(referee);
        if (prefix.isNotEmpty && prefix != userId) {
          return _refRepo.createReferral(userId, referee).then((res) {
            return res.model!;
          });
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<void> initDynamicLinks() async {
    await FirebaseDynamicLinks.instance.getInitialLink().then(_processDeepLink);
    _dynamicLinkSubscription = FirebaseDynamicLinks.instance.onLink.listen(
      _processDeepLink,
    );
  }

  Future<void> _processDeepLink(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      _logger.d('Received deep link. Process the referral');
      await _processDynamicLink(_userService.baseUser!.uid, deepLink);
    }
  }

  Future<void> _processDynamicLink(String? userId, Uri deepLink) async {
    String uri = deepLink.toString();

    if (uri.startsWith(Constants.APP_DOWNLOAD_LINK)) {
      _submitTrack(uri);
    } else if (uri.startsWith(Constants.APP_NAVIGATION_LINK)) {
      try {
        final timer = Stopwatch();
        timer.start();

        while (!AppState.isRootAvailableForIncomingTaskExecution) {
          await Future.delayed(const Duration(seconds: 1));
          if (timer.elapsed.inSeconds >= 10) {
            timer.stop();
            break;
          }
        }

        final path =
            uri.substring(Constants.APP_NAVIGATION_LINK.length, uri.length);
        if (AppState.isRootAvailableForIncomingTaskExecution) {
          AppState.isRootAvailableForIncomingTaskExecution = false;
          AppState.delegate!.parseRoute(Uri.parse(path));
          AppState.isRootAvailableForIncomingTaskExecution = true;
        }
      } catch (error) {
        _logger.e(error);
      }
    } else {
      BaseUtil.manualReferralCode =
          null; //make manual Code null in case user used both link and code

      //Referral dynamic link
      bool flag = await _submitReferral(
        _userService.baseUser!.uid,
        _userService.myUserName,
        uri,
      );

      if (flag) {
        _logger.d('Rewards added');
      }
    }
  }

  bool _submitTrack(String deepLink) {
    try {
      String prefix = '${Constants.APP_DOWNLOAD_LINK}/campaign/';
      if (deepLink.startsWith(prefix)) {
        String campaignId = deepLink.replaceAll(prefix, '');
        if (campaignId.isNotEmpty) {
          _logger.d(campaignId);
          _analyticsService.trackInstall(campaignId);
          return true;
        }
      }
      return false;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  fetchBasicConstantValues() {
    _minWithdrawPrize =
        AppConfig.getValue(AppConfigKey.min_withdrawable_prize).toString();
    _refUnlock = AppConfig.getValue(AppConfigKey.unlock_referral_amt);
    _refUnlockAmt = BaseUtil.toInt(_refUnlock);
    _minWithdrawPrizeAmt = BaseUtil.toInt(_minWithdrawPrize);
    appShareMessage = AppConfig.getValue(AppConfigKey.appShareMessage);
  }

  dynamic getRedeemAsset(double walletBalnce) {
    if (walletBalnce == 0) {
      return Assets.prizeClaimAssets[0];
    } else if (walletBalnce <= 10) {
      return Assets.prizeClaimAssets[1];
    } else if (walletBalnce > 10 && walletBalnce <= 20) {
      return Assets.prizeClaimAssets[2];
    } else if (walletBalnce > 20 && walletBalnce <= 30) {
      return Assets.prizeClaimAssets[3];
    } else if (walletBalnce > 30 && walletBalnce <= 40) {
      return Assets.prizeClaimAssets[4];
    } else if (walletBalnce > 40 && walletBalnce <= 50) {
      return Assets.prizeClaimAssets[5];
    } else if (walletBalnce > 50 && walletBalnce <= 100) {
      return Assets.prizeClaimAssets[6];
    } else if (walletBalnce > 100 && walletBalnce <= minWithdrawPrizeAmt! - 1) {
      return Assets.prizeClaimAssets[7];
    } else if (walletBalnce >= minWithdrawPrizeAmt!) {
      return Assets.prizeClaimAssets[8];
    }
  }

  showConfirmDialog(PrizeClaimChoice choice) {
    _analyticsService.track(
      eventName: AnalyticsEvents.winRedeemWinningsTapped,
      properties: AnalyticsProperties.getDefaultPropertiesMap(
        extraValuesMap: {
          "Total Winnings Amount":
              _userService.userFundWallet?.prizeLifetimeWin ?? 0
        },
      ),
    );
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissible: false,
      hapticVibrate: true,
      content: ConfirmationDialog(
        confirmAction: () async {
          await claim(choice, _userService.userFundWallet!.unclaimedBalance);
        },
        title: locale.confirmation,
        description: choice == PrizeClaimChoice.AMZ_VOUCHER
            ? locale.redeemAmznGiftVchr(BaseUtil.digitPrecision(
                _userService.userFundWallet!.unclaimedBalance, 2, false))
            : locale.redeemDigitalGold(BaseUtil.digitPrecision(
                _userService.userFundWallet!.unclaimedBalance, 2, false)),
        buttonText: locale.btnYes,
        cancelBtnText: locale.btnNo,
        cancelAction: AppState.backButtonDispatcher!.didPopRoute,
      ),
    );
  }

  claim(PrizeClaimChoice choice, double claimPrize) {
    // double _claimAmt = claimPrize;
    _registerClaimChoice(choice).then((flag) {
      getGramsWon(claimPrize).then((value) {
        if (flag) {
          showSuccessPrizeWithdrawalDialog(
              choice,
              choice == PrizeClaimChoice.AMZ_VOUCHER ? "amazon" : "gold",
              claimPrize,
              value);
        }
      });
    });

    _analyticsService.track(
      eventName: AnalyticsEvents.winRedeemWinnings,
      properties: AnalyticsProperties.getDefaultPropertiesMap(
        extraValuesMap: {
          "Total Winnings Amount":
              _userService.userFundWallet?.prizeLifetimeWin ?? 0
        },
      ),
    );
  }

  Future<String> getGramsWon(double amount) async {
    AugmontService? augmontService = locator<AugmontService>();
    AugmontRates? goldRates = await augmontService.getRates();
    if (goldRates != null && goldRates.goldSellPrice != 0.0) {
      return '${BaseUtil.digitPrecision(amount / goldRates.goldSellPrice!, 4, false)}gm';
    } else {
      return '0.0gm';
    }
  }

  showSuccessPrizeWithdrawalDialog(PrizeClaimChoice choice, String subtitle,
      double claimPrize, String gramsWon) async {
    //Starting the redemption sucessfull screen
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      widget: RedeemSucessfulScreen(
          subTitleWidget: getSubtitleWidget(subtitle),
          claimPrize: claimPrize,
          dpUrl: _userService.myUserDpUrl,
          choice: choice,
          wonGrams: gramsWon //await getGramsWon(claimPrize),
          ),
      page: RedeemSuccessfulScreenPageConfig,
    );
  }

  Future<bool> _registerClaimChoice(PrizeClaimChoice choice) async {
    if (choice == PrizeClaimChoice.NA) return false;
    final response = await _prizingRepo.claimPrize(
      _userService.userFundWallet!.unclaimedBalance,
      choice,
    );

    log("response.isSuccess() ${response.isSuccess()}");

    if (response.isSuccess()) {
      await _userService.getUserFundWalletData();
      await _transactionHistoryService
          .updateTransactions(InvestmentType.AUGGOLD99);
      // await _localDBModel!.savePrizeClaimChoice(choice);
      await AppState.backButtonDispatcher!.didPopRoute();

      return true;
    } else {
      await AppState.backButtonDispatcher!.didPopRoute();
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
          style: TextStyles.body3.colour(Colors.white),
          children: [
            TextSpan(
              text: locale.businessDays,
              style: TextStyles.body3.colour(Colors.white),
            )
          ],
        ),
      );
    }
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: TextStyles.body2.colour(Colors.white),
    );
  }

  ///CAPTURE
  ///
  ///
  ///

  caputure(String shareMessage) {
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

  shareCard(Uint8List image, String shareMessage) async {
    try {
      if (Platform.isAndroid) {
        final directory = (await getExternalStorageDirectory())!.path;
        String dt = DateTime.now().toString();
        File imgg = File('$directory/fello-reward-$dt.png');
        imgg.writeAsBytesSync(image);
        await Share.shareFiles(
          [imgg.path],
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
        });
      } else if (Platform.isIOS) {
        String dt = DateTime.now().toString();

        final directory = await getTemporaryDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);

        final File imgg =
            await File('${directory.path}/fello-reward-$dt.jpg').create();
        imgg.writeAsBytesSync(image);

        _logger.d("Image file created and sharing, ${imgg.path}");

        await Share.shareFiles(
          [imgg.path],
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
        });
      }
    } catch (e) {
      // backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(
          locale.taskFailed, locale.UnableToSharePicture);
    }
  }

  Future<String> createDynamicLink(bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix:
          '${FlavorConfig.instance!.values.dynamicLinkPrefix}/app/referral',
      link: Uri.parse('https://fello.in/${_userService.baseUser!.uid}'),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Download ${Constants.APP_NAME}',
          description:
              'Fello makes saving fun, and investing a lot more simple!',
          imageUrl: Uri.parse(
              'https://fello-assets.s3.ap-south-1.amazonaws.com/ic_social.png')),
      androidParameters: const AndroidParameters(
        packageName: 'in.fello.felloapp',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'in.fello.felloappiOS',
        minimumVersion: '0',
        appStoreId: '1558445254',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await FirebaseDynamicLinksPlatform
          .instance
          .buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = parameters.link;
    }

    return url.toString();
  }
}
