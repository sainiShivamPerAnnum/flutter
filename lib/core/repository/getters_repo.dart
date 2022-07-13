import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/cupertino.dart';

class GetterRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://qdp0idzhjc.execute-api.ap-south-1.amazonaws.com/dev'
      : '';

  Future<ApiResponse> getStatisticsByFreqGameTypeAndCode({
    String type,
    String freq,
  }) async {
    try {
      final String code = CodeFromFreq.getCodeFromFreq(freq);
      final statisticsResponse = await APIService.instance.getData(
        ApiPath.statistics,
        cBaseUrl: _baseUrl,
        queryParams: {
          "type": type,
          "freq": freq,
          "code": code,
        },
      );

      return ApiResponse(model: statisticsResponse["data"], code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<WinnersModel>> getWinnerByFreqGameType({
    String type,
    String freq,
  }) async {
    try {
      final winnersResponse = await APIService.instance.getData(
        ApiPath.getWinners(type, freq),
        cBaseUrl: _baseUrl,
      );

      return ApiResponse(
        model: WinnersModel.fromMap(winnersResponse["data"]),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch statistics", 400);
    }
  }

  Future<ApiResponse<List<WinnersModel>>> getPastWinners({
    String type,
    String freq,
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

  Future<ApiResponse<List<AmountChipsModel>>> getAmountChips({
    @required String freq,
  }) async {
    try {
      final amountChipsResponse = await APIService.instance.getData(
        ApiPath.amountChips,
        cBaseUrl: _baseUrl,
        queryParams: {
          "freq": freq,
        },
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
      final response = await APIService.instance.getData(
        ApiPath.kPromos,
        cBaseUrl: _baseUrl,
        queryParams: {
          "uid": userService.baseUser.uid,
        },
      );

      final responseData = response["data"];

      logger.d(responseData);
      final events = PromoCardModel.helper.fromMapArray(responseData['promos']);

      return ApiResponse<List<PromoCardModel>>(model: events, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch promos", 400);
    }
  }
}
