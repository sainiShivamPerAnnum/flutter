// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_sections.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HomePageSection _$HomePageSectionFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'stories':
      return StoriesSection.fromJson(json);
    case 'steps':
      return StepsSection.fromJson(json);
    case 'infoCards':
      return QuickActions.fromJson(json);
    case 'image':
      return ImageSection.fromJson(json);
    case 'nudgeCard':
      return NudgeSection.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'type', 'HomePageSection',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$HomePageSection {
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StoriesSection value) stories,
    required TResult Function(StepsSection value) steps,
    required TResult Function(QuickActions value) quickActions,
    required TResult Function(ImageSection value) image,
    required TResult Function(NudgeSection value) nudge,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StoriesSection value)? stories,
    TResult? Function(StepsSection value)? steps,
    TResult? Function(QuickActions value)? quickActions,
    TResult? Function(ImageSection value)? image,
    TResult? Function(NudgeSection value)? nudge,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StoriesSection value)? stories,
    TResult Function(StepsSection value)? steps,
    TResult Function(QuickActions value)? quickActions,
    TResult Function(ImageSection value)? image,
    TResult Function(NudgeSection value)? nudge,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageSectionCopyWith<$Res> {
  factory $HomePageSectionCopyWith(
          HomePageSection value, $Res Function(HomePageSection) then) =
      _$HomePageSectionCopyWithImpl<$Res, HomePageSection>;
}

/// @nodoc
class _$HomePageSectionCopyWithImpl<$Res, $Val extends HomePageSection>
    implements $HomePageSectionCopyWith<$Res> {
  _$HomePageSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StoriesSectionImplCopyWith<$Res> {
  factory _$$StoriesSectionImplCopyWith(_$StoriesSectionImpl value,
          $Res Function(_$StoriesSectionImpl) then) =
      __$$StoriesSectionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({StoriesData data});
}

/// @nodoc
class __$$StoriesSectionImplCopyWithImpl<$Res>
    extends _$HomePageSectionCopyWithImpl<$Res, _$StoriesSectionImpl>
    implements _$$StoriesSectionImplCopyWith<$Res> {
  __$$StoriesSectionImplCopyWithImpl(
      _$StoriesSectionImpl _value, $Res Function(_$StoriesSectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$StoriesSectionImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StoriesData,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$StoriesSectionImpl implements StoriesSection {
  const _$StoriesSectionImpl(this.data, {final String? $type})
      : $type = $type ?? 'stories';

  factory _$StoriesSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoriesSectionImplFromJson(json);

  @override
  final StoriesData data;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'HomePageSection.stories(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoriesSectionImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StoriesSectionImplCopyWith<_$StoriesSectionImpl> get copyWith =>
      __$$StoriesSectionImplCopyWithImpl<_$StoriesSectionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StoriesSection value) stories,
    required TResult Function(StepsSection value) steps,
    required TResult Function(QuickActions value) quickActions,
    required TResult Function(ImageSection value) image,
    required TResult Function(NudgeSection value) nudge,
  }) {
    return stories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StoriesSection value)? stories,
    TResult? Function(StepsSection value)? steps,
    TResult? Function(QuickActions value)? quickActions,
    TResult? Function(ImageSection value)? image,
    TResult? Function(NudgeSection value)? nudge,
  }) {
    return stories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StoriesSection value)? stories,
    TResult Function(StepsSection value)? steps,
    TResult Function(QuickActions value)? quickActions,
    TResult Function(ImageSection value)? image,
    TResult Function(NudgeSection value)? nudge,
    required TResult orElse(),
  }) {
    if (stories != null) {
      return stories(this);
    }
    return orElse();
  }
}

abstract class StoriesSection implements HomePageSection {
  const factory StoriesSection(final StoriesData data) = _$StoriesSectionImpl;

  factory StoriesSection.fromJson(Map<String, dynamic> json) =
      _$StoriesSectionImpl.fromJson;

