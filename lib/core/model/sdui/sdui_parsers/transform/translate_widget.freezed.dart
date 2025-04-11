// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translate_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransformWidget _$TransformWidgetFromJson(Map<String, dynamic> json) {
  return _TransformWidget.fromJson(json);
}

/// @nodoc
mixin _$TransformWidget {
  double get dx => throw _privateConstructorUsedError;
  double get dy => throw _privateConstructorUsedError;
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TransformWidget value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TransformWidget value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TransformWidget value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransformWidgetCopyWith<TransformWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransformWidgetCopyWith<$Res> {
  factory $TransformWidgetCopyWith(
          TransformWidget value, $Res Function(TransformWidget) then) =
      _$TransformWidgetCopyWithImpl<$Res, TransformWidget>;
  @useResult
  $Res call({double dx, double dy, Map<String, dynamic>? child});
}

/// @nodoc
class _$TransformWidgetCopyWithImpl<$Res, $Val extends TransformWidget>
    implements $TransformWidgetCopyWith<$Res> {
  _$TransformWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
    Object? child = freezed,
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
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransformWidgetImplCopyWith<$Res>
    implements $TransformWidgetCopyWith<$Res> {
  factory _$$TransformWidgetImplCopyWith(_$TransformWidgetImpl value,
          $Res Function(_$TransformWidgetImpl) then) =
      __$$TransformWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double dx, double dy, Map<String, dynamic>? child});
}

/// @nodoc
class __$$TransformWidgetImplCopyWithImpl<$Res>
    extends _$TransformWidgetCopyWithImpl<$Res, _$TransformWidgetImpl>
    implements _$$TransformWidgetImplCopyWith<$Res> {
  __$$TransformWidgetImplCopyWithImpl(
      _$TransformWidgetImpl _value, $Res Function(_$TransformWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dx = null,
    Object? dy = null,
    Object? child = freezed,
  }) {
    return _then(_$TransformWidgetImpl(
      dx: null == dx
          ? _value.dx
          : dx // ignore: cast_nullable_to_non_nullable
              as double,
      dy: null == dy
          ? _value.dy
          : dy // ignore: cast_nullable_to_non_nullable
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
class _$TransformWidgetImpl implements _TransformWidget {
  const _$TransformWidgetImpl(
      {this.dx = 0, this.dy = 0, final Map<String, dynamic>? child})
      : _child = child;

  factory _$TransformWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransformWidgetImplFromJson(json);

  @override
  @JsonKey()
  final double dx;
  @override
  @JsonKey()
  final double dy;
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
    return 'TransformWidget(dx: $dx, dy: $dy, child: $child)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransformWidgetImpl &&
            (identical(other.dx, dx) || other.dx == dx) &&
            (identical(other.dy, dy) || other.dy == dy) &&
            const DeepCollectionEquality().equals(other._child, _child));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, dx, dy, const DeepCollectionEquality().hash(_child));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransformWidgetImplCopyWith<_$TransformWidgetImpl> get copyWith =>
      __$$TransformWidgetImplCopyWithImpl<_$TransformWidgetImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TransformWidget value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TransformWidget value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TransformWidget value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TransformWidgetImplToJson(
      this,
    );
  }
}

abstract class _TransformWidget implements TransformWidget {
  const factory _TransformWidget(
      {final double dx,
      final double dy,
      final Map<String, dynamic>? child}) = _$TransformWidgetImpl;

  factory _TransformWidget.fromJson(Map<String, dynamic> json) =
      _$TransformWidgetImpl.fromJson;

  @override
  double get dx;
  @override
  double get dy;
  @override
  Map<String, dynamic>? get child;
  @override
  @JsonKey(ignore: true)
  _$$TransformWidgetImplCopyWith<_$TransformWidgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
