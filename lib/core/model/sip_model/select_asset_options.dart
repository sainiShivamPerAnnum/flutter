import 'package:json_annotation/json_annotation.dart';

part 'select_asset_options.g.dart';

@JsonSerializable(
  createToJson: false,
)
class AssetOptions {
  String? title;
  String? imageUrl;
  String? subText;
  bool? defaultSelected;
  String? type;

  AssetOptions(
      {this.title,
      this.imageUrl,
      this.subText,
      this.defaultSelected,
      this.type});
  factory AssetOptions.fromJson(Map<String, dynamic> json) =>
      _$AssetOptionsFromJson(json);
}
