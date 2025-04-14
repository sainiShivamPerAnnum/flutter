import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_image_widget.freezed.dart';
part 'app_image_widget.g.dart';

@freezed
class AppImageWidget with _$AppImageWidget {
  const factory AppImageWidget({
    required String image,
    String? fit,
    double? height,
    double? width,
    String? color,
  }) = _AppImageWidget;

  factory AppImageWidget.fromJson(Map<String, dynamic> json) =>
      _$AppImageWidgetFromJson(json);
}
