import 'package:json_annotation/json_annotation.dart';

part 'sip_options.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SipOptions {
  final int? order;
  final int value;
  final bool? best;

  SipOptions({this.order = 0, required this.value, this.best = false});
  factory SipOptions.fromJson(Map<String, dynamic> json) =>
      _$SipOptionsFromJson(json);
}
