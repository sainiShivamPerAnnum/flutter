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

  ExpertsHome({
    required this.list,
    required this.values,
    this.isAnyFreeCallAvailable = false,
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
  });

  factory Expert.fromJson(Map<String, dynamic> json) => _$ExpertFromJson(json);
}
