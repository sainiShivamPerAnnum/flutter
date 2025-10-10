import 'dart:async';

import 'package:dio/dio.dart';
import 'package:felloapp/util/stac/lib/src/action_parsers/stac_network_request/stac_network_request.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/services/stac_network_service.dart';
import 'package:felloapp/util/stac/lib/src/utils/action_type.dart';
import 'package:felloapp/util/stac/lib/src/utils/log.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';
import 'package:flutter/material.dart';

class StacNetworkRequestParser extends StacActionParser<StacNetworkRequest> {
  const StacNetworkRequestParser();

  @override
  String get actionType => ActionType.networkRequest.name;

  @override
  StacNetworkRequest getModel(Map<String, dynamic> json) =>
      StacNetworkRequest.fromJson(json);

  @override
  FutureOr onCall(BuildContext context, StacNetworkRequest model) async {
    Map<dynamic, dynamic>? response;

    try {
      response = await StacNetworkService.request(context, model);
    } on DioException catch (e) {
      response = e.response?.extra;
      Log.e(e.response);
    }

    if (response != null && response["statusCode"] != null) {
      final result = model.results.firstWhere(
        (element) => element.statusCode == response!["statusCode"],
      );

      if (context.mounted) {
        return Stac.onCallFromJson(result.action, context);
      }
    }
  }
}
