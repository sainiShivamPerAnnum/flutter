import 'package:json_annotation/json_annotation.dart';

part 'experts_home.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class ExpertsHome {
  final List<String> sections;
  final List<Expert> our_top_experts;
  final List<Expert> stock_market;
  final List<Expert> mutual_funds;
  final List<Expert> personal_finace;

  ExpertsHome({
    required this.sections,
    required this.our_top_experts,
    required this.stock_market,
    required this.mutual_funds,
    required this.personal_finace,
  });

  factory ExpertsHome.fromJson(Map<String, dynamic> json) =>
      _$ExpertsHomeFromJson(json);
}

@_deserializable
class Expert {
  final String name;
  final String experience;
  final double rating;
  final List<String> expertise;
  final List<String> qualifications;
  final String image;
  final bool isFree;
  final String advisorID;

  Expert({
    required this.name,
    required this.experience,
    required this.rating,
    required this.expertise,
    required this.qualifications,
    required this.image,
    required this.isFree,
    required this.advisorID,
  });

  factory Expert.fromJson(Map<String, dynamic> json) => _$ExpertFromJson(json);
}
