import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable(
  createToJson: false,
)
class Features {
  final Map<String, Feature> features;
  const Features(this.features);

  factory Features.fromJson(Map<String, dynamic> json) =>
      _$FeaturesFromJson(json);
}

@JsonSerializable(
  createToJson: false,
)
class Feature {
  final List<Rule> rules;
  final Object? defaultValue;

  const Feature({
    this.rules = const [],
    this.defaultValue,
  });

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);
}

@JsonSerializable(
  createToJson: false,
)
class Rule {
  final Object? condition; // a condition for the force result.
  final Object? force; //

  const Rule(
    this.condition,
    this.force,
  );

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
}
