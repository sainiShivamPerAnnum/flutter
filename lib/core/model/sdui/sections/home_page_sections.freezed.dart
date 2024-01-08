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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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

    default:
      throw CheckedFromJsonException(json, 'type', 'HomePageSection',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$HomePageSection {
  Object get data => throw _privateConstructorUsedError;
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
}

abstract class StoriesSection implements HomePageSection {
  const factory StoriesSection(final StoriesData data) = _$StoriesSectionImpl;

  factory StoriesSection.fromJson(Map<String, dynamic> json) =
      _$StoriesSectionImpl.fromJson;

  @override
  StoriesData get data;
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
}

abstract class StepsSection implements HomePageSection {
  const factory StepsSection(final StepsData data) = _$StepsSectionImpl;

  factory StepsSection.fromJson(Map<String, dynamic> json) =
      _$StepsSectionImpl.fromJson;

  @override
  StepsData get data;
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
}

abstract class QuickActions implements HomePageSection {
  const factory QuickActions(final QuickActionsCardsData data) =
      _$QuickActionsImpl;

  factory QuickActions.fromJson(Map<String, dynamic> json) =
      _$QuickActionsImpl.fromJson;

  @override
  QuickActionsCardsData get data;
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
}

abstract class ImageSection implements HomePageSection {
  const factory ImageSection(final ImageSectionData data) = _$ImageSectionImpl;

  factory ImageSection.fromJson(Map<String, dynamic> json) =
      _$ImageSectionImpl.fromJson;

  @override
  ImageSectionData get data;
}
