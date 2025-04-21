// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'divider_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DividerWidget _$DividerWidgetFromJson(Map<String, dynamic> json) {
  return _DividerWidget.fromJson(json);
}

/// @nodoc
mixin _$DividerWidget {
  double? get height => throw _privateConstructorUsedError;
  double? get thickness => throw _privateConstructorUsedError;
  double? get indent => throw _privateConstructorUsedError;
  double? get endIndent => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DividerWidget value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DividerWidget value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DividerWidget value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DividerWidgetCopyWith<DividerWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DividerWidgetCopyWith<$Res> {
  factory $DividerWidgetCopyWith(
          DividerWidget value, $Res Function(DividerWidget) then) =
      _$DividerWidgetCopyWithImpl<$Res, DividerWidget>;
  @useResult
  $Res call(
      {double? height,
      double? thickness,
      double? indent,
      double? endIndent,
      String? color});
}

/// @nodoc
class _$DividerWidgetCopyWithImpl<$Res, $Val extends DividerWidget>
    implements $DividerWidgetCopyWith<$Res> {
  _$DividerWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = freezed,
    Object? thickness = freezed,
    Object? indent = freezed,
    Object? endIndent = freezed,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      thickness: freezed == thickness
          ? _value.thickness
          : thickness // ignore: cast_nullable_to_non_nullable
              as double?,
      indent: freezed == indent
          ? _value.indent
          : indent // ignore: cast_nullable_to_non_nullable
              as double?,
      endIndent: freezed == endIndent
          ? _value.endIndent
          : endIndent // ignore: cast_nullable_to_non_nullable
              as double?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DividerWidgetImplCopyWith<$Res>
    implements $DividerWidgetCopyWith<$Res> {
  factory _$$DividerWidgetImplCopyWith(
          _$DividerWidgetImpl value, $Res Function(_$DividerWidgetImpl) then) =
      __$$DividerWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? height,
      double? thickness,
      double? indent,
      double? endIndent,
      String? color});
}

/// @nodoc
class __$$DividerWidgetImplCopyWithImpl<$Res>
    extends _$DividerWidgetCopyWithImpl<$Res, _$DividerWidgetImpl>
    implements _$$DividerWidgetImplCopyWith<$Res> {
  __$$DividerWidgetImplCopyWithImpl(
      _$DividerWidgetImpl _value, $Res Function(_$DividerWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = freezed,
    Object? thickness = freezed,
    Object? indent = freezed,
    Object? endIndent = freezed,
    Object? color = freezed,
  }) {
    return _then(_$DividerWidgetImpl(
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      thickness: freezed == thickness
          ? _value.thickness
          : thickness // ignore: cast_nullable_to_non_nullable
              as double?,
      indent: freezed == indent
          ? _value.indent
          : indent // ignore: cast_nullable_to_non_nullable
              as double?,
      endIndent: freezed == endIndent
          ? _value.endIndent
          : endIndent // ignore: cast_nullable_to_non_nullable
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
class _$DividerWidgetImpl implements _DividerWidget {
  const _$DividerWidgetImpl(
      {this.height, this.thickness, this.indent, this.endIndent, this.color});

  factory _$DividerWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$DividerWidgetImplFromJson(json);

  @override
  final double? height;
  @override
  final double? thickness;
  @override
  final double? indent;
  @override
  final double? endIndent;
  @override
  final String? color;

  @override
  String toString() {
    return 'DividerWidget(height: $height, thickness: $thickness, indent: $indent, endIndent: $endIndent, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DividerWidgetImpl &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.thickness, thickness) ||
                other.thickness == thickness) &&
            (identical(other.indent, indent) || other.indent == indent) &&
            (identical(other.endIndent, endIndent) ||
                other.endIndent == endIndent) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, height, thickness, indent, endIndent, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DividerWidgetImplCopyWith<_$DividerWidgetImpl> get copyWith =>
      __$$DividerWidgetImplCopyWithImpl<_$DividerWidgetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DividerWidget value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DividerWidget value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DividerWidget value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DividerWidgetImplToJson(
      this,
    );
  }
}

abstract class _DividerWidget implements DividerWidget {
  const factory _DividerWidget(
      {final double? height,
      final double? thickness,
      final double? indent,
      final double? endIndent,
      final String? color}) = _$DividerWidgetImpl;

  factory _DividerWidget.fromJson(Map<String, dynamic> json) =
      _$DividerWidgetImpl.fromJson;

  @override
  double? get height;
  @override
  double? get thickness;
  @override
  double? get indent;
  @override
  double? get endIndent;
  @override
  String? get color;
  @override
  @JsonKey(ignore: true)
  _$$DividerWidgetImplCopyWith<_$DividerWidgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
