// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_flexible_spacebar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StacFlexibleSpaceBar _$StacFlexibleSpaceBarFromJson(Map<String, dynamic> json) {
  return _StacFlexibleSpaceBar.fromJson(json);
}

/// @nodoc
mixin _$StacFlexibleSpaceBar {
  String? get title => throw _privateConstructorUsedError;
  Map<String, dynamic>? get background => throw _privateConstructorUsedError;
  CollapseMode get collapseMode => throw _privateConstructorUsedError;
  bool get centerTitle => throw _privateConstructorUsedError;
  List<StretchMode> get stretchModes => throw _privateConstructorUsedError;
  StacEdgeInsets? get titlePadding => throw _privateConstructorUsedError;
  bool get expandedTitleScale => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacFlexibleSpaceBar value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacFlexibleSpaceBar value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacFlexibleSpaceBar value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StacFlexibleSpaceBarCopyWith<StacFlexibleSpaceBar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StacFlexibleSpaceBarCopyWith<$Res> {
  factory $StacFlexibleSpaceBarCopyWith(StacFlexibleSpaceBar value,
          $Res Function(StacFlexibleSpaceBar) then) =
      _$StacFlexibleSpaceBarCopyWithImpl<$Res, StacFlexibleSpaceBar>;
  @useResult
  $Res call(
      {String? title,
      Map<String, dynamic>? background,
      CollapseMode collapseMode,
      bool centerTitle,
      List<StretchMode> stretchModes,
      StacEdgeInsets? titlePadding,
      bool expandedTitleScale});

  $StacEdgeInsetsCopyWith<$Res>? get titlePadding;
}

/// @nodoc
class _$StacFlexibleSpaceBarCopyWithImpl<$Res,
        $Val extends StacFlexibleSpaceBar>
    implements $StacFlexibleSpaceBarCopyWith<$Res> {
  _$StacFlexibleSpaceBarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? background = freezed,
    Object? collapseMode = null,
    Object? centerTitle = null,
    Object? stretchModes = null,
    Object? titlePadding = freezed,
    Object? expandedTitleScale = null,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      background: freezed == background
          ? _value.background
          : background // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      collapseMode: null == collapseMode
          ? _value.collapseMode
          : collapseMode // ignore: cast_nullable_to_non_nullable
              as CollapseMode,
      centerTitle: null == centerTitle
          ? _value.centerTitle
          : centerTitle // ignore: cast_nullable_to_non_nullable
              as bool,
      stretchModes: null == stretchModes
          ? _value.stretchModes
          : stretchModes // ignore: cast_nullable_to_non_nullable
              as List<StretchMode>,
      titlePadding: freezed == titlePadding
          ? _value.titlePadding
          : titlePadding // ignore: cast_nullable_to_non_nullable
              as StacEdgeInsets?,
      expandedTitleScale: null == expandedTitleScale
          ? _value.expandedTitleScale
          : expandedTitleScale // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StacEdgeInsetsCopyWith<$Res>? get titlePadding {
    if (_value.titlePadding == null) {
      return null;
    }

    return $StacEdgeInsetsCopyWith<$Res>(_value.titlePadding!, (value) {
      return _then(_value.copyWith(titlePadding: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StacFlexibleSpaceBarImplCopyWith<$Res>
    implements $StacFlexibleSpaceBarCopyWith<$Res> {
  factory _$$StacFlexibleSpaceBarImplCopyWith(_$StacFlexibleSpaceBarImpl value,
          $Res Function(_$StacFlexibleSpaceBarImpl) then) =
      __$$StacFlexibleSpaceBarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      Map<String, dynamic>? background,
      CollapseMode collapseMode,
      bool centerTitle,
      List<StretchMode> stretchModes,
      StacEdgeInsets? titlePadding,
      bool expandedTitleScale});

  @override
  $StacEdgeInsetsCopyWith<$Res>? get titlePadding;
}

/// @nodoc
class __$$StacFlexibleSpaceBarImplCopyWithImpl<$Res>
    extends _$StacFlexibleSpaceBarCopyWithImpl<$Res, _$StacFlexibleSpaceBarImpl>
    implements _$$StacFlexibleSpaceBarImplCopyWith<$Res> {
  __$$StacFlexibleSpaceBarImplCopyWithImpl(_$StacFlexibleSpaceBarImpl _value,
      $Res Function(_$StacFlexibleSpaceBarImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? background = freezed,
    Object? collapseMode = null,
    Object? centerTitle = null,
    Object? stretchModes = null,
    Object? titlePadding = freezed,
    Object? expandedTitleScale = null,
  }) {
    return _then(_$StacFlexibleSpaceBarImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      background: freezed == background
          ? _value._background
          : background // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      collapseMode: null == collapseMode
          ? _value.collapseMode
          : collapseMode // ignore: cast_nullable_to_non_nullable
              as CollapseMode,
      centerTitle: null == centerTitle
          ? _value.centerTitle
          : centerTitle // ignore: cast_nullable_to_non_nullable
              as bool,
      stretchModes: null == stretchModes
          ? _value._stretchModes
          : stretchModes // ignore: cast_nullable_to_non_nullable
              as List<StretchMode>,
      titlePadding: freezed == titlePadding
          ? _value.titlePadding
          : titlePadding // ignore: cast_nullable_to_non_nullable
              as StacEdgeInsets?,
      expandedTitleScale: null == expandedTitleScale
          ? _value.expandedTitleScale
          : expandedTitleScale // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StacFlexibleSpaceBarImpl implements _StacFlexibleSpaceBar {
  const _$StacFlexibleSpaceBarImpl(
      {this.title,
      final Map<String, dynamic>? background,
      this.collapseMode = CollapseMode.parallax,
      this.centerTitle = true,
      final List<StretchMode> stretchModes = const [StretchMode.zoomBackground],
      this.titlePadding,
      this.expandedTitleScale = false})
      : _background = background,
        _stretchModes = stretchModes;

  factory _$StacFlexibleSpaceBarImpl.fromJson(Map<String, dynamic> json) =>
      _$$StacFlexibleSpaceBarImplFromJson(json);

  @override
  final String? title;
  final Map<String, dynamic>? _background;
  @override
  Map<String, dynamic>? get background {
    final value = _background;
    if (value == null) return null;
    if (_background is EqualUnmodifiableMapView) return _background;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final CollapseMode collapseMode;
  @override
  @JsonKey()
  final bool centerTitle;
  final List<StretchMode> _stretchModes;
  @override
  @JsonKey()
  List<StretchMode> get stretchModes {
    if (_stretchModes is EqualUnmodifiableListView) return _stretchModes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stretchModes);
  }

  @override
  final StacEdgeInsets? titlePadding;
  @override
  @JsonKey()
  final bool expandedTitleScale;

  @override
  String toString() {
    return 'StacFlexibleSpaceBar(title: $title, background: $background, collapseMode: $collapseMode, centerTitle: $centerTitle, stretchModes: $stretchModes, titlePadding: $titlePadding, expandedTitleScale: $expandedTitleScale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StacFlexibleSpaceBarImpl &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other._background, _background) &&
            (identical(other.collapseMode, collapseMode) ||
                other.collapseMode == collapseMode) &&
            (identical(other.centerTitle, centerTitle) ||
                other.centerTitle == centerTitle) &&
            const DeepCollectionEquality()
                .equals(other._stretchModes, _stretchModes) &&
            (identical(other.titlePadding, titlePadding) ||
                other.titlePadding == titlePadding) &&
            (identical(other.expandedTitleScale, expandedTitleScale) ||
                other.expandedTitleScale == expandedTitleScale));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      const DeepCollectionEquality().hash(_background),
      collapseMode,
      centerTitle,
      const DeepCollectionEquality().hash(_stretchModes),
      titlePadding,
      expandedTitleScale);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StacFlexibleSpaceBarImplCopyWith<_$StacFlexibleSpaceBarImpl>
      get copyWith =>
          __$$StacFlexibleSpaceBarImplCopyWithImpl<_$StacFlexibleSpaceBarImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StacFlexibleSpaceBar value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StacFlexibleSpaceBar value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StacFlexibleSpaceBar value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StacFlexibleSpaceBarImplToJson(
      this,
    );
  }
}

abstract class _StacFlexibleSpaceBar implements StacFlexibleSpaceBar {
  const factory _StacFlexibleSpaceBar(
      {final String? title,
      final Map<String, dynamic>? background,
      final CollapseMode collapseMode,
      final bool centerTitle,
      final List<StretchMode> stretchModes,
      final StacEdgeInsets? titlePadding,
      final bool expandedTitleScale}) = _$StacFlexibleSpaceBarImpl;

  factory _StacFlexibleSpaceBar.fromJson(Map<String, dynamic> json) =
      _$StacFlexibleSpaceBarImpl.fromJson;

  @override
  String? get title;
  @override
  Map<String, dynamic>? get background;
  @override
  CollapseMode get collapseMode;
  @override
  bool get centerTitle;
  @override
  List<StretchMode> get stretchModes;
  @override
  StacEdgeInsets? get titlePadding;
  @override
  bool get expandedTitleScale;
  @override
  @JsonKey(ignore: true)
  _$$StacFlexibleSpaceBarImplCopyWith<_$StacFlexibleSpaceBarImpl>
      get copyWith => throw _privateConstructorUsedError;
}
