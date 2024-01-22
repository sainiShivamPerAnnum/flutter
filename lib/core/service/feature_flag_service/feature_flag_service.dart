import 'package:felloapp/core/service/feature_flag_service/condition_evaluator.dart';
import 'package:felloapp/core/service/feature_flag_service/types.dart';

class FeatureFlagService {
  FeatureFlagService._(
    this._features,
  ) : _attributes = {};

  final Features _features;
  Map<String, dynamic> _attributes;

  factory FeatureFlagService.init({
    required Map<String, dynamic> features,
  }) {
    final f = Features.fromJson(features);
    return FeatureFlagService._(f);
  }

  /// Evaluates the feature value based on provided [feature] key.
  T evaluateFeature<T>(String feature, {required T defaultValue}) {
    final result =
        _FeatureEvaluator.evaluateFeature(_attributes, _features, feature);
    return result as T? ?? defaultValue;
  }

  /// Appends [attributes] in existing user attributes if the key were not in
  /// existing attributes else update the existing attribute value with new.
  void updateAttributes({Map<String, dynamic> attributes = const {}}) {
    for (final MapEntry<String, dynamic> attr in attributes.entries) {
      if (_attributes.containsKey(attr.key)) {
        _attributes.update(attr.key, (value) => attr.value);
      } else {
        _attributes.putIfAbsent(attr.key, () => attr.value);
      }
    }
  }

  static const newUserVariant = 'newUserVariant';
  static const entryScreen = 'entryScreen';
}

class _FeatureEvaluator {
  const _FeatureEvaluator();
  static Object? evaluateFeature(
      Map<String, dynamic> attributes, Features context, String featureKey) {
    final targetFeature = context.features[featureKey];

    // If feature doesn't exists return null.
    if (targetFeature == null) {
      return null;
    }

    // Iterate through the rules if any rule passes return value if that rule.
    final rules = targetFeature.rules;
    if (rules.isNotEmpty) {
      for (final rule in rules) {
        if (rule.condition != null) {
          final attr = attributes;
          if (!ConditionEvaluator.instance.evaluate(attr, rule.condition)) {
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
