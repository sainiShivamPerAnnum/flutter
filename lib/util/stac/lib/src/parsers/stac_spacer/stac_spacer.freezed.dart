// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_spacer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacSpacer _$StacSpacerFromJson(Map<String, dynamic> json) {
  return _StacSpacer.fromJson(json);
}

/// @nodoc
mixin _$StacSpacer {
  int get flex => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacSpacer value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacSpacer value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacSpacer value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacSpacerCopyWith<StacSpacer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacSpacerCopyWith<$Res> {
  factory $StacSpacerCopyWith(
          StacSpacer value, $Res Function(StacSpacer) then) =
      _$StacSpacerCopyWithImpl<$Res, StacSpacer>;
  @useResult
  $Res call({int flex});
}

/// @nodoc
class _$StacSpacerCopyWithImpl<$Res, $Val extends StacSpacer>
    implements $StacSpacerCopyWith<$Res> {
  _$StacSpacerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flex = null,
  }) {
    return _then(_value.copyWith(
      flex: null == flex
          ? _value.flex
          : flex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StacSpacerImplCopyWith<$Res>
    implements $StacSpacerCopyWith<$Res> {
  factory _$$StacSpacerImplCopyWith(
          _$StacSpacerImpl value, $Res Function(_$StacSpacerImpl) then) =
      __$$StacSpacerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int flex});
}

/// @nodoc
class __$$StacSpacerImplCopyWithImpl<$Res>
    extends _$StacSpacerCopyWithImpl<$Res, _$StacSpacerImpl>
    implements _$$StacSpacerImplCopyWith<$Res> {
  __$$StacSpacerImplCopyWithImpl(
      _$StacSpacerImpl _value, $Res Function(_$StacSpacerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flex = null,
  }) {
    return _then(_$StacSpacerImpl(
      flex: null == flex
          ? _value.flex
          : flex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacSpacerImpl implements _StacSpacer {
  const _$StacSpacerImpl({this.flex = 1});

  factory _$StacSpacerImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacSpacerImplFromJson(json);

  @override
  @JsonKey()
  final int flex;

  @override
  String toString() {
    return 'StacSpacer(flex: $flex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacSpacerImpl &&
            (identical(other.flex, flex) || other.flex == flex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, flex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacSpacerImplCopyWith<_$StacSpacerImpl> get copyWith =>
      __$$StacSpacerImplCopyWithImpl<_$StacSpacerImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacSpacer value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacSpacer value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacSpacer value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacSpacerImplToJson(
      this,
    );
  }
}

abstract class _StacSpacer implements StacSpacer {
  const factory _StacSpacer({final int flex}) = _$StacSpacerImpl;

  factory _StacSpacer.fromJson(Map<String, dynamic> json) =
      _$StacSpacerImpl.fromJson;

  @override
  int get flex;
  @override
  @JsonKey(ignore: true)
  _$$StacSpacerImplCopyWith<_$StacSpacerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