  StoriesData get data;
  @JsonKey(ignore: true)
  _$$StoriesSectionImplCopyWith<_$StoriesSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StepsSectionImplCopyWith<$Res> {
  factory _$$StepsSectionImplCopyWith(
          _$StepsSectionImpl value, $Res Function(_$StepsSectionImpl) then) =
      __$$StepsSectionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({StepsData data});
}

/// @nodoc
class __$$StepsSectionImplCopyWithImpl<$Res>
    extends _$HomePageSectionCopyWithImpl<$Res, _$StepsSectionImpl>
    implements _$$StepsSectionImplCopyWith<$Res> {
  __$$StepsSectionImplCopyWithImpl(
      _$StepsSectionImpl _value, $Res Function(_$StepsSectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$StepsSectionImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as StepsData,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$StepsSectionImpl implements StepsSection {
  const _$StepsSectionImpl(this.data, {final String? $type})
      : $type = $type ?? 'steps';

  factory _$StepsSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StepsSectionImplFromJson(json);

  @override
  final StepsData data;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'HomePageSection.steps(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StepsSectionImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StepsSectionImplCopyWith<_$StepsSectionImpl> get copyWith =>
      __$$StepsSectionImplCopyWithImpl<_$StepsSectionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StoriesSection value) stories,
    required TResult Function(StepsSection value) steps,
    required TResult Function(QuickActions value) quickActions,
    required TResult Function(ImageSection value) image,
    required TResult Function(NudgeSection value) nudge,
  }) {
    return steps(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StoriesSection value)? stories,
    TResult? Function(StepsSection value)? steps,
    TResult? Function(QuickActions value)? quickActions,
    TResult? Function(ImageSection value)? image,
    TResult? Function(NudgeSection value)? nudge,
  }) {
    return steps?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StoriesSection value)? stories,
    TResult Function(StepsSection value)? steps,
    TResult Function(QuickActions value)? quickActions,
    TResult Function(ImageSection value)? image,
    TResult Function(NudgeSection value)? nudge,
    required TResult orElse(),
  }) {
    if (steps != null) {
      return steps(this);
    }
    return orElse();
  }
}

abstract class StepsSection implements HomePageSection {
  const factory StepsSection(final StepsData data) = _$StepsSectionImpl;

  factory StepsSection.fromJson(Map<String, dynamic> json) =
      _$StepsSectionImpl.fromJson;

  StepsData get data;
  @JsonKey(ignore: true)
  _$$StepsSectionImplCopyWith<_$StepsSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QuickActionsImplCopyWith<$Res> {
  factory _$$QuickActionsImplCopyWith(
          _$QuickActionsImpl value, $Res Function(_$QuickActionsImpl) then) =
      __$$QuickActionsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({QuickActionsCardsData data});
}

/// @nodoc
class __$$QuickActionsImplCopyWithImpl<$Res>
    extends _$HomePageSectionCopyWithImpl<$Res, _$QuickActionsImpl>
    implements _$$QuickActionsImplCopyWith<$Res> {
  __$$QuickActionsImplCopyWithImpl(
      _$QuickActionsImpl _value, $Res Function(_$QuickActionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$QuickActionsImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as QuickActionsCardsData,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$QuickActionsImpl implements QuickActions {
  const _$QuickActionsImpl(this.data, {final String? $type})
      : $type = $type ?? 'infoCards';

  factory _$QuickActionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuickActionsImplFromJson(json);

  @override
  final QuickActionsCardsData data;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'HomePageSection.quickActions(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickActionsImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickActionsImplCopyWith<_$QuickActionsImpl> get copyWith =>
      __$$QuickActionsImplCopyWithImpl<_$QuickActionsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StoriesSection value) stories,
    required TResult Function(StepsSection value) steps,
    required TResult Function(QuickActions value) quickActions,
    required TResult Function(ImageSection value) image,
    required TResult Function(NudgeSection value) nudge,
  }) {
    return quickActions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StoriesSection value)? stories,
    TResult? Function(StepsSection value)? steps,
    TResult? Function(QuickActions value)? quickActions,
    TResult? Function(ImageSection value)? image,
    TResult? Function(NudgeSection value)? nudge,
  }) {
    return quickActions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StoriesSection value)? stories,
    TResult Function(StepsSection value)? steps,
    TResult Function(QuickActions value)? quickActions,
    TResult Function(ImageSection value)? image,
    TResult Function(NudgeSection value)? nudge,
    required TResult orElse(),
  }) {
    if (quickActions != null) {
      return quickActions(this);
    }
    return orElse();
  }
}

abstract class QuickActions implements HomePageSection {
  const factory QuickActions(final QuickActionsCardsData data) =
      _$QuickActionsImpl;

  factory QuickActions.fromJson(Map<String, dynamic> json) =
      _$QuickActionsImpl.fromJson;

