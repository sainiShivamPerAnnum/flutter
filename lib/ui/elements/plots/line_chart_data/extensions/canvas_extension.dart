import 'dart:ui';

import 'package:felloapp/ui/elements/plots/line_chart_data/utils/canvas_wrapper.dart';
import 'package:felloapp/ui/elements/plots/line_chart_data/extensions/path_extension.dart';

/// Defines extensions on the [CanvasWrapper]
extension DashedLine on CanvasWrapper {
  /// Draws a dashed line from passed in offsets
  void drawDashedLine(
      Offset from, Offset to, Paint painter, List<int> dashArray) {
    var path = Path();
    path.moveTo(from.dx, from.dy);
    path.lineTo(to.dx, to.dy);
    path = path.toDashedPath(dashArray);
    drawPath(path, painter);
  }
}
