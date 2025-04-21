import 'package:freezed_annotation/freezed_annotation.dart';

export 'stac_sliver_to_box_adapter_parser.dart';

part 'stac_sliver_to_box_adapter.freezed.dart';
part 'stac_sliver_to_box_adapter.g.dart';

@freezed
abstract class StacSliverToBoxAdapter with _$StacSliverToBoxAdapter {
  const factory StacSliverToBoxAdapter({
    Map<String, dynamic>? child,
    String? key,
  }) = _StacSliverToBoxAdapter;

  factory StacSliverToBoxAdapter.fromJson(Map<String, dynamic> json) =>
      _$StacSliverToBoxAdapterFromJson(json);
}
