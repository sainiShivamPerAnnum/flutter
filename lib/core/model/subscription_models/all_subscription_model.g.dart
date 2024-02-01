// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllSubscriptionModel _$AllSubscriptionModelFromJson(
        Map<String, dynamic> json) =>
    AllSubscriptionModel(
      length: json['length'] as int?,
      isActive: json['isActive'] as bool?,
      subs: (json['subs'] as List<dynamic>?)
          ?.map((e) => SubscriptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
