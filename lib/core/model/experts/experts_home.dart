import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'experts_home.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class ExpertsHome {
  List<String> list;
  Map<String, List<Expert>> values;
  bool isAnyFreeCallAvailable;
  List<UserInterestedAdvisor> userInterestedAdvisors;

  ExpertsHome({
    required this.list,
    required this.values,
    this.isAnyFreeCallAvailable = false,
    this.userInterestedAdvisors = const [],
  });

  factory ExpertsHome.fromJson(Map<String, dynamic> json) =>
      _$ExpertsHomeFromJson(json);
}

@_deserializable
class Expert {
  final String name;
  final dynamic experience;
  final num rating;
  final String expertise;
  final String qualifications;
  final num rate;
  final String rateNew;
  final String image;
  final bool isFree;
  final String advisorId;
  final List<License> licenses;

  Expert({
    required this.name,
    required this.experience,
    required this.rating,
    required this.expertise,
    required this.qualifications,
    required this.rate,
    required this.rateNew,
    required this.image,
    required this.isFree,
    required this.advisorId,
    this.licenses = const [],
  });

  factory Expert.fromJson(Map<String, dynamic> json) => _$ExpertFromJson(json);
}

@_deserializable
class UserInterestedAdvisor {
  final String name;
  final dynamic experience;
  final num rating;
  final String description;
  final String expertise;
  final String qualifications;
  final num rate;
  final String rateNew;
  final String image;
  final bool isFree;
  final String advisorId;
  final List<License> licenses;
  final String originalPrice;
  @JsonKey(name: 'intro_videos')
  final List<VideoData> introVideos;
  final List<String> expertiseTags;

  UserInterestedAdvisor({
    required this.name,
    required this.experience,
    required this.description,
    required this.rating,
    required this.expertise,
    required this.qualifications,
    required this.rate,
    required this.rateNew,
    required this.image,
    required this.isFree,
    required this.advisorId,
    this.originalPrice = '',
    this.licenses = const [],
    this.introVideos = const [],
    this.expertiseTags = const [],
  });

  factory UserInterestedAdvisor.fromJson(Map<String, dynamic> json) =>
      _$UserInterestedAdvisorFromJson(json);
}
