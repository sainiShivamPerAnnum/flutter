// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_expert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopExpertModel _$TopExpertModelFromJson(Map<String, dynamic> json) =>
    TopExpertModel(
      id: json['id'] as int,
      name: json['name'] as String,
      bgImage: json['bgImage'] as String,
      exp: json['exp'] as int,
      rating: (json['rating'] as num).toDouble(),
      qualifications: (json['qualifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      availableSlot: json['availableSlot'] as int,
      expertise:
          (json['expertise'] as List<dynamic>).map((e) => e as String).toList(),
    );
