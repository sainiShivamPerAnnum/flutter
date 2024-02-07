import 'package:felloapp/core/model/sip_model/calculator_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calculator_model.g.dart';

@JsonSerializable(
  createToJson: false,
)
class CalculatorScreen {
  final String title;
  final String imageUrl;
  final CalculatorData calculatorData;

  CalculatorScreen(
      {this.title = '', this.imageUrl = '', required this.calculatorData});
  factory CalculatorScreen.fromJson(Map<String, dynamic> json) =>
      _$CalculatorScreenFromJson(json);
}
