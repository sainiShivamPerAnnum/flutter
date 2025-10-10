// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spacer_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpacerWidget _$SpacerWidgetFromJson(Map<String, dynamic> json) {
  return _SpacerWidget.fromJson(json);
}

/// @nodoc
mixin _$SpacerWidget {
  int get flex => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpacerWidget value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpacerWidget value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpacerWidget value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpacerWidgetCopyWith<SpacerWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpacerWidgetCopyWith<$Res> {
  factory $SpacerWidgetCopyWith(
          SpacerWidget value, $Res Function(SpacerWidget) then) =
      _$SpacerWidgetCopyWithImpl<$Res, SpacerWidget>;
  @useResult
  $Res call({int flex});
}

/// @nodoc
class _$SpacerWidgetCopyWithImpl<$Res, $Val extends SpacerWidget>
    implements $SpacerWidgetCopyWith<$Res> {
  _$SpacerWidgetCopyWithImpl(this._value, this._then);

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
abstract class _$$SpacerWidgetImplCopyWith<$Res>
    implements $SpacerWidgetCopyWith<$Res> {
  factory _$$SpacerWidgetImplCopyWith(
          _$SpacerWidgetImpl value, $Res Function(_$SpacerWidgetImpl) then) =
      __$$SpacerWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int flex});
}

/// @nodoc
class __$$SpacerWidgetImplCopyWithImpl<$Res>
    extends _$SpacerWidgetCopyWithImpl<$Res, _$SpacerWidgetImpl>
    implements _$$SpacerWidgetImplCopyWith<$Res> {
  __$$SpacerWidgetImplCopyWithImpl(
      _$SpacerWidgetImpl _value, $Res Function(_$SpacerWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flex = null,
  }) {
    return _then(_$SpacerWidgetImpl(
      flex: null == flex
          ? _value.flex
          : flex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpacerWidgetImpl implements _SpacerWidget {
  const _$SpacerWidgetImpl({this.flex = 1});

  factory _$SpacerWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpacerWidgetImplFromJson(json);

  @override
  @JsonKey()
  final int flex;

  @override
  String toString() {
    return 'SpacerWidget(flex: $flex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpacerWidgetImpl &&
            (identical(other.flex, flex) || other.flex == flex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, flex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpacerWidgetImplCopyWith<_$SpacerWidgetImpl> get copyWith =>
      __$$SpacerWidgetImplCopyWithImpl<_$SpacerWidgetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpacerWidget value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpacerWidget value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpacerWidget value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpacerWidgetImplToJson(
      this,
    );
  }
}

abstract class _SpacerWidget implements SpacerWidget {
  const factory _SpacerWidget({final int flex}) = _$SpacerWidgetImpl;

  factory _SpacerWidget.fromJson(Map<String, dynamic> json) =
      _$SpacerWidgetImpl.fromJson;

  @override
  int get flex;
  @override
  @JsonKey(ignore: true)
  _$$SpacerWidgetImplCopyWith<_$SpacerWidgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
