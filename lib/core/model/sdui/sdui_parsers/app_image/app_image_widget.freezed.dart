// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_image_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppImageWidget _$AppImageWidgetFromJson(Map<String, dynamic> json) {
  return _AppImageWidget.fromJson(json);
}

/// @nodoc
mixin _$AppImageWidget {
  String get image => throw _privateConstructorUsedError;
  String? get fit => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  double? get width => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AppImageWidget value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AppImageWidget value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AppImageWidget value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppImageWidgetCopyWith<AppImageWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppImageWidgetCopyWith<$Res> {
  factory $AppImageWidgetCopyWith(
          AppImageWidget value, $Res Function(AppImageWidget) then) =
      _$AppImageWidgetCopyWithImpl<$Res, AppImageWidget>;
  @useResult
  $Res call(
      {String image,
      String? fit,
      double? height,
      double? width,
      String? color});
}

/// @nodoc
class _$AppImageWidgetCopyWithImpl<$Res, $Val extends AppImageWidget>
    implements $AppImageWidgetCopyWith<$Res> {
  _$AppImageWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = null,
    Object? fit = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      fit: freezed == fit
          ? _value.fit
          : fit // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppImageWidgetImplCopyWith<$Res>
    implements $AppImageWidgetCopyWith<$Res> {
  factory _$$AppImageWidgetImplCopyWith(_$AppImageWidgetImpl value,
          $Res Function(_$AppImageWidgetImpl) then) =
      __$$AppImageWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String image,
      String? fit,
      double? height,
      double? width,
      String? color});
}

/// @nodoc
class __$$AppImageWidgetImplCopyWithImpl<$Res>
    extends _$AppImageWidgetCopyWithImpl<$Res, _$AppImageWidgetImpl>
    implements _$$AppImageWidgetImplCopyWith<$Res> {
  __$$AppImageWidgetImplCopyWithImpl(
      _$AppImageWidgetImpl _value, $Res Function(_$AppImageWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = null,
    Object? fit = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? color = freezed,
  }) {
    return _then(_$AppImageWidgetImpl(
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      fit: freezed == fit
          ? _value.fit
          : fit // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppImageWidgetImpl implements _AppImageWidget {
  const _$AppImageWidgetImpl(
      {required this.image, this.fit, this.height, this.width, this.color});

  factory _$AppImageWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppImageWidgetImplFromJson(json);

  @override
  final String image;
  @override
  final String? fit;
  @override
  final double? height;
  @override
  final double? width;
  @override
  final String? color;

  @override
  String toString() {
    return 'AppImageWidget(image: $image, fit: $fit, height: $height, width: $width, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppImageWidgetImpl &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.fit, fit) || other.fit == fit) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, image, fit, height, width, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppImageWidgetImplCopyWith<_$AppImageWidgetImpl> get copyWith =>
      __$$AppImageWidgetImplCopyWithImpl<_$AppImageWidgetImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AppImageWidget value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AppImageWidget value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AppImageWidget value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AppImageWidgetImplToJson(
      this,
    );
  }
}

abstract class _AppImageWidget implements AppImageWidget {
  const factory _AppImageWidget(
      {required final String image,
      final String? fit,
      final double? height,
      final double? width,
      final String? color}) = _$AppImageWidgetImpl;

  factory _AppImageWidget.fromJson(Map<String, dynamic> json) =
      _$AppImageWidgetImpl.fromJson;

  @override
  String get image;
  @override
  String? get fit;
  @override
  double? get height;
  @override
  double? get width;
  @override
  String? get color;
  @override
  @JsonKey(ignore: true)
  _$$AppImageWidgetImplCopyWith<_$AppImageWidgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
