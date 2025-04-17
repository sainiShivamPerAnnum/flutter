import 'package:dio/dio.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/stac/lib/src/action_parsers/stac_network_request/stac_network_request.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:flutter/material.dart';

class StacNetworkService {
  const StacNetworkService._();

  static Future<Response?> request(
    BuildContext context,
    StacNetworkRequest request,
  ) async {
    switch (request.method) {
      case Method.get:
        return getRequest(request);
      case Method.post:
        return postRequest(request, context.mounted ? context : context);
      case Method.put:
        return putRequest(request);
      case Method.delete:
        return null;
    }
  }

  static Future<Response?> getRequest(StacNetworkRequest request) async {
    return APIService.instance.getData(
      request.url,
      queryParams: request.queryParameters,
      headers: Map<String, dynamic>.from(request.headers ?? {}),
      apiName: 'sdui/${request.url}',
    );
  }

  static Future<Response?> postRequest(
    StacNetworkRequest request,
    BuildContext context,
  ) async {
    final body = await _updateBody(context, request.body);

    return APIService.instance.postData(
      request.url,
      queryParams: request.queryParameters,
      body: body,
      headers: Map<String, String>.from(request.headers ?? {}),
      apiName: 'sdui/${request.url}',
    );
  }

  static Future<Response?> putRequest(StacNetworkRequest request) async {
    return APIService.instance.putData(
      request.url,
      body: request.body,
      headers: Map<String, dynamic>.from(request.headers ?? {}),
      apiName: 'sdui/${request.url}',
    );
  }

  // static Future<Response?> deleteRequest(StacNetworkRequest request) async {
  //   return APIService.instance.(
  //     request.url,
  //     queryParams: request.queryParameters,
  //     headers: Map<String, dynamic>.from(request.headers ?? {}),
  //     apiName: 'sdui/${request.url}',
  //   );
  // }

  static Future<dynamic> _updateBody(
    BuildContext context,
    dynamic body,
  ) async {
    Map<dynamic, dynamic> bodyMap = {};

    if (body is Map) {
      bodyMap.addAll(body);
      for (dynamic mapEntry in bodyMap.entries) {
        final key = mapEntry.key;
        final value = mapEntry.value;
        if (value is Map && value.containsKey('actionType')) {
          final dynamic callbackValue = await Future<dynamic>.value(
            Stac.onCallFromJson(value as Map<String, dynamic>, context),
          );
          bodyMap[key] = callbackValue;
        }
      }
    }

    return bodyMap;
  }
}
