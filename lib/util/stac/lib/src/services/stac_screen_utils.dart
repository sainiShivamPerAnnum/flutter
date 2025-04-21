import 'package:felloapp/util/stac/lib/stac.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A class that transforms STAC JSON to apply ScreenUtil values
/// before the regular STAC parsers process them
class StacScreenUtilTransformer {
  /// Transform the JSON by applying ScreenUtil modifiers to numeric values
  static Map<String, dynamic>? _transformJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    // Create a deep copy of the JSON to avoid modifying the original
    final Map<String, dynamic> transformedJson = Map.from(json);

    // Apply transformations based on the widget type
    final String widgetType = json['type'] as String? ?? '';
    _applyTransformations(transformedJson, widgetType);

    return transformedJson;
  }

  /// Apply appropriate transformations based on widget type and property names
  static void _applyTransformations(
    Map<String, dynamic> json,
    String widgetType,
  ) {
    // Process common properties first
    _processCommonProperties(json);

    // Process children recursively
    _processChildren(json);

    // Process special widget-specific properties
    _processSpecificWidget(json, widgetType);
  }

  /// Process common properties that appear in multiple widget types
  static void _processCommonProperties(Map<String, dynamic> json) {
    // Handle width and height (apply .w and .h)
    if (json.containsKey('width') && json['width'] is num) {
      json['width'] = ScreenUtilTag('w', json['width']);
    }

    if (json.containsKey('height') && json['height'] is num) {
      json['height'] = ScreenUtilTag('h', json['height']);
    }

    // Handle size (apply .r for radius-related properties)
    if (json.containsKey('size') && json['size'] is num) {
      json['size'] = ScreenUtilTag('r', json['size']);
    }

    // Handle padding
    if (json.containsKey('padding')) {
      json['padding'] = _processEdgeInsets(json['padding'], forHeight: false);
    }

    // Handle margin
    if (json.containsKey('margin')) {
      json['margin'] = _processEdgeInsets(json['margin'], forHeight: false);
    }

    // Handle decoration
    if (json.containsKey('decoration') && json['decoration'] is Map) {
      _processDecoration(json['decoration'] as Map<String, dynamic>);
    }

    // Handle style for text properties
    if (json.containsKey('style') && json['style'] is Map) {
      _processTextStyle(json['style'] as Map<String, dynamic>);
    }
  }

  /// Process children of container widgets recursively
  static void _processChildren(Map<String, dynamic> json) {
    // Process child widgets recursively
    if (json.containsKey('child') && json['child'] is Map) {
      final childJson = json['child'] as Map<String, dynamic>;
      final childType = childJson['type'] as String? ?? '';
      _applyTransformations(childJson, childType);
    }

    // Process lists of children recursively
    if (json.containsKey('children') && json['children'] is List) {
      final children = json['children'] as List;
      for (int i = 0; i < children.length; i++) {
        if (children[i] is Map) {
          final childJson = children[i] as Map<String, dynamic>;
          final childType = childJson['type'] as String? ?? '';
          _applyTransformations(childJson, childType);
        }
      }
    }
  }

  /// Process widget-specific properties
  static void _processSpecificWidget(
    Map<String, dynamic> json,
    String widgetType,
  ) {
    switch (widgetType) {
      case 'Text':
        // Handle direct fontSize property if present
        if (json.containsKey('fontSize') && json['fontSize'] is num) {
          json['fontSize'] = ScreenUtilTag('sp', json['fontSize']);
        }
        break;

      case 'Container':
      case 'SizedBox':
        // These are handled by common properties
        break;

      case 'BorderRadius':
        // Handle border radius values
        if (json.containsKey('radius') && json['radius'] is num) {
          json['radius'] = ScreenUtilTag('r', json['radius']);
        }
        break;

      // Add cases for other widget types that need special handling

      default:
        // Other widget types are processed by common properties
        break;
    }
  }

  /// Process EdgeInsets values
  static dynamic _processEdgeInsets(padding, {bool forHeight = false}) {
    if (padding is num) {
      // For a single number, use .r as it applies to all sides
      return ScreenUtilTag('r', padding);
    } else if (padding is Map<String, dynamic>) {
      // For a map with specific sides
      final result = Map<String, dynamic>.from(padding);

      if (result.containsKey('left') && result['left'] is num) {
        result['left'] = ScreenUtilTag('w', result['left']);
      }

      if (result.containsKey('right') && result['right'] is num) {
        result['right'] = ScreenUtilTag('w', result['right']);
      }

      if (result.containsKey('top') && result['top'] is num) {
        result['top'] = ScreenUtilTag('h', result['top']);
      }

      if (result.containsKey('bottom') && result['bottom'] is num) {
        result['bottom'] = ScreenUtilTag('h', result['bottom']);
      }

      if (result.containsKey('horizontal') && result['horizontal'] is num) {
        result['horizontal'] = ScreenUtilTag('w', result['horizontal']);
      }

      if (result.containsKey('vertical') && result['vertical'] is num) {
        result['vertical'] = ScreenUtilTag('h', result['vertical']);
      }

      return result;
    } else if (padding is List && padding.length >= 2) {
      // For a list with horizontal and vertical values
      final result = List.from(padding);
      if (result[0] is num) {
        result[0] = ScreenUtilTag('w', result[0]);
      }

      if (result[1] is num) {
        result[1] = ScreenUtilTag('h', result[1]);
      }

      return result;
    }

    return padding;
  }

  /// Process BoxDecoration values
  static void _processDecoration(Map<String, dynamic> decoration) {
    // Handle border radius
    if (decoration.containsKey('borderRadius') &&
        decoration['borderRadius'] is num) {
      decoration['borderRadius'] =
          ScreenUtilTag('r', decoration['borderRadius']);
    } else if (decoration.containsKey('borderRadius') &&
        decoration['borderRadius'] is Map) {
      final borderRadius = decoration['borderRadius'] as Map<String, dynamic>;

      if (borderRadius.containsKey('topLeft') &&
          borderRadius['topLeft'] is num) {
        borderRadius['topLeft'] = ScreenUtilTag('r', borderRadius['topLeft']);
      }

      if (borderRadius.containsKey('topRight') &&
          borderRadius['topRight'] is num) {
        borderRadius['topRight'] = ScreenUtilTag('r', borderRadius['topRight']);
      }

      if (borderRadius.containsKey('bottomLeft') &&
          borderRadius['bottomLeft'] is num) {
        borderRadius['bottomLeft'] =
            ScreenUtilTag('r', borderRadius['bottomLeft']);
      }

      if (borderRadius.containsKey('bottomRight') &&
          borderRadius['bottomRight'] is num) {
        borderRadius['bottomRight'] =
            ScreenUtilTag('r', borderRadius['bottomRight']);
      }
    }

    // Handle border width
    if (decoration.containsKey('border') && decoration['border'] is Map) {
      final border = decoration['border'] as Map<String, dynamic>;

      if (border.containsKey('width') && border['width'] is num) {
        border['width'] = ScreenUtilTag('w', border['width']);
      }
    }
  }

  /// Process TextStyle values
  static void _processTextStyle(Map<String, dynamic> style) {
    // Handle fontSize
    if (style.containsKey('fontSize') && style['fontSize'] is num) {
      style['fontSize'] = ScreenUtilTag('sp', style['fontSize']);
    }

    // Handle letterSpacing
    if (style.containsKey('letterSpacing') && style['letterSpacing'] is num) {
      style['letterSpacing'] = ScreenUtilTag('w', style['letterSpacing']);
    }

    // Handle height (line height)
    if (style.containsKey('height') && style['height'] is num) {
      // Line height is unitless, so we don't apply ScreenUtil
      // But if you want to apply it, use .sp
      // style['height'] = ScreenUtilTag('sp', style['height']);
    }
  }
}

