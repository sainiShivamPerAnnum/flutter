import 'package:felloapp/core/model/sip_model/sip_amount_details.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sip_amount_data.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SipAmountSelection {
  String? title;
  List<String>? options;
  Map<String, SipAmountDetails>? data;

  SipAmountSelection({this.title, this.options, this.data});
  factory SipAmountSelection.fromJson(Map<String, dynamic> json) =>
      _$SipAmountSelectionFromJson(json);
}
