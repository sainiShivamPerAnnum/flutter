import 'package:felloapp/core/model/sip_model/calculator_model.dart';
import 'package:felloapp/core/model/sip_model/select_asset_model.dart';
import 'package:felloapp/core/model/sip_model/sip_amount_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sip_data_model.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SipData {
  final SelectAssetScreen? selectAssetScreen;
  final CalculatorScreen? calculatorScreen;
  final SipAmountSelection? amountSelectionScreen;

  SipData(
      {this.selectAssetScreen,
      this.calculatorScreen,
      this.amountSelectionScreen});
  factory SipData.fromJson(Map<String, dynamic> json) =>
      _$SipDataFromJson(json);
}
