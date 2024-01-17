import 'package:felloapp/core/service/feature_flag_service/condition_evaluator.dart';
import 'package:felloapp/core/service/feature_flag_service/types.dart';

class FeatureFlagService {
  const FeatureFlagService._(
    this._features,
    this._attributes,
  );

  final Features _features;
  final Map<String, dynamic> _attributes;

  factory FeatureFlagService.init(
      Map<String, dynamic> feature, Map<String, dynamic> attributes) {
    final f = Features.fromJson(feature);
    return FeatureFlagService._(f, attributes);
  }

  T? evaluateFeature<T>(String key) {
    final result =
        _FeatureEvaluator.evaluateFeature(_attributes, _features, key);
    return result as T?;
  }

  void updateAttributes({Map<String, dynamic> attributes = const {}}) {
    for (final MapEntry<String, dynamic> attr in attributes.entries) {
      if (attributes.containsKey(attr.key)) {
        attributes.update(attr.key, (value) => attr.value);
      } else {
        attributes.putIfAbsent(attr.key, () => attr.value);
      }
    }
  }
}

class _FeatureEvaluator {
  const _FeatureEvaluator();
  static Object? evaluateFeature(
      Map<String, dynamic> attributes, Features context, String featureKey) {
    // If we are not able to find feature on the basis of the passed featureKey
    // then we are going to return unKnownFeature.
    final targetFeature = context.features[featureKey];
    if (targetFeature == null) {
      return null;
    }

    // Loop through the feature rules (if any)
    final rules = targetFeature.rules;

    // Return if rules is not provided.
    if (rules.isNotEmpty) {
      for (final rule in rules) {
        if (rule.condition != null) {
          final attr = attributes;
          if (!ConditionEvaluator.instance
              .evaluateCondition(attr, rule.condition)) {
            continue;
          }

          if (rule.force != null) {
            return rule.force;
          }
        }
      }
    }

    return targetFeature.defaultValue;
  }
}
