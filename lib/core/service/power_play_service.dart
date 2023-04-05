import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/power_play_models/match_user_predicted_model.dart';
import 'package:felloapp/core/model/power_play_models/match_winners_leaderboard_item_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/power_play_repo.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MatchStatus { active, upcoming, completed }

class PowerPlayService extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();
  final PowerPlayRepository _powerPlayRepository =
      locator<PowerPlayRepository>();

  final TransactionHistoryRepository _transactionHistoryRepository =
      locator<TransactionHistoryRepository>();

  List<MatchData> matchData = [];
  MatchData? liveMatchData;

  List<UserTransaction>? transactions = [];
  List<Map<String, dynamic>>? cardCarousel;

  Map<String, String> currentScore = {};

  static bool powerPlayDepositFlow = false;

  List<MatchUserPredictedData> _userPredictedData = [];

  List<MatchUserPredictedData> get userPredictedData => _userPredictedData;

  set userPredictedData(List<MatchUserPredictedData> value) {
    _userPredictedData = value;
  }

  // List<MatchData> get completedMatchData => _completedMatchData;

  void init() {
    _logger.i("PowerPlayService init");
  }

  void dump() {
    matchData = [];
    liveMatchData = null;
    powerPlayDepositFlow = false;
    _logger.i("PowerPlayService dump");
  }

  Future<List<MatchData>> getMatchesByStatus(
      String status, int limit, int offset) async {
    _logger.i("PowerPlayService -> getMatchesByStatus");
    final response =
        await _powerPlayRepository.getMatchesByStatus(status, limit, offset);
    log("SERVICE response => ${response.model?.data?.toList()}");

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

  Future<void> getUserPredictedStats() async {
    _logger.i("PowerPlayService -> getMatchStats");

    final response =
        await _powerPlayRepository.getUserPredictedStats('csk_rcb');

    log("SERVICE response => ${response.model?.data?.toList()}");

    if (response.isSuccess()) {
      userPredictedData = response.model!.data!;
    } else {
      BaseUtil.showNegativeAlert(response.errorMessage, "Please try again");
    }
  }

  Future<void> getUserTransactionHistory(
    MatchData matchData,
  ) async {
    _logger.i("PowerPlayService -> getTransactionHistory");
    var startTime;
    var endTime;

    if (matchData.status == MatchStatus.active.name) {
      startTime = matchData.startsAt;
      endTime = DateTime.now();
    } else if (matchData.status == MatchStatus.completed.name) {
      startTime = matchData.startsAt;
      endTime = matchData.endsAt;
    }

    final response =
        await _transactionHistoryRepository.getPowerPlayUserTransactions(
            startTime: startTime,
            endTime: endTime,
            type: 'DEPOSIT',
            status: 'COMPLETE');

    log("SERVICE response => ${response.model?.transactions?.toList()}");

    if (response.isSuccess()) {
      transactions = response.model!.transactions;

      log('transactions => ${transactions!.length}');
      // userPredictedData = response.model!.data!;
    } else {
      BaseUtil.showNegativeAlert(response.errorMessage, "Please try again");
    }
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
}

class PowerPlayWinDialog extends StatelessWidget {
  const PowerPlayWinDialog({
    super.key,
    required this.winString,
  });

  final String winString;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Container(
            margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
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
                  Column(mainAxisSize: MainAxisSize.min, children: [
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
                          'START PREDICTING NOW',
                          style:
                              TextStyles.rajdhaniB.body1.colour(Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                  ]),
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
