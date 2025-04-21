// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_circle_border.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacCircleBorder _$StacCircleBorderFromJson(Map<String, dynamic> json) {
  return _StacCircleBorder.fromJson(json);
}

/// @nodoc
mixin _$StacCircleBorder {
  StacBorderSide get side => throw _privateConstructorUsedError;
  double get eccentricity => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacCircleBorder value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacCircleBorder value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacCircleBorder value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacCircleBorderCopyWith<StacCircleBorder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacCircleBorderCopyWith<$Res> {
  factory $StacCircleBorderCopyWith(
          StacCircleBorder value, $Res Function(StacCircleBorder) then) =
      _$StacCircleBorderCopyWithImpl<$Res, StacCircleBorder>;
  @useResult
  $Res call({StacBorderSide side, double eccentricity});

  $StacBorderSideCopyWith<$Res> get side;
}

/// @nodoc
class _$StacCircleBorderCopyWithImpl<$Res, $Val extends StacCircleBorder>
    implements $StacCircleBorderCopyWith<$Res> {
  _$StacCircleBorderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? side = null,
    Object? eccentricity = null,
  }) {
    return _then(_value.copyWith(
      side: null == side
          ? _value.side
          : side // ignore: cast_nullable_to_non_nullable
              as StacBorderSide,
      eccentricity: null == eccentricity
          ? _value.eccentricity
          : eccentricity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StacBorderSideCopyWith<$Res> get side {
    return $StacBorderSideCopyWith<$Res>(_value.side, (value) {
      return _then(_value.copyWith(side: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StacCircleBorderImplCopyWith<$Res>
    implements $StacCircleBorderCopyWith<$Res> {
  factory _$$StacCircleBorderImplCopyWith(_$StacCircleBorderImpl value,
          $Res Function(_$StacCircleBorderImpl) then) =
      __$$StacCircleBorderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({StacBorderSide side, double eccentricity});

  @override
  $StacBorderSideCopyWith<$Res> get side;
}

/// @nodoc
class __$$StacCircleBorderImplCopyWithImpl<$Res>
    extends _$StacCircleBorderCopyWithImpl<$Res, _$StacCircleBorderImpl>
    implements _$$StacCircleBorderImplCopyWith<$Res> {
  __$$StacCircleBorderImplCopyWithImpl(_$StacCircleBorderImpl _value,
      $Res Function(_$StacCircleBorderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? side = null,
    Object? eccentricity = null,
  }) {
    return _then(_$StacCircleBorderImpl(
      side: null == side
          ? _value.side
          : side // ignore: cast_nullable_to_non_nullable
              as StacBorderSide,
      eccentricity: null == eccentricity
          ? _value.eccentricity
          : eccentricity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacCircleBorderImpl implements _StacCircleBorder {
  const _$StacCircleBorderImpl(
      {this.side = const StacBorderSide.none(), this.eccentricity = 0.0});

  factory _$StacCircleBorderImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacCircleBorderImplFromJson(json);

  @override
  @JsonKey()
  final StacBorderSide side;
  @override
  @JsonKey()
  final double eccentricity;

  @override
  String toString() {
    return 'StacCircleBorder(side: $side, eccentricity: $eccentricity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacCircleBorderImpl &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.eccentricity, eccentricity) ||
                other.eccentricity == eccentricity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, side, eccentricity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacCircleBorderImplCopyWith<_$StacCircleBorderImpl> get copyWith =>
      __$$StacCircleBorderImplCopyWithImpl<_$StacCircleBorderImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacCircleBorder value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacCircleBorder value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacCircleBorder value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacCircleBorderImplToJson(
      this,
    );
  }
}

abstract class _StacCircleBorder implements StacCircleBorder {
  const factory _StacCircleBorder(
      {final StacBorderSide side,
      final double eccentricity}) = _$StacCircleBorderImpl;

  factory _StacCircleBorder.fromJson(Map<String, dynamic> json) =
      _$StacCircleBorderImpl.fromJson;

  @override
  StacBorderSide get side;
  @override
  double get eccentricity;
  @override
  @JsonKey(ignore: true)
  _$$StacCircleBorderImplCopyWith<_$StacCircleBorderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
