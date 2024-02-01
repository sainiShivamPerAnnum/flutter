import 'package:felloapp/core/model/sip_model/calculator_model.dart';
import 'package:felloapp/core/model/sip_model/select_asset_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sip_data_model.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SipData {
  SelectAssetScreen? selectAssetScreen;
  CalculatorScreen? calculatorScreen;

  SipData({this.selectAssetScreen, this.calculatorScreen});
  factory SipData.fromJson(Map<String, dynamic> json) =>
      _$SipDataFromJson(json);
}
