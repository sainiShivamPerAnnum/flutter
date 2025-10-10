// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'responsive_container_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResponsiveContainer _$ResponsiveContainerFromJson(Map<String, dynamic> json) {
  return _ResponsiveContainer.fromJson(json);
}

/// @nodoc
mixin _$ResponsiveContainer {
  StacAlignment? get alignment => throw _privateConstructorUsedError;
  StacEdgeInsets? get padding => throw _privateConstructorUsedError;
  StacBoxDecoration? get decoration => throw _privateConstructorUsedError;
  StacBoxDecoration? get foregroundDecoration =>
      throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  double? get width => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  String? get widthScaling => throw _privateConstructorUsedError;
  String? get heightScaling => throw _privateConstructorUsedError;
  StacBoxConstraints? get constraints => throw _privateConstructorUsedError;
  StacEdgeInsets? get margin => throw _privateConstructorUsedError;
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;
  Clip get clipBehavior => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ResponsiveContainer value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ResponsiveContainer value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ResponsiveContainer value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResponsiveContainerCopyWith<ResponsiveContainer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponsiveContainerCopyWith<$Res> {
  factory $ResponsiveContainerCopyWith(
          ResponsiveContainer value, $Res Function(ResponsiveContainer) then) =
      _$ResponsiveContainerCopyWithImpl<$Res, ResponsiveContainer>;
  @useResult
  $Res call(
      {StacAlignment? alignment,
      StacEdgeInsets? padding,
      StacBoxDecoration? decoration,
      StacBoxDecoration? foregroundDecoration,
      String? color,
      double? width,
      double? height,
      String? widthScaling,
      String? heightScaling,
      StacBoxConstraints? constraints,
      StacEdgeInsets? margin,
      Map<String, dynamic>? child,
      Clip clipBehavior});

  $StacEdgeInsetsCopyWith<$Res>? get padding;
  $StacBoxDecorationCopyWith<$Res>? get decoration;
  $StacBoxDecorationCopyWith<$Res>? get foregroundDecoration;
  $StacBoxConstraintsCopyWith<$Res>? get constraints;
  $StacEdgeInsetsCopyWith<$Res>? get margin;
}

/// @nodoc
class _$ResponsiveContainerCopyWithImpl<$Res, $Val extends ResponsiveContainer>
    implements $ResponsiveContainerCopyWith<$Res> {
  _$ResponsiveContainerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alignment = freezed,
    Object? padding = freezed,
    Object? decoration = freezed,
    Object? foregroundDecoration = freezed,
    Object? color = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? widthScaling = freezed,
    Object? heightScaling = freezed,
    Object? constraints = freezed,
    Object? margin = freezed,
    Object? child = freezed,
    Object? clipBehavior = null,
  }) {
    return _then(_value.copyWith(
      alignment: freezed == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as StacAlignment?,
      padding: freezed == padding
          ? _value.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as StacEdgeInsets?,
      decoration: freezed == decoration
          ? _value.decoration
          : decoration // ignore: cast_nullable_to_non_nullable
              as StacBoxDecoration?,
      foregroundDecoration: freezed == foregroundDecoration
          ? _value.foregroundDecoration
          : foregroundDecoration // ignore: cast_nullable_to_non_nullable
              as StacBoxDecoration?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      widthScaling: freezed == widthScaling
          ? _value.widthScaling
          : widthScaling // ignore: cast_nullable_to_non_nullable
              as String?,
      heightScaling: freezed == heightScaling
          ? _value.heightScaling
          : heightScaling // ignore: cast_nullable_to_non_nullable
              as String?,
      constraints: freezed == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as StacBoxConstraints?,
      margin: freezed == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as StacEdgeInsets?,
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      clipBehavior: null == clipBehavior
          ? _value.clipBehavior
          : clipBehavior // ignore: cast_nullable_to_non_nullable
              as Clip,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StacEdgeInsetsCopyWith<$Res>? get padding {
    if (_value.padding == null) {
      return null;
    }

    return $StacEdgeInsetsCopyWith<$Res>(_value.padding!, (value) {
      return _then(_value.copyWith(padding: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StacBoxDecorationCopyWith<$Res>? get decoration {
    if (_value.decoration == null) {
      return null;
    }

    return $StacBoxDecorationCopyWith<$Res>(_value.decoration!, (value) {
      return _then(_value.copyWith(decoration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StacBoxDecorationCopyWith<$Res>? get foregroundDecoration {
    if (_value.foregroundDecoration == null) {
      return null;
    }

    return $StacBoxDecorationCopyWith<$Res>(_value.foregroundDecoration!,
        (value) {
      return _then(_value.copyWith(foregroundDecoration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StacBoxConstraintsCopyWith<$Res>? get constraints {
    if (_value.constraints == null) {
      return null;
    }

    return $StacBoxConstraintsCopyWith<$Res>(_value.constraints!, (value) {
      return _then(_value.copyWith(constraints: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StacEdgeInsetsCopyWith<$Res>? get margin {
    if (_value.margin == null) {
      return null;
    }

    return $StacEdgeInsetsCopyWith<$Res>(_value.margin!, (value) {
      return _then(_value.copyWith(margin: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResponsiveContainerImplCopyWith<$Res>
    implements $ResponsiveContainerCopyWith<$Res> {
  factory _$$ResponsiveContainerImplCopyWith(_$ResponsiveContainerImpl value,
          $Res Function(_$ResponsiveContainerImpl) then) =
      __$$ResponsiveContainerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StacAlignment? alignment,
      StacEdgeInsets? padding,
      StacBoxDecoration? decoration,
      StacBoxDecoration? foregroundDecoration,
      String? color,
      double? width,
      double? height,
      String? widthScaling,
      String? heightScaling,
      StacBoxConstraints? constraints,
      StacEdgeInsets? margin,
      Map<String, dynamic>? child,
      Clip clipBehavior});

  @override
  $StacEdgeInsetsCopyWith<$Res>? get padding;
  @override
  $StacBoxDecorationCopyWith<$Res>? get decoration;
  @override
  $StacBoxDecorationCopyWith<$Res>? get foregroundDecoration;
  @override
  $StacBoxConstraintsCopyWith<$Res>? get constraints;
  @override
  $StacEdgeInsetsCopyWith<$Res>? get margin;
}

/// @nodoc
class __$$ResponsiveContainerImplCopyWithImpl<$Res>
    extends _$ResponsiveContainerCopyWithImpl<$Res, _$ResponsiveContainerImpl>
    implements _$$ResponsiveContainerImplCopyWith<$Res> {
  __$$ResponsiveContainerImplCopyWithImpl(_$ResponsiveContainerImpl _value,
      $Res Function(_$ResponsiveContainerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alignment = freezed,
    Object? padding = freezed,
    Object? decoration = freezed,
    Object? foregroundDecoration = freezed,
    Object? color = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? widthScaling = freezed,
    Object? heightScaling = freezed,
    Object? constraints = freezed,
    Object? margin = freezed,
    Object? child = freezed,
    Object? clipBehavior = null,
  }) {
    return _then(_$ResponsiveContainerImpl(
      alignment: freezed == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as StacAlignment?,
      padding: freezed == padding
          ? _value.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as StacEdgeInsets?,
      decoration: freezed == decoration
          ? _value.decoration
          : decoration // ignore: cast_nullable_to_non_nullable
              as StacBoxDecoration?,
      foregroundDecoration: freezed == foregroundDecoration
          ? _value.foregroundDecoration
          : foregroundDecoration // ignore: cast_nullable_to_non_nullable
              as StacBoxDecoration?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      widthScaling: freezed == widthScaling
          ? _value.widthScaling
          : widthScaling // ignore: cast_nullable_to_non_nullable
              as String?,
      heightScaling: freezed == heightScaling
          ? _value.heightScaling
          : heightScaling // ignore: cast_nullable_to_non_nullable
              as String?,
      constraints: freezed == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as StacBoxConstraints?,
      margin: freezed == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as StacEdgeInsets?,
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      clipBehavior: null == clipBehavior
          ? _value.clipBehavior
          : clipBehavior // ignore: cast_nullable_to_non_nullable
              as Clip,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResponsiveContainerImpl implements _ResponsiveContainer {
  const _$ResponsiveContainerImpl(
      {this.alignment,
      this.padding,
      this.decoration,
      this.foregroundDecoration,
      this.color,
      this.width,
      this.height,
      this.widthScaling,
      this.heightScaling,
      this.constraints,
      this.margin,
      final Map<String, dynamic>? child,
      this.clipBehavior = Clip.none})
      : _child = child;

  factory _$ResponsiveContainerImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponsiveContainerImplFromJson(json);

  @override
  final StacAlignment? alignment;
  @override
  final StacEdgeInsets? padding;
  @override
  final StacBoxDecoration? decoration;
  @override
  final StacBoxDecoration? foregroundDecoration;
  @override
  final String? color;
  @override
  final double? width;
  @override
  final double? height;
  @override
  final String? widthScaling;
  @override
  final String? heightScaling;
  @override
  final StacBoxConstraints? constraints;
  @override
  final StacEdgeInsets? margin;
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
  @JsonKey()
  final Clip clipBehavior;

  @override
  String toString() {
    return 'ResponsiveContainer(alignment: $alignment, padding: $padding, decoration: $decoration, foregroundDecoration: $foregroundDecoration, color: $color, width: $width, height: $height, widthScaling: $widthScaling, heightScaling: $heightScaling, constraints: $constraints, margin: $margin, child: $child, clipBehavior: $clipBehavior)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponsiveContainerImpl &&
            (identical(other.alignment, alignment) ||
                other.alignment == alignment) &&
            (identical(other.padding, padding) || other.padding == padding) &&
            (identical(other.decoration, decoration) ||
                other.decoration == decoration) &&
            (identical(other.foregroundDecoration, foregroundDecoration) ||
                other.foregroundDecoration == foregroundDecoration) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.widthScaling, widthScaling) ||
                other.widthScaling == widthScaling) &&
            (identical(other.heightScaling, heightScaling) ||
                other.heightScaling == heightScaling) &&
            (identical(other.constraints, constraints) ||
                other.constraints == constraints) &&
            (identical(other.margin, margin) || other.margin == margin) &&
            const DeepCollectionEquality().equals(other._child, _child) &&
            (identical(other.clipBehavior, clipBehavior) ||
                other.clipBehavior == clipBehavior));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      alignment,
      padding,
      decoration,
      foregroundDecoration,
      color,
      width,
      height,
      widthScaling,
      heightScaling,
      constraints,
      margin,
      const DeepCollectionEquality().hash(_child),
      clipBehavior);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponsiveContainerImplCopyWith<_$ResponsiveContainerImpl> get copyWith =>
      __$$ResponsiveContainerImplCopyWithImpl<_$ResponsiveContainerImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ResponsiveContainer value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ResponsiveContainer value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ResponsiveContainer value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponsiveContainerImplToJson(
      this,
    );
  }
}

abstract class _ResponsiveContainer implements ResponsiveContainer {
  const factory _ResponsiveContainer(
      {final StacAlignment? alignment,
      final StacEdgeInsets? padding,
      final StacBoxDecoration? decoration,
      final StacBoxDecoration? foregroundDecoration,
      final String? color,
      final double? width,
      final double? height,
      final String? widthScaling,
      final String? heightScaling,
      final StacBoxConstraints? constraints,
      final StacEdgeInsets? margin,
      final Map<String, dynamic>? child,
      final Clip clipBehavior}) = _$ResponsiveContainerImpl;

  factory _ResponsiveContainer.fromJson(Map<String, dynamic> json) =
      _$ResponsiveContainerImpl.fromJson;

  @override
  StacAlignment? get alignment;
  @override
  StacEdgeInsets? get padding;
  @override
  StacBoxDecoration? get decoration;
  @override
  StacBoxDecoration? get foregroundDecoration;
  @override
  String? get color;
  @override
  double? get width;
  @override
  double? get height;
  @override
  String? get widthScaling;
  @override
  String? get heightScaling;
  @override
  StacBoxConstraints? get constraints;
  @override
  StacEdgeInsets? get margin;
  @override
  Map<String, dynamic>? get child;
  @override
  Clip get clipBehavior;
  @override
  @JsonKey(ignore: true)
  _$$ResponsiveContainerImplCopyWith<_$ResponsiveContainerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
