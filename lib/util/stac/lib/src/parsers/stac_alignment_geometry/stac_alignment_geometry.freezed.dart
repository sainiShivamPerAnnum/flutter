// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_alignment_geometry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacAlignmentGeometry _$StacAlignmentGeometryFromJson(
    Map<String, dynamic> json) {
  return _StacAlignmentGeometry.fromJson(json);
}

/// @nodoc
mixin _$StacAlignmentGeometry {
  double get dx => throw _privateConstructorUsedError;
  double get dy => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacAlignmentGeometry value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacAlignmentGeometry value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacAlignmentGeometry value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacAlignmentGeometryCopyWith<StacAlignmentGeometry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacAlignmentGeometryCopyWith<$Res> {
  factory $StacAlignmentGeometryCopyWith(StacAlignmentGeometry value,
          $Res Function(StacAlignmentGeometry) then) =
      _$StacAlignmentGeometryCopyWithImpl<$Res, StacAlignmentGeometry>;
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class _$StacAlignmentGeometryCopyWithImpl<$Res,
        $Val extends StacAlignmentGeometry>
    implements $StacAlignmentGeometryCopyWith<$Res> {
  _$StacAlignmentGeometryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
  }) {
    return _then(_value.copyWith(
      dx: null == dx
          ? _value.dx
          : dx // ignore: cast_nullable_to_non_nullable
              as double,
      dy: null == dy
          ? _value.dy
          : dy // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StacAlignmentGeometryImplCopyWith<$Res>
    implements $StacAlignmentGeometryCopyWith<$Res> {
  factory _$$StacAlignmentGeometryImplCopyWith(
          _$StacAlignmentGeometryImpl value,
          $Res Function(_$StacAlignmentGeometryImpl) then) =
      __$$StacAlignmentGeometryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double dx, double dy});
}

/// @nodoc
class __$$StacAlignmentGeometryImplCopyWithImpl<$Res>
    extends _$StacAlignmentGeometryCopyWithImpl<$Res,
        _$StacAlignmentGeometryImpl>
    implements _$$StacAlignmentGeometryImplCopyWith<$Res> {
  __$$StacAlignmentGeometryImplCopyWithImpl(_$StacAlignmentGeometryImpl _value,
      $Res Function(_$StacAlignmentGeometryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
  }) {
    return _then(_$StacAlignmentGeometryImpl(
      dx: null == dx
          ? _value.dx
          : dx // ignore: cast_nullable_to_non_nullable
              as double,
      dy: null == dy
          ? _value.dy
          : dy // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacAlignmentGeometryImpl implements _StacAlignmentGeometry {
  const _$StacAlignmentGeometryImpl({required this.dx, required this.dy});

  factory _$StacAlignmentGeometryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacAlignmentGeometryImplFromJson(json);

  @override
  final double dx;
  @override
  final double dy;

  @override
  String toString() {
    return 'StacAlignmentGeometry(dx: $dx, dy: $dy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacAlignmentGeometryImpl &&
            (identical(other.dx, dx) || other.dx == dx) &&
            (identical(other.dy, dy) || other.dy == dy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, dx, dy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacAlignmentGeometryImplCopyWith<_$StacAlignmentGeometryImpl>
      get copyWith => __$$StacAlignmentGeometryImplCopyWithImpl<
          _$StacAlignmentGeometryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacAlignmentGeometry value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacAlignmentGeometry value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacAlignmentGeometry value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacAlignmentGeometryImplToJson(
      this,
    );
  }
}

abstract class _StacAlignmentGeometry implements StacAlignmentGeometry {
  const factory _StacAlignmentGeometry(
      {required final double dx,
      required final double dy}) = _$StacAlignmentGeometryImpl;

  factory _StacAlignmentGeometry.fromJson(Map<String, dynamic> json) =
      _$StacAlignmentGeometryImpl.fromJson;

  @override
  double get dx;
  @override
  double get dy;
  @override
  @JsonKey(ignore: true)
  _$$StacAlignmentGeometryImplCopyWith<_$StacAlignmentGeometryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
