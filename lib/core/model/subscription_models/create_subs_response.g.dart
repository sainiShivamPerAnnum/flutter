// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_subs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSubscriptionResponse _$CreateSubscriptionResponseFromJson(
        Map<String, dynamic> json) =>
    CreateSubscriptionResponse(
      data: SubscriptionResponseData.fromJson(
          json['data'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
    );

SubscriptionResponseData _$SubscriptionResponseDataFromJson(
        Map<String, dynamic> json) =>
    SubscriptionResponseData(
      intent:
          SubscriptionIntent.fromJson(json['intent'] as Map<String, dynamic>),
      subscription: SubscriptionStatusData.fromJson(
          json['subscription'] as Map<String, dynamic>),
    );

SubscriptionIntent _$SubscriptionIntentFromJson(Map<String, dynamic> json) =>
    SubscriptionIntent(
      redirectUrl: json['redirectUrl'] as String? ?? '',
      alreadyExist: json['alreadyExist'] as bool? ?? false,
      id: json['id'] as String? ?? '',
    );
