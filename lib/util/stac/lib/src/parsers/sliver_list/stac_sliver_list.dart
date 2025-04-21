import 'package:freezed_annotation/freezed_annotation.dart';

export 'stac_sliver_list_parser.dart';

part 'stac_sliver_list.freezed.dart';
part 'stac_sliver_list.g.dart';

@freezed
abstract class StacSliverList with _$StacSliverList {
  const factory StacSliverList({
    @Default(false) bool addAutomaticKeepAlives,
    @Default(false) bool addRepaintBoundaries,
    @Default(true) bool addSemanticIndexes,
    List<Map<String, dynamic>>? children,
    String? key,
    int? semanticIndexOffset,
  }) = _StacSliverList;

  factory StacSliverList.fromJson(Map<String, dynamic> json) =>
      _$StacSliverListFromJson(json);
}
