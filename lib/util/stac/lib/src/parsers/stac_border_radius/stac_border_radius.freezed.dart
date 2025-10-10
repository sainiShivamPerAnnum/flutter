// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_border_radius.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacBorderRadius _$StacBorderRadiusFromJson(Map<String, dynamic> json) {
  return _StacBorder.fromJson(json);
}

/// @nodoc
mixin _$StacBorderRadius {
  double get topLeft => throw _privateConstructorUsedError;
  double get topRight => throw _privateConstructorUsedError;
  double get bottomLeft => throw _privateConstructorUsedError;
  double get bottomRight => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacBorder value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacBorder value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacBorder value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacBorderRadiusCopyWith<StacBorderRadius> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacBorderRadiusCopyWith<$Res> {
  factory $StacBorderRadiusCopyWith(
          StacBorderRadius value, $Res Function(StacBorderRadius) then) =
      _$StacBorderRadiusCopyWithImpl<$Res, StacBorderRadius>;
  @useResult
  $Res call(
      {double topLeft, double topRight, double bottomLeft, double bottomRight});
}

/// @nodoc
class _$StacBorderRadiusCopyWithImpl<$Res, $Val extends StacBorderRadius>
    implements $StacBorderRadiusCopyWith<$Res> {
  _$StacBorderRadiusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topLeft = null,
    Object? topRight = null,
    Object? bottomLeft = null,
    Object? bottomRight = null,
  }) {
    return _then(_value.copyWith(
      topLeft: null == topLeft
          ? _value.topLeft
          : topLeft // ignore: cast_nullable_to_non_nullable
              as double,
      topRight: null == topRight
          ? _value.topRight
          : topRight // ignore: cast_nullable_to_non_nullable
              as double,
      bottomLeft: null == bottomLeft
          ? _value.bottomLeft
          : bottomLeft // ignore: cast_nullable_to_non_nullable
              as double,
      bottomRight: null == bottomRight
          ? _value.bottomRight
          : bottomRight // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StacBorderImplCopyWith<$Res>
    implements $StacBorderRadiusCopyWith<$Res> {
  factory _$$StacBorderImplCopyWith(
          _$StacBorderImpl value, $Res Function(_$StacBorderImpl) then) =
      __$$StacBorderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double topLeft, double topRight, double bottomLeft, double bottomRight});
}

/// @nodoc
class __$$StacBorderImplCopyWithImpl<$Res>
    extends _$StacBorderRadiusCopyWithImpl<$Res, _$StacBorderImpl>
    implements _$$StacBorderImplCopyWith<$Res> {
  __$$StacBorderImplCopyWithImpl(
      _$StacBorderImpl _value, $Res Function(_$StacBorderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topLeft = null,
    Object? topRight = null,
    Object? bottomLeft = null,
    Object? bottomRight = null,
  }) {
    return _then(_$StacBorderImpl(
      topLeft: null == topLeft
          ? _value.topLeft
          : topLeft // ignore: cast_nullable_to_non_nullable
              as double,
      topRight: null == topRight
          ? _value.topRight
          : topRight // ignore: cast_nullable_to_non_nullable
              as double,
      bottomLeft: null == bottomLeft
          ? _value.bottomLeft
          : bottomLeft // ignore: cast_nullable_to_non_nullable
              as double,
      bottomRight: null == bottomRight
          ? _value.bottomRight
          : bottomRight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacBorderImpl implements _StacBorder {
  const _$StacBorderImpl(
      {this.topLeft = 0.0,
      this.topRight = 0.0,
      this.bottomLeft = 0.0,
      this.bottomRight = 0.0});

  factory _$StacBorderImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacBorderImplFromJson(json);

  @override
  @JsonKey()
  final double topLeft;
  @override
  @JsonKey()
  final double topRight;
  @override
  @JsonKey()
  final double bottomLeft;
  @override
  @JsonKey()
  final double bottomRight;

  @override
  String toString() {
    return 'StacBorderRadius(topLeft: $topLeft, topRight: $topRight, bottomLeft: $bottomLeft, bottomRight: $bottomRight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacBorderImpl &&
            (identical(other.topLeft, topLeft) || other.topLeft == topLeft) &&
            (identical(other.topRight, topRight) ||
                other.topRight == topRight) &&
            (identical(other.bottomLeft, bottomLeft) ||
                other.bottomLeft == bottomLeft) &&
            (identical(other.bottomRight, bottomRight) ||
                other.bottomRight == bottomRight));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, topLeft, topRight, bottomLeft, bottomRight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacBorderImplCopyWith<_$StacBorderImpl> get copyWith =>
      __$$StacBorderImplCopyWithImpl<_$StacBorderImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacBorder value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacBorder value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacBorder value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacBorderImplToJson(
      this,
    );
  }
}

abstract class _StacBorder implements StacBorderRadius {
  const factory _StacBorder(
      {final double topLeft,
      final double topRight,
      final double bottomLeft,
      final double bottomRight}) = _$StacBorderImpl;

  factory _StacBorder.fromJson(Map<String, dynamic> json) =
      _$StacBorderImpl.fromJson;

  @override
  double get topLeft;
  @override
  double get topRight;
  @override
  double get bottomLeft;
  @override
  double get bottomRight;
  @override
  @JsonKey(ignore: true)
  _$$StacBorderImplCopyWith<_$StacBorderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
