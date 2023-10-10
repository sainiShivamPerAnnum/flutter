import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/power_play_models/match_user_predicted_model.dart';
import 'package:felloapp/core/model/power_play_models/match_winners_leaderboard_item_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/power_play_repo.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MatchStatus { active, upcoming, completed, half_complete }

class PowerPlayService extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();
  final PowerPlayRepository _powerPlayRepository =
      locator<PowerPlayRepository>();

  final TransactionHistoryRepository _transactionHistoryRepository =
      locator<TransactionHistoryRepository>();

  List<MatchData> matchData = [];
  MatchData? liveMatchData;
  bool isLinkSharing = false;
  bool _isPredictionsLoading = false;

  bool get isPredictionsLoading => _isPredictionsLoading;

  set isPredictionsLoading(bool value) {
    _isPredictionsLoading = value;
    notifyListeners();
  }

  List<UserTransaction>? _transactions = [];
  List<Map<String, dynamic>>? cardCarousel;

  Map<String, String> currentScore = {};

  static bool powerPlayDepositFlow = false;

  List<MatchUserPredictedData> _userPredictedData = [];

  List<MatchUserPredictedData> get userPredictedData => _userPredictedData;

  set userPredictedData(List<MatchUserPredictedData> value) {
    _userPredictedData = value;
  }

  List<UserTransaction>? get transactions => _transactions;

  set transactions(List<UserTransaction>? value) {
    _transactions = value;
    notifyListeners();
  }

  // List<MatchData> get completedMatchData => _completedMatchData;

  void init() {
    _logger.i("PowerPlayService init");
  }

  void dump() {
    matchData = [];
    liveMatchData = null;
    powerPlayDepositFlow = false;
    transactions = [];
    _userPredictedData = [];
    cardCarousel = null;
    currentScore = {};
    _logger.i("PowerPlayService dump");
  }

  Future<List<MatchData>> getMatchesByStatus(
      String status, int limit, int offset) async {
    _logger.i("PowerPlayService -> getMatchesByStatus");
    final response =
        await _powerPlayRepository.getMatchesByStatus(status, limit, offset);
    log("SERVICE response => ${response.model?.data?.length}");

    try {
      if (response.isSuccess()) {
        if (status == MatchStatus.active.name) {
          liveMatchData = response.model!.data![0];
        }
        return response.model!.data!;
      }
      return [];
    } catch (e) {
      _logger.d(e.toString());
      return [];
    }
  }

  Future<int> getPowerPlayRewards() async {
    _logger.i("PowerPlayService -> getPowerPlayRewards");
    final response = await _powerPlayRepository.getPowerPlayReward();
    log("SERVICE getPowerPlayRewards response => ${response.model?.data?.amount}");

    try {
      if (response.isSuccess()) {
        return response.model!.data!.amount!;
      }
      return 0;
    } catch (e) {
      _logger.d(e.toString());
      return 0;
    }
  }

  Future<void> getUserPredictedStats(String id) async {
    _logger.i("PowerPlayService -> getUserPredictedStats");

    final response = await _powerPlayRepository.getUserPredictedStats(id);

    log("SERVICE response => ${response.model?.data?.toList()}");

    if (response.isSuccess()) {
      userPredictedData = response.model!.data!;
    } else {
      BaseUtil.showNegativeAlert(response.errorMessage, "Please try again");
    }
  }

  Future<void> getUserTransactionHistory({required MatchData matchData}) async {
    _logger.i(
        "PowerPlayService -> getUserTransactionHistory -- MatchData $matchData");
    TimestampModel? startTime;
    TimestampModel? endTime;
    isPredictionsLoading = true;
    if (matchData.status == MatchStatus.active.name) {
      startTime = matchData.startsAt;
      endTime = TimestampModel.currentTimeStamp();
    } else if (matchData.status == MatchStatus.half_complete.name) {
      startTime = matchData.startsAt;
      endTime =
          matchData.predictionEndedAt ?? TimestampModel.currentTimeStamp();
    } else if (matchData.status == MatchStatus.completed.name) {
      startTime = matchData.startsAt;
      endTime = matchData.predictionEndedAt ?? matchData.endsAt;
    }

    final response =
        await _transactionHistoryRepository.getPowerPlayUserTransactions(
      startTime: startTime,
      endTime: endTime,
      type: 'DEPOSIT',
      status: 'COMPLETE',
      minAmount: 10,
      maxAmount: 999,
    );

    log("SERVICE response => ${response.model?.transactions?.toList()}");

    if (response.isSuccess()) {
      transactions = response.model?.transactions;
      log('transactions => ${transactions!.length}');
      notifyListeners();
    } else {
      BaseUtil.showNegativeAlert(response.errorMessage, "Please try again");
    }
    isPredictionsLoading = false;
  }

  Future<List<MatchWinnersLeaderboardItemModel>?>
      getCompletedMatchWinnersLeaderboard(String matchId) async {
    final res = await _powerPlayRepository.getWinnersLeaderboard(matchId);
    if (res.isSuccess()) {
      return res.model!;
    } else {
      BaseUtil.showNegativeAlert(
          res.errorMessage, "Please try again after sometime");
      return [];
    }
  }

  void showPowerPlayWinDialog(String payload) {
    final response = json.decode(payload);
    String winString = response["winString"] ?? "";
    BaseUtil.openDialog(
      isBarrierDismissible: false,
      addToScreenStack: true,
      content: PowerPlayWinDialog(winString: winString),
    );
  }

  Future<void> referFriend(String location) async {
    if (isLinkSharing) return;
    Haptic.vibrate();
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.iplInviteFriendsTapped,
      properties: {"location": location},
    );
    String powerPlayReferralString =
        "Hey! I am predicting in Fello's Powerplay and winning FREE Digital Gold! Sending you an exclusive invite to predict the Chasing score of every match and start your savings journey with Fello. Here's the link -";
    isLinkSharing = true;
    await locator<ReferralService>()
        .shareLink(customMessage: powerPlayReferralString);
    isLinkSharing = false;
  }
}

class PowerPlayWinDialog extends StatelessWidget {
  const PowerPlayWinDialog({
    required this.winString,
    super.key,
  });

  final String winString;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.pageHorizontalMargins,
                left: SizeConfig.pageHorizontalMargins,
                right: SizeConfig.pageHorizontalMargins,
                bottom: SizeConfig.padding10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              gradient: const LinearGradient(
                  colors: [Color(0xff91929C), Color(0xff4E536E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            padding: const EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  color: UiConstants.kPowerPlayPrimary),
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.network(
                        Assets.powerPlayMain,
                        width: SizeConfig.screenWidth! * 0.3,
                      ),
                      SvgPicture.asset(
                        Assets.wohoo,
                        width: SizeConfig.screenWidth! * 0.5,
                      ),
                      SizedBox(height: SizeConfig.padding10),
                      winString.beautify(
                          boldStyle: TextStyles.sourceSansB.body3
                              .colour(UiConstants.primaryColor),
                          style:
                              TextStyles.sourceSans.body3.colour(Colors.white)),
                      SizedBox(height: SizeConfig.padding16),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.white,
                        onPressed: () {
                          AppState.backButtonDispatcher!.didPopRoute();
                          AppState.delegate!
                              .parseRoute(Uri.parse('/win/myWinnings'));
                        },
                        child: Center(
                          child: Text(
                            'CLAIM REWARDS',
                            style:
                                TextStyles.rajdhaniB.body1.colour(Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding20,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onDoubleTap: () {
                        AppState.backButtonDispatcher!.didPopRoute();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
