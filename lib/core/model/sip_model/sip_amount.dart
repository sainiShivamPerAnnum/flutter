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

  const SipAmount(
      {this.min = 0,
      this.max = 1000,
      this.multiples = 1,
      this.defaultValue = 1});
  factory SipAmount.fromJson(Map<String, dynamic> json) =>
      _$SipAmountFromJson(json);
}
