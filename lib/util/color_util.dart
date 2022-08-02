import 'dart:ui';

class ColorUtil {
  static Color fromColorString(String color) {
    return Color(int.parse('0xff$color'));
  }
}
