// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_auto_complete.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacAutoComplete _$StacAutoCompleteFromJson(Map<String, dynamic> json) {
  return _StacAutoComplete.fromJson(json);
}

/// @nodoc
mixin _$StacAutoComplete {
  List<String> get options => throw _privateConstructorUsedError;
  Map<String, dynamic>? get onSelected => throw _privateConstructorUsedError;
  double get optionsMaxHeight => throw _privateConstructorUsedError;
  OptionsViewOpenDirection get optionsViewOpenDirection =>
      throw _privateConstructorUsedError;
  String? get initialValue => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacAutoComplete value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacAutoComplete value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacAutoComplete value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacAutoCompleteCopyWith<StacAutoComplete> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacAutoCompleteCopyWith<$Res> {
  factory $StacAutoCompleteCopyWith(
          StacAutoComplete value, $Res Function(StacAutoComplete) then) =
      _$StacAutoCompleteCopyWithImpl<$Res, StacAutoComplete>;
  @useResult
  $Res call(
      {List<String> options,
      Map<String, dynamic>? onSelected,
      double optionsMaxHeight,
      OptionsViewOpenDirection optionsViewOpenDirection,
      String? initialValue});
}

/// @nodoc
class _$StacAutoCompleteCopyWithImpl<$Res, $Val extends StacAutoComplete>
    implements $StacAutoCompleteCopyWith<$Res> {
  _$StacAutoCompleteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
    Object? onSelected = freezed,
    Object? optionsMaxHeight = null,
    Object? optionsViewOpenDirection = null,
    Object? initialValue = freezed,
  }) {
    return _then(_value.copyWith(
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      onSelected: freezed == onSelected
          ? _value.onSelected
          : onSelected // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      optionsMaxHeight: null == optionsMaxHeight
          ? _value.optionsMaxHeight
          : optionsMaxHeight // ignore: cast_nullable_to_non_nullable
              as double,
      optionsViewOpenDirection: null == optionsViewOpenDirection
          ? _value.optionsViewOpenDirection
          : optionsViewOpenDirection // ignore: cast_nullable_to_non_nullable
              as OptionsViewOpenDirection,
      initialValue: freezed == initialValue
          ? _value.initialValue
          : initialValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StacAutoCompleteImplCopyWith<$Res>
    implements $StacAutoCompleteCopyWith<$Res> {
  factory _$$StacAutoCompleteImplCopyWith(_$StacAutoCompleteImpl value,
          $Res Function(_$StacAutoCompleteImpl) then) =
      __$$StacAutoCompleteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> options,
      Map<String, dynamic>? onSelected,
      double optionsMaxHeight,
      OptionsViewOpenDirection optionsViewOpenDirection,
      String? initialValue});
}

/// @nodoc
class __$$StacAutoCompleteImplCopyWithImpl<$Res>
    extends _$StacAutoCompleteCopyWithImpl<$Res, _$StacAutoCompleteImpl>
    implements _$$StacAutoCompleteImplCopyWith<$Res> {
  __$$StacAutoCompleteImplCopyWithImpl(_$StacAutoCompleteImpl _value,
      $Res Function(_$StacAutoCompleteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
    Object? onSelected = freezed,
    Object? optionsMaxHeight = null,
    Object? optionsViewOpenDirection = null,
    Object? initialValue = freezed,
  }) {
    return _then(_$StacAutoCompleteImpl(
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      onSelected: freezed == onSelected
          ? _value._onSelected
          : onSelected // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      optionsMaxHeight: null == optionsMaxHeight
          ? _value.optionsMaxHeight
          : optionsMaxHeight // ignore: cast_nullable_to_non_nullable
              as double,
      optionsViewOpenDirection: null == optionsViewOpenDirection
          ? _value.optionsViewOpenDirection
          : optionsViewOpenDirection // ignore: cast_nullable_to_non_nullable
              as OptionsViewOpenDirection,
      initialValue: freezed == initialValue
          ? _value.initialValue
          : initialValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacAutoCompleteImpl implements _StacAutoComplete {
  const _$StacAutoCompleteImpl(
      {required final List<String> options,
      final Map<String, dynamic>? onSelected,
      this.optionsMaxHeight = 200,
      this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
      this.initialValue})
      : _options = options,
        _onSelected = onSelected;

  factory _$StacAutoCompleteImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacAutoCompleteImplFromJson(json);

  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  final Map<String, dynamic>? _onSelected;
  @override
  Map<String, dynamic>? get onSelected {
    final value = _onSelected;
    if (value == null) return null;
    if (_onSelected is EqualUnmodifiableMapView) return _onSelected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final double optionsMaxHeight;
  @override
  @JsonKey()
  final OptionsViewOpenDirection optionsViewOpenDirection;
  @override
  final String? initialValue;

  @override
  String toString() {
    return 'StacAutoComplete(options: $options, onSelected: $onSelected, optionsMaxHeight: $optionsMaxHeight, optionsViewOpenDirection: $optionsViewOpenDirection, initialValue: $initialValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacAutoCompleteImpl &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality()
                .equals(other._onSelected, _onSelected) &&
            (identical(other.optionsMaxHeight, optionsMaxHeight) ||
                other.optionsMaxHeight == optionsMaxHeight) &&
            (identical(
                    other.optionsViewOpenDirection, optionsViewOpenDirection) ||
                other.optionsViewOpenDirection == optionsViewOpenDirection) &&
            (identical(other.initialValue, initialValue) ||
                other.initialValue == initialValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_options),
      const DeepCollectionEquality().hash(_onSelected),
      optionsMaxHeight,
      optionsViewOpenDirection,
      initialValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacAutoCompleteImplCopyWith<_$StacAutoCompleteImpl> get copyWith =>
      __$$StacAutoCompleteImplCopyWithImpl<_$StacAutoCompleteImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacAutoComplete value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacAutoComplete value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacAutoComplete value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacAutoCompleteImplToJson(
      this,
    );
  }
}

abstract class _StacAutoComplete implements StacAutoComplete {
  const factory _StacAutoComplete(
      {required final List<String> options,
      final Map<String, dynamic>? onSelected,
      final double optionsMaxHeight,
      final OptionsViewOpenDirection optionsViewOpenDirection,
      final String? initialValue}) = _$StacAutoCompleteImpl;

  factory _StacAutoComplete.fromJson(Map<String, dynamic> json) =
      _$StacAutoCompleteImpl.fromJson;

  @override
  List<String> get options;
  @override
  Map<String, dynamic>? get onSelected;
  @override
  double get optionsMaxHeight;
  @override
  OptionsViewOpenDirection get optionsViewOpenDirection;
  @override
  String? get initialValue;
  @override
  @JsonKey(ignore: true)
  _$$StacAutoCompleteImplCopyWith<_$StacAutoCompleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
