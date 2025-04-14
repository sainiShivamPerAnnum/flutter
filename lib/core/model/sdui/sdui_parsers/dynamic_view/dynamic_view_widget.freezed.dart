// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dynamic_view_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DynamicViewWidget _$DynamicViewWidgetFromJson(Map<String, dynamic> json) {
  return _DynamicViewWidget.fromJson(json);
}

/// @nodoc
mixin _$DynamicViewWidget {
  StacNetworkRequest get request => throw _privateConstructorUsedError;
  String get targetPath => throw _privateConstructorUsedError;
  Map<String, dynamic> get template => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DynamicViewWidget value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DynamicViewWidget value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DynamicViewWidget value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DynamicViewWidgetCopyWith<DynamicViewWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DynamicViewWidgetCopyWith<$Res> {
  factory $DynamicViewWidgetCopyWith(
          DynamicViewWidget value, $Res Function(DynamicViewWidget) then) =
      _$DynamicViewWidgetCopyWithImpl<$Res, DynamicViewWidget>;
  @useResult
  $Res call(
      {StacNetworkRequest request,
      String targetPath,
      Map<String, dynamic> template});

  $StacNetworkRequestCopyWith<$Res> get request;
}

/// @nodoc
class _$DynamicViewWidgetCopyWithImpl<$Res, $Val extends DynamicViewWidget>
    implements $DynamicViewWidgetCopyWith<$Res> {
  _$DynamicViewWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? request = null,
    Object? targetPath = null,
    Object? template = null,
  }) {
    return _then(_value.copyWith(
      request: null == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as StacNetworkRequest,
      targetPath: null == targetPath
          ? _value.targetPath
          : targetPath // ignore: cast_nullable_to_non_nullable
              as String,
      template: null == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StacNetworkRequestCopyWith<$Res> get request {
    return $StacNetworkRequestCopyWith<$Res>(_value.request, (value) {
      return _then(_value.copyWith(request: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DynamicViewWidgetImplCopyWith<$Res>
    implements $DynamicViewWidgetCopyWith<$Res> {
  factory _$$DynamicViewWidgetImplCopyWith(_$DynamicViewWidgetImpl value,
          $Res Function(_$DynamicViewWidgetImpl) then) =
      __$$DynamicViewWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StacNetworkRequest request,
      String targetPath,
      Map<String, dynamic> template});

  @override
  $StacNetworkRequestCopyWith<$Res> get request;
}

/// @nodoc
class __$$DynamicViewWidgetImplCopyWithImpl<$Res>
    extends _$DynamicViewWidgetCopyWithImpl<$Res, _$DynamicViewWidgetImpl>
    implements _$$DynamicViewWidgetImplCopyWith<$Res> {
  __$$DynamicViewWidgetImplCopyWithImpl(_$DynamicViewWidgetImpl _value,
      $Res Function(_$DynamicViewWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? request = null,
    Object? targetPath = null,
    Object? template = null,
  }) {
    return _then(_$DynamicViewWidgetImpl(
      request: null == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as StacNetworkRequest,
      targetPath: null == targetPath
          ? _value.targetPath
          : targetPath // ignore: cast_nullable_to_non_nullable
              as String,
      template: null == template
          ? _value._template
          : template // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DynamicViewWidgetImpl implements _DynamicViewWidget {
  const _$DynamicViewWidgetImpl(
      {required this.request,
      this.targetPath = '',
      required final Map<String, dynamic> template})
      : _template = template;

  factory _$DynamicViewWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$DynamicViewWidgetImplFromJson(json);

  @override
  final StacNetworkRequest request;
  @override
  @JsonKey()
  final String targetPath;
  final Map<String, dynamic> _template;
  @override
  Map<String, dynamic> get template {
    if (_template is EqualUnmodifiableMapView) return _template;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_template);
  }

  @override
  String toString() {
    return 'DynamicViewWidget(request: $request, targetPath: $targetPath, template: $template)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DynamicViewWidgetImpl &&
            (identical(other.request, request) || other.request == request) &&
            (identical(other.targetPath, targetPath) ||
                other.targetPath == targetPath) &&
            const DeepCollectionEquality().equals(other._template, _template));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, request, targetPath,
      const DeepCollectionEquality().hash(_template));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DynamicViewWidgetImplCopyWith<_$DynamicViewWidgetImpl> get copyWith =>
      __$$DynamicViewWidgetImplCopyWithImpl<_$DynamicViewWidgetImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DynamicViewWidget value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DynamicViewWidget value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DynamicViewWidget value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DynamicViewWidgetImplToJson(
      this,
    );
  }
}

abstract class _DynamicViewWidget implements DynamicViewWidget {
  const factory _DynamicViewWidget(
      {required final StacNetworkRequest request,
      final String targetPath,
      required final Map<String, dynamic> template}) = _$DynamicViewWidgetImpl;

  factory _DynamicViewWidget.fromJson(Map<String, dynamic> json) =
      _$DynamicViewWidgetImpl.fromJson;

  @override
  StacNetworkRequest get request;
  @override
  String get targetPath;
  @override
  Map<String, dynamic> get template;
  @override
  @JsonKey(ignore: true)
  _$$DynamicViewWidgetImplCopyWith<_$DynamicViewWidgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
