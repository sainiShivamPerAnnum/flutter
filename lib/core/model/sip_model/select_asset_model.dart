import 'package:felloapp/core/model/sip_model/select_asset_options.dart';
import 'package:json_annotation/json_annotation.dart';

part 'select_asset_model.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SelectAssetScreen {
  String? title;
  String? subTitle;
  List<AssetOptions>? options;

  SelectAssetScreen({this.title, this.subTitle, this.options});
  factory SelectAssetScreen.fromJson(Map<String, dynamic> json) =>
      _$SelectAssetScreenFromJson(json);
}
