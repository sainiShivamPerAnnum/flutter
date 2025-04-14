import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac/stac.dart';

part 'dynamic_view_widget.freezed.dart';
part 'dynamic_view_widget.g.dart';

@freezed
class DynamicViewWidget with _$DynamicViewWidget {
  const factory DynamicViewWidget({
    required StacNetworkRequest request,
    @Default('') String targetPath,
    required Map<String, dynamic> template,
  }) = _DynamicViewWidget;

  factory DynamicViewWidget.fromJson(Map<String, dynamic> json) =>
      _$DynamicViewWidgetFromJson(json);
}
