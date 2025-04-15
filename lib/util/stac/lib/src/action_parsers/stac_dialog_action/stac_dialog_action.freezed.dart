// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_dialog_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacDialogAction _$StacDialogActionFromJson(Map<String, dynamic> json) {
  return _StacDialogAction.fromJson(json);
}

/// @nodoc
mixin _$StacDialogAction {
  Map<String, dynamic>? get widget => throw _privateConstructorUsedError;
  StacNetworkRequest? get request => throw _privateConstructorUsedError;
  String? get assetPath => throw _privateConstructorUsedError;
  bool get barrierDismissible => throw _privateConstructorUsedError;
  String? get barrierColor => throw _privateConstructorUsedError;
  String? get barrierLabel => throw _privateConstructorUsedError;
  bool get useSafeArea => throw _privateConstructorUsedError;
  bool get addToScreenStack => throw _privateConstructorUsedError;
  bool get hapticVibrate => throw _privateConstructorUsedError;
  TraversalEdgeBehavior? get traversalEdgeBehavior =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacDialogAction value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacDialogAction value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacDialogAction value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacDialogActionCopyWith<StacDialogAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacDialogActionCopyWith<$Res> {
  factory $StacDialogActionCopyWith(
          StacDialogAction value, $Res Function(StacDialogAction) then) =
      _$StacDialogActionCopyWithImpl<$Res, StacDialogAction>;
  @useResult
  $Res call(
      {Map<String, dynamic>? widget,
      StacNetworkRequest? request,
      String? assetPath,
      bool barrierDismissible,
      String? barrierColor,
      String? barrierLabel,
      bool useSafeArea,
      bool addToScreenStack,
      bool hapticVibrate,
      TraversalEdgeBehavior? traversalEdgeBehavior});

  $StacNetworkRequestCopyWith<$Res>? get request;
}

/// @nodoc
class _$StacDialogActionCopyWithImpl<$Res, $Val extends StacDialogAction>
    implements $StacDialogActionCopyWith<$Res> {
  _$StacDialogActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? widget = freezed,
    Object? request = freezed,
    Object? assetPath = freezed,
    Object? barrierDismissible = null,
    Object? barrierColor = freezed,
    Object? barrierLabel = freezed,
    Object? useSafeArea = null,
    Object? addToScreenStack = null,
    Object? hapticVibrate = null,
    Object? traversalEdgeBehavior = freezed,
  }) {
    return _then(_value.copyWith(
      widget: freezed == widget
          ? _value.widget
          : widget // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as StacNetworkRequest?,
      assetPath: freezed == assetPath
          ? _value.assetPath
          : assetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      barrierDismissible: null == barrierDismissible
          ? _value.barrierDismissible
          : barrierDismissible // ignore: cast_nullable_to_non_nullable
              as bool,
      barrierColor: freezed == barrierColor
          ? _value.barrierColor
          : barrierColor // ignore: cast_nullable_to_non_nullable
              as String?,
      barrierLabel: freezed == barrierLabel
          ? _value.barrierLabel
          : barrierLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      useSafeArea: null == useSafeArea
          ? _value.useSafeArea
          : useSafeArea // ignore: cast_nullable_to_non_nullable
              as bool,
      addToScreenStack: null == addToScreenStack
          ? _value.addToScreenStack
          : addToScreenStack // ignore: cast_nullable_to_non_nullable
              as bool,
      hapticVibrate: null == hapticVibrate
          ? _value.hapticVibrate
          : hapticVibrate // ignore: cast_nullable_to_non_nullable
              as bool,
      traversalEdgeBehavior: freezed == traversalEdgeBehavior
          ? _value.traversalEdgeBehavior
          : traversalEdgeBehavior // ignore: cast_nullable_to_non_nullable
              as TraversalEdgeBehavior?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StacNetworkRequestCopyWith<$Res>? get request {
    if (_value.request == null) {
      return null;
    }

    return $StacNetworkRequestCopyWith<$Res>(_value.request!, (value) {
      return _then(_value.copyWith(request: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StacDialogActionImplCopyWith<$Res>
    implements $StacDialogActionCopyWith<$Res> {
  factory _$$StacDialogActionImplCopyWith(_$StacDialogActionImpl value,
          $Res Function(_$StacDialogActionImpl) then) =
      __$$StacDialogActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, dynamic>? widget,
      StacNetworkRequest? request,
      String? assetPath,
      bool barrierDismissible,
      String? barrierColor,
      String? barrierLabel,
      bool useSafeArea,
      bool addToScreenStack,
      bool hapticVibrate,
      TraversalEdgeBehavior? traversalEdgeBehavior});

  @override
  $StacNetworkRequestCopyWith<$Res>? get request;
}

/// @nodoc
class __$$StacDialogActionImplCopyWithImpl<$Res>
    extends _$StacDialogActionCopyWithImpl<$Res, _$StacDialogActionImpl>
    implements _$$StacDialogActionImplCopyWith<$Res> {
  __$$StacDialogActionImplCopyWithImpl(_$StacDialogActionImpl _value,
      $Res Function(_$StacDialogActionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? widget = freezed,
    Object? request = freezed,
    Object? assetPath = freezed,
    Object? barrierDismissible = null,
    Object? barrierColor = freezed,
    Object? barrierLabel = freezed,
    Object? useSafeArea = null,
    Object? addToScreenStack = null,
    Object? hapticVibrate = null,
    Object? traversalEdgeBehavior = freezed,
  }) {
    return _then(_$StacDialogActionImpl(
      widget: freezed == widget
          ? _value._widget
          : widget // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as StacNetworkRequest?,
      assetPath: freezed == assetPath
          ? _value.assetPath
          : assetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      barrierDismissible: null == barrierDismissible
          ? _value.barrierDismissible
          : barrierDismissible // ignore: cast_nullable_to_non_nullable
              as bool,
      barrierColor: freezed == barrierColor
          ? _value.barrierColor
          : barrierColor // ignore: cast_nullable_to_non_nullable
              as String?,
      barrierLabel: freezed == barrierLabel
          ? _value.barrierLabel
          : barrierLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      useSafeArea: null == useSafeArea
          ? _value.useSafeArea
          : useSafeArea // ignore: cast_nullable_to_non_nullable
              as bool,
      addToScreenStack: null == addToScreenStack
          ? _value.addToScreenStack
          : addToScreenStack // ignore: cast_nullable_to_non_nullable
              as bool,
      hapticVibrate: null == hapticVibrate
          ? _value.hapticVibrate
          : hapticVibrate // ignore: cast_nullable_to_non_nullable
              as bool,
      traversalEdgeBehavior: freezed == traversalEdgeBehavior
          ? _value.traversalEdgeBehavior
          : traversalEdgeBehavior // ignore: cast_nullable_to_non_nullable
              as TraversalEdgeBehavior?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacDialogActionImpl implements _StacDialogAction {
  const _$StacDialogActionImpl(
      {final Map<String, dynamic>? widget,
      this.request,
      this.assetPath,
      this.barrierDismissible = true,
      this.barrierColor,
      this.barrierLabel,
      this.useSafeArea = true,
      this.addToScreenStack = true,
      this.hapticVibrate = false,
      this.traversalEdgeBehavior})
      : _widget = widget;

  factory _$StacDialogActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacDialogActionImplFromJson(json);

  final Map<String, dynamic>? _widget;
  @override
  Map<String, dynamic>? get widget {
    final value = _widget;
    if (value == null) return null;
    if (_widget is EqualUnmodifiableMapView) return _widget;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final StacNetworkRequest? request;
  @override
  final String? assetPath;
  @override
  @JsonKey()
  final bool barrierDismissible;
  @override
  final String? barrierColor;
  @override
  final String? barrierLabel;
  @override
  @JsonKey()
  final bool useSafeArea;
  @override
  @JsonKey()
  final bool addToScreenStack;
  @override
  @JsonKey()
  final bool hapticVibrate;
  @override
  final TraversalEdgeBehavior? traversalEdgeBehavior;

  @override
  String toString() {
    return 'StacDialogAction(widget: $widget, request: $request, assetPath: $assetPath, barrierDismissible: $barrierDismissible, barrierColor: $barrierColor, barrierLabel: $barrierLabel, useSafeArea: $useSafeArea, addToScreenStack: $addToScreenStack, hapticVibrate: $hapticVibrate, traversalEdgeBehavior: $traversalEdgeBehavior)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacDialogActionImpl &&
            const DeepCollectionEquality().equals(other._widget, _widget) &&
            (identical(other.request, request) || other.request == request) &&
            (identical(other.assetPath, assetPath) ||
                other.assetPath == assetPath) &&
            (identical(other.barrierDismissible, barrierDismissible) ||
                other.barrierDismissible == barrierDismissible) &&
            (identical(other.barrierColor, barrierColor) ||
                other.barrierColor == barrierColor) &&
            (identical(other.barrierLabel, barrierLabel) ||
                other.barrierLabel == barrierLabel) &&
            (identical(other.useSafeArea, useSafeArea) ||
                other.useSafeArea == useSafeArea) &&
            (identical(other.addToScreenStack, addToScreenStack) ||
                other.addToScreenStack == addToScreenStack) &&
            (identical(other.hapticVibrate, hapticVibrate) ||
                other.hapticVibrate == hapticVibrate) &&
            (identical(other.traversalEdgeBehavior, traversalEdgeBehavior) ||
                other.traversalEdgeBehavior == traversalEdgeBehavior));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_widget),
      request,
      assetPath,
      barrierDismissible,
      barrierColor,
      barrierLabel,
      useSafeArea,
      addToScreenStack,
      hapticVibrate,
      traversalEdgeBehavior);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacDialogActionImplCopyWith<_$StacDialogActionImpl> get copyWith =>
      __$$StacDialogActionImplCopyWithImpl<_$StacDialogActionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacDialogAction value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacDialogAction value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacDialogAction value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacDialogActionImplToJson(
      this,
    );
  }
}

abstract class _StacDialogAction implements StacDialogAction {
  const factory _StacDialogAction(
          {final Map<String, dynamic>? widget,
          final StacNetworkRequest? request,
          final String? assetPath,
          final bool barrierDismissible,
          final String? barrierColor,
          final String? barrierLabel,
          final bool useSafeArea,
          final bool addToScreenStack,
          final bool hapticVibrate,
          final TraversalEdgeBehavior? traversalEdgeBehavior}) =
      _$StacDialogActionImpl;

  factory _StacDialogAction.fromJson(Map<String, dynamic> json) =
      _$StacDialogActionImpl.fromJson;

  @override
  Map<String, dynamic>? get widget;
  @override
  StacNetworkRequest? get request;
  @override
  String? get assetPath;
  @override
  bool get barrierDismissible;
  @override
  String? get barrierColor;
  @override
  String? get barrierLabel;
  @override
  bool get useSafeArea;
  @override
  bool get addToScreenStack;
  @override
  bool get hapticVibrate;
  @override
  TraversalEdgeBehavior? get traversalEdgeBehavior;
  @override
  @JsonKey(ignore: true)
  _$$StacDialogActionImplCopyWith<_$StacDialogActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
