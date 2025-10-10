import 'package:freezed_annotation/freezed_annotation.dart';

part 'bloc_widget.freezed.dart';
part 'bloc_widget.g.dart';

/// The BLoC widget model for STAC
@freezed
class BlocWidget with _$BlocWidget {
  const factory BlocWidget({
    // The type of BLoC to be provided
    required String blocType,

    // Initial state for the BLoC
    Map<String, dynamic>? initialState,

    // Child widget
    Map<String, dynamic>? child,

    // List of events that can be handled
    List<BlocEventModel>? events,

    // Properties for the builder
    Map<String, dynamic>? builderProperties,

    // Whether this is a provider, builder, or consumer
    @Default('provider') String widgetType,

    //Initial event that can be fired
    Map<String, dynamic>? initialEvent,

    // Builder condition (when to rebuild)
    String? buildWhen,
    String? listenWhen,
  }) = _BlocWidget;

  factory BlocWidget.fromJson(Map<String, dynamic> json) =>
      _$BlocWidgetFromJson(json);
}

/// Model for BLoC events
@freezed
class BlocEventModel with _$BlocEventModel {
  const factory BlocEventModel({
    // Event type/name
    required String type,

    // Event payload
    Map<String, dynamic>? payload,

    // Trigger action (tap, longPress, etc.)
    @Default('tap') String trigger,
  }) = _BlocEventModel;

  factory BlocEventModel.fromJson(Map<String, dynamic> json) =>
      _$BlocEventModelFromJson(json);
}
