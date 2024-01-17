import 'package:flutter/foundation.dart';

extension ObjectChecker on Object? {
  /// Check that if object is string.
  bool get isString => this is String;

  /// Check that if object is List.
  bool get isArray => this is List;

  /// Check that if object is null.
  bool get isNull => this == null;

  /// Check that if object is bool.
  bool get isBoolean => this is bool;

  /// Check that if object is number.
  bool get isNumber => this is num || this is int || this is double;

  /// Check that if object is map.
  bool get isMap => this is Map;

  /// Check that it is primitive data type or not.
  bool get isPrimitive => isString || isBoolean || isNumber;

  /// Check that if object is double.
  bool get isDouble => this is double;
}

extension StringComparison on String {
  bool operator <(String other) =>
      compareTo(other) != 1 && (compareTo(other) != 0);

  bool operator <=(String other) =>
      compareTo(other) != 1 && (compareTo(other) == 0);

  bool operator >(String other) =>
      compareTo(other) != -1 && (compareTo(other) != 0);

  bool operator >=(String other) =>
      compareTo(other) != -1 || (compareTo(other) == 0);
}

enum AttributeType {
  /// String Type Attribute.
  gbString('string'),

  /// Number Type Attribute.
  gbNumber('number'),

  /// Boolean Type Attribute.
  gbBoolean('boolean'),

  //// Array Type Attribute.
  gbArray('array'),

  /// Object Type Attribute.
  gbObject('object'),

  /// Null Type Attribute.
  gbNull('null'),

  /// Not Supported Type Attribute.
  gbUnknown('unknown');

  const AttributeType(this.name);

  final String name;

  @override
  String toString() => name;
}

class ConditionEvaluator {
  const ConditionEvaluator._();

  static const instance = ConditionEvaluator._();

