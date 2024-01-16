import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/golden_ticket_service_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/rewardsquickLinks_model.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/rewards/instant_scratch_card/gt_instant_view.dart';
import 'package:felloapp/ui/pages/rewards/multiple_scratch_cards/multiple_scratch_cards_view.dart';
import 'package:felloapp/util/api_response.dart';
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
  final CustomLogger _logger = locator<CustomLogger>();
  final ScratchCardRepository _gtRepo = locator<ScratchCardRepository>();
  final UserService _userService = locator<UserService>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  final AppFlyerAnalytics _appFlyer = locator<AppFlyerAnalytics>();
  S locale = locator<S>();

  bool isLastPageForScratchCards = false;
  bool _isFetchingScratchCards = false;
  String? scratchCardsListLastTicketId;

  bool get isFetchingScratchCards => _isFetchingScratchCards;

  set isFetchingScratchCards(bool val) {
    _isFetchingScratchCards = val;
    notifyListeners();
  }

  List<ScratchCard> _allScratchCards = [];
  List<ScratchCard> get allScratchCards => _allScratchCards;
  set allScratchCards(List<ScratchCard> value) {
    _allScratchCards = value;
  }

  List<RewardsQuickLinksModel> _allQuickLinks = [];
  List<RewardsQuickLinksModel> get allRewardsQuickLinks => _allQuickLinks;
  set allRewardsQuickLinks(List<RewardsQuickLinksModel> value) {
    _allQuickLinks = value;
  }

  void addScratchCards(List<ScratchCard>? value) {
    if (value != null) _allScratchCards.addAll(value);
  }

  int _unscratchedMilestoneScratchCardCount = 0;
  int _unscratchedTicketsScratchCardCount = 0;

  int get unscratchedMilestoneScratchCardCount =>
      _unscratchedMilestoneScratchCardCount;
  int get unscratchedTicketsScratchCardCount =>
      _unscratchedTicketsScratchCardCount;
  set unscratchedMilestoneScratchCardCount(int value) {
    _unscratchedMilestoneScratchCardCount = value;
    notifyListeners();
  }

  set unscratchedTicketsScratchCardCount(int value) {
    _unscratchedTicketsScratchCardCount = value;
    notifyListeners();
  }

  int _unscratchedTicketsCount = 0;
  int get unscratchedTicketsCount => _unscratchedTicketsCount;
  set unscratchedTicketsCount(int value) {
    _unscratchedTicketsCount = value;
    notifyListeners();
  }

  static String? scratchCardId;
  static String? gameEndMsgText;
  static ScratchCard? currentGT;
  static String? lastScratchCardId;
  static List<String>? scratchCardsList;
  static String previousPrizeSubtype = '';

  dump() {
    scratchCardId = null;
    gameEndMsgText = null;
    currentGT = null;
    lastScratchCardId = null;
    previousPrizeSubtype = '';
    _unscratchedTicketsCount = 0;
    _unscratchedMilestoneScratchCardCount = 0;
    _unscratchedTicketsScratchCardCount = 0;
  }

  List<ScratchCard>? _unscratchedScratchCards;

  List<ScratchCard> get unscratchedScratchCards =>
      _unscratchedScratchCards ?? [];

  set unscratchedScratchCards(List<ScratchCard> value) {
    _unscratchedScratchCards = value;
    notifyListeners();
    log("Unscratched ScratchCard list updated");
  }

  List<ScratchCard>? _activeScratchCards;

  List<ScratchCard> get activeScratchCards => _activeScratchCards ?? [];

  set activeScratchCards(List<ScratchCard>? value) {
    _activeScratchCards = value;
    notifyListeners();
    log("ScratchCard list updated");
  }

  Future<bool> fetchAndVerifyScratchCardByID() async {
    if (scratchCardId != null && scratchCardId!.isNotEmpty) {
      ApiResponse<ScratchCard> ticketResponse =
          await _gtRepo.getScratchCardById(
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
    if (previousPrizeSubtype.isNotEmpty) {
      ApiResponse<ScratchCard> ticketResponse =
          await _gtRepo.getGTByPrizeSubtype(
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

  Future<void> showInstantScratchCardView(
      {required GTSOURCE source,
      String? title,
      double? amount = 0,
      bool onJourney = false,
      bool showRatingDialog = true,
      bool showAutoSavePrompt = false}) async {
    if (AppState.isWebGameLInProgress || AppState.isWebGamePInProgress) return;
    if (currentGT != null) {
      log("previousPrizeSubtype $previousPrizeSubtype  && current gt prizeSubtype: ${ScratchCardService.currentGT!.prizeSubtype} ");
      if (previousPrizeSubtype == ScratchCardService.currentGT!.prizeSubtype &&
          !onJourney) return;
      await Future.delayed(const Duration(milliseconds: 200), () async {
        // if (source != GTSOURCE.deposit)
        AppState.screenStack.add(ScreenItem.dialog);
        await Navigator.of(AppState.delegate!.navigatorKey.currentContext!)
            .push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) => GTInstantView(
              source: source,
              title: title,
              amount: amount,
              showRatingDialog: showRatingDialog,
              showAutosavePrompt: showAutoSavePrompt,
            ),
          ),
        );
      });
    }
  }

  void showMultipleScratchCardsView() {
    if (scratchCardsList != null && scratchCardsList!.isNotEmpty) {
      if (scratchCardsList!.length == 1) {
        scratchCardId = scratchCardsList![0];
        fetchAndVerifyScratchCardByID()
            .then((_) => showInstantScratchCardView(source: GTSOURCE.prize));
      } else {
        AppState.screenStack.add(ScreenItem.dialog);
        Navigator.of(AppState.delegate!.navigatorKey.currentContext!).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) => const MultipleScratchCardsView(),
          ),
        );
      }
    }
  }

  Future<void> updateUnscratchedGTCount() async {
    final res = await _gtRepo.getGTByPrizeType("UNSCRATCHED");
    if (res.isSuccess()) {
      unscratchedTicketsCount = res.model!.length;
      unscratchedMilestoneScratchCardCount = 0;
      unscratchedTicketsScratchCardCount = 0;
      for (final sc in res.model!) {
        if (sc.prizeSubtype!.toLowerCase().contains("_mlst_")) {
          unscratchedMilestoneScratchCardCount += 1;
        }
        if (sc.eventType!.contains("buyTambolaTickets")) {
          unscratchedTicketsScratchCardCount += 1;
        }
      }
    } else {
      unscratchedTicketsCount = 0;
    }
  }

  //HELPERS

  bool isGTValid(ScratchCard ticket) {
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
        final link = await _appFlyer.inviteLink();
        if (link['status'] == 'success') {
          url = link['payload']['userInviteUrl'];
          url ??= link['payload']['userInviteURL'];
        }

        if (url != null) {
          caputure(
              'Hey, I won ${ticket.rewardArr!.length > 1 ? "these prizes" : "this prize"} on Fello! \nLet\'s save and play together: $url');
        }
      } catch (e) {
        _logger.e(e.toString());
        BaseUtil.showNegativeAlert(
            locale.errorOccured, locale.obPleaseTryAgain);
      }
    }
  }

  caputure(String shareMessage) {
    Future.delayed(const Duration(seconds: 1), () {
      captureCard().then((image) {
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
      RenderRepaintBoundary imageObject = ticketImageKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
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
        unawaited(Share.shareFiles(
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
        }));
      } else if (Platform.isIOS) {
        String dt = DateTime.now().toString();

        final directory = await getTemporaryDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);

        final File imgg =
            await File('${directory.path}/fello-reward-$dt.jpg').create();
        imgg.writeAsBytesSync(image);

        _logger.d("Image file created and sharing, ${imgg.path}");

        unawaited(Share.shareFiles(
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
        }));
      }
    } catch (e) {
      // backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(
          locale.taskFailed, locale.UnableToSharePicture);
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
        allRewardsQuickLinks = res.model?["links"];
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
      unawaited(locator<InternalOpsService>().logFailure(
        _userService.baseUser!.uid,
        FailType.ScratchCardListFailed,
        {'message': "Scratch Card data fetch failed"},
      ));
      allScratchCards = [];
      isFetchingScratchCards = false;
    }
  }

  List<ScratchCard> arrangeScratchCards() {
    List<ScratchCard> arrangedScratchCardList = [];
    List<ScratchCard> tempTickets = allScratchCards;
    tempTickets
        .sort((a, b) => b.timestamp!.seconds.compareTo(a.timestamp!.seconds));
    for (final e in tempTickets) {
      if (e.redeemedTimestamp == null ||
          e.redeemedTimestamp == TimestampModel(nanoseconds: 0, seconds: 0)) {
        arrangedScratchCardList.add(e);
      }
    }
    for (final e in tempTickets) {
      if ((e.redeemedTimestamp != null &&
              e.redeemedTimestamp !=
                  TimestampModel(nanoseconds: 0, seconds: 0)) &&
          e.isRewarding!) {
        arrangedScratchCardList.add(e);
      }
    }
    return arrangedScratchCardList;
    // CODE FOR TICKET DISTINCTION - USE IF REQUIRED
    // final ids = Set();
    // arrangedScratchCardList.retainWhere((x) => ids.add(x.gtId));
    // arrangedScratchCardList = ids.toList();
  }

  void refreshTickets({required String gtId}) {
    allScratchCards
        .firstWhere((ticket) => ticket.gtId == gtId)
        .redeemedTimestamp = TimestampModel.currentTimeStamp();
    allScratchCards = arrangeScratchCards();
    notifyListeners();
  }
}
