import 'package:felloapp/core/model/sip_model/sip_amount.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calculator_details.g.dart';

@JsonSerializable(
  createToJson: false,
)
class CalculatorDetails {
  final SipAmount? sipAmount;
  final SipAmount? timePeriod;
  final Map<String, dynamic>? interest;
  final int? numberOfPeriodsPerYear;

  CalculatorDetails(
      {this.sipAmount,
      this.timePeriod,
      this.interest,
      this.numberOfPeriodsPerYear});
  factory CalculatorDetails.fromJson(Map<String, dynamic> json) =>
      _$CalculatorDetailsFromJson(json);
}
