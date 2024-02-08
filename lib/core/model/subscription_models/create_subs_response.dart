import 'package:json_annotation/json_annotation.dart';

import 'subscription_status_response.dart';

part 'create_subs_response.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class CreateSubscriptionResponse {
  final String message;
  final SubscriptionResponseData data;

  const CreateSubscriptionResponse({
    required this.data,
    this.message = '',
  });

  factory CreateSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateSubscriptionResponseFromJson(json);
}

@_deserializable
class SubscriptionResponseData {
  // If mandate is not created then will be receiving this object with url.
  final SubscriptionIntent intent;

  // If mandate already exists for this user then BE will be providing
  // subscription response
  final SubscriptionStatusData subscription;

  const SubscriptionResponseData({
    required this.intent,
    required this.subscription,
  });

  factory SubscriptionResponseData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseDataFromJson(json);
}

@_deserializable
class SubscriptionIntent {
  final String redirectUrl;
  final bool alreadyExist;
  final String id;

  const SubscriptionIntent({
    this.redirectUrl = '',
    this.alreadyExist = false,
    this.id = '',
  });

  factory SubscriptionIntent.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionIntentFromJson(json);
}
