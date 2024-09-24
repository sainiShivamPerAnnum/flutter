import 'package:json_annotation/json_annotation.dart';

part 'top_expert_model.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class TopExpertModel {
  int id;
  String name;
  String bgImage;
  int exp;
  double rating;
  List<String> qualifications;
  int availableSlot;
  List<String> expertise;

  TopExpertModel(
      {required this.id,
      required this.name,
      required this.bgImage,
      required this.exp,
      required this.rating,
      required this.qualifications,
      required this.availableSlot,
      required this.expertise});

  factory TopExpertModel.fromJson(Map<String, dynamic> json) =>
      _$TopExpertModelFromJson(json);
}
