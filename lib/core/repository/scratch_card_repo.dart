// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/app_environment.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/rewards_history.dart';
import 'package:felloapp/core/model/rewardsquickLinks_model.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class ScratchCardRepository extends BaseRepo {
  static const _rewards = 'rewards';
  final _newbaseUrl = FlavorConfig.isDevelopment()
      ? 'https://advisors.fello-dev.net/'
      : 'https://advisors.fello-prod.net/';

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

  Future<ApiResponse<List<RewardsHistoryModel>>> getRewardsHistory() async {
    try {
      final historyResponse = await APIService.instance.getData(
        'payments/txn/coins',
        cBaseUrl: _newbaseUrl,
        apiName: '$_rewards/getRewardsHistory',
      );
      final responseData = historyResponse["data"];

      final List<RewardsHistoryModel> history = (responseData as List)
          .map(
            (item) => RewardsHistoryModel.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse<List<RewardsHistoryModel>>(
        model: history,
        code: 200,
      );
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
      return ApiResponse.withError(e.toString(), 400);
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
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getScratchCards(
      {int? start}) async {
    final List<ScratchCard> scratchCardsList = [];
    final List<RewardsQuickLinksModel> quickLinks = [];
    try {
      final prizeResponse = await APIService.instance.getData(
        ApiPath.getScratchCard(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.rewards,
        queryParams: {
          if (start != null) 'offset': start,
        },
        apiName: '$_rewards/getScratchCardByID',
      );
      final Map<String, dynamic>? responseData = prizeResponse['data'];
      if (responseData != null && responseData.isNotEmpty) {
        responseData["gts"].forEach((gt) {
          scratchCardsList.add(ScratchCard.fromJson(gt, ""));
        });
        responseData["quickLinks"]?.forEach((links) {
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
      return ApiResponse.withError(e.toString(), 400);
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
