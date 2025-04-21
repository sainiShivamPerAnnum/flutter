// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_aspect_ratio.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacAspectRatio _$StacAspectRatioFromJson(Map<String, dynamic> json) {
  return _StacAspectRatio.fromJson(json);
}

/// @nodoc
mixin _$StacAspectRatio {
  double get aspectRatio => throw _privateConstructorUsedError;
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacAspectRatio value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacAspectRatio value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacAspectRatio value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacAspectRatioCopyWith<StacAspectRatio> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacAspectRatioCopyWith<$Res> {
  factory $StacAspectRatioCopyWith(
          StacAspectRatio value, $Res Function(StacAspectRatio) then) =
      _$StacAspectRatioCopyWithImpl<$Res, StacAspectRatio>;
  @useResult
  $Res call({double aspectRatio, Map<String, dynamic>? child});
}

/// @nodoc
class _$StacAspectRatioCopyWithImpl<$Res, $Val extends StacAspectRatio>
    implements $StacAspectRatioCopyWith<$Res> {
  _$StacAspectRatioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aspectRatio = null,
    Object? child = freezed,
  }) {
    return _then(_value.copyWith(
      aspectRatio: null == aspectRatio
          ? _value.aspectRatio
          : aspectRatio // ignore: cast_nullable_to_non_nullable
              as double,
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StacAspectRatioImplCopyWith<$Res>
    implements $StacAspectRatioCopyWith<$Res> {
  factory _$$StacAspectRatioImplCopyWith(_$StacAspectRatioImpl value,
          $Res Function(_$StacAspectRatioImpl) then) =
      __$$StacAspectRatioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double aspectRatio, Map<String, dynamic>? child});
}

/// @nodoc
class __$$StacAspectRatioImplCopyWithImpl<$Res>
    extends _$StacAspectRatioCopyWithImpl<$Res, _$StacAspectRatioImpl>
    implements _$$StacAspectRatioImplCopyWith<$Res> {
  __$$StacAspectRatioImplCopyWithImpl(
      _$StacAspectRatioImpl _value, $Res Function(_$StacAspectRatioImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aspectRatio = null,
    Object? child = freezed,
  }) {
    return _then(_$StacAspectRatioImpl(
      aspectRatio: null == aspectRatio
          ? _value.aspectRatio
          : aspectRatio // ignore: cast_nullable_to_non_nullable
              as double,
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacAspectRatioImpl implements _StacAspectRatio {
  const _$StacAspectRatioImpl(
      {this.aspectRatio = 1, final Map<String, dynamic>? child})
      : _child = child;

  factory _$StacAspectRatioImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacAspectRatioImplFromJson(json);

  @override
  @JsonKey()
  final double aspectRatio;
  final Map<String, dynamic>? _child;
  @override
  Map<String, dynamic>? get child {
    final value = _child;
    if (value == null) return null;
    if (_child is EqualUnmodifiableMapView) return _child;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'StacAspectRatio(aspectRatio: $aspectRatio, child: $child)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacAspectRatioImpl &&
            (identical(other.aspectRatio, aspectRatio) ||
                other.aspectRatio == aspectRatio) &&
            const DeepCollectionEquality().equals(other._child, _child));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, aspectRatio, const DeepCollectionEquality().hash(_child));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacAspectRatioImplCopyWith<_$StacAspectRatioImpl> get copyWith =>
      __$$StacAspectRatioImplCopyWithImpl<_$StacAspectRatioImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacAspectRatio value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacAspectRatio value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacAspectRatio value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacAspectRatioImplToJson(
      this,
    );
  }
}

abstract class _StacAspectRatio implements StacAspectRatio {
  const factory _StacAspectRatio(
      {final double aspectRatio,
      final Map<String, dynamic>? child}) = _$StacAspectRatioImpl;

  factory _StacAspectRatio.fromJson(Map<String, dynamic> json) =
      _$StacAspectRatioImpl.fromJson;

  @override
  double get aspectRatio;
  @override
  Map<String, dynamic>? get child;
  @override
  @JsonKey(ignore: true)
  _$$StacAspectRatioImplCopyWith<_$StacAspectRatioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
