// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/app_environment.dart';
import 'package:felloapp/core/model/daily_bonus_event_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/rewardsquickLinks_model.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/preference_helper.dart';

class ScratchCardRepository extends BaseRepo {
  static const _rewards = 'rewards';

  Future<ApiResponse<ScratchCard>> getScratchCardById({
    String? scratchCardId,
  }) async {
    try {
      final scratchCardRespone = await APIService.instance.getData(
        ApiPath.getScratchCardById(
          userService.baseUser!.uid,
          scratchCardId,
        ),
        cBaseUrl: AppEnvironment.instance.rewards,
        apiName: '$_rewards/getScratchCardByID',
      );

      final ticket =
          ScratchCard.fromJson(scratchCardRespone['data'], scratchCardId!);
      return ApiResponse<ScratchCard>(model: ticket, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch ticket", 400);
    }
  }

  Future<ApiResponse<PrizesModel>> getPrizesPerGamePerFreq(
      String gameCode, String freq) async {
    try {
      final milestoneRespone = await APIService.instance.getData(
        ApiPath.prizes,
        cBaseUrl: AppEnvironment.instance.rewards,
        queryParams: {
          'game': gameCode,
          'freq': freq,
        },
        apiName: '$_rewards/getPrizeByGameCode',
      );

      final prizesModel = PrizesModel.fromMap(milestoneRespone["data"]);
      return ApiResponse<PrizesModel>(model: prizesModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch ticket", 400);
    }
  }

  //Skip milestone
  Future<ApiResponse<bool>> skipMilestone() async {
    try {
      final Map<String, int?> body = {
        "mlIndex": userService.userJourneyStats!.mlIndex
      };
      final queryParams = {"uid": userService.baseUser!.uid};
      final response = await APIService.instance.postData(
        ApiPath.kSkipMilestone(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.rewards,
        body: body,
        queryParams: queryParams,
        apiName: '$_rewards/skipMilestone',
      );
      if (response != null) {
        final responseData = response["data"];
        logger.d("Response from skip milestone API: $responseData");
        return ApiResponse(model: true, code: 200);
      } else {
        return ApiResponse(model: false, code: 400);
      }
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to skip milestone", 400);
    }
  }

  Future<ApiResponse<ScratchCard>> getGTByPrizeSubtype(
      String? prizeSubtype) async {
    try {
      final prizeResponse = await APIService.instance.getData(
        ApiPath.prizeBySubtype(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.rewards,
        queryParams: {
          'subType': prizeSubtype,
        },
        apiName: '$_rewards/getAllPrizeBySubtype',
      );

      final scratchCard = ScratchCard.fromJson(prizeResponse["data"], "");
      return ApiResponse<ScratchCard>(model: scratchCard, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch ticket", 400);
    }
  }

  Future<ApiResponse<List<ScratchCard>>> getUnscratchedScratchCards() async {
    final List<ScratchCard> unscratchedScratchCards = [];
    try {
      final prizeResponse = await APIService.instance.getData(
        ApiPath.getScratchCard(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.rewards,
        queryParams: {
          'type': 'UNSCRATCHED',
        },
        apiName: '$_rewards/getScratchCardByID',
      );
      final Map<String, dynamic>? responseData = prizeResponse["data"];
      if (responseData != null && responseData.isNotEmpty) {
        responseData["gts"].forEach((gt) {
          unscratchedScratchCards.add(ScratchCard.fromJson(gt, ""));
        });
      }

      return ApiResponse<List<ScratchCard>>(
          model: unscratchedScratchCards, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch ticket", 400);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getScratchCards(
      {String? start}) async {
    final List<ScratchCard> scratchCardsList = [];
    final List<RewardsQuickLinksModel> quickLinks = [];
    try {
      final prizeResponse = await APIService.instance.getData(
        ApiPath.getScratchCard(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.rewards,
        queryParams: {
          if (start != null) 'start': start,
        },
        apiName: '$_rewards/getScratchCardByID',
      );
      final Map<String, dynamic>? responseData = prizeResponse['data'];
      if (responseData != null && responseData.isNotEmpty) {
        responseData["gts"].forEach((gt) {
          scratchCardsList.add(ScratchCard.fromJson(gt, ""));
        });
        responseData["quickLinks"].forEach((links) {
          quickLinks.add(RewardsQuickLinksModel.fromJson(links));
        });
      }

      return ApiResponse(model: {
        "tickets": scratchCardsList,
        "links": quickLinks,
        "isLastPage": responseData!["isLastPage"]
      }, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<ScratchCard>>> getGTByPrizeType(String type) async {
    List<ScratchCard> tickets = [];
    try {
      final prizeResponse = await APIService.instance.getData(
        ApiPath.scratchCards(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.rewards,
        queryParams: {
          'type': type,
        },
        apiName: '$_rewards/getAllScratchCard',
      );
      List ticketsData = prizeResponse["data"]['gts'];
      for (final ticket in ticketsData) {
        tickets.add(ScratchCard.fromJson(ticket, ""));
      }

      return ApiResponse<List<ScratchCard>>(model: tickets, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch ticket", 400);
    }
  }

  Future<ApiResponse<bool>> redeemReward(
    String? gtId,
  ) async {
    try {
      final uid = userService.baseUser!.uid;

      Map<String, dynamic> body = {"uid": uid, "gtId": gtId};
      log("GT Redeem id: $body");
      final response = await APIService.instance.postData(
        ApiPath.kRedeemGtReward,
        body: body,
        cBaseUrl: AppEnvironment.instance.rewards,
        apiName: '$_rewards/redeem',
      );

      final data = response['data'];
      logger.d(data.toString());
      return ApiResponse(model: true, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<DailyAppCheckInEventModel>>
      getDailyBonusEventDetails() async {
    try {
      //LOCAL CHECK IF EVENT IS AVAILABLE FOR THS USER
      if (PreferenceHelper.getBool(
              PreferenceHelper.CACHE_IS_DAILY_APP_BONUS_EVENT_ACTIVE,
              def: true) ==
          false) return ApiResponse.withError("Event Over for this user", 400);

      //LOCAL CHECK IF REWARD FOR TODAY IS ALREADY CLAIMED
      final int lastBonusClaimedDay = PreferenceHelper.getInt(
          PreferenceHelper.CACHE_LAST_DAILY_APP_BONUS_REWARD_CLAIM_DAY);

      if (lastBonusClaimedDay != 0 &&
          lastBonusClaimedDay == DateTime.now().day) {
        return ApiResponse.withError("Reward Claimed for today", 400);
      }

      //No local restrictions found here. claiming today's bonus
      //FETCH EVENT DETAILS

      final response = await APIService.instance.getData(
        ApiPath.kDailyAppBonusEvent(
          userService.baseUser!.uid!,
        ),
        cBaseUrl: AppEnvironment.instance.rewards,
        apiName: '$_rewards/getDailyBonus',
      );
      log("DAILY APP : $response");
      final responseData = DailyAppCheckInEventModel.fromMap(response["data"]);

      //NETWORK CHECK IF EVENT OVER FOR THIS USER
      if (responseData.currentDay >= 7) {
        await PreferenceHelper.setBool(
            PreferenceHelper.CACHE_IS_DAILY_APP_BONUS_EVENT_ACTIVE, false);
        return ApiResponse.withError("Event over for this user", 400);
      }

      //NETWORK CHECK IF CLAIM WAS SUCCESSFUL OR NOT
      //If a goldenTicket is received in response model, consider it as a claim
      if (responseData.gtId.isEmpty) {
        await PreferenceHelper.setInt(
            PreferenceHelper.CACHE_LAST_DAILY_APP_BONUS_REWARD_CLAIM_DAY,
            DateTime.now().day);
        return ApiResponse.withError("Reward claimed for today", 400);
      } else {
        ScratchCardService.scratchCardId = responseData.gtId;
        await PreferenceHelper.setInt(
            PreferenceHelper.CACHE_LAST_DAILY_APP_BONUS_REWARD_CLAIM_DAY,
            DateTime.now().day);
        print("DAILY APP BOUNUS: claimed day cached is ${DateTime.now().day}");
      }
      //CHECK IF STREAK IS RESET
      if (responseData.streakBreakMessage.isNotEmpty) {
        responseData.showStreakBreakMessage = true;
      }

      //ALL GOOD, USER ELIGIBLE FOR DAILY APP REWARDS

      return ApiResponse(model: responseData, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  // Future<ApiResponse<DailyAppBonusClaimRewardModel>>
  //     claimDailyBonusEventDetails() async {
  //   try {
  //     final String bearer = await getBearerToken();
  //     final response = await APIService.instance.postData(
  //         ApiPath.kDailyAppBonusEvent(userService.baseUser!.uid!),
  //         token: bearer,
  //         cBaseUrl: _baseUrl);
  //     final responseData =
  //         DailyAppBonusClaimRewardModel.fromMap(response['data']);
  //     logger.d(response.toString());
  //     return ApiResponse(model: responseData, code: 200);
  //   } catch (e) {
  //     logger.e(e.toString());
  //     return ApiResponse.withError(e.toString(), 400);
  //   }
  // }
}

//TEST CASES
//NEW USER -> Signup -> first claim
//EXISTING USER -> Signin -> first claim
