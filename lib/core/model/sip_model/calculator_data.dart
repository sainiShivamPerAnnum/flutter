import 'package:felloapp/core/model/sip_model/calculator_details.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calculator_data.g.dart';

@JsonSerializable(
  createToJson: false,
)
class CalculatorData {
  final List<String>? options;
  final Map<String, CalculatorDetails>? data;

  CalculatorData({this.options, this.data});
  factory CalculatorData.fromJson(Map<String, dynamic> json) =>
      _$CalculatorDataFromJson(json);
}
