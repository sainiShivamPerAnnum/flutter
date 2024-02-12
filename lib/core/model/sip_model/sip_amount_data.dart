import 'package:felloapp/core/model/sip_model/sip_amount_details.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sip_amount_data.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SipAmountSelection {
  final String title;
  final List<String> options;
  final Map<String, SipAmountDetails> data;

  const SipAmountSelection(
      {this.title = '', this.options = const [], this.data = const {}});
  factory SipAmountSelection.fromJson(Map<String, dynamic> json) =>
      _$SipAmountSelectionFromJson(json);
}
