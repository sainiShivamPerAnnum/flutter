import 'package:json_annotation/json_annotation.dart';

part 'sip_options.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SipOptions {
  int? order;
  int? value;
  bool? best;

  SipOptions({this.order, this.value, this.best});
  factory SipOptions.fromJson(Map<String, dynamic> json) =>
      _$SipOptionsFromJson(json);
}
