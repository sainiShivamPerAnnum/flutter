// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gesture_detector_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GestureDetectorWidget _$GestureDetectorWidgetFromJson(
    Map<String, dynamic> json) {
  return _GestureDetectorWidget.fromJson(json);
}

/// @nodoc
mixin _$GestureDetectorWidget {
  Map<String, dynamic>? get onTap => throw _privateConstructorUsedError;
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GestureDetectorWidget value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GestureDetectorWidget value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GestureDetectorWidget value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GestureDetectorWidgetCopyWith<GestureDetectorWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GestureDetectorWidgetCopyWith<$Res> {
  factory $GestureDetectorWidgetCopyWith(GestureDetectorWidget value,
          $Res Function(GestureDetectorWidget) then) =
      _$GestureDetectorWidgetCopyWithImpl<$Res, GestureDetectorWidget>;
  @useResult
  $Res call({Map<String, dynamic>? onTap, Map<String, dynamic>? child});
}

/// @nodoc
class _$GestureDetectorWidgetCopyWithImpl<$Res,
        $Val extends GestureDetectorWidget>
    implements $GestureDetectorWidgetCopyWith<$Res> {
  _$GestureDetectorWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onTap = freezed,
    Object? child = freezed,
  }) {
    return _then(_value.copyWith(
      onTap: freezed == onTap
          ? _value.onTap
          : onTap // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GestureDetectorWidgetImplCopyWith<$Res>
    implements $GestureDetectorWidgetCopyWith<$Res> {
  factory _$$GestureDetectorWidgetImplCopyWith(
          _$GestureDetectorWidgetImpl value,
          $Res Function(_$GestureDetectorWidgetImpl) then) =
      __$$GestureDetectorWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, dynamic>? onTap, Map<String, dynamic>? child});
}

/// @nodoc
class __$$GestureDetectorWidgetImplCopyWithImpl<$Res>
    extends _$GestureDetectorWidgetCopyWithImpl<$Res,
        _$GestureDetectorWidgetImpl>
    implements _$$GestureDetectorWidgetImplCopyWith<$Res> {
  __$$GestureDetectorWidgetImplCopyWithImpl(_$GestureDetectorWidgetImpl _value,
      $Res Function(_$GestureDetectorWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onTap = freezed,
    Object? child = freezed,
  }) {
    return _then(_$GestureDetectorWidgetImpl(
      onTap: freezed == onTap
          ? _value._onTap
          : onTap // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GestureDetectorWidgetImpl implements _GestureDetectorWidget {
  const _$GestureDetectorWidgetImpl(
      {final Map<String, dynamic>? onTap, final Map<String, dynamic>? child})
      : _onTap = onTap,
        _child = child;

  factory _$GestureDetectorWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$GestureDetectorWidgetImplFromJson(json);

  final Map<String, dynamic>? _onTap;
  @override
  Map<String, dynamic>? get onTap {
    final value = _onTap;
    if (value == null) return null;
    if (_onTap is EqualUnmodifiableMapView) return _onTap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

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
    return 'GestureDetectorWidget(onTap: $onTap, child: $child)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GestureDetectorWidgetImpl &&
            const DeepCollectionEquality().equals(other._onTap, _onTap) &&
            const DeepCollectionEquality().equals(other._child, _child));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_onTap),
      const DeepCollectionEquality().hash(_child));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GestureDetectorWidgetImplCopyWith<_$GestureDetectorWidgetImpl>
      get copyWith => __$$GestureDetectorWidgetImplCopyWithImpl<
          _$GestureDetectorWidgetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GestureDetectorWidget value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GestureDetectorWidget value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GestureDetectorWidget value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GestureDetectorWidgetImplToJson(
      this,
    );
  }
}

abstract class _GestureDetectorWidget implements GestureDetectorWidget {
  const factory _GestureDetectorWidget(
      {final Map<String, dynamic>? onTap,
      final Map<String, dynamic>? child}) = _$GestureDetectorWidgetImpl;

  factory _GestureDetectorWidget.fromJson(Map<String, dynamic> json) =
      _$GestureDetectorWidgetImpl.fromJson;

  @override
  Map<String, dynamic>? get onTap;
  @override
  Map<String, dynamic>? get child;
  @override
  @JsonKey(ignore: true)
  _$$GestureDetectorWidgetImplCopyWith<_$GestureDetectorWidgetImpl>
      get copyWith => throw _privateConstructorUsedError;
}
