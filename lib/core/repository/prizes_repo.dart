import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class PrizesRepository {
  final _logger = locator<Logger>();
  final _api = locator<Api>();

  Future<ApiResponse<PrizesModel>> getPrizesPerGamePerFreq(
      String gameCode, String freq) async {
    try {
      QueryDocumentSnapshot _queryDocumentSanpshot =
          await _api.getPrizesPerGamePerFreq(gameCode, freq);

      _logger.i("getPrizesPerGamePerFreq, successfully called");
      _logger.d(_queryDocumentSanpshot.data());

      PrizesModel _prizesModel =
          PrizesModel.fromMap(_queryDocumentSanpshot.data());
      return ApiResponse(model: _prizesModel, code: 200);
    } catch (e) {
      _logger.e(e);
      throw e;
    }
  }
}
