import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class PrizeService extends ChangeNotifier {
  final GoldenTicketRepository _gtRepo = locator<GoldenTicketRepository>();

  Map<String, PrizesModel> gamePrizeMap = {};

  fetchPrizeByGameType(String game) async {
    ApiResponse<PrizesModel> prizeResult =
        await _gtRepo.getPrizesPerGamePerFreq(game, "weekly");
    if (prizeResult.isSuccess() && prizeResult.model != null)
      gamePrizeMap[game] = prizeResult.model!;
  }
}
