import 'package:json_annotation/json_annotation.dart';

part 'sip_amount.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SipAmount {
  final int min;
  final int max;
  final int multiples;
  @JsonKey(name: "default")
  final int defaultValue;

  SipAmount(
      {required this.min,
      required this.max,
      required this.multiples,
      required this.defaultValue});
  factory SipAmount.fromJson(Map<String, dynamic> json) =>
      _$SipAmountFromJson(json);
}
