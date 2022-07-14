import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/user_milestone_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class GoldenTicketRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://unzrx9x548.execute-api.ap-south-1.amazonaws.com/dev'
      : '';

  Future<ApiResponse<GoldenTicket>> getGoldenTicketById({
    String goldenTicketId,
  }) async {
    try {
      final token = await getBearerToken();
      final goldenTicketRespone = await APIService.instance.getData(
        ApiPath.getGoldenTicketById(
          this.userService.baseUser.uid,
          goldenTicketId,
        ),
        cBaseUrl: _baseUrl,
        token: token,
      );

      final ticket =
          GoldenTicket.fromJson(goldenTicketRespone['data'], goldenTicketId);
      return ApiResponse<GoldenTicket>(model: ticket, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch ticket", 400);
    }
  }

  Future<ApiResponse<List<UserMilestone>>> fetchMilestones() async {
    try {
      final token = await getBearerToken();
      final milestoneRespone = await APIService.instance.getData(
        ApiPath.getMilestone(
          this.userService.baseUser.uid,
        ),
        cBaseUrl: _baseUrl,
        token: token,
      );

      // final miletones = UserMilestoneModel.fromJson(milestoneRespone).data;
      final miletones =
          UserMilestone.helper.fromMapArray(milestoneRespone["data"]);
      return ApiResponse<List<UserMilestone>>(model: miletones, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch ticket", 400);
    }
  }

  Future<ApiResponse<PrizesModel>> getPrizesPerGamePerFreq(
      String gameCode, String freq) async {
    try {
      final token = await getBearerToken();
      final milestoneRespone = await APIService.instance.getData(
        ApiPath.prizes,
        cBaseUrl: _baseUrl,
        queryParams: {
          'game': gameCode,
          'freq': freq,
        },
        token: token,
      );

      final prizesModel = PrizesModel.fromJson(milestoneRespone["data"]);
      return ApiResponse<PrizesModel>(model: prizesModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch ticket", 400);
    }
  }
}
