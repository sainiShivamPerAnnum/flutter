import 'dart:async';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_best_tickets_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class TambolaRepo extends BaseRepo {
  final _cacheService = CacheService();
  TimestampModel? lastTimeStamp;
  List<TambolaTicketModel> activeTambolaTickets = [];
  static int expiringTicketCount = 0;
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://qv53yko0b0.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://7icbm6j9e7.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<TambolaBestTicketsModel>> getBestTickets() async {
    TambolaBestTicketsModel? bestTickets;
    try {
      final uid = userService.baseUser!.uid;
      final token = await getBearerToken();

      // await preProcessTambolaTickets();

      final response = await APIService.instance.getData(
        ApiPath.tambolaBestTickets(uid!),
        token: token,
        cBaseUrl: _baseUrl,
      );
      bestTickets = TambolaBestTicketsModel.fromJson(response);
      // await postProcessTambolaTickets(response);
      expiringTicketCount = response["data"]["expiringTicketsCount"] ?? 0;

      return ApiResponse<TambolaBestTicketsModel>(
        model: bestTickets,
        code: 200,
      );
    } catch (e) {
      logger.e('Failed to get best tickets: $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<TambolaTicketModel>>> getTickets(
      int offset, int limit) async {
    // try {
    final uid = userService.baseUser!.uid;
    final token = await getBearerToken();

    // await preProcessTambolaTickets();

    final response = await APIService.instance.getData(
      ApiPath.tambolaTickets(uid),
      token: token,
      queryParams: {'limit': limit.toString(), 'offset': offset.toString()},
      cBaseUrl: _baseUrl,
    );
    List<TambolaTicketModel>? tickets =
        TambolaTicketModel.helper.fromMapArray(response['data']['tickets']);
    expiringTicketCount = response["data"]["expiringTicketsCount"] ?? 0;
    // await postProcessTambolaTickets(response);
    return ApiResponse<List<TambolaTicketModel>>(
      model: tickets ?? [],
      code: 200,
    );
    // } catch (e) {
    //   logger.e('get all tambola tickets $e');
    //   return ApiResponse.withError(e.toString(), 400);
    // }
  }

  // Future<void> preProcessTambolaTickets() async {
  //   CacheModel? cache = await _cacheService.getData(CacheKeys.TAMBOLA_TICKETS);
  //   if (cache != null) {
  //     dynamic cachedData = json.decode(cache.data!);
  //     final List<TambolaTicketModel> cachedTickets =
  //         TambolaTicketModel.helper.fromMapArray(cachedData["tickets"]);
  //     expiringTicketCount = cachedData["expiringTicketsCount"] ?? 0;
  //     arrangeTambolaTickets(cachedTickets, []);
  //   }
  // }

  // Future<void> postProcessTambolaTickets(response) async {
  //   final List<TambolaTicketModel> tickets =
  //       TambolaTicketModel.helper.fromMapArray(response["data"]["tickets"]);
  //   final List<TambolaTicketModel> deletedTickets = TambolaTicketModel.helper
  //       .fromMapArray(response["data"]["deletedTickets"]);
  //   expiringTicketCount = response["data"]["expiringTicketsCount"] ?? 0;
  //   if (tickets.isEmpty && deletedTickets.isEmpty) return;
  //   arrangeTambolaTickets(tickets, deletedTickets);
  //   List<Map<String, dynamic>> ticketData = [];
  //   if (activeTambolaTickets.isNotEmpty) {
  //     activeTambolaTickets.forEach((ticket) {
  //       ticketData.add(ticket.toMap());
  //     });
  //   }
  //   await CacheService.invalidateByKey(CacheKeys.TAMBOLA_TICKETS);
  //   if (ticketData.isNotEmpty) {
  //     unawaited(_cacheService.writeMap(
  //         CacheKeys.TAMBOLA_TICKETS, DateHelper.timeToWeekendInMinutes(), {
  //       "tickets": ticketData,
  //       "expiringTicketsCount": expiringTicketCount
  //     }));
  //   }
  // }

  // void arrangeTambolaTickets(List<TambolaTicketModel> tickets,
  //     List<TambolaTicketModel> deletedTickets) {
  //   if (activeTambolaTickets.isEmpty) {
  //     activeTambolaTickets = tickets;
  //   } else {
  //     if (deletedTickets.isNotEmpty) {
  //       deletedTickets.forEach((dt) {
  //         //   if (activeTambolaTickets.contains(dt))
  //         //     activeTambolaTickets.remove(dt);
  //         if (activeTambolaTickets.firstWhere((ticket) => ticket.id == dt.id,
  //                 orElse: () => TambolaTicketModel.none()) !=
  //             TambolaTicketModel.none()) {
  //           activeTambolaTickets.removeWhere((ticket) => ticket.id == dt.id);
  //         }
  //       });
  //     }
  //     if (tickets.isNotEmpty) {
  //       tickets.forEach((t) {
  //         if (activeTambolaTickets.firstWhere((ticket) => ticket.id == t.id,
  //                 orElse: () => TambolaTicketModel.none()) ==
  //             TambolaTicketModel.none()) activeTambolaTickets.add(t);
  //       });
  //     }
  //   }

  //   activeTambolaTickets.forEach((tt) {
  //     if (lastTimeStamp == null) {
  //       lastTimeStamp = tt.assignedTime;
  //     } else if (tt.assignedTime.toDate().isAfter(lastTimeStamp!.toDate())) {
  //       lastTimeStamp = tt.assignedTime;
  //     }
  //   });
  //   logger.d(
  //       "Latest TimeStamp: ${lastTimeStamp != null ? DateFormat('d MMMM, yyyy - hh:mm a').format(lastTimeStamp!.toDate()) + ' ' + lastTimeStamp!.toDate().toUtc().toString() + ' ' + lastTimeStamp!.toDate().toUtc().toIso8601String() : 'null'}");
  // }

  Future<ApiResponse<dynamic>> getWeeklyPicks() async {
    try {
      final String bearer = await getBearerToken();

      // cache till 6 PM only
      final now = DateTime.now();
      // final ttl = ((18 - now.hour) % 24) * 60 - now.minute;

      return await _cacheService.cachedApi(
          CacheKeys.TAMBOLA_PICKS,
          0,
          () => APIService.instance.getData(
                ApiPath.dailyPicks,
                token: bearer,
                cBaseUrl: _baseUrl,
              ), (dynamic response) {
        final data = response['data'];
        if (data != null && data.isNotEmpty) {
          return ApiResponse<DailyPick>(
            model: DailyPick.fromMap(data["picks"]),
            code: 200,
          );
        } else {
          return ApiResponse<DailyPick>(model: DailyPick.noPicks(), code: 200);
        }
      });
    } catch (e) {
      logger.e('daily pick $e');
      return ApiResponse<DailyPick>(model: DailyPick.noPicks(), code: 200);
    }
  }

  void dump() {
    lastTimeStamp = null;
    activeTambolaTickets = [];
    expiringTicketCount = 0;
  }
}
