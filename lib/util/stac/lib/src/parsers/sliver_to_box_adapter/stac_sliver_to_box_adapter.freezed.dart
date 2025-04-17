// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_sliver_to_box_adapter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacSliverToBoxAdapter _$StacSliverToBoxAdapterFromJson(
    Map<String, dynamic> json) {
  return _StacSliverToBoxAdapter.fromJson(json);
}

/// @nodoc
mixin _$StacSliverToBoxAdapter {
  Map<String, dynamic>? get child => throw _privateConstructorUsedError;
  String? get key => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacSliverToBoxAdapter value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacSliverToBoxAdapter value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacSliverToBoxAdapter value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacSliverToBoxAdapterCopyWith<StacSliverToBoxAdapter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacSliverToBoxAdapterCopyWith<$Res> {
  factory $StacSliverToBoxAdapterCopyWith(StacSliverToBoxAdapter value,
          $Res Function(StacSliverToBoxAdapter) then) =
      _$StacSliverToBoxAdapterCopyWithImpl<$Res, StacSliverToBoxAdapter>;
  @useResult
  $Res call({Map<String, dynamic>? child, String? key});
}

/// @nodoc
class _$StacSliverToBoxAdapterCopyWithImpl<$Res,
        $Val extends StacSliverToBoxAdapter>
    implements $StacSliverToBoxAdapterCopyWith<$Res> {
  _$StacSliverToBoxAdapterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? child = freezed,
    Object? key = freezed,
  }) {
    return _then(_value.copyWith(
      child: freezed == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StacSliverToBoxAdapterImplCopyWith<$Res>
    implements $StacSliverToBoxAdapterCopyWith<$Res> {
  factory _$$StacSliverToBoxAdapterImplCopyWith(
          _$StacSliverToBoxAdapterImpl value,
          $Res Function(_$StacSliverToBoxAdapterImpl) then) =
      __$$StacSliverToBoxAdapterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, dynamic>? child, String? key});
}

/// @nodoc
class __$$StacSliverToBoxAdapterImplCopyWithImpl<$Res>
    extends _$StacSliverToBoxAdapterCopyWithImpl<$Res,
        _$StacSliverToBoxAdapterImpl>
    implements _$$StacSliverToBoxAdapterImplCopyWith<$Res> {
  __$$StacSliverToBoxAdapterImplCopyWithImpl(
      _$StacSliverToBoxAdapterImpl _value,
      $Res Function(_$StacSliverToBoxAdapterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? child = freezed,
    Object? key = freezed,
  }) {
    return _then(_$StacSliverToBoxAdapterImpl(
      child: freezed == child
          ? _value._child
          : child // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacSliverToBoxAdapterImpl implements _StacSliverToBoxAdapter {
  const _$StacSliverToBoxAdapterImpl(
      {final Map<String, dynamic>? child, this.key})
      : _child = child;

  factory _$StacSliverToBoxAdapterImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacSliverToBoxAdapterImplFromJson(json);

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
  final String? key;

  @override
  String toString() {
    return 'StacSliverToBoxAdapter(child: $child, key: $key)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacSliverToBoxAdapterImpl &&
            const DeepCollectionEquality().equals(other._child, _child) &&
            (identical(other.key, key) || other.key == key));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_child), key);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacSliverToBoxAdapterImplCopyWith<_$StacSliverToBoxAdapterImpl>
      get copyWith => __$$StacSliverToBoxAdapterImplCopyWithImpl<
          _$StacSliverToBoxAdapterImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacSliverToBoxAdapter value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacSliverToBoxAdapter value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacSliverToBoxAdapter value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacSliverToBoxAdapterImplToJson(
      this,
    );
  }
}

abstract class _StacSliverToBoxAdapter implements StacSliverToBoxAdapter {
  const factory _StacSliverToBoxAdapter(
      {final Map<String, dynamic>? child,
      final String? key}) = _$StacSliverToBoxAdapterImpl;

  factory _StacSliverToBoxAdapter.fromJson(Map<String, dynamic> json) =
      _$StacSliverToBoxAdapterImpl.fromJson;

  @override
  Map<String, dynamic>? get child;
  @override
  String? get key;
  @override
  @JsonKey(ignore: true)
  _$$StacSliverToBoxAdapterImplCopyWith<_$StacSliverToBoxAdapterImpl>
      get copyWith => throw _privateConstructorUsedError;
}
