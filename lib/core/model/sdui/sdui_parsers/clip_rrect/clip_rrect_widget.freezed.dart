// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clip_rrect_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClipRRectWidget _$ClipRRectWidgetFromJson(Map<String, dynamic> json) {
  return _ClipRRectWidget.fromJson(json);
}

/// @nodoc
mixin _$ClipRRectWidget {
  BorderRadiusModel? get borderRadius => throw _privateConstructorUsedError;
  String? get clipBehavior => throw _privateConstructorUsedError;
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ClipRRectWidget value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ClipRRectWidget value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ClipRRectWidget value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClipRRectWidgetCopyWith<ClipRRectWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClipRRectWidgetCopyWith<$Res> {
  factory $ClipRRectWidgetCopyWith(
          ClipRRectWidget value, $Res Function(ClipRRectWidget) then) =
      _$ClipRRectWidgetCopyWithImpl<$Res, ClipRRectWidget>;
  @useResult
  $Res call(
      {BorderRadiusModel? borderRadius,
      String? clipBehavior,
      Map<String, dynamic>? child});

  $BorderRadiusModelCopyWith<$Res>? get borderRadius;
}

/// @nodoc
class _$ClipRRectWidgetCopyWithImpl<$Res, $Val extends ClipRRectWidget>
    implements $ClipRRectWidgetCopyWith<$Res> {
  _$ClipRRectWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? borderRadius = freezed,
    Object? clipBehavior = freezed,
    Object? child = freezed,
  }) {
    return _then(_value.copyWith(
      borderRadius: freezed == borderRadius
          ? _value.borderRadius
          : borderRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadiusModel?,
      clipBehavior: freezed == clipBehavior
          ? _value.clipBehavior
          : clipBehavior // ignore: cast_nullable_to_non_nullable
              as String?,
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BorderRadiusModelCopyWith<$Res>? get borderRadius {
    if (_value.borderRadius == null) {
      return null;
    }

    return $BorderRadiusModelCopyWith<$Res>(_value.borderRadius!, (value) {
      return _then(_value.copyWith(borderRadius: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ClipRRectWidgetImplCopyWith<$Res>
    implements $ClipRRectWidgetCopyWith<$Res> {
  factory _$$ClipRRectWidgetImplCopyWith(_$ClipRRectWidgetImpl value,
          $Res Function(_$ClipRRectWidgetImpl) then) =
      __$$ClipRRectWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BorderRadiusModel? borderRadius,
      String? clipBehavior,
      Map<String, dynamic>? child});

  @override
  $BorderRadiusModelCopyWith<$Res>? get borderRadius;
}

/// @nodoc
class __$$ClipRRectWidgetImplCopyWithImpl<$Res>
    extends _$ClipRRectWidgetCopyWithImpl<$Res, _$ClipRRectWidgetImpl>
    implements _$$ClipRRectWidgetImplCopyWith<$Res> {
  __$$ClipRRectWidgetImplCopyWithImpl(
      _$ClipRRectWidgetImpl _value, $Res Function(_$ClipRRectWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? borderRadius = freezed,
    Object? clipBehavior = freezed,
    Object? child = freezed,
  }) {
    return _then(_$ClipRRectWidgetImpl(
      borderRadius: freezed == borderRadius
          ? _value.borderRadius
          : borderRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadiusModel?,
      clipBehavior: freezed == clipBehavior
          ? _value.clipBehavior
          : clipBehavior // ignore: cast_nullable_to_non_nullable
              as String?,
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClipRRectWidgetImpl implements _ClipRRectWidget {
  const _$ClipRRectWidgetImpl(
      {this.borderRadius, this.clipBehavior, final Map<String, dynamic>? child})
      : _child = child;

  factory _$ClipRRectWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClipRRectWidgetImplFromJson(json);

  @override
  final BorderRadiusModel? borderRadius;
  @override
  final String? clipBehavior;
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
    return 'ClipRRectWidget(borderRadius: $borderRadius, clipBehavior: $clipBehavior, child: $child)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClipRRectWidgetImpl &&
            (identical(other.borderRadius, borderRadius) ||
                other.borderRadius == borderRadius) &&
            (identical(other.clipBehavior, clipBehavior) ||
                other.clipBehavior == clipBehavior) &&
            const DeepCollectionEquality().equals(other._child, _child));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, borderRadius, clipBehavior,
      const DeepCollectionEquality().hash(_child));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClipRRectWidgetImplCopyWith<_$ClipRRectWidgetImpl> get copyWith =>
      __$$ClipRRectWidgetImplCopyWithImpl<_$ClipRRectWidgetImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ClipRRectWidget value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ClipRRectWidget value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ClipRRectWidget value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ClipRRectWidgetImplToJson(
      this,
    );
  }
}

abstract class _ClipRRectWidget implements ClipRRectWidget {
  const factory _ClipRRectWidget(
      {final BorderRadiusModel? borderRadius,
      final String? clipBehavior,
      final Map<String, dynamic>? child}) = _$ClipRRectWidgetImpl;

  factory _ClipRRectWidget.fromJson(Map<String, dynamic> json) =
      _$ClipRRectWidgetImpl.fromJson;

  @override
  BorderRadiusModel? get borderRadius;
  @override
  String? get clipBehavior;
  @override
  Map<String, dynamic>? get child;
  @override
  @JsonKey(ignore: true)
  _$$ClipRRectWidgetImplCopyWith<_$ClipRRectWidgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BorderRadiusModel _$BorderRadiusModelFromJson(Map<String, dynamic> json) {
  return _BorderRadiusModel.fromJson(json);
}

/// @nodoc
mixin _$BorderRadiusModel {
  double? get all => throw _privateConstructorUsedError;
  double? get topLeft => throw _privateConstructorUsedError;
  double? get topRight => throw _privateConstructorUsedError;
  double? get bottomLeft => throw _privateConstructorUsedError;
  double? get bottomRight => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BorderRadiusModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BorderRadiusModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BorderRadiusModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BorderRadiusModelCopyWith<BorderRadiusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BorderRadiusModelCopyWith<$Res> {
  factory $BorderRadiusModelCopyWith(
          BorderRadiusModel value, $Res Function(BorderRadiusModel) then) =
      _$BorderRadiusModelCopyWithImpl<$Res, BorderRadiusModel>;
  @useResult
  $Res call(
      {double? all,
      double? topLeft,
      double? topRight,
      double? bottomLeft,
      double? bottomRight});
}

/// @nodoc
class _$BorderRadiusModelCopyWithImpl<$Res, $Val extends BorderRadiusModel>
    implements $BorderRadiusModelCopyWith<$Res> {
  _$BorderRadiusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? all = freezed,
    Object? topLeft = freezed,
    Object? topRight = freezed,
    Object? bottomLeft = freezed,
    Object? bottomRight = freezed,
  }) {
    return _then(_value.copyWith(
      all: freezed == all
          ? _value.all
          : all // ignore: cast_nullable_to_non_nullable
              as double?,
      topLeft: freezed == topLeft
          ? _value.topLeft
          : topLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      topRight: freezed == topRight
          ? _value.topRight
          : topRight // ignore: cast_nullable_to_non_nullable
              as double?,
      bottomLeft: freezed == bottomLeft
          ? _value.bottomLeft
          : bottomLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      bottomRight: freezed == bottomRight
          ? _value.bottomRight
          : bottomRight // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BorderRadiusModelImplCopyWith<$Res>
    implements $BorderRadiusModelCopyWith<$Res> {
  factory _$$BorderRadiusModelImplCopyWith(_$BorderRadiusModelImpl value,
          $Res Function(_$BorderRadiusModelImpl) then) =
      __$$BorderRadiusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? all,
      double? topLeft,
      double? topRight,
      double? bottomLeft,
      double? bottomRight});
}

/// @nodoc
class __$$BorderRadiusModelImplCopyWithImpl<$Res>
    extends _$BorderRadiusModelCopyWithImpl<$Res, _$BorderRadiusModelImpl>
    implements _$$BorderRadiusModelImplCopyWith<$Res> {
  __$$BorderRadiusModelImplCopyWithImpl(_$BorderRadiusModelImpl _value,
      $Res Function(_$BorderRadiusModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? all = freezed,
    Object? topLeft = freezed,
    Object? topRight = freezed,
    Object? bottomLeft = freezed,
    Object? bottomRight = freezed,
  }) {
    return _then(_$BorderRadiusModelImpl(
      all: freezed == all
          ? _value.all
          : all // ignore: cast_nullable_to_non_nullable
              as double?,
      topLeft: freezed == topLeft
          ? _value.topLeft
          : topLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      topRight: freezed == topRight
          ? _value.topRight
          : topRight // ignore: cast_nullable_to_non_nullable
              as double?,
      bottomLeft: freezed == bottomLeft
          ? _value.bottomLeft
          : bottomLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      bottomRight: freezed == bottomRight
          ? _value.bottomRight
          : bottomRight // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BorderRadiusModelImpl implements _BorderRadiusModel {
  const _$BorderRadiusModelImpl(
      {this.all,
      this.topLeft,
      this.topRight,
      this.bottomLeft,
      this.bottomRight});

  factory _$BorderRadiusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BorderRadiusModelImplFromJson(json);

  @override
  final double? all;
  @override
  final double? topLeft;
  @override
  final double? topRight;
  @override
  final double? bottomLeft;
  @override
  final double? bottomRight;

  @override
  String toString() {
    return 'BorderRadiusModel(all: $all, topLeft: $topLeft, topRight: $topRight, bottomLeft: $bottomLeft, bottomRight: $bottomRight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BorderRadiusModelImpl &&
            (identical(other.all, all) || other.all == all) &&
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
      Object.hash(runtimeType, all, topLeft, topRight, bottomLeft, bottomRight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BorderRadiusModelImplCopyWith<_$BorderRadiusModelImpl> get copyWith =>
      __$$BorderRadiusModelImplCopyWithImpl<_$BorderRadiusModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BorderRadiusModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BorderRadiusModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BorderRadiusModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BorderRadiusModelImplToJson(
      this,
    );
  }
}

abstract class _BorderRadiusModel implements BorderRadiusModel {
  const factory _BorderRadiusModel(
      {final double? all,
      final double? topLeft,
      final double? topRight,
      final double? bottomLeft,
      final double? bottomRight}) = _$BorderRadiusModelImpl;

  factory _BorderRadiusModel.fromJson(Map<String, dynamic> json) =
      _$BorderRadiusModelImpl.fromJson;

  @override
  double? get all;
  @override
  double? get topLeft;
  @override
  double? get topRight;
  @override
  double? get bottomLeft;
  @override
  double? get bottomRight;
  @override
  @JsonKey(ignore: true)
  _$$BorderRadiusModelImplCopyWith<_$BorderRadiusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
