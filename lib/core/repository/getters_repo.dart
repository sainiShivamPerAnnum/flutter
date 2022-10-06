import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/model/story_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/cupertino.dart';

class GetterRepository extends BaseRepo {
  final _cacheService = CacheService();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://qdp0idzhjc.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://vbbe56oey5.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse> getStatisticsByFreqGameTypeAndCode({
    String type,
    String freq,
    bool isForPast = false,
  }) async {
    try {
      final token = await getBearerToken();
      final String code = isForPast
          ? CodeFromFreq.getPastWeekCode()
          : CodeFromFreq.getCodeFromFreq(freq);
      final statisticsResponse = await APIService.instance.getData(
        ApiPath.statistics,
        cBaseUrl: _baseUrl,
        queryParams: {
          "type": type,
          "freq": freq,
          "code": code,
        },
        token: token,
      );

      print("Reaching here: ${statisticsResponse.toString()}");

      return ApiResponse(model: statisticsResponse["data"], code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<WinnersModel>> getWinnerByFreqGameType({
    String type,
    String freq,
  }) async {
    try {
      final token = await getBearerToken();
      final winnersResponse = await APIService.instance.getData(
        ApiPath.getWinners(type, freq),
        cBaseUrl: _baseUrl,
        token: token,
      );

      return ApiResponse(
        model: WinnersModel.fromMap(winnersResponse["data"]),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<List<WinnersModel>>> getPastWinners({
    String type,
    String freq,
  }) async {
    try {
      final token = await getBearerToken();
      final winnersResponse = await APIService.instance.getData(
        ApiPath.pastWinners(type, freq),
        cBaseUrl: _baseUrl,
        token: token,
      );

      final winnerModel =
          WinnersModel.helper.fromMapArray(winnersResponse["data"]);

      return ApiResponse(model: winnerModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<List<AmountChipsModel>>> getAmountChips({
    @required String freq,
  }) async {
    try {
      final token = await getBearerToken();
      final amountChipsResponse = await APIService.instance.getData(
        ApiPath.amountChips,
        cBaseUrl: _baseUrl,
        queryParams: {
          "freq": freq,
        },
        token: token,
      );

      final amountChipsModel =
          AmountChipsModel.helper.fromMapArray(amountChipsResponse["data"]);

      return ApiResponse(model: amountChipsModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<List<PromoCardModel>>> getPromoCards() async {
    try {
      final token = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.kPromos,
        cBaseUrl: _baseUrl,
        queryParams: {
          "uid": userService.baseUser.uid,
        },
        token: token,
      );

      final responseData = response["data"];

      print("Test123 ${response.toString()}");

      logger.d(responseData);
      final events = PromoCardModel.helper.fromMapArray(responseData['promos']);

      return ApiResponse<List<PromoCardModel>>(model: events, code: 200);
    } catch (e) {
      logger.e(e.toString());
      print("Test123 ${e.toString()}");
      return ApiResponse.withError("Unable to fetch promos", 400);
    }
  }

  Future<ApiResponse<List<FAQDataModel>>> getFaqs({
    FaqsType type,
  }) async {
    try {
      final token = await getBearerToken();

      return await _cacheService.cachedApi(
        '${CacheKeys.FAQS}/${type.name}',
        TTL.TWO_HOURS,
        () => APIService.instance.getData(
          ApiPath.faqs,
          token: token,
          cBaseUrl: _baseUrl,
          queryParams: {"type": type.name},
        ),
        (response) {
          final faqs = FAQDataModel.helper.fromMapArray(response["data"]);
          return ApiResponse<List<FAQDataModel>>(model: faqs, code: 200);
        },
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<List<StoryItemModel>>> getStory({String topic}) async {
    try {
      final token = await getBearerToken();
      final response = await APIService.instance.getData(
        '${ApiPath.kStory}/$topic',
        cBaseUrl: _baseUrl,
        queryParams: {"topic": topic},
        token: token,
      );

      final responseData = response["data"];

      logger.d(responseData);
      final events = StoryItemModel.helper.fromMapArray(responseData['slides']);

      return ApiResponse<List<StoryItemModel>>(model: events, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch promos", 400);
    }
  }

  //TODO: Not working
  //Triggered on: Share button click on win view
  // Future<ApiResponse<List<GoldenTicket>>> getGoldenTickets() async {
  //   try {
  //     // final token = await getBearerToken();
  //     final response = await APIService.instance.getData(
  //       ApiPath.goldenTickets(userService.baseUser.uid),
  //       cBaseUrl: "https://6w37rw51hj.execute-api.ap-south-1.amazonaws.com/dev",
  //       queryParams: {},
  //     );

  //     // final response2 = await APIService.instance.getData(
  //     //   "/user/ojUP6fumUgOb9wDMB6Jmoy32GOE3/golden_tickets",
  //     //   cBaseUrl: _baseUrl,
  //     //   queryParams: {},
  //     // );

  //     final responseData = response["data"]["gts"];

  //     print("Test123 ${response.toString()}");
  //     // final goldenTickets = GoldenTicket.fromJson(json, docId);

  //     // return ApiResponse<List<GoldenTicket>>(model: events, code: 200);
  //   } catch (e) {
  //     logger.e(e.toString());
  //     print("Test123 ${e.toString()}");

  //     return ApiResponse.withError("Unable to fetch golden tickets", 400);
  //   }
  // }
}
