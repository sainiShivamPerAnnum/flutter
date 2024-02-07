import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'select_asset_options.g.dart';

@JsonSerializable(
  createToJson: false,
)
class AssetOptions {
  final String title;
  final String imageUrl;
  final String subText;
  final bool defaultSelected;
  @JsonKey(unknownEnumValue: SIPAssetTypes.UNKNOWN)
  final SIPAssetTypes type;
  final num interest;

  AssetOptions(
      {this.title = '',
      this.imageUrl = '',
      this.subText = '',
      this.defaultSelected = false,
      this.type = SIPAssetTypes.UNKNOWN,
      this.interest = 8});
  factory AssetOptions.fromJson(Map<String, dynamic> json) =>
      _$AssetOptionsFromJson(json);
}