  /// Evaluates the condition based on the user attributes and provided
  /// [condition].
  bool evaluateCondition(Map<String, dynamic> attributes, Object? condition) {
    if (condition.isArray) {
      return false;
    } else {
      condition as Map;

      var targetItems = condition["\$or"];
      if (targetItems != null) {
        return evalOr(attributes, targetItems);
      }

      targetItems = condition["\$nor"];
      if (targetItems != null) {
        return !evalOr(attributes, targetItems);
      }

      targetItems = condition["\$and"];
      if (targetItems != null) {
        return evalAnd(attributes, targetItems);
      }

      var targetItem = condition["\$not"];
      if (targetItem != null) {
        return !evaluateCondition(attributes, targetItem);
      }

      // Loop through the conditionObj key/value pairs
      for (final key in condition.keys) {
        final element = getPath(attributes, key);
        final value = condition[key];
        if (value != null) {
          if (!evalConditionValue(value, element)) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Evaluate OR conditions against given attributes
  bool evalOr(Map<String, dynamic> attributes, List conditionObj) {
    if (conditionObj.isEmpty) {
      return true;
    } else {
      for (final item in conditionObj) {
        if (evaluateCondition(attributes, item)) {
          return true;
        }
      }
    }
    // Return false
    return false;
  }

  /// Evaluate AND conditions against given attributes
  bool evalAnd(Map<String, dynamic> attributes, List conditionObj) {
    for (final item in conditionObj) {
      if (!evaluateCondition(attributes, item)) {
        return false;
      }
    }
    return true;
  }

  /// This accepts a parsed JSON object as input and returns true if every key
  /// in the object starts with $
  bool isOperatorObject(Object? obj) {
    var isOperator = true;
    if (obj.isMap) {
      if ((obj as Map<String, dynamic>).keys.isNotEmpty) {
        for (final key in obj.keys) {
          if (!key.startsWith(r"$")) {
            isOperator = false;
            break;
          }
        }
      }
    } else {
      isOperator = false;
    }
    return isOperator;
  }

  ///  This returns the data type of the passed in argument.
  AttributeType getType(Object? obj) {
    if (obj == null) {
      return AttributeType.gbNull;
    }

    final value = obj;

    if (value.isPrimitive) {
      if (value.isString) {
        return AttributeType.gbString;
      } else if (value == true || value == false) {
        return AttributeType.gbBoolean;
      } else {
        return AttributeType.gbNumber;
      }
    }

    if (value.isArray) {
      return AttributeType.gbArray;
    }

    if (value.isMap) {
      return AttributeType.gbObject;
    }

    return AttributeType.gbUnknown;
  }

  // Given attributes and a dot-separated path string, return the value at
  // that path (or null/undefined if the path doesn't exist)
  Object? getPath(Map<String, dynamic> obj, String key) {
    var paths = <String>[];

    if (key.contains(".")) {
      paths = key.split('.');
    } else {
      paths.add(key);
    }

    Object? element = obj;
    for (final path in paths) {
      if (element == null || element.isArray) {
        return null;
      }
      if (element is Map) {
        element = element[path];
      } else {
        return null;
      }
    }

    return element;
  }

  // Evaluates Condition Value against given condition & attributes
  bool evalConditionValue(Object? conditionValue, Object? attributeValue) {
    // If conditionValue is a string, number, boolean, return true if it's
    // "equal" to attributeValue and false if not.
    if (conditionValue.isPrimitive && attributeValue.isPrimitive) {
      return conditionValue == attributeValue;
    }

    // Evaluate to false if attributeValue is null.
    if (conditionValue.isPrimitive && attributeValue == null) {
      return false;
    }

    // If conditionValue is array, return true if it's "equal" - "equal" should
    // do a deep comparison for arrays.
    if (conditionValue is List) {
      if (attributeValue is List) {
        if (conditionValue.length == attributeValue.length) {
          return listEquals(conditionValue, attributeValue);
        }
      } else {
        return false;
      }
    }

    // If conditionValue is an object, loop over each key/value pair:
    if (conditionValue is Map) {
      if (isOperatorObject(conditionValue)) {
        for (final key in conditionValue.keys) {
          // If evalOperatorCondition(key, attributeValue, value)
          // is false, return false
          if (!evalOperatorCondition(
              key, attributeValue, conditionValue[key])) {
            return false;
          }
        }
      } else if (attributeValue != null) {
        return attributeValue is Map
            ? mapEquals(conditionValue, attributeValue)
            : attributeValue == conditionValue;
      } else {
        return false;
      }
    }

    return true;
  }

  // This checks if attributeValue is an array, and if so at least one of the
  // array items must match the condition
  bool elemMatch(Object? attributeValue, Object? condition) {
    // Loop through items in attributeValue
    if (attributeValue is List) {
      for (final item in attributeValue) {
        // If isOperatorObject(condition)
        if (isOperatorObject(condition)) {
          //If evalConditionValue(condition, item), break out of loop and
          //return true
          if (evalConditionValue(condition, item)) {
            return true;
          }
        }
        // Else if evalCondition(item, condition), break out of loop and
        //return true
        else if (evaluateCondition(item, condition)) {
          return true;
        }
      }
    }

    return false; // If attributeValue is not an array.
  }

  bool evalOperatorCondition(
      String operator, Object? attributeValue, Object? conditionValue) {
    // Evaluate TYPE operator - whether both are of same type
    if (operator == "\$type") {
      return getType(attributeValue).name == conditionValue;
    }

    // Evaluate NOT operator - whether condition doesn't contain attribute
    if (operator == "\$not") {
      return !evalConditionValue(conditionValue, attributeValue);
    }

    // Evaluate EXISTS operator - whether condition contains attribute
    if (operator == "\$exists") {
      if (conditionValue.toString() == 'false' && attributeValue == null) {
        return true;
      } else if (conditionValue.toString() == 'true' &&
          attributeValue != null) {
        return true;
      }
    }

    // There are three operators where conditionValue is an array
    if (conditionValue is List) {
      switch (operator) {
        case '\$in':
          return conditionValue.contains(attributeValue);

        // Evaluate NIN operator - attributeValue not in the conditionValue
        // array.
        case '\$nin':
          return !conditionValue.contains(attributeValue);

        // Evaluate ALL operator - whether condition contains all attribute
        case '\$all':
          if (attributeValue is List) {
            // Loop through conditionValue array If none of the elements in the
            // attributeValue array pass return false.
            for (final con in conditionValue) {
              var result = false;
              for (final attr in attributeValue) {
                if (evalConditionValue(con, attr)) {
                  result = true;
                }
              }
              if (!result) {
                return result;
              }
            }

            return true;
          } else {
            return false; // If attributeValue is not an array, return false
          }
        default:
          return false;
      }
    } else if (attributeValue is List) {
      switch (operator) {
        // Evaluate ELEMENT-MATCH operator - whether condition matches attribute
        case "\$elemMatch":
          return elemMatch(attributeValue, conditionValue);

        // Evaluate SIE operator - whether condition size is same as that
        // of attribute
        case "\$size":
          return evalConditionValue(
            conditionValue,
            attributeValue.length,
          );

        default:
      }
    } else if (attributeValue.isPrimitive && conditionValue.isPrimitive) {
      // If condition is bool.
      if (conditionValue.isBoolean && attributeValue.isBoolean) {
        bool evaluatedValue = false;
        switch (operator) {
          case "\$eq":
            evaluatedValue = conditionValue == attributeValue;
            break;
          case "\$ne":
            evaluatedValue = conditionValue != attributeValue;
            break;
        }
        return evaluatedValue;
      }

      /// If condition is num.
      if (conditionValue.isNumber && attributeValue.isNumber) {
        conditionValue as num;
        attributeValue as num;
        bool evaluatedValue = false;
        switch (operator) {
          // Evaluate EQ operator - whether condition equals to attribute
          case '\$eq':
            evaluatedValue = conditionValue == attributeValue;
            break;

          // Evaluate NE operator - whether condition doesn't equal to attribute
          case '\$ne':
            evaluatedValue = conditionValue != attributeValue;
            break;

          // Evaluate LT operator - whether attribute less than to condition
          case '\$lt':
            evaluatedValue = attributeValue < conditionValue;
            break;

          // Evaluate LTE operator - whether attribute less than or equal to
          // condition.
          case '\$lte':
            evaluatedValue = attributeValue <= conditionValue;
            break;

          // Evaluate GT operator - whether attribute greater than to condition
          case '\$gt':
            evaluatedValue = attributeValue > conditionValue;
            break;

          case '\$gte':
            evaluatedValue = attributeValue >= conditionValue;
            break;

          default:
            evaluatedValue = false;
        }
        return evaluatedValue;
      }

      if (conditionValue.isString && attributeValue.isString) {
        bool evaluatedValue = false;
        conditionValue as String;
        attributeValue as String;
        switch (operator) {
          /// Evaluate EQ operator - whether condition equals to attribute
          case '\$eq':
            evaluatedValue = conditionValue == attributeValue;
            break;

          // Evaluate NE operator - whether condition doesn't equal to attribute
          case '\$ne':
            evaluatedValue = conditionValue != attributeValue;
            break;

          // Evaluate LT operator - whether attribute less than to condition
          case '\$lt':
            evaluatedValue = attributeValue < conditionValue;
            break;

          // Evaluate VEQ operator - whether attribute version equals the
          // condition version
          case '\$veq':
            evaluatedValue = GBUtils.paddedVersionString(attributeValue) ==
                GBUtils.paddedVersionString(conditionValue);
            break;

          // Evaluate VNE operator - whether attribute version does not equal
          // the condition version
          case '\$vne':
            evaluatedValue = GBUtils.paddedVersionString(attributeValue) !=
                GBUtils.paddedVersionString(conditionValue);
            break;

          // Evaluate VGT operator - whether attribute version is greater than
          // the condition version
          case '\$vgt':
            evaluatedValue = GBUtils.paddedVersionString(attributeValue) >
                GBUtils.paddedVersionString(conditionValue);
            break;

          // Evaluate VGT operator - whether attribute version is greater
          // than or equal to the condition version
          case '\$vgte':
            final attributeVersion =
                GBUtils.paddedVersionString(attributeValue);
            final conditionVersion =
                GBUtils.paddedVersionString(conditionValue);
            evaluatedValue = (attributeVersion == conditionVersion) ||
                (attributeVersion > conditionVersion);
            break;

          // Evaluate VLT operator - whether attribute version is less than the
          // condition version
          case '\$vlt':
            evaluatedValue = GBUtils.paddedVersionString(attributeValue) <
                GBUtils.paddedVersionString(conditionValue);
            break;

          // Evaluate VLTE operator - whether attribute version is less than or
          // equal to the condition version
          case '\$vlte':
            final attributeVersion =
                GBUtils.paddedVersionString(attributeValue);
            final conditionVersion =
                GBUtils.paddedVersionString(conditionValue);
            evaluatedValue = (attributeVersion == conditionVersion) ||
                (attributeVersion < conditionVersion);
            break;

          // Evaluate LTE operator - whether attribute less than or equal
          // to condition
          case '\$lte':
            evaluatedValue = attributeValue <= conditionValue;
            break;

          // Evaluate GT operator - whether attribute greater than to condition
          case '\$gt':
            evaluatedValue = attributeValue > conditionValue;
            break;

          case '\$gte':
            evaluatedValue = attributeValue >= conditionValue;
            break;

          case '\$regex':
            try {
              final regEx = RegExp(conditionValue.toString());
              evaluatedValue = regEx.hasMatch(attributeValue.toString());
            } catch (e) {
              evaluatedValue = false;
            }
            break;

          default:
            evaluatedValue = false;
        }
        return evaluatedValue;
      }
    }

    return false;
  }
}

class GBUtils {
  const GBUtils();

  static String paddedVersionString(String input) {
    // Remove build info and leading `v` if any
    // Split version into parts (both core version numbers and pre-release tags)
    // "v1.2.3-rc.1+build123" -> ["1","2","3","rc","1"]
    final parts = input
        .replaceAll(
          RegExp(r"(^v|\+.*$)"),
          "",
        )
        .split(RegExp(r"[-.]"));

    // If it's SemVer without a pre-release, add `~` to the end
    // ["1","0","0"] -> ["1","0","0","~"]
    // "~" is the largest ASCII character, so this will make "1.0.0" greater
    // than "1.0.0-beta" for example
    if (parts.length == 3) {
      parts.add("~");
    }

    // Left pad each numeric part with spaces so string comparisons will work
    // ("9">"10", but " 9"<"10")
    // Then, join back together into a single string
    final digits = RegExp(r"^[0-9]+$");
    return parts
        .map((v) => digits.hasMatch(v) ? v.padLeft(5, " ") : v)
        .join("-");
  }
}