/// Hack: We use this class to tag values for ScreenUtil processing
/// STAC will see this as a string or number (whichever is appropriate)
/// The native STAC parsers then convert these values using ScreenUtil
class ScreenUtilTag {
  final String type; // 'w', 'h', 'r', or 'sp'
  final num value;

  ScreenUtilTag(this.type, this.value);

  @override
  String toString() {
    switch (type) {
      case 'w':
        return '${value.toDouble().w}';
      case 'h':
        return '${value.toDouble().h}';
      case 'r':
        return '${value.toDouble().r}';
      case 'sp':
        return '${value.toDouble().sp}';
      default:
        return value.toString();
    }
  }

  /// Allow this to be treated as a number
  double toDouble() {
    switch (type) {
      case 'w':
        return value.toDouble().w;
      case 'h':
        return value.toDouble().h;
      case 'r':
        return value.toDouble().r;
      case 'sp':
        return value.toDouble().sp;
      default:
        return value.toDouble();
    }
  }
}

/// Extension method to make initialization cleaner
extension ScreenUtilStacExtension on Stac {
  /// Initialize STAC with ScreenUtil support
  static Future<void> santizeJson({
    Map<String, dynamic>? json,
  }) async {
    StacScreenUtilTransformer._transformJson(json);
  }
}
