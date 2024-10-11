// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experts_home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpertsHome _$ExpertsHomeFromJson(Map<String, dynamic> json) => ExpertsHome(
      sections:
          (json['sections'] as List<dynamic>).map((e) => e as String).toList(),
      our_top_experts: (json['our_top_experts'] as List<dynamic>)
          .map((e) => Expert.fromJson(e as Map<String, dynamic>))
          .toList(),
      stock_market: (json['stock_market'] as List<dynamic>)
          .map((e) => Expert.fromJson(e as Map<String, dynamic>))
          .toList(),
      mutual_funds: (json['mutual_funds'] as List<dynamic>)
          .map((e) => Expert.fromJson(e as Map<String, dynamic>))
          .toList(),
      personal_finace: (json['personal_finace'] as List<dynamic>)
          .map((e) => Expert.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Expert _$ExpertFromJson(Map<String, dynamic> json) => Expert(
      name: json['name'] as String,
      experience: json['experience'] as String,
      rating: (json['rating'] as num).toDouble(),
      expertise:
          (json['expertise'] as List<dynamic>).map((e) => e as String).toList(),
      qualifications: (json['qualifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      image: json['image'] as String,
      isFree: json['isFree'] as bool,
      advisorID: json['advisorID'] as String,
    );
