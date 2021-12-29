import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/tambola_ticket_generation_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';

class TicketGenerationRepo {
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();
  final _userService = locator<UserService>();

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  Future<ApiResponse<TambolaTicketGenerationModel>> generateTickets(
      {String userId, int numberOfTickets}) async {
    // try {
      final String _bearer = await _getBearerToken();
      final code = CodeFromFreq.getYearWeekCode();
      final _body = {
        "user_id": userId,
        "week_code": code,
        "num_tickets": numberOfTickets
      };

      _logger.d("Generating Tickets: ${_body.toString()}");

      final response = await APIService.instance.postData(
          _apiPaths.kGenerateTambolaTickets,
          body: _body,
          token: _bearer);

      TambolaTicketGenerationModel _tambolaTicketGenerationModel =
          TambolaTicketGenerationModel.fromMap(response);

      return ApiResponse(model: _tambolaTicketGenerationModel, code: 200);
    // } catch (e) {
    //   _logger.e(e.toString());
    //   return ApiResponse.withError("Ticket Generation Failed", 400);
    // }
  }
}
