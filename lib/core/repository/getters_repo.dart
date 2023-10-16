import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_config_model.dart';
import 'package:felloapp/core/model/home_screen_carousel_items.dart';
import 'package:felloapp/core/model/page_config_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/model/quick_save_model.dart';
import 'package:felloapp/core/model/story_model.dart';
import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/core/model/tambola_offers_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_rate_graph.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/material.dart';

//[TODO]:Added Prod CDN url;
class GetterRepository extends BaseRepo {
  final _cacheService = CacheService();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://qdp0idzhjc.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://vbbe56oey5.execute-api.ap-south-1.amazonaws.com/prod';

  final _cdnBaseUrl = FlavorConfig.isDevelopment()
      ? 'https://d18gbwu7fwwwtf.cloudfront.net/'
      : 'https://d11q4cti75qmcp.cloudfront.net/';

  Map? goldChartData;

  Future<ApiResponse> getStatisticsByFreqGameTypeAndCode({
    String? type,
    String? freq,
    bool isForPast = false,
  }) async {
    try {
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
      );

      debugPrint("Reaching here: ${statisticsResponse.toString()}");

      return ApiResponse(model: statisticsResponse["data"], code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<WinnersModel>> getWinnerByFreqGameType({
    String? type,
    String? freq,
  }) async {
    try {
      return await _cacheService.cachedApi<WinnersModel>(
        CacheKeys.TICKETS_LB,
        TTL.UPTO_SIX_PM,
        () => APIService.instance.getData(
          ApiPath.getWinners(type, freq),
          cBaseUrl: _baseUrl,
        ),
        (p0) {
          logger.d("Winners for $type: ${p0.toString()}");
          return ApiResponse(
            model: WinnersModel.fromMap(p0["data"]),
            code: 200,
          );
        },
      );

      // final winnersResponse = await APIService.instance.getData(
      //   ApiPath.getWinners(type, freq),
      //   cBaseUrl: _baseUrl,
      //   token: token,
      // );

      // return ApiResponse(
      //   model: WinnersModel.fromMap(winnersResponse["data"]),
      //   code: 200,
      // );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<AssetOptionsModel>> getAssetOptions(
    String freq,
    String type, {
    String? subType,
    bool? isOldLendboxUser,
    bool? isNewUser,
    String? entryPoint,
  }) async {
    try {
      Map<String, dynamic>? map = {
        "type": type,
        "freq": freq,
        "isNewUser": isNewUser.toString(),
      };

      if (entryPoint != null) {
        map['source'] = entryPoint;
      }

      if (type == "flo") {
        map.addAll({
          "subType": subType,
          "isOldLbUser": isOldLendboxUser.toString(),
        });
      }

      final response = await APIService.instance.getData(
        ApiPath.getAssetOptions(),
        queryParams: map,
        cBaseUrl: _baseUrl,
      );

      return ApiResponse<AssetOptionsModel>(
        code: 200,
        model: AssetOptionsModel.fromJson(
          response,
        ),
      );
    } catch (e) {
      return ApiResponse.withError('Something went wrong', 400);
    }
  }

  Future setUpAppConfigs() async {
    final appConfig = await getAppConfig();
    if (appConfig.code != 200) {
      AppConfig.instance({
        "message": "Default Values",
        "data": BaseRemoteConfig.DEFAULTS,
      });
    }
  }

  Future<ApiResponse<AppConfig>> getAppConfig() async {
    try {
      return await _cacheService.cachedApi<AppConfig>(
        CacheKeys.APPCONFIG,
        TTL.ONE_DAY,
        () => APIService.instance.getData(
          'appConfig.txt',
          cBaseUrl: _cdnBaseUrl,
          decryptData: true,
        ),
        (p0) {
          log("AppConfig: ${p0.toString()}", name: "AppConfig");
          return ApiResponse(
            code: 200,
            model: AppConfig.instance(p0),
          );
        },
      );
    } catch (e) {
      log(e.toString());
      return ApiResponse.withError('Something went wrong', 400);
    }
  }

  Future<ApiResponse<List<WinnersModel>>> getPastWinners({
    String? type,
    String? freq,
  }) async {
    try {
      final winnersResponse = await APIService.instance.getData(
        ApiPath.pastWinners(type, freq),
        cBaseUrl: _baseUrl,
      );

      final winnerModel =
          WinnersModel.helper.fromMapArray(winnersResponse["data"]);

      return ApiResponse(model: winnerModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch statistics", 400);
    }
  }

  // Future<ApiResponse<List<AmountChipsModel>>> getAmountChips({
  //   required String freq,
  // }) async {
  //   try {
  //     final token = await getBearerToken();
  //     final amountChipsResponse = await APIService.instance.getData(
  //       ApiPath.amountChips,
  //       cBaseUrl: _baseUrl,
  //       queryParams: {
  //         "freq": freq,
  //       },
  //       token: token,
  //     );

  //     final amountChipsModel =
  //         AmountChipsModel.helper.fromMapArray(amountChipsResponse["data"]);

  //     return ApiResponse(model: amountChipsModel, code: 200);
  //   } catch (e) {
  //     logger!.e(e.toString());
  //     return ApiResponse.withError("Unable to fetch statistics", 400);
  //   }
  // }

  Future<ApiResponse<List>> getSubCombosAndChips({
    required String freq,
  }) async {
    try {
      final subComboResponse = await APIService.instance.getData(
        ApiPath.getSubCombosChips(freq.toUpperCase()),
        cBaseUrl: _baseUrl,
      );

      final subComboModelData =
          SubComboModel.helper.fromMapArray(subComboResponse["data"]["combos"]);
      final augChips = AmountChipsModel.helper.fromMapArray(
          subComboResponse["data"][Constants.ASSET_TYPE_LENDBOX]["chips"]);

      final lbChips = AmountChipsModel.helper.fromMapArray(
          subComboResponse["data"][Constants.ASSET_TYPE_LENDBOX]["chips"]);

      final minMaxInfo = MaxMin.fromMap({
        "min": subComboResponse["data"]["min"],
        "max": MaxMinAsset.fromMap({
          'AUGGOLD99': subComboResponse["data"]["max"],
          'LENDBOXP2P': subComboResponse["data"]["max"]
        }).toMap()
      });

      return ApiResponse(
          model: [augChips, lbChips, subComboModelData, minMaxInfo], code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<List<PromoCardModel>>> getPromoCards() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.kPromos,
        cBaseUrl: _baseUrl,
        queryParams: {
          "uid": userService.baseUser!.uid,
        },
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

  Future<ApiResponse<dynamic>> getFaqs({
    required FaqsType type,
  }) async {
    try {
      // final token = await getBearerToken();

      return await _cacheService.cachedApi(
        '${CacheKeys.FAQS}/${type.name}',
        TTL.TWO_HOURS,
        () => APIService.instance.getData(
          ApiPath.faqs,
          // token: token,
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
          e.toString() ?? "Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<List<StoryItemModel>>> getStory({String? topic}) async {
    try {
      final response = await APIService.instance.getData(
        '${ApiPath.kStory}/$topic',
        cBaseUrl: _baseUrl,
        queryParams: {"topic": topic},
      );

      final responseData = response["data"];

      logger.d(responseData);
      final events = StoryItemModel.helper.fromMapArray(responseData['slides']);

      return ApiResponse<List<StoryItemModel>>(model: events, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch stories", 400);
    }
  }

  Future<ApiResponse<DynamicUI>> getPageConfigs() async {
    try {
      return await _cacheService.cachedApi(
        CacheKeys.PAGE_CONFIGS,
        TTL.ONE_DAY,
        () => APIService.instance.getData(
          "dynamicUi.txt",
          cBaseUrl: _cdnBaseUrl,
          decryptData: true,
        ),
        (response) {
          final responseData = response["dynamicUi"];

          // logger.d("Page Config: $responseData");
          final pageConfig = DynamicUI.fromMap(responseData);
          logger.d("Page Config: ${pageConfig.toString()}");
          return ApiResponse<DynamicUI>(model: pageConfig, code: 200);
        },
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch stories", 400);
    }
  }

  Future<ApiResponse<QuickSaveModel>> getQuickSave() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.quickSave,
        cBaseUrl: _baseUrl,
      );

      final quickSave = QuickSaveModel.fromJson(response);

      return ApiResponse<QuickSaveModel>(model: quickSave, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch stories", 400);
    }
  }

  Future<ApiResponse<List>> getIncentivesList() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.incentives,
        cBaseUrl: _baseUrl,
      );

      return ApiResponse<List>(
          model: response["data"]["earnMoreRewards"], code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch stories", 400);
    }
  }

  Future<ApiResponse<List<TicketsOffers>>> getTambolaOffers() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.tambolaOffers,
        cBaseUrl: _baseUrl,
      );

      return ApiResponse<List<TicketsOffers>>(
          model: TicketsOffers.helper.fromMapArray(response["data"]["offers"]),
          code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch stories", 400);
    }
  }

  Future<ApiResponse<Map>> getGoldRatesGraphItems() async {
    try {
      if (goldChartData != null) {
        return ApiResponse(model: goldChartData, code: 200);
      }

      return await _cacheService.cachedApi(
        CacheKeys.GOLD_RATES,
        TTL.ONE_WEEK,
        () => APIService.instance.getData(
          ApiPath.goldRatesGraph,
          cBaseUrl: _baseUrl,
        ),
        (response) {
          final List rates = response["data"]["rates"];

          final List<ChartData> chartData = [];

          for (int i = 0; i < rates.length; i++) {
            chartData.add(ChartData(day: i, price: rates[i]["rate"]));
          }

          List<String> returnsList = [];
          final Map returnsMap = response["data"]["returns"];

          returnsMap.forEach(
            (key, value) => returnsList.add(value),
          );

          final responseMap = {};
          responseMap["chartDataList"] = chartData;
          responseMap["returnsList"] = returnsList;
          log("Gold Rate Data $responseMap");
          goldChartData = responseMap;
          return ApiResponse(model: goldChartData, code: 200);
        },
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch stories", 400);
    }
  }

  Future<ApiResponse<List<HomeScreenCarouselItemsModel>>>
      getHomeScreenItems() async {
    try {
      return await _cacheService.cachedApi(
          CacheKeys.HOME_SCREEN_ITEMS,
          TTL.ONE_MIN,
          () => APIService.instance.getData(
                ApiPath.homeScreenCarouselItems,
                cBaseUrl: _baseUrl,
              ), (response) {
        List<HomeScreenCarouselItemsModel> items = HomeScreenCarouselItemsModel
            .helper
            .fromMapArray(response['data']["items"]);
        return ApiResponse<List<HomeScreenCarouselItemsModel>>(
            model: items, code: 200);
      });
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch stories", 400);
    }
  }

  Future<ApiResponse<GoldProConfig>> getGoldProConfig() async {
    try {
      return await _cacheService.cachedApi(
          CacheKeys.GOLDPRO_CONFIG,
          TTL.ONE_DAY,
          () => APIService.instance.getData(
                ApiPath.goldProConfig,
                cBaseUrl: _baseUrl,
              ), (response) {
        GoldProConfig config = GoldProConfig.fromJson(response);

        return ApiResponse<GoldProConfig>(
          model: config,
          code: 200,
        );
      });
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch stories", 400);
    }
  }
}
