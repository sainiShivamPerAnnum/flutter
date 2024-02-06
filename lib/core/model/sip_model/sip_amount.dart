import 'package:json_annotation/json_annotation.dart';

part 'sip_amount.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SipAmount {
  final int? min;
  final int? max;
  final int? multiples;
  @JsonKey(name: "default")
  final int? defaultValue;

  SipAmount({this.min, this.max, this.multiples, this.defaultValue});
  factory SipAmount.fromJson(Map<String, dynamic> json) =>
      _$SipAmountFromJson(json);
}
