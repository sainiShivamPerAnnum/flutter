// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experts_home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpertsHome _$ExpertsHomeFromJson(Map<String, dynamic> json) => ExpertsHome(
      list: (json['list'] as List<dynamic>).map((e) => e as String).toList(),
      values: (json['values'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => Expert.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      isAnyFreeCallAvailable: json['isAnyFreeCallAvailable'] as bool? ?? false,
    );

Expert _$ExpertFromJson(Map<String, dynamic> json) => Expert(
      name: json['name'] as String,
      experience: json['experience'],
      rating: json['rating'] as num,
      expertise: json['expertise'] as String,
      qualifications: json['qualifications'] as String,
      rate: json['rate'] as String,
      image: json['image'] as String,
      isFree: json['isFree'] as bool,
      advisorId: json['advisorId'] as String,
    );
