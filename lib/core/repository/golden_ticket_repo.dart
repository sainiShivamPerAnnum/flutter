import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class GoldenTicketRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://3yoxli7gxc.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://jad0ai2t6k.execute-api.ap-south-1.amazonaws.com/prod';

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

  //Skip milestone
  Future<ApiResponse<bool>> skipMilestone() async {
    try {
      final Map<String, int> _body = {
        "mlIndex": userService.userJourneyStats.mlIndex
      };
      final queryParams = {"uid": userService.baseUser.uid};
      final token = await getBearerToken();
      final response = await APIService.instance.postData(
        ApiPath.kSkipMilestone(userService.baseUser.uid),
        token: token,
        cBaseUrl: _baseUrl,
        body: _body,
        queryParams: queryParams,
      );
      if (response != null) {
        final responseData = response["data"];
        logger.d("Response from skip milestone API: $responseData");
        return ApiResponse(model: true, code: 200);
      } else
        return ApiResponse(model: false, code: 400);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to skip milestone", 400);
    }
  }

  Future<ApiResponse<GoldenTicket>> getGTByPrizeSubtype(
      String prizeSubtype) async {
    try {
      final token = await getBearerToken();
      final prizeResponse = await APIService.instance.getData(
        ApiPath.prizeBySubtype(userService.baseUser.uid),
        cBaseUrl: _baseUrl,
        queryParams: {
          'subType': prizeSubtype,
        },
        token: token,
      );

      final goldenTicket = GoldenTicket.fromJson(prizeResponse["data"], "");
      return ApiResponse<GoldenTicket>(model: goldenTicket, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch ticket", 400);
    }
  }

  Future<ApiResponse<List<GoldenTicket>>> getGTByPrizeType(String type) async {
    List<GoldenTicket> tickets = [];
    try {
      final token = await getBearerToken();
      final prizeResponse = await APIService.instance.getData(
        ApiPath.goldenTickets(userService.baseUser.uid),
        cBaseUrl: _baseUrl,
        queryParams: {
          'type': type,
        },
        token: token,
      );
      List ticketsData = prizeResponse["data"]['gts'];
      ticketsData.forEach((ticket) {
        tickets.add(GoldenTicket.fromJson(ticket, ""));
      });

      return ApiResponse<List<GoldenTicket>>(model: tickets, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch ticket", 400);
    }
  }

  Future<ApiResponse<bool>> redeemReward(
    String gtId,
  ) async {
    try {
      final uid = userService.baseUser.uid;
      final String bearer = await getBearerToken();

      Map<String, dynamic> body = {"uid": uid, "gtId": gtId};

      final response = await APIService.instance.postData(
        ApiPath.kRedeemGtReward,
        body: body,
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data'];
      this.logger.d(data.toString());
      return ApiResponse(model: true, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
