// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_form_validator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacFormFieldValidator _$StacFormFieldValidatorFromJson(
    Map<String, dynamic> json) {
  return _StacFormFieldValidator.fromJson(json);
}

/// @nodoc
mixin _$StacFormFieldValidator {
  String get rule => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacFormFieldValidator value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacFormFieldValidator value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacFormFieldValidator value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacFormFieldValidatorCopyWith<StacFormFieldValidator> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacFormFieldValidatorCopyWith<$Res> {
  factory $StacFormFieldValidatorCopyWith(StacFormFieldValidator value,
          $Res Function(StacFormFieldValidator) then) =
      _$StacFormFieldValidatorCopyWithImpl<$Res, StacFormFieldValidator>;
  @useResult
  $Res call({String rule, String? message});
}

/// @nodoc
class _$StacFormFieldValidatorCopyWithImpl<$Res,
        $Val extends StacFormFieldValidator>
    implements $StacFormFieldValidatorCopyWith<$Res> {
  _$StacFormFieldValidatorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rule = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      rule: null == rule
          ? _value.rule
          : rule // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StacFormFieldValidatorImplCopyWith<$Res>
    implements $StacFormFieldValidatorCopyWith<$Res> {
  factory _$$StacFormFieldValidatorImplCopyWith(
          _$StacFormFieldValidatorImpl value,
          $Res Function(_$StacFormFieldValidatorImpl) then) =
      __$$StacFormFieldValidatorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String rule, String? message});
}

/// @nodoc
class __$$StacFormFieldValidatorImplCopyWithImpl<$Res>
    extends _$StacFormFieldValidatorCopyWithImpl<$Res,
        _$StacFormFieldValidatorImpl>
    implements _$$StacFormFieldValidatorImplCopyWith<$Res> {
  __$$StacFormFieldValidatorImplCopyWithImpl(
      _$StacFormFieldValidatorImpl _value,
      $Res Function(_$StacFormFieldValidatorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rule = null,
    Object? message = freezed,
  }) {
    return _then(_$StacFormFieldValidatorImpl(
      rule: null == rule
          ? _value.rule
          : rule // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacFormFieldValidatorImpl implements _StacFormFieldValidator {
  const _$StacFormFieldValidatorImpl({required this.rule, this.message});

  factory _$StacFormFieldValidatorImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacFormFieldValidatorImplFromJson(json);

  @override
  final String rule;
  @override
  final String? message;

  @override
  String toString() {
    return 'StacFormFieldValidator(rule: $rule, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacFormFieldValidatorImpl &&
            (identical(other.rule, rule) || other.rule == rule) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, rule, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacFormFieldValidatorImplCopyWith<_$StacFormFieldValidatorImpl>
      get copyWith => __$$StacFormFieldValidatorImplCopyWithImpl<
          _$StacFormFieldValidatorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacFormFieldValidator value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacFormFieldValidator value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacFormFieldValidator value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacFormFieldValidatorImplToJson(
      this,
    );
  }
}

abstract class _StacFormFieldValidator implements StacFormFieldValidator {
  const factory _StacFormFieldValidator(
      {required final String rule,
      final String? message}) = _$StacFormFieldValidatorImpl;

  factory _StacFormFieldValidator.fromJson(Map<String, dynamic> json) =
      _$StacFormFieldValidatorImpl.fromJson;

  @override
  String get rule;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$StacFormFieldValidatorImplCopyWith<_$StacFormFieldValidatorImpl>
      get copyWith => throw _privateConstructorUsedError;
}
