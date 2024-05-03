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
  final String type;
  final num interest;

  const AssetOptions(
      {this.title = '',
      this.imageUrl = '',
      this.subText = '',
      this.defaultSelected = false,
      this.type = 'UNKNOWN',
      this.interest = 8});
  factory AssetOptions.fromJson(Map<String, dynamic> json) =>
      _$AssetOptionsFromJson(json);
}

extension AssetOptionsX on AssetOptions {
  bool get isAugGold => type == 'AUGGOLD99';
  bool get isCombined => type == 'BOTH';
  bool get isLendBox =>
      type != 'AUGGOLD99' && type != 'BOTH' && type != 'UNKNOWN';
}
