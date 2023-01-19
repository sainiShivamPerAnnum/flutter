import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/golden_ticket_service_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/ui/pages/finance/autopay/autopay_process/autopay_process_view.dart';
import 'package:felloapp/ui/pages/rewards/instant_scratch_card/gt_instant_view.dart';
import 'package:felloapp/ui/pages/rewards/multiple_scratch_cards/multiple_scratch_cards_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:share_plus/share_plus.dart';

final GlobalKey ticketImageKey = GlobalKey();

class ScratchCardService
    extends PropertyChangeNotifier<ScratchCardServiceProperties> {
  final CustomLogger? _logger = locator<CustomLogger>();
  final ScratchCardRepository _gtRepo = locator<ScratchCardRepository>();
  final UserService? _userService = locator<UserService>();
  final PaytmService? _paytmService = locator<PaytmService>();
  final InternalOpsService? _internalOpsService = locator<InternalOpsService>();
  final AppFlyerAnalytics? _appFlyer = locator<AppFlyerAnalytics>();
  S locale = locator<S>();

  //ALL GOLDEN TICKETS VIEW FIELDS -- START
  bool isLastPageForScratchCards = false;
  bool _isFetchingScratchCards = false;
  String? scratchCardsListLastTicketId;
  bool get isFetchingScratchCards => this._isFetchingScratchCards;
  set isFetchingScratchCards(bool val) {
    this._isFetchingScratchCards = val;
    notifyListeners(ScratchCardServiceProperties.AllScratchCards);
  }

  List<ScratchCard> _allScratchCards = [];
  List<ScratchCard> get allScratchCards => this._allScratchCards;
  set allScratchCards(List<ScratchCard> value) {
    this._allScratchCards = value;
    // notifyListeners(ScratchCardServiceProperties.AllScratchCards);
  }

  void addScratchCards(List<ScratchCard>? value) {
    if (value != null) this._allScratchCards.addAll(value);
    // notifyListeners(ScratchCardServiceProperties.AllScratchCards);
  }

  //ALL GOLDEN TICKETS VIEW FIELDS -- START

  // static bool hasScratchCard = false;
  int _unscratchedTicketsCount = 0;
  int get unscratchedTicketsCount => this._unscratchedTicketsCount;

  set unscratchedTicketsCount(int value) {
    this._unscratchedTicketsCount = value;
    // notifyListeners(ScratchCardServiceProperties.UnscratchedCount);
  }

  static String? scratchCardId;
  static String? gameEndMsgText;
  static ScratchCard? currentGT;
  static String? lastScratchCardId;
  static List<String>? scratchCardsList;
  static String previousPrizeSubtype = '';

  static dump() {
    scratchCardId = null;
    gameEndMsgText = null;
    currentGT = null;
    lastScratchCardId = null;
    previousPrizeSubtype = '';
  }

  List<ScratchCard>? _unscratchedScratchCards;

  List<ScratchCard> get unscratchedScratchCards =>
      this._unscratchedScratchCards ?? [];

  set unscratchedScratchCards(List<ScratchCard> value) {
    this._unscratchedScratchCards = value;
    notifyListeners();
    log("Unscratched ScratchCard list updated");
  }

  List<ScratchCard>? _activeScratchCards;

  List<ScratchCard> get activeScratchCards => this._activeScratchCards ?? [];

  set activeScratchCards(List<ScratchCard>? value) {
    this._activeScratchCards = value;
    notifyListeners();
    log("ScratchCard list updated");
  }

  Future<bool> fetchAndVerifyScratchCardByID() async {
    if (scratchCardId != null && scratchCardId!.isNotEmpty) {
      ApiResponse<ScratchCard> ticketResponse =
          await _gtRepo!.getScratchCardById(
        scratchCardId: scratchCardId,
      );

      if (ticketResponse.code == 200 && isGTValid(ticketResponse.model!)) {
        currentGT = ticketResponse.model;
        scratchCardId = null;
        return true;
      } else {
        currentGT = null;
        scratchCardId = null;
        return false;
      }
    }
    return false;
  }

  Future<ScratchCard?> getScratchCardById(String? id) async {
    if (id != null && id.isNotEmpty) {
      ApiResponse<ScratchCard> ticketResponse =
          await _gtRepo.getScratchCardById(
        scratchCardId: id,
      );

      if (ticketResponse.code == 200 && isGTValid(ticketResponse.model!)) {
        return ticketResponse.model;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<bool> fetchAndVerifyScratchCardByPrizeSubtype() async {
    if (previousPrizeSubtype != null && previousPrizeSubtype.isNotEmpty) {
      ApiResponse<ScratchCard> ticketResponse =
          await _gtRepo!.getGTByPrizeSubtype(
        previousPrizeSubtype,
      );

      if (ticketResponse.code == 200 && isGTValid(ticketResponse.model!)) {
        currentGT = ticketResponse.model;
        return true;
      } else {
        currentGT = null;
        return false;
      }
    }
    return false;
  }

  showInstantScratchCardView(
      {required GTSOURCE source,
      String? title,
      double? amount = 0,
      bool onJourney = false,
      bool showAutoSavePrompt = false}) {
    if (AppState.isWebGameLInProgress || AppState.isWebGamePInProgress) return;
    if (currentGT != null) {
      log("previousPrizeSubtype $previousPrizeSubtype  && current gt prizeSubtype: ${ScratchCardService.currentGT!.prizeSubtype} ");
      if (previousPrizeSubtype == ScratchCardService.currentGT!.prizeSubtype &&
          !onJourney) return;
      Future.delayed(Duration(milliseconds: 200), () {
        // if (source != GTSOURCE.deposit)
        AppState.screenStack.add(ScreenItem.dialog);
        Navigator.of(AppState.delegate!.navigatorKey.currentContext!).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) => GTInstantView(
              source: source,
              title: title,
              amount: amount,
              showAutosavePrompt: showAutoSavePrompt,
            ),
          ),
        );
      });
    }
  }

  showMultipleScratchCardsView() {
    if (scratchCardsList != null && scratchCardsList!.isNotEmpty) {
      if (scratchCardsList!.length == 1) {
        scratchCardId = scratchCardsList![0];
        return fetchAndVerifyScratchCardByID()
            .then((_) => showInstantScratchCardView(source: GTSOURCE.prize));
      } else {
        AppState.screenStack.add(ScreenItem.dialog);
        Navigator.of(AppState.delegate!.navigatorKey.currentContext!).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) =>
                MultipleScratchCardsView(),
          ),
        );
      }
    }
  }

  Future<void> updateUnscratchedGTCount() async {
    final res = await _gtRepo.getGTByPrizeType("UNSCRATCHED");
    if (res.isSuccess())
      unscratchedTicketsCount = res.model!.length;
    else
      unscratchedTicketsCount = 0;
  }

  //HELPERS

  isGTValid(ScratchCard ticket) {
    if (ticket.isRewarding != null &&
        ticket.gtId != null &&
        ticket.gtType != null &&
        ticket.timestamp != null) return true;
    return false;
  }

  Future shareScratchCard(ScratchCard ticket) async {
    {
      try {
        String? url;
        final link = await _appFlyer!.inviteLink();
        if (link['status'] == 'success') {
          url = link['payload']['userInviteUrl'];
          if (url == null) url = link['payload']['userInviteURL'];
        }

        if (url != null)
          caputure(
              'Hey, I won ${ticket.rewardArr!.length > 1 ? "these prizes" : "this prize"} on Fello! \nLet\'s save and play together: $url');
      } catch (e) {
        _logger!.e(e.toString());
        BaseUtil.showNegativeAlert(
            locale.errorOccured, locale.obPleaseTryAgain);
      }
    }
  }

  caputure(String shareMessage) {
    Future.delayed(Duration(seconds: 1), () {
      captureCard().then((image) {
        if (image != null)
          shareCard(image, shareMessage);
        else {
          try {
            if (Platform.isIOS) {
              Share.share(shareMessage).catchError((onError) {
                if (_userService!.baseUser!.uid != null) {
                  Map<String, dynamic> errorDetails = {
                    'error_msg': 'Share reward text in My winnings failed'
                  };
                  _internalOpsService!.logFailure(_userService!.baseUser!.uid,
                      FailType.FelloRewardTextShareFailed, errorDetails);
                }
                _logger!.e(onError);
              });
            } else {
              Share.share(shareMessage).catchError((onError) {
                if (_userService!.baseUser!.uid != null) {
                  Map<String, dynamic> errorDetails = {
                    'error_msg': 'Share reward text in My winnings failed'
                  };
                  _internalOpsService!.logFailure(_userService!.baseUser!.uid,
                      FailType.FelloRewardTextShareFailed, errorDetails);
                }
                _logger!.e(onError);
              });
            }
          } catch (e) {
            _logger!.e(e.toString());
          }
        }
      });
    });
  }

  Future<Uint8List?> captureCard() async {
    try {
      RenderRepaintBoundary imageObject = ticketImageKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final image = await imageObject.toImage(pixelRatio: 2);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      if (_userService!.baseUser!.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Share reward card creation failed'
        };
        _internalOpsService!.logFailure(_userService!.baseUser!.uid,
            FailType.FelloRewardCardShareFailed, errorDetails);
      }

      AppState.backButtonDispatcher!.didPopRoute();
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
        File imgg = new File('$directory/fello-reward-$dt.png');
        imgg.writeAsBytesSync(image);
        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
        ).catchError((onError) {
          if (_userService!.baseUser!.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _internalOpsService!.logFailure(_userService!.baseUser!.uid,
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

        _logger!.d("Image file created and sharing, ${imgg.path}");

        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
        ).catchError((onError) {
          if (_userService!.baseUser!.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _internalOpsService!.logFailure(_userService!.baseUser!.uid,
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

  showAutosavePrompt() {
    if (!(AppConfig.getValue(AppConfigKey.autosaveActive) as bool)) return;
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissible: false,
      hapticVibrate: true,
      content: FelloInfoDialog(
        title: locale.savingsOnAuto,
        subtitle: locale.savingsOnAutoSubtitle,
        png: Assets.preAutosave,
        action: AppPositiveBtn(
          btnText: locale.btnSetupAutoSave,
          onPressed: () {
            AppState.backButtonDispatcher!.didPopRoute();
            openAutosave();
          },
        ),
      ),
    );
  }

  openAutosave() {
    if (!(AppConfig.getValue(AppConfigKey.autosaveActive) as bool)) return;

    if (_paytmService!.activeSubscription != null) {
      AppState.delegate!.appState.currentAction = PageAction(
          page: AutosaveProcessViewPageConfig,
          widget: AutosaveProcessView(page: 2),
          state: PageState.addWidget);
    } else {
      AppState.delegate!.appState.currentAction = PageAction(
        page: AutosaveDetailsViewPageConfig,
        state: PageState.addPage,
      );
    }
  }

  Future<void> fetchScratchCards({bool more = false}) async {
    try {
      if (isLastPageForScratchCards) return;
      if (isFetchingScratchCards) return;
      if (!more) allScratchCards.clear();
      isFetchingScratchCards = true;
      final res =
          await _gtRepo.getScratchCards(start: scratchCardsListLastTicketId);
      if (res.isSuccess()) {
        if (allScratchCards.isEmpty) {
          allScratchCards = res.model?["tickets"];
          isLastPageForScratchCards = res.model?["isLastPage"];
        } else {
          addScratchCards(res.model?["tickets"]);
          isLastPageForScratchCards = res.model?["isLastPage"];
        }
      }
      allScratchCards = arrangeScratchCards();
      scratchCardsListLastTicketId = allScratchCards.last.gtId;
      isFetchingScratchCards = false;
    } catch (e) {
      locator<InternalOpsService>().logFailure(
        _userService!.baseUser!.uid,
        FailType.ScratchCardListFailed,
        {'message': "Scratch Card data fetch failed"},
      );
      allScratchCards = [];
      isFetchingScratchCards = false;
    }
  }

  List<ScratchCard> arrangeScratchCards() {
    List<ScratchCard> arrangedScratchCardList = [];
    List<ScratchCard> temptickets = allScratchCards;
    temptickets
        .sort((a, b) => b.timestamp!.seconds.compareTo(a.timestamp!.seconds));
    temptickets.forEach((e) {
      if (e.redeemedTimestamp == null ||
          e.redeemedTimestamp == TimestampModel(nanoseconds: 0, seconds: 0)) {
        arrangedScratchCardList.add(e);
      }
    });
    temptickets.forEach((e) {
      if ((e.redeemedTimestamp != null &&
              e.redeemedTimestamp !=
                  TimestampModel(nanoseconds: 0, seconds: 0)) &&
          e.isRewarding!) {
        arrangedScratchCardList.add(e);
      }
    });
    return arrangedScratchCardList;
    // CODE FOR TICKET DISTINCTION - USE IF REQUIRED
    // final ids = Set();
    // arrangedScratchCardList.retainWhere((x) => ids.add(x.gtId));
    // arrangedScratchCardList = ids.toList();
  }

  refreshTickets({required String prizeSubtype}) {
    allScratchCards
        .firstWhere((ticket) => ticket.prizeSubtype == prizeSubtype)
        .redeemedTimestamp = TimestampModel.currentTimeStamp();
    allScratchCards = arrangeScratchCards();
    notifyListeners(ScratchCardServiceProperties.AllScratchCards);
  }
}
