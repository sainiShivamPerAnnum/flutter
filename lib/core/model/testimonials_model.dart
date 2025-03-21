import 'package:json_annotation/json_annotation.dart';

part 'testimonials_model.g.dart';

@JsonSerializable()
class TestimonialsModel {
  final String userName;
  final num rating;
  final String review;
  final String createdAt;
  final String avatarId;
  final String dpUrl;

  TestimonialsModel({
    required this.userName,
    required this.rating,
    required this.review,
    required this.createdAt,
    this.avatarId = "AV1",
    this.dpUrl = "",
  });

  factory TestimonialsModel.fromJson(Map<String, dynamic> json) =>
      _$TestimonialsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TestimonialsModelToJson(this);
}