  QuickActionsCardsData get data;
  @JsonKey(ignore: true)
  _$$QuickActionsImplCopyWith<_$QuickActionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ImageSectionImplCopyWith<$Res> {
  factory _$$ImageSectionImplCopyWith(
          _$ImageSectionImpl value, $Res Function(_$ImageSectionImpl) then) =
      __$$ImageSectionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ImageSectionData data});
}

/// @nodoc
class __$$ImageSectionImplCopyWithImpl<$Res>
    extends _$HomePageSectionCopyWithImpl<$Res, _$ImageSectionImpl>
    implements _$$ImageSectionImplCopyWith<$Res> {
  __$$ImageSectionImplCopyWithImpl(
      _$ImageSectionImpl _value, $Res Function(_$ImageSectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$ImageSectionImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ImageSectionData,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$ImageSectionImpl implements ImageSection {
  const _$ImageSectionImpl(this.data, {final String? $type})
      : $type = $type ?? 'image';

  factory _$ImageSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageSectionImplFromJson(json);

  @override
  final ImageSectionData data;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'HomePageSection.image(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageSectionImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageSectionImplCopyWith<_$ImageSectionImpl> get copyWith =>
      __$$ImageSectionImplCopyWithImpl<_$ImageSectionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StoriesSection value) stories,
    required TResult Function(StepsSection value) steps,
    required TResult Function(QuickActions value) quickActions,
    required TResult Function(ImageSection value) image,
    required TResult Function(NudgeSection value) nudge,
  }) {
    return image(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StoriesSection value)? stories,
    TResult? Function(StepsSection value)? steps,
    TResult? Function(QuickActions value)? quickActions,
    TResult? Function(ImageSection value)? image,
    TResult? Function(NudgeSection value)? nudge,
  }) {
    return image?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StoriesSection value)? stories,
    TResult Function(StepsSection value)? steps,
    TResult Function(QuickActions value)? quickActions,
    TResult Function(ImageSection value)? image,
    TResult Function(NudgeSection value)? nudge,
    required TResult orElse(),
  }) {
    if (image != null) {
      return image(this);
    }
    return orElse();
  }
}

abstract class ImageSection implements HomePageSection {
  const factory ImageSection(final ImageSectionData data) = _$ImageSectionImpl;

  factory ImageSection.fromJson(Map<String, dynamic> json) =
      _$ImageSectionImpl.fromJson;

  ImageSectionData get data;
  @JsonKey(ignore: true)
  _$$ImageSectionImplCopyWith<_$ImageSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NudgeSectionImplCopyWith<$Res> {
  factory _$$NudgeSectionImplCopyWith(
          _$NudgeSectionImpl value, $Res Function(_$NudgeSectionImpl) then) =
      __$$NudgeSectionImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NudgeSectionImplCopyWithImpl<$Res>
    extends _$HomePageSectionCopyWithImpl<$Res, _$NudgeSectionImpl>
    implements _$$NudgeSectionImplCopyWith<$Res> {
  __$$NudgeSectionImplCopyWithImpl(
      _$NudgeSectionImpl _value, $Res Function(_$NudgeSectionImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$NudgeSectionImpl implements NudgeSection {
  const _$NudgeSectionImpl({final String? $type})
      : $type = $type ?? 'nudgeCard';

  factory _$NudgeSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$NudgeSectionImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'HomePageSection.nudge()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NudgeSectionImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StoriesSection value) stories,
    required TResult Function(StepsSection value) steps,
    required TResult Function(QuickActions value) quickActions,
    required TResult Function(ImageSection value) image,
    required TResult Function(NudgeSection value) nudge,
  }) {
    return nudge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StoriesSection value)? stories,
    TResult? Function(StepsSection value)? steps,
    TResult? Function(QuickActions value)? quickActions,
    TResult? Function(ImageSection value)? image,
    TResult? Function(NudgeSection value)? nudge,
  }) {
    return nudge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StoriesSection value)? stories,
    TResult Function(StepsSection value)? steps,
    TResult Function(QuickActions value)? quickActions,
    TResult Function(ImageSection value)? image,
    TResult Function(NudgeSection value)? nudge,
    required TResult orElse(),
  }) {
    if (nudge != null) {
      return nudge(this);
    }
    return orElse();
  }
}

abstract class NudgeSection implements HomePageSection {
  const factory NudgeSection() = _$NudgeSectionImpl;

  factory NudgeSection.fromJson(Map<String, dynamic> json) =
      _$NudgeSectionImpl.fromJson;
}
