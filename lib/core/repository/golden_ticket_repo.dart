import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/flavor_config.dart';

class GoldenTicketRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://unzrx9x548.execute-api.ap-south-1.amazonaws.com/dev'
      : '';

  Future<GoldenTicket> getGoldenTicketById({String goldenTicketId}) async {
    GoldenTicket ticket;
    try {
      logger.i("CALLING: fetchGoldenTicketById");
      logger.i("Kunj: fetchGoldenTicketById");
      final goldenTicketRespone = await APIService.instance.getData(
            ApiPath.getGoldenTicketById(
              this.userService.baseUser.uid,
              goldenTicketId,
            ),
            cBaseUrl: _baseUrl,
          ) ??
          {};
      if (goldenTicketRespone != null) {
        ticket =
            GoldenTicket.fromJson(goldenTicketRespone['data'], goldenTicketId);
      }
    } catch (e) {
      return ticket;
    }
    return ticket;
  }
}
