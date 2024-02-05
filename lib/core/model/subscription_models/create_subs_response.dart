import 'package:json_annotation/json_annotation.dart';

part 'create_subs_response.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
  checked: true,
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
  final SubscriptionIntent intent;

  const SubscriptionResponseData({
    required this.intent,
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
