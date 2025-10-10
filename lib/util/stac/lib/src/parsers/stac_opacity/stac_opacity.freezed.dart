// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_opacity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacOpacity _$StacOpacityFromJson(Map<String, dynamic> json) {
  return _StacOpacity.fromJson(json);
}

/// @nodoc
mixin _$StacOpacity {
  double get opacity => throw _privateConstructorUsedError;
  Map<String, dynamic> get child => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacOpacity value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacOpacity value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacOpacity value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacOpacityCopyWith<StacOpacity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacOpacityCopyWith<$Res> {
  factory $StacOpacityCopyWith(
          StacOpacity value, $Res Function(StacOpacity) then) =
      _$StacOpacityCopyWithImpl<$Res, StacOpacity>;
  @useResult
  $Res call({double opacity, Map<String, dynamic> child});
}

/// @nodoc
class _$StacOpacityCopyWithImpl<$Res, $Val extends StacOpacity>
    implements $StacOpacityCopyWith<$Res> {
  _$StacOpacityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? opacity = null,
    Object? child = null,
  }) {
    return _then(_value.copyWith(
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      child: null == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StacOpacityImplCopyWith<$Res>
    implements $StacOpacityCopyWith<$Res> {
  factory _$$StacOpacityImplCopyWith(
          _$StacOpacityImpl value, $Res Function(_$StacOpacityImpl) then) =
      __$$StacOpacityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double opacity, Map<String, dynamic> child});
}

/// @nodoc
class __$$StacOpacityImplCopyWithImpl<$Res>
    extends _$StacOpacityCopyWithImpl<$Res, _$StacOpacityImpl>
    implements _$$StacOpacityImplCopyWith<$Res> {
  __$$StacOpacityImplCopyWithImpl(
      _$StacOpacityImpl _value, $Res Function(_$StacOpacityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? opacity = null,
    Object? child = null,
  }) {
    return _then(_$StacOpacityImpl(
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      child: null == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacOpacityImpl implements _StacOpacity {
  const _$StacOpacityImpl(
      {required this.opacity, required final Map<String, dynamic> child})
      : _child = child;

  factory _$StacOpacityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacOpacityImplFromJson(json);

  @override
  final double opacity;
  final Map<String, dynamic> _child;
  @override
  Map<String, dynamic> get child {
    if (_child is EqualUnmodifiableMapView) return _child;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_child);
  }

  @override
  String toString() {
    return 'StacOpacity(opacity: $opacity, child: $child)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacOpacityImpl &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            const DeepCollectionEquality().equals(other._child, _child));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, opacity, const DeepCollectionEquality().hash(_child));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacOpacityImplCopyWith<_$StacOpacityImpl> get copyWith =>
      __$$StacOpacityImplCopyWithImpl<_$StacOpacityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacOpacity value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacOpacity value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacOpacity value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacOpacityImplToJson(
      this,
    );
  }
}

abstract class _StacOpacity implements StacOpacity {
  const factory _StacOpacity(
      {required final double opacity,
      required final Map<String, dynamic> child}) = _$StacOpacityImpl;

  factory _StacOpacity.fromJson(Map<String, dynamic> json) =
      _$StacOpacityImpl.fromJson;

  @override
  double get opacity;
  @override
  Map<String, dynamic> get child;
  @override
  @JsonKey(ignore: true)
  _$$StacOpacityImplCopyWith<_$StacOpacityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
