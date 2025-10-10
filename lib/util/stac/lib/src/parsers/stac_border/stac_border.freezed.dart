// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_border.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacBorder _$StacBorderFromJson(Map<String, dynamic> json) {
  return _StacBorder.fromJson(json);
}

/// @nodoc
mixin _$StacBorder {
  String? get color => throw _privateConstructorUsedError;
  BorderStyle get borderStyle => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get strokeAlign => throw _privateConstructorUsedError;

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
  $StacBorderCopyWith<StacBorder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacBorderCopyWith<$Res> {
  factory $StacBorderCopyWith(
          StacBorder value, $Res Function(StacBorder) then) =
      _$StacBorderCopyWithImpl<$Res, StacBorder>;
  @useResult
  $Res call(
      {String? color,
      BorderStyle borderStyle,
      double width,
      double strokeAlign});
}

/// @nodoc
class _$StacBorderCopyWithImpl<$Res, $Val extends StacBorder>
    implements $StacBorderCopyWith<$Res> {
  _$StacBorderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? borderStyle = null,
    Object? width = null,
    Object? strokeAlign = null,
  }) {
    return _then(_value.copyWith(
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      borderStyle: null == borderStyle
          ? _value.borderStyle
          : borderStyle // ignore: cast_nullable_to_non_nullable
              as BorderStyle,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      strokeAlign: null == strokeAlign
          ? _value.strokeAlign
          : strokeAlign // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StacBorderImplCopyWith<$Res>
    implements $StacBorderCopyWith<$Res> {
  factory _$$StacBorderImplCopyWith(
          _$StacBorderImpl value, $Res Function(_$StacBorderImpl) then) =
      __$$StacBorderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? color,
      BorderStyle borderStyle,
      double width,
      double strokeAlign});
}

/// @nodoc
class __$$StacBorderImplCopyWithImpl<$Res>
    extends _$StacBorderCopyWithImpl<$Res, _$StacBorderImpl>
    implements _$$StacBorderImplCopyWith<$Res> {
  __$$StacBorderImplCopyWithImpl(
      _$StacBorderImpl _value, $Res Function(_$StacBorderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? borderStyle = null,
    Object? width = null,
    Object? strokeAlign = null,
  }) {
    return _then(_$StacBorderImpl(
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      borderStyle: null == borderStyle
          ? _value.borderStyle
          : borderStyle // ignore: cast_nullable_to_non_nullable
              as BorderStyle,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      strokeAlign: null == strokeAlign
          ? _value.strokeAlign
          : strokeAlign // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacBorderImpl implements _StacBorder {
  const _$StacBorderImpl(
      {this.color,
      this.borderStyle = BorderStyle.solid,
      this.width = 1.0,
      this.strokeAlign = BorderSide.strokeAlignInside});

  factory _$StacBorderImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacBorderImplFromJson(json);

  @override
  final String? color;
  @override
  @JsonKey()
  final BorderStyle borderStyle;
  @override
  @JsonKey()
  final double width;
  @override
  @JsonKey()
  final double strokeAlign;

  @override
  String toString() {
    return 'StacBorder(color: $color, borderStyle: $borderStyle, width: $width, strokeAlign: $strokeAlign)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacBorderImpl &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.borderStyle, borderStyle) ||
                other.borderStyle == borderStyle) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.strokeAlign, strokeAlign) ||
                other.strokeAlign == strokeAlign));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, color, borderStyle, width, strokeAlign);

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

abstract class _StacBorder implements StacBorder {
  const factory _StacBorder(
      {final String? color,
      final BorderStyle borderStyle,
      final double width,
      final double strokeAlign}) = _$StacBorderImpl;

  factory _StacBorder.fromJson(Map<String, dynamic> json) =
      _$StacBorderImpl.fromJson;

  @override
  String? get color;
  @override
  BorderStyle get borderStyle;
  @override
  double get width;
  @override
  double get strokeAlign;
  @override
  @JsonKey(ignore: true)
  _$$StacBorderImplCopyWith<_$StacBorderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
