// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bloc_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BlocWidget _$BlocWidgetFromJson(Map<String, dynamic> json) {
  return _BlocWidget.fromJson(json);
}

/// @nodoc
mixin _$BlocWidget {
// The type of BLoC to be provided
  String get blocType =>
      throw _privateConstructorUsedError; // Initial state for the BLoC
  Map<String, dynamic>? get initialState =>
      throw _privateConstructorUsedError; // Child widget
  Map<String, dynamic>? get child =>
      throw _privateConstructorUsedError; // List of events that can be handled
  List<BlocEventModel>? get events =>
      throw _privateConstructorUsedError; // Properties for the builder
  Map<String, dynamic>? get builderProperties =>
      throw _privateConstructorUsedError; // Whether this is a provider, builder, or consumer
  String get widgetType =>
      throw _privateConstructorUsedError; //Initial event that can be fired
  Map<String, dynamic>? get initialEvent =>
      throw _privateConstructorUsedError; // Builder condition (when to rebuild)
  String? get buildWhen => throw _privateConstructorUsedError;
  String? get listenWhen => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BlocWidget value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BlocWidget value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BlocWidget value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlocWidgetCopyWith<BlocWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlocWidgetCopyWith<$Res> {
  factory $BlocWidgetCopyWith(
          BlocWidget value, $Res Function(BlocWidget) then) =
      _$BlocWidgetCopyWithImpl<$Res, BlocWidget>;
  @useResult
  $Res call(
      {String blocType,
      Map<String, dynamic>? initialState,
      Map<String, dynamic>? child,
      List<BlocEventModel>? events,
      Map<String, dynamic>? builderProperties,
      String widgetType,
      Map<String, dynamic>? initialEvent,
      String? buildWhen,
      String? listenWhen});
}

/// @nodoc
class _$BlocWidgetCopyWithImpl<$Res, $Val extends BlocWidget>
    implements $BlocWidgetCopyWith<$Res> {
  _$BlocWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocType = null,
    Object? initialState = freezed,
    Object? child = freezed,
    Object? events = freezed,
    Object? builderProperties = freezed,
    Object? widgetType = null,
    Object? initialEvent = freezed,
    Object? buildWhen = freezed,
    Object? listenWhen = freezed,
  }) {
    return _then(_value.copyWith(
      blocType: null == blocType
          ? _value.blocType
          : blocType // ignore: cast_nullable_to_non_nullable
              as String,
      initialState: freezed == initialState
          ? _value.initialState
          : initialState // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      events: freezed == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<BlocEventModel>?,
      builderProperties: freezed == builderProperties
          ? _value.builderProperties
          : builderProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      widgetType: null == widgetType
          ? _value.widgetType
          : widgetType // ignore: cast_nullable_to_non_nullable
              as String,
      initialEvent: freezed == initialEvent
          ? _value.initialEvent
          : initialEvent // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      buildWhen: freezed == buildWhen
          ? _value.buildWhen
          : buildWhen // ignore: cast_nullable_to_non_nullable
              as String?,
      listenWhen: freezed == listenWhen
          ? _value.listenWhen
          : listenWhen // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlocWidgetImplCopyWith<$Res>
    implements $BlocWidgetCopyWith<$Res> {
  factory _$$BlocWidgetImplCopyWith(
          _$BlocWidgetImpl value, $Res Function(_$BlocWidgetImpl) then) =
      __$$BlocWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String blocType,
      Map<String, dynamic>? initialState,
      Map<String, dynamic>? child,
      List<BlocEventModel>? events,
      Map<String, dynamic>? builderProperties,
      String widgetType,
      Map<String, dynamic>? initialEvent,
      String? buildWhen,
      String? listenWhen});
}

/// @nodoc
class __$$BlocWidgetImplCopyWithImpl<$Res>
    extends _$BlocWidgetCopyWithImpl<$Res, _$BlocWidgetImpl>
    implements _$$BlocWidgetImplCopyWith<$Res> {
  __$$BlocWidgetImplCopyWithImpl(
      _$BlocWidgetImpl _value, $Res Function(_$BlocWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocType = null,
    Object? initialState = freezed,
    Object? child = freezed,
    Object? events = freezed,
    Object? builderProperties = freezed,
    Object? widgetType = null,
    Object? initialEvent = freezed,
    Object? buildWhen = freezed,
    Object? listenWhen = freezed,
  }) {
    return _then(_$BlocWidgetImpl(
      blocType: null == blocType
          ? _value.blocType
          : blocType // ignore: cast_nullable_to_non_nullable
              as String,
      initialState: freezed == initialState
          ? _value._initialState
          : initialState // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      events: freezed == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<BlocEventModel>?,
      builderProperties: freezed == builderProperties
          ? _value._builderProperties
          : builderProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      widgetType: null == widgetType
          ? _value.widgetType
          : widgetType // ignore: cast_nullable_to_non_nullable
              as String,
      initialEvent: freezed == initialEvent
          ? _value._initialEvent
          : initialEvent // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      buildWhen: freezed == buildWhen
          ? _value.buildWhen
          : buildWhen // ignore: cast_nullable_to_non_nullable
              as String?,
      listenWhen: freezed == listenWhen
          ? _value.listenWhen
          : listenWhen // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlocWidgetImpl implements _BlocWidget {
  const _$BlocWidgetImpl(
      {required this.blocType,
      final Map<String, dynamic>? initialState,
      final Map<String, dynamic>? child,
      final List<BlocEventModel>? events,
      final Map<String, dynamic>? builderProperties,
      this.widgetType = 'provider',
      final Map<String, dynamic>? initialEvent,
      this.buildWhen,
      this.listenWhen})
      : _initialState = initialState,
        _child = child,
        _events = events,
        _builderProperties = builderProperties,
        _initialEvent = initialEvent;

  factory _$BlocWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlocWidgetImplFromJson(json);

// The type of BLoC to be provided
  @override
  final String blocType;
// Initial state for the BLoC
  final Map<String, dynamic>? _initialState;
// Initial state for the BLoC
  @override
  Map<String, dynamic>? get initialState {
    final value = _initialState;
    if (value == null) return null;
    if (_initialState is EqualUnmodifiableMapView) return _initialState;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Child widget
  final Map<String, dynamic>? _child;
// Child widget
  @override
  Map<String, dynamic>? get child {
    final value = _child;
    if (value == null) return null;
    if (_child is EqualUnmodifiableMapView) return _child;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// List of events that can be handled
  final List<BlocEventModel>? _events;
// List of events that can be handled
  @override
  List<BlocEventModel>? get events {
    final value = _events;
    if (value == null) return null;
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Properties for the builder
  final Map<String, dynamic>? _builderProperties;
// Properties for the builder
  @override
  Map<String, dynamic>? get builderProperties {
    final value = _builderProperties;
    if (value == null) return null;
    if (_builderProperties is EqualUnmodifiableMapView)
      return _builderProperties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Whether this is a provider, builder, or consumer
  @override
  @JsonKey()
  final String widgetType;
//Initial event that can be fired
  final Map<String, dynamic>? _initialEvent;
//Initial event that can be fired
  @override
  Map<String, dynamic>? get initialEvent {
    final value = _initialEvent;
    if (value == null) return null;
    if (_initialEvent is EqualUnmodifiableMapView) return _initialEvent;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Builder condition (when to rebuild)
  @override
  final String? buildWhen;
  @override
  final String? listenWhen;

  @override
  String toString() {
    return 'BlocWidget(blocType: $blocType, initialState: $initialState, child: $child, events: $events, builderProperties: $builderProperties, widgetType: $widgetType, initialEvent: $initialEvent, buildWhen: $buildWhen, listenWhen: $listenWhen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlocWidgetImpl &&
            (identical(other.blocType, blocType) ||
                other.blocType == blocType) &&
            const DeepCollectionEquality()
                .equals(other._initialState, _initialState) &&
            const DeepCollectionEquality().equals(other._child, _child) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            const DeepCollectionEquality()
                .equals(other._builderProperties, _builderProperties) &&
            (identical(other.widgetType, widgetType) ||
                other.widgetType == widgetType) &&
            const DeepCollectionEquality()
                .equals(other._initialEvent, _initialEvent) &&
            (identical(other.buildWhen, buildWhen) ||
                other.buildWhen == buildWhen) &&
            (identical(other.listenWhen, listenWhen) ||
                other.listenWhen == listenWhen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      blocType,
      const DeepCollectionEquality().hash(_initialState),
      const DeepCollectionEquality().hash(_child),
      const DeepCollectionEquality().hash(_events),
      const DeepCollectionEquality().hash(_builderProperties),
      widgetType,
      const DeepCollectionEquality().hash(_initialEvent),
      buildWhen,
      listenWhen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlocWidgetImplCopyWith<_$BlocWidgetImpl> get copyWith =>
      __$$BlocWidgetImplCopyWithImpl<_$BlocWidgetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BlocWidget value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BlocWidget value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BlocWidget value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BlocWidgetImplToJson(
      this,
    );
  }
}

abstract class _BlocWidget implements BlocWidget {
  const factory _BlocWidget(
      {required final String blocType,
      final Map<String, dynamic>? initialState,
      final Map<String, dynamic>? child,
      final List<BlocEventModel>? events,
      final Map<String, dynamic>? builderProperties,
      final String widgetType,
      final Map<String, dynamic>? initialEvent,
      final String? buildWhen,
      final String? listenWhen}) = _$BlocWidgetImpl;

  factory _BlocWidget.fromJson(Map<String, dynamic> json) =
      _$BlocWidgetImpl.fromJson;

  @override // The type of BLoC to be provided
  String get blocType;
  @override // Initial state for the BLoC
  Map<String, dynamic>? get initialState;
  @override // Child widget
  Map<String, dynamic>? get child;
  @override // List of events that can be handled
  List<BlocEventModel>? get events;
  @override // Properties for the builder
  Map<String, dynamic>? get builderProperties;
  @override // Whether this is a provider, builder, or consumer
  String get widgetType;
  @override //Initial event that can be fired
  Map<String, dynamic>? get initialEvent;
  @override // Builder condition (when to rebuild)
  String? get buildWhen;
  @override
  String? get listenWhen;
  @override
  @JsonKey(ignore: true)
  _$$BlocWidgetImplCopyWith<_$BlocWidgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BlocEventModel _$BlocEventModelFromJson(Map<String, dynamic> json) {
  return _BlocEventModel.fromJson(json);
}

/// @nodoc
mixin _$BlocEventModel {
// Event type/name
  String get type => throw _privateConstructorUsedError; // Event payload
  Map<String, dynamic>? get payload =>
      throw _privateConstructorUsedError; // Trigger action (tap, longPress, etc.)
  String get trigger => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BlocEventModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BlocEventModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BlocEventModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlocEventModelCopyWith<BlocEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlocEventModelCopyWith<$Res> {
  factory $BlocEventModelCopyWith(
          BlocEventModel value, $Res Function(BlocEventModel) then) =
      _$BlocEventModelCopyWithImpl<$Res, BlocEventModel>;
  @useResult
  $Res call({String type, Map<String, dynamic>? payload, String trigger});
}

/// @nodoc
class _$BlocEventModelCopyWithImpl<$Res, $Val extends BlocEventModel>
    implements $BlocEventModelCopyWith<$Res> {
  _$BlocEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? payload = freezed,
    Object? trigger = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      trigger: null == trigger
          ? _value.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlocEventModelImplCopyWith<$Res>
    implements $BlocEventModelCopyWith<$Res> {
  factory _$$BlocEventModelImplCopyWith(_$BlocEventModelImpl value,
          $Res Function(_$BlocEventModelImpl) then) =
      __$$BlocEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, Map<String, dynamic>? payload, String trigger});
}

/// @nodoc
class __$$BlocEventModelImplCopyWithImpl<$Res>
    extends _$BlocEventModelCopyWithImpl<$Res, _$BlocEventModelImpl>
    implements _$$BlocEventModelImplCopyWith<$Res> {
  __$$BlocEventModelImplCopyWithImpl(
      _$BlocEventModelImpl _value, $Res Function(_$BlocEventModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? payload = freezed,
    Object? trigger = null,
  }) {
    return _then(_$BlocEventModelImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      payload: freezed == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      trigger: null == trigger
          ? _value.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlocEventModelImpl implements _BlocEventModel {
  const _$BlocEventModelImpl(
      {required this.type,
      final Map<String, dynamic>? payload,
      this.trigger = 'tap'})
      : _payload = payload;

  factory _$BlocEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlocEventModelImplFromJson(json);

// Event type/name
  @override
  final String type;
// Event payload
  final Map<String, dynamic>? _payload;
// Event payload
  @override
  Map<String, dynamic>? get payload {
    final value = _payload;
    if (value == null) return null;
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Trigger action (tap, longPress, etc.)
  @override
  @JsonKey()
  final String trigger;

  @override
  String toString() {
    return 'BlocEventModel(type: $type, payload: $payload, trigger: $trigger)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlocEventModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.trigger, trigger) || other.trigger == trigger));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type,
      const DeepCollectionEquality().hash(_payload), trigger);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlocEventModelImplCopyWith<_$BlocEventModelImpl> get copyWith =>
      __$$BlocEventModelImplCopyWithImpl<_$BlocEventModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BlocEventModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BlocEventModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BlocEventModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BlocEventModelImplToJson(
      this,
    );
  }
}

abstract class _BlocEventModel implements BlocEventModel {
  const factory _BlocEventModel(
      {required final String type,
      final Map<String, dynamic>? payload,
      final String trigger}) = _$BlocEventModelImpl;

  factory _BlocEventModel.fromJson(Map<String, dynamic> json) =
      _$BlocEventModelImpl.fromJson;

  @override // Event type/name
  String get type;
  @override // Event payload
  Map<String, dynamic>? get payload;
  @override // Trigger action (tap, longPress, etc.)
  String get trigger;
  @override
  @JsonKey(ignore: true)
  _$$BlocEventModelImplCopyWith<_$BlocEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
