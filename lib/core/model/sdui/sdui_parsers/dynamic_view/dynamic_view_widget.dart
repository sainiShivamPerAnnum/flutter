import 'package:felloapp/util/stac/lib/src/action_parsers/stac_network_request/stac_network_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'dynamic_view_widget.freezed.dart';
part 'dynamic_view_widget.g.dart';

@freezed
class DynamicViewWidget with _$DynamicViewWidget {
  const factory DynamicViewWidget({
    required StacNetworkRequest request,
    required Map<String, dynamic> template,
    @Default('') String targetPath,
  }) = _DynamicViewWidget;

  factory DynamicViewWidget.fromJson(Map<String, dynamic> json) =>
      _$DynamicViewWidgetFromJson(json);
}
