import 'dart:ui';

class ColorUtil {
  static Color? fromColorString(String? color) {
    if (color == null) {
      return null;
    }

    String formattedColor = color.startsWith('#') ? color.substring(1) : color;
    int? colorValue = int.tryParse('0xff$formattedColor', radix: 16);
    if (colorValue == null) {
      return null;
    }

    return Color(colorValue);
  }
}
