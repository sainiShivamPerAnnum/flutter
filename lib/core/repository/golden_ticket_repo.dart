import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
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
    GoldenTicket ticket;
    try {
      final goldenTicketRespone = await APIService.instance.getData(
        ApiPath.getGoldenTicketById(
          this.userService.baseUser.uid,
          goldenTicketId,
        ),
        cBaseUrl: _baseUrl,
      );

      ticket =
          GoldenTicket.fromJson(goldenTicketRespone['data'], goldenTicketId);
      return ApiResponse<GoldenTicket>(model: ticket, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch ticket", 400);
    }
  }
}
