import 'package:json_annotation/json_annotation.dart';

part 'cart_details.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class CartDetails {
  final bool isAvailable;
  final String advisorId;
  final String advisorName;
  @JsonKey(name: 'advidorImg')
  final String advisorImg;
  final String? fromTime;
  final String? toTime;
  final int? duration;

  CartDetails({
    required this.advisorId,
    required this.advisorName,
    required this.advisorImg,
    this.isAvailable = true,
    this.duration,
    this.fromTime,
    this.toTime,
  });
  factory CartDetails.fromJson(Map<String, dynamic> json) =>
      _$CartDetailsFromJson(json);
}
