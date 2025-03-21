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
      userInterestedAdvisors: (json['userInterestedAdvisors'] as List<dynamic>?)
              ?.map((e) =>
                  UserInterestedAdvisor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Expert _$ExpertFromJson(Map<String, dynamic> json) => Expert(
      name: json['name'] as String,
      experience: json['experience'],
      rating: json['rating'] as num,
      expertise: json['expertise'] as String,
      qualifications: json['qualifications'] as String,
      rate: json['rate'] as num,
      rateNew: json['rateNew'] as String,
      image: json['image'] as String,
      isFree: json['isFree'] as bool,
      advisorId: json['advisorId'] as String,
      licenses: (json['licenses'] as List<dynamic>?)
              ?.map((e) => License.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

UserInterestedAdvisor _$UserInterestedAdvisorFromJson(
        Map<String, dynamic> json) =>
    UserInterestedAdvisor(
      name: json['name'] as String,
      experience: json['experience'],
      description: json['description'] as String,
      rating: json['rating'] as num,
      expertise: json['expertise'] as String,
      qualifications: json['qualifications'] as String,
      rate: json['rate'] as num,
      rateNew: json['rateNew'] as String,
      image: json['image'] as String,
      isFree: json['isFree'] as bool,
      advisorId: json['advisorId'] as String,
      originalPrice: json['originalPrice'] as String? ?? '',
      licenses: (json['licenses'] as List<dynamic>?)
              ?.map((e) => License.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      introVideos: (json['intro_videos'] as List<dynamic>?)
              ?.map((e) => VideoData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      expertiseTags: (json['expertiseTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
