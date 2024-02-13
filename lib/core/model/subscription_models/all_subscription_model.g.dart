// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscriptions _$SubscriptionsFromJson(Map<String, dynamic> json) =>
    Subscriptions(
      length: json['length'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      subs: (json['subs'] as List<dynamic>?)
              ?.map(
                  (e) => SubscriptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
