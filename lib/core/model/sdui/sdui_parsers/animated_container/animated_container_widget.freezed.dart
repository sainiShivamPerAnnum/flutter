// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animated_container_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnimatedContainerWidget _$AnimatedContainerWidgetFromJson(
    Map<String, dynamic> json) {
  return _AnimatedContainerWidget.fromJson(json);
}

/// @nodoc
mixin _$AnimatedContainerWidget {
  int? get durationInMs => throw _privateConstructorUsedError;
  String? get curve => throw _privateConstructorUsedError;
  double? get width => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  Map<String, dynamic>? get padding => throw _privateConstructorUsedError;
  Map<String, dynamic>? get margin => throw _privateConstructorUsedError;
  String? get alignment => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  ContainerDecorationModel? get decoration =>
      throw _privateConstructorUsedError;
  TransformModel? get transform => throw _privateConstructorUsedError;
  String? get transformAlignment => throw _privateConstructorUsedError;
  String? get clip => throw _privateConstructorUsedError;
  BoxConstraintsModel? get constraints => throw _privateConstructorUsedError;
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AnimatedContainerWidget value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AnimatedContainerWidget value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AnimatedContainerWidget value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnimatedContainerWidgetCopyWith<AnimatedContainerWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimatedContainerWidgetCopyWith<$Res> {
  factory $AnimatedContainerWidgetCopyWith(AnimatedContainerWidget value,
          $Res Function(AnimatedContainerWidget) then) =
      _$AnimatedContainerWidgetCopyWithImpl<$Res, AnimatedContainerWidget>;
  @useResult
  $Res call(
      {int? durationInMs,
      String? curve,
      double? width,
      double? height,
      Map<String, dynamic>? padding,
      Map<String, dynamic>? margin,
      String? alignment,
      String? color,
      ContainerDecorationModel? decoration,
      TransformModel? transform,
      String? transformAlignment,
      String? clip,
      BoxConstraintsModel? constraints,
      Map<String, dynamic>? child});

  $ContainerDecorationModelCopyWith<$Res>? get decoration;
  $TransformModelCopyWith<$Res>? get transform;
  $BoxConstraintsModelCopyWith<$Res>? get constraints;
}

/// @nodoc
class _$AnimatedContainerWidgetCopyWithImpl<$Res,
        $Val extends AnimatedContainerWidget>
    implements $AnimatedContainerWidgetCopyWith<$Res> {
  _$AnimatedContainerWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationInMs = freezed,
    Object? curve = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? padding = freezed,
    Object? margin = freezed,
    Object? alignment = freezed,
    Object? color = freezed,
    Object? decoration = freezed,
    Object? transform = freezed,
    Object? transformAlignment = freezed,
    Object? clip = freezed,
    Object? constraints = freezed,
    Object? child = freezed,
  }) {
    return _then(_value.copyWith(
      durationInMs: freezed == durationInMs
          ? _value.durationInMs
          : durationInMs // ignore: cast_nullable_to_non_nullable
              as int?,
      curve: freezed == curve
          ? _value.curve
          : curve // ignore: cast_nullable_to_non_nullable
              as String?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      padding: freezed == padding
          ? _value.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      margin: freezed == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      alignment: freezed == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      decoration: freezed == decoration
          ? _value.decoration
          : decoration // ignore: cast_nullable_to_non_nullable
              as ContainerDecorationModel?,
      transform: freezed == transform
          ? _value.transform
          : transform // ignore: cast_nullable_to_non_nullable
              as TransformModel?,
      transformAlignment: freezed == transformAlignment
          ? _value.transformAlignment
          : transformAlignment // ignore: cast_nullable_to_non_nullable
              as String?,
      clip: freezed == clip
          ? _value.clip
          : clip // ignore: cast_nullable_to_non_nullable
              as String?,
      constraints: freezed == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as BoxConstraintsModel?,
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ContainerDecorationModelCopyWith<$Res>? get decoration {
    if (_value.decoration == null) {
      return null;
    }

    return $ContainerDecorationModelCopyWith<$Res>(_value.decoration!, (value) {
      return _then(_value.copyWith(decoration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TransformModelCopyWith<$Res>? get transform {
    if (_value.transform == null) {
      return null;
    }

    return $TransformModelCopyWith<$Res>(_value.transform!, (value) {
      return _then(_value.copyWith(transform: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BoxConstraintsModelCopyWith<$Res>? get constraints {
    if (_value.constraints == null) {
      return null;
    }

    return $BoxConstraintsModelCopyWith<$Res>(_value.constraints!, (value) {
      return _then(_value.copyWith(constraints: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnimatedContainerWidgetImplCopyWith<$Res>
    implements $AnimatedContainerWidgetCopyWith<$Res> {
  factory _$$AnimatedContainerWidgetImplCopyWith(
          _$AnimatedContainerWidgetImpl value,
          $Res Function(_$AnimatedContainerWidgetImpl) then) =
      __$$AnimatedContainerWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? durationInMs,
      String? curve,
      double? width,
      double? height,
      Map<String, dynamic>? padding,
      Map<String, dynamic>? margin,
      String? alignment,
      String? color,
      ContainerDecorationModel? decoration,
      TransformModel? transform,
      String? transformAlignment,
      String? clip,
      BoxConstraintsModel? constraints,
      Map<String, dynamic>? child});

  @override
  $ContainerDecorationModelCopyWith<$Res>? get decoration;
  @override
  $TransformModelCopyWith<$Res>? get transform;
  @override
  $BoxConstraintsModelCopyWith<$Res>? get constraints;
}

/// @nodoc
class __$$AnimatedContainerWidgetImplCopyWithImpl<$Res>
    extends _$AnimatedContainerWidgetCopyWithImpl<$Res,
        _$AnimatedContainerWidgetImpl>
    implements _$$AnimatedContainerWidgetImplCopyWith<$Res> {
  __$$AnimatedContainerWidgetImplCopyWithImpl(
      _$AnimatedContainerWidgetImpl _value,
      $Res Function(_$AnimatedContainerWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationInMs = freezed,
    Object? curve = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? padding = freezed,
    Object? margin = freezed,
    Object? alignment = freezed,
    Object? color = freezed,
    Object? decoration = freezed,
    Object? transform = freezed,
    Object? transformAlignment = freezed,
    Object? clip = freezed,
    Object? constraints = freezed,
    Object? child = freezed,
  }) {
    return _then(_$AnimatedContainerWidgetImpl(
      durationInMs: freezed == durationInMs
          ? _value.durationInMs
          : durationInMs // ignore: cast_nullable_to_non_nullable
              as int?,
      curve: freezed == curve
          ? _value.curve
          : curve // ignore: cast_nullable_to_non_nullable
              as String?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      padding: freezed == padding
          ? _value._padding
          : padding // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      margin: freezed == margin
          ? _value._margin
          : margin // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      alignment: freezed == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      decoration: freezed == decoration
          ? _value.decoration
          : decoration // ignore: cast_nullable_to_non_nullable
              as ContainerDecorationModel?,
      transform: freezed == transform
          ? _value.transform
          : transform // ignore: cast_nullable_to_non_nullable
              as TransformModel?,
      transformAlignment: freezed == transformAlignment
          ? _value.transformAlignment
          : transformAlignment // ignore: cast_nullable_to_non_nullable
              as String?,
      clip: freezed == clip
          ? _value.clip
          : clip // ignore: cast_nullable_to_non_nullable
              as String?,
      constraints: freezed == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as BoxConstraintsModel?,
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnimatedContainerWidgetImpl implements _AnimatedContainerWidget {
  const _$AnimatedContainerWidgetImpl(
      {this.durationInMs,
      this.curve,
      this.width,
      this.height,
      final Map<String, dynamic>? padding,
      final Map<String, dynamic>? margin,
      this.alignment,
      this.color,
      this.decoration,
      this.transform,
      this.transformAlignment,
      this.clip,
      this.constraints,
      final Map<String, dynamic>? child})
      : _padding = padding,
        _margin = margin,
        _child = child;

  factory _$AnimatedContainerWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnimatedContainerWidgetImplFromJson(json);

  @override
  final int? durationInMs;
  @override
  final String? curve;
  @override
  final double? width;
  @override
  final double? height;
  final Map<String, dynamic>? _padding;
  @override
  Map<String, dynamic>? get padding {
    final value = _padding;
    if (value == null) return null;
    if (_padding is EqualUnmodifiableMapView) return _padding;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _margin;
  @override
  Map<String, dynamic>? get margin {
    final value = _margin;
    if (value == null) return null;
    if (_margin is EqualUnmodifiableMapView) return _margin;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? alignment;
  @override
  final String? color;
  @override
  final ContainerDecorationModel? decoration;
  @override
  final TransformModel? transform;
  @override
  final String? transformAlignment;
  @override
  final String? clip;
  @override
  final BoxConstraintsModel? constraints;
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
    return 'AnimatedContainerWidget(durationInMs: $durationInMs, curve: $curve, width: $width, height: $height, padding: $padding, margin: $margin, alignment: $alignment, color: $color, decoration: $decoration, transform: $transform, transformAlignment: $transformAlignment, clip: $clip, constraints: $constraints, child: $child)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimatedContainerWidgetImpl &&
            (identical(other.durationInMs, durationInMs) ||
                other.durationInMs == durationInMs) &&
            (identical(other.curve, curve) || other.curve == curve) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            const DeepCollectionEquality().equals(other._padding, _padding) &&
            const DeepCollectionEquality().equals(other._margin, _margin) &&
            (identical(other.alignment, alignment) ||
                other.alignment == alignment) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.decoration, decoration) ||
                other.decoration == decoration) &&
            (identical(other.transform, transform) ||
                other.transform == transform) &&
            (identical(other.transformAlignment, transformAlignment) ||
                other.transformAlignment == transformAlignment) &&
            (identical(other.clip, clip) || other.clip == clip) &&
            (identical(other.constraints, constraints) ||
                other.constraints == constraints) &&
            const DeepCollectionEquality().equals(other._child, _child));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      durationInMs,
      curve,
      width,
      height,
      const DeepCollectionEquality().hash(_padding),
      const DeepCollectionEquality().hash(_margin),
      alignment,
      color,
      decoration,
      transform,
      transformAlignment,
      clip,
      constraints,
      const DeepCollectionEquality().hash(_child));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimatedContainerWidgetImplCopyWith<_$AnimatedContainerWidgetImpl>
      get copyWith => __$$AnimatedContainerWidgetImplCopyWithImpl<
          _$AnimatedContainerWidgetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AnimatedContainerWidget value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AnimatedContainerWidget value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AnimatedContainerWidget value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AnimatedContainerWidgetImplToJson(
      this,
    );
  }
}

abstract class _AnimatedContainerWidget implements AnimatedContainerWidget {
  const factory _AnimatedContainerWidget(
      {final int? durationInMs,
      final String? curve,
      final double? width,
      final double? height,
      final Map<String, dynamic>? padding,
      final Map<String, dynamic>? margin,
      final String? alignment,
      final String? color,
      final ContainerDecorationModel? decoration,
      final TransformModel? transform,
      final String? transformAlignment,
      final String? clip,
      final BoxConstraintsModel? constraints,
      final Map<String, dynamic>? child}) = _$AnimatedContainerWidgetImpl;

  factory _AnimatedContainerWidget.fromJson(Map<String, dynamic> json) =
      _$AnimatedContainerWidgetImpl.fromJson;

  @override
  int? get durationInMs;
  @override
  String? get curve;
  @override
  double? get width;
  @override
  double? get height;
  @override
  Map<String, dynamic>? get padding;
  @override
  Map<String, dynamic>? get margin;
  @override
  String? get alignment;
  @override
  String? get color;
  @override
  ContainerDecorationModel? get decoration;
  @override
  TransformModel? get transform;
  @override
  String? get transformAlignment;
  @override
  String? get clip;
  @override
  BoxConstraintsModel? get constraints;
  @override
  Map<String, dynamic>? get child;
  @override
  @JsonKey(ignore: true)
  _$$AnimatedContainerWidgetImplCopyWith<_$AnimatedContainerWidgetImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContainerDecorationModel _$ContainerDecorationModelFromJson(
    Map<String, dynamic> json) {
  return _ContainerDecorationModel.fromJson(json);
}

/// @nodoc
mixin _$ContainerDecorationModel {
  String? get color => throw _privateConstructorUsedError;
  double? get borderRadius => throw _privateConstructorUsedError;
  String? get borderColor => throw _privateConstructorUsedError;
  double? get borderWidth => throw _privateConstructorUsedError;
  double? get shadow => throw _privateConstructorUsedError;
  String? get shadowColor => throw _privateConstructorUsedError;
  double? get spreadRadius => throw _privateConstructorUsedError;
  double? get offsetX => throw _privateConstructorUsedError;
  double? get offsetY => throw _privateConstructorUsedError;
  Map<String, dynamic>? get gradient => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ContainerDecorationModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ContainerDecorationModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ContainerDecorationModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContainerDecorationModelCopyWith<ContainerDecorationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContainerDecorationModelCopyWith<$Res> {
  factory $ContainerDecorationModelCopyWith(ContainerDecorationModel value,
          $Res Function(ContainerDecorationModel) then) =
      _$ContainerDecorationModelCopyWithImpl<$Res, ContainerDecorationModel>;
  @useResult
  $Res call(
      {String? color,
      double? borderRadius,
      String? borderColor,
      double? borderWidth,
      double? shadow,
      String? shadowColor,
      double? spreadRadius,
      double? offsetX,
      double? offsetY,
      Map<String, dynamic>? gradient});
}

/// @nodoc
class _$ContainerDecorationModelCopyWithImpl<$Res,
        $Val extends ContainerDecorationModel>
    implements $ContainerDecorationModelCopyWith<$Res> {
  _$ContainerDecorationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? borderRadius = freezed,
    Object? borderColor = freezed,
    Object? borderWidth = freezed,
    Object? shadow = freezed,
    Object? shadowColor = freezed,
    Object? spreadRadius = freezed,
    Object? offsetX = freezed,
    Object? offsetY = freezed,
    Object? gradient = freezed,
  }) {
    return _then(_value.copyWith(
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      borderRadius: freezed == borderRadius
          ? _value.borderRadius
          : borderRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      borderColor: freezed == borderColor
          ? _value.borderColor
          : borderColor // ignore: cast_nullable_to_non_nullable
              as String?,
      borderWidth: freezed == borderWidth
          ? _value.borderWidth
          : borderWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      shadow: freezed == shadow
          ? _value.shadow
          : shadow // ignore: cast_nullable_to_non_nullable
              as double?,
      shadowColor: freezed == shadowColor
          ? _value.shadowColor
          : shadowColor // ignore: cast_nullable_to_non_nullable
              as String?,
      spreadRadius: freezed == spreadRadius
          ? _value.spreadRadius
          : spreadRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      offsetX: freezed == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double?,
      offsetY: freezed == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double?,
      gradient: freezed == gradient
          ? _value.gradient
          : gradient // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContainerDecorationModelImplCopyWith<$Res>
    implements $ContainerDecorationModelCopyWith<$Res> {
  factory _$$ContainerDecorationModelImplCopyWith(
          _$ContainerDecorationModelImpl value,
          $Res Function(_$ContainerDecorationModelImpl) then) =
      __$$ContainerDecorationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? color,
      double? borderRadius,
      String? borderColor,
      double? borderWidth,
      double? shadow,
      String? shadowColor,
      double? spreadRadius,
      double? offsetX,
      double? offsetY,
      Map<String, dynamic>? gradient});
}

/// @nodoc
class __$$ContainerDecorationModelImplCopyWithImpl<$Res>
    extends _$ContainerDecorationModelCopyWithImpl<$Res,
        _$ContainerDecorationModelImpl>
    implements _$$ContainerDecorationModelImplCopyWith<$Res> {
  __$$ContainerDecorationModelImplCopyWithImpl(
      _$ContainerDecorationModelImpl _value,
      $Res Function(_$ContainerDecorationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? borderRadius = freezed,
    Object? borderColor = freezed,
    Object? borderWidth = freezed,
    Object? shadow = freezed,
    Object? shadowColor = freezed,
    Object? spreadRadius = freezed,
    Object? offsetX = freezed,
    Object? offsetY = freezed,
    Object? gradient = freezed,
  }) {
    return _then(_$ContainerDecorationModelImpl(
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      borderRadius: freezed == borderRadius
          ? _value.borderRadius
          : borderRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      borderColor: freezed == borderColor
          ? _value.borderColor
          : borderColor // ignore: cast_nullable_to_non_nullable
              as String?,
      borderWidth: freezed == borderWidth
          ? _value.borderWidth
          : borderWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      shadow: freezed == shadow
          ? _value.shadow
          : shadow // ignore: cast_nullable_to_non_nullable
              as double?,
      shadowColor: freezed == shadowColor
          ? _value.shadowColor
          : shadowColor // ignore: cast_nullable_to_non_nullable
              as String?,
      spreadRadius: freezed == spreadRadius
          ? _value.spreadRadius
          : spreadRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      offsetX: freezed == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double?,
      offsetY: freezed == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double?,
      gradient: freezed == gradient
          ? _value._gradient
          : gradient // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContainerDecorationModelImpl implements _ContainerDecorationModel {
  const _$ContainerDecorationModelImpl(
      {this.color,
      this.borderRadius,
      this.borderColor,
      this.borderWidth,
      this.shadow,
      this.shadowColor,
      this.spreadRadius,
      this.offsetX,
      this.offsetY,
      final Map<String, dynamic>? gradient})
      : _gradient = gradient;

  factory _$ContainerDecorationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContainerDecorationModelImplFromJson(json);

  @override
  final String? color;
  @override
  final double? borderRadius;
  @override
  final String? borderColor;
  @override
  final double? borderWidth;
  @override
  final double? shadow;
  @override
  final String? shadowColor;
  @override
  final double? spreadRadius;
  @override
  final double? offsetX;
  @override
  final double? offsetY;
  final Map<String, dynamic>? _gradient;
  @override
  Map<String, dynamic>? get gradient {
    final value = _gradient;
    if (value == null) return null;
    if (_gradient is EqualUnmodifiableMapView) return _gradient;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ContainerDecorationModel(color: $color, borderRadius: $borderRadius, borderColor: $borderColor, borderWidth: $borderWidth, shadow: $shadow, shadowColor: $shadowColor, spreadRadius: $spreadRadius, offsetX: $offsetX, offsetY: $offsetY, gradient: $gradient)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContainerDecorationModelImpl &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.borderRadius, borderRadius) ||
                other.borderRadius == borderRadius) &&
            (identical(other.borderColor, borderColor) ||
                other.borderColor == borderColor) &&
            (identical(other.borderWidth, borderWidth) ||
                other.borderWidth == borderWidth) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.shadowColor, shadowColor) ||
                other.shadowColor == shadowColor) &&
            (identical(other.spreadRadius, spreadRadius) ||
                other.spreadRadius == spreadRadius) &&
            (identical(other.offsetX, offsetX) || other.offsetX == offsetX) &&
            (identical(other.offsetY, offsetY) || other.offsetY == offsetY) &&
            const DeepCollectionEquality().equals(other._gradient, _gradient));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      color,
      borderRadius,
      borderColor,
      borderWidth,
      shadow,
      shadowColor,
      spreadRadius,
      offsetX,
      offsetY,
      const DeepCollectionEquality().hash(_gradient));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContainerDecorationModelImplCopyWith<_$ContainerDecorationModelImpl>
      get copyWith => __$$ContainerDecorationModelImplCopyWithImpl<
          _$ContainerDecorationModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ContainerDecorationModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ContainerDecorationModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ContainerDecorationModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ContainerDecorationModelImplToJson(
      this,
    );
  }
}

abstract class _ContainerDecorationModel implements ContainerDecorationModel {
  const factory _ContainerDecorationModel(
      {final String? color,
      final double? borderRadius,
      final String? borderColor,
      final double? borderWidth,
      final double? shadow,
      final String? shadowColor,
      final double? spreadRadius,
      final double? offsetX,
      final double? offsetY,
      final Map<String, dynamic>? gradient}) = _$ContainerDecorationModelImpl;

  factory _ContainerDecorationModel.fromJson(Map<String, dynamic> json) =
      _$ContainerDecorationModelImpl.fromJson;

  @override
  String? get color;
  @override
  double? get borderRadius;
  @override
  String? get borderColor;
  @override
  double? get borderWidth;
  @override
  double? get shadow;
  @override
  String? get shadowColor;
  @override
  double? get spreadRadius;
  @override
  double? get offsetX;
  @override
  double? get offsetY;
  @override
  Map<String, dynamic>? get gradient;
  @override
  @JsonKey(ignore: true)
  _$$ContainerDecorationModelImplCopyWith<_$ContainerDecorationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TransformModel _$TransformModelFromJson(Map<String, dynamic> json) {
  return _TransformModel.fromJson(json);
}

/// @nodoc
mixin _$TransformModel {
  double? get translateX => throw _privateConstructorUsedError;
  double? get translateY => throw _privateConstructorUsedError;
  double? get translateZ => throw _privateConstructorUsedError;
  double? get rotateX => throw _privateConstructorUsedError;
  double? get rotateY => throw _privateConstructorUsedError;
  double? get rotateZ => throw _privateConstructorUsedError;
  double? get scaleX => throw _privateConstructorUsedError;
  double? get scaleY => throw _privateConstructorUsedError;
  double? get scaleZ => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TransformModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TransformModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TransformModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransformModelCopyWith<TransformModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransformModelCopyWith<$Res> {
  factory $TransformModelCopyWith(
          TransformModel value, $Res Function(TransformModel) then) =
      _$TransformModelCopyWithImpl<$Res, TransformModel>;
  @useResult
  $Res call(
      {double? translateX,
      double? translateY,
      double? translateZ,
      double? rotateX,
      double? rotateY,
      double? rotateZ,
      double? scaleX,
      double? scaleY,
      double? scaleZ});
}

/// @nodoc
class _$TransformModelCopyWithImpl<$Res, $Val extends TransformModel>
    implements $TransformModelCopyWith<$Res> {
  _$TransformModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? translateX = freezed,
    Object? translateY = freezed,
    Object? translateZ = freezed,
    Object? rotateX = freezed,
    Object? rotateY = freezed,
    Object? rotateZ = freezed,
    Object? scaleX = freezed,
    Object? scaleY = freezed,
    Object? scaleZ = freezed,
  }) {
    return _then(_value.copyWith(
      translateX: freezed == translateX
          ? _value.translateX
          : translateX // ignore: cast_nullable_to_non_nullable
              as double?,
      translateY: freezed == translateY
          ? _value.translateY
          : translateY // ignore: cast_nullable_to_non_nullable
              as double?,
      translateZ: freezed == translateZ
          ? _value.translateZ
          : translateZ // ignore: cast_nullable_to_non_nullable
              as double?,
      rotateX: freezed == rotateX
          ? _value.rotateX
          : rotateX // ignore: cast_nullable_to_non_nullable
              as double?,
      rotateY: freezed == rotateY
          ? _value.rotateY
          : rotateY // ignore: cast_nullable_to_non_nullable
              as double?,
      rotateZ: freezed == rotateZ
          ? _value.rotateZ
          : rotateZ // ignore: cast_nullable_to_non_nullable
              as double?,
      scaleX: freezed == scaleX
          ? _value.scaleX
          : scaleX // ignore: cast_nullable_to_non_nullable
              as double?,
      scaleY: freezed == scaleY
          ? _value.scaleY
          : scaleY // ignore: cast_nullable_to_non_nullable
              as double?,
      scaleZ: freezed == scaleZ
          ? _value.scaleZ
          : scaleZ // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransformModelImplCopyWith<$Res>
    implements $TransformModelCopyWith<$Res> {
  factory _$$TransformModelImplCopyWith(_$TransformModelImpl value,
          $Res Function(_$TransformModelImpl) then) =
      __$$TransformModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? translateX,
      double? translateY,
      double? translateZ,
      double? rotateX,
      double? rotateY,
      double? rotateZ,
      double? scaleX,
      double? scaleY,
      double? scaleZ});
}

/// @nodoc
class __$$TransformModelImplCopyWithImpl<$Res>
    extends _$TransformModelCopyWithImpl<$Res, _$TransformModelImpl>
    implements _$$TransformModelImplCopyWith<$Res> {
  __$$TransformModelImplCopyWithImpl(
      _$TransformModelImpl _value, $Res Function(_$TransformModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? translateX = freezed,
    Object? translateY = freezed,
    Object? translateZ = freezed,
    Object? rotateX = freezed,
    Object? rotateY = freezed,
    Object? rotateZ = freezed,
    Object? scaleX = freezed,
    Object? scaleY = freezed,
    Object? scaleZ = freezed,
  }) {
    return _then(_$TransformModelImpl(
      translateX: freezed == translateX
          ? _value.translateX
          : translateX // ignore: cast_nullable_to_non_nullable
              as double?,
      translateY: freezed == translateY
          ? _value.translateY
          : translateY // ignore: cast_nullable_to_non_nullable
              as double?,
      translateZ: freezed == translateZ
          ? _value.translateZ
          : translateZ // ignore: cast_nullable_to_non_nullable
              as double?,
      rotateX: freezed == rotateX
          ? _value.rotateX
          : rotateX // ignore: cast_nullable_to_non_nullable
              as double?,
      rotateY: freezed == rotateY
          ? _value.rotateY
          : rotateY // ignore: cast_nullable_to_non_nullable
              as double?,
      rotateZ: freezed == rotateZ
          ? _value.rotateZ
          : rotateZ // ignore: cast_nullable_to_non_nullable
              as double?,
      scaleX: freezed == scaleX
          ? _value.scaleX
          : scaleX // ignore: cast_nullable_to_non_nullable
              as double?,
      scaleY: freezed == scaleY
          ? _value.scaleY
          : scaleY // ignore: cast_nullable_to_non_nullable
              as double?,
      scaleZ: freezed == scaleZ
          ? _value.scaleZ
          : scaleZ // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransformModelImpl implements _TransformModel {
  const _$TransformModelImpl(
      {this.translateX,
      this.translateY,
      this.translateZ,
      this.rotateX,
      this.rotateY,
      this.rotateZ,
      this.scaleX,
      this.scaleY,
      this.scaleZ});

  factory _$TransformModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransformModelImplFromJson(json);

  @override
  final double? translateX;
  @override
  final double? translateY;
  @override
  final double? translateZ;
  @override
  final double? rotateX;
  @override
  final double? rotateY;
  @override
  final double? rotateZ;
  @override
  final double? scaleX;
  @override
  final double? scaleY;
  @override
  final double? scaleZ;

  @override
  String toString() {
    return 'TransformModel(translateX: $translateX, translateY: $translateY, translateZ: $translateZ, rotateX: $rotateX, rotateY: $rotateY, rotateZ: $rotateZ, scaleX: $scaleX, scaleY: $scaleY, scaleZ: $scaleZ)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransformModelImpl &&
            (identical(other.translateX, translateX) ||
                other.translateX == translateX) &&
            (identical(other.translateY, translateY) ||
                other.translateY == translateY) &&
            (identical(other.translateZ, translateZ) ||
                other.translateZ == translateZ) &&
            (identical(other.rotateX, rotateX) || other.rotateX == rotateX) &&
            (identical(other.rotateY, rotateY) || other.rotateY == rotateY) &&
            (identical(other.rotateZ, rotateZ) || other.rotateZ == rotateZ) &&
            (identical(other.scaleX, scaleX) || other.scaleX == scaleX) &&
            (identical(other.scaleY, scaleY) || other.scaleY == scaleY) &&
            (identical(other.scaleZ, scaleZ) || other.scaleZ == scaleZ));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, translateX, translateY,
      translateZ, rotateX, rotateY, rotateZ, scaleX, scaleY, scaleZ);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransformModelImplCopyWith<_$TransformModelImpl> get copyWith =>
      __$$TransformModelImplCopyWithImpl<_$TransformModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TransformModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TransformModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TransformModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TransformModelImplToJson(
      this,
    );
  }
}

abstract class _TransformModel implements TransformModel {
  const factory _TransformModel(
      {final double? translateX,
      final double? translateY,
      final double? translateZ,
      final double? rotateX,
      final double? rotateY,
      final double? rotateZ,
      final double? scaleX,
      final double? scaleY,
      final double? scaleZ}) = _$TransformModelImpl;

  factory _TransformModel.fromJson(Map<String, dynamic> json) =
      _$TransformModelImpl.fromJson;

  @override
  double? get translateX;
  @override
  double? get translateY;
  @override
  double? get translateZ;
  @override
  double? get rotateX;
  @override
  double? get rotateY;
  @override
  double? get rotateZ;
  @override
  double? get scaleX;
  @override
  double? get scaleY;
  @override
  double? get scaleZ;
  @override
  @JsonKey(ignore: true)
  _$$TransformModelImplCopyWith<_$TransformModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BoxConstraintsModel _$BoxConstraintsModelFromJson(Map<String, dynamic> json) {
  return _BoxConstraintsModel.fromJson(json);
}

/// @nodoc
mixin _$BoxConstraintsModel {
  double? get minWidth => throw _privateConstructorUsedError;
  double? get maxWidth => throw _privateConstructorUsedError;
  double? get minHeight => throw _privateConstructorUsedError;
  double? get maxHeight => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BoxConstraintsModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BoxConstraintsModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BoxConstraintsModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoxConstraintsModelCopyWith<BoxConstraintsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoxConstraintsModelCopyWith<$Res> {
  factory $BoxConstraintsModelCopyWith(
          BoxConstraintsModel value, $Res Function(BoxConstraintsModel) then) =
      _$BoxConstraintsModelCopyWithImpl<$Res, BoxConstraintsModel>;
  @useResult
  $Res call(
      {double? minWidth,
      double? maxWidth,
      double? minHeight,
      double? maxHeight});
}

/// @nodoc
class _$BoxConstraintsModelCopyWithImpl<$Res, $Val extends BoxConstraintsModel>
    implements $BoxConstraintsModelCopyWith<$Res> {
  _$BoxConstraintsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minWidth = freezed,
    Object? maxWidth = freezed,
    Object? minHeight = freezed,
    Object? maxHeight = freezed,
  }) {
    return _then(_value.copyWith(
      minWidth: freezed == minWidth
          ? _value.minWidth
          : minWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      maxWidth: freezed == maxWidth
          ? _value.maxWidth
          : maxWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      minHeight: freezed == minHeight
          ? _value.minHeight
          : minHeight // ignore: cast_nullable_to_non_nullable
              as double?,
      maxHeight: freezed == maxHeight
          ? _value.maxHeight
          : maxHeight // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoxConstraintsModelImplCopyWith<$Res>
    implements $BoxConstraintsModelCopyWith<$Res> {
  factory _$$BoxConstraintsModelImplCopyWith(_$BoxConstraintsModelImpl value,
          $Res Function(_$BoxConstraintsModelImpl) then) =
      __$$BoxConstraintsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? minWidth,
      double? maxWidth,
      double? minHeight,
      double? maxHeight});
}

/// @nodoc
class __$$BoxConstraintsModelImplCopyWithImpl<$Res>
    extends _$BoxConstraintsModelCopyWithImpl<$Res, _$BoxConstraintsModelImpl>
    implements _$$BoxConstraintsModelImplCopyWith<$Res> {
  __$$BoxConstraintsModelImplCopyWithImpl(_$BoxConstraintsModelImpl _value,
      $Res Function(_$BoxConstraintsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minWidth = freezed,
    Object? maxWidth = freezed,
    Object? minHeight = freezed,
    Object? maxHeight = freezed,
  }) {
    return _then(_$BoxConstraintsModelImpl(
      minWidth: freezed == minWidth
          ? _value.minWidth
          : minWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      maxWidth: freezed == maxWidth
          ? _value.maxWidth
          : maxWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      minHeight: freezed == minHeight
          ? _value.minHeight
          : minHeight // ignore: cast_nullable_to_non_nullable
              as double?,
      maxHeight: freezed == maxHeight
          ? _value.maxHeight
          : maxHeight // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoxConstraintsModelImpl implements _BoxConstraintsModel {
  const _$BoxConstraintsModelImpl(
      {this.minWidth, this.maxWidth, this.minHeight, this.maxHeight});

  factory _$BoxConstraintsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoxConstraintsModelImplFromJson(json);

  @override
  final double? minWidth;
  @override
  final double? maxWidth;
  @override
  final double? minHeight;
  @override
  final double? maxHeight;

  @override
  String toString() {
    return 'BoxConstraintsModel(minWidth: $minWidth, maxWidth: $maxWidth, minHeight: $minHeight, maxHeight: $maxHeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoxConstraintsModelImpl &&
            (identical(other.minWidth, minWidth) ||
                other.minWidth == minWidth) &&
            (identical(other.maxWidth, maxWidth) ||
                other.maxWidth == maxWidth) &&
            (identical(other.minHeight, minHeight) ||
                other.minHeight == minHeight) &&
            (identical(other.maxHeight, maxHeight) ||
                other.maxHeight == maxHeight));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, minWidth, maxWidth, minHeight, maxHeight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoxConstraintsModelImplCopyWith<_$BoxConstraintsModelImpl> get copyWith =>
      __$$BoxConstraintsModelImplCopyWithImpl<_$BoxConstraintsModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BoxConstraintsModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BoxConstraintsModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BoxConstraintsModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BoxConstraintsModelImplToJson(
      this,
    );
  }
}

abstract class _BoxConstraintsModel implements BoxConstraintsModel {
  const factory _BoxConstraintsModel(
      {final double? minWidth,
      final double? maxWidth,
      final double? minHeight,
      final double? maxHeight}) = _$BoxConstraintsModelImpl;

  factory _BoxConstraintsModel.fromJson(Map<String, dynamic> json) =
      _$BoxConstraintsModelImpl.fromJson;

  @override
  double? get minWidth;
  @override
  double? get maxWidth;
  @override
  double? get minHeight;
  @override
  double? get maxHeight;
  @override
  @JsonKey(ignore: true)
  _$$BoxConstraintsModelImplCopyWith<_$BoxConstraintsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
