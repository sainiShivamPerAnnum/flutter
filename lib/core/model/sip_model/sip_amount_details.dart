import 'package:felloapp/core/model/sip_model/sip_options.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sip_amount_details.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SipAmountDetails {
  final int? minamount;
  final int? numberOfPeriodsPerYear;
  final List<SipOptions>? options;

  SipAmountDetails({this.minamount, this.numberOfPeriodsPerYear, this.options});
  factory SipAmountDetails.fromJson(Map<String, dynamic> json) =>
      _$SipAmountDetailsFromJson(json);
}
