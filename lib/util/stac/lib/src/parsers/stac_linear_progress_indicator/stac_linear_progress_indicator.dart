import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:felloapp/util/stac/lib/src/parsers/parsers.dart';

export 'package:felloapp/util/stac/lib/src/parsers/stac_linear_progress_indicator/stac_linear_progress_indicator_parser.dart';

part 'stac_linear_progress_indicator.freezed.dart';
part 'stac_linear_progress_indicator.g.dart';

@freezed
class StacLinearProgressIndicator with _$StacLinearProgressIndicator {
  const factory StacLinearProgressIndicator({
    double? value,
    String? backgroundColor,
    String? color,
    double? minHeight,
    String? semanticsLabel,
    String? semanticsValue,
    @Default(StacBorderRadius()) StacBorderRadius borderRadius,
  }) = _StacLinearProgressIndicator;

  factory StacLinearProgressIndicator.fromJson(Map<String, dynamic> json) =>
      _$StacLinearProgressIndicatorFromJson(json);
}
