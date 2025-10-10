import 'package:flutter/material.dart';

class TimelineWidget extends StatelessWidget {
  final int nodeCount;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final double nodeSize;
  final double nodeInnerSize;
  final double nodeInnerMostSize;
  final double lineHeight;
  final double dashLength;
  final double dashGap;
  final double lineWidth;

  const TimelineWidget({
    required this.nodeCount,
    Key? key,
    this.primaryColor = const Color(0xFF1E2532),
    this.secondaryColor = const Color(0xFF2A3343),
    this.tertiaryColor = const Color(0xFF4CD080),
    this.nodeSize = 40.0,
    this.nodeInnerSize = 28.0,
    this.nodeInnerMostSize = 16.0,
    this.lineHeight = 80.0,
    this.dashLength = 8.0,
    this.dashGap = 4.0,
    this.lineWidth = 2.0,
  })  : assert(nodeCount > 0, 'Node count must be greater than 0'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildTimelineItems(),
      ),
    );
  }

  List<Widget> _buildTimelineItems() {
    final List<Widget> items = [];

    for (int i = 0; i < nodeCount; i++) {
      // Add node
      items.add(_buildNode());

      // Add connector line if it's not the last node
      if (i < nodeCount - 1) {
        items.add(_buildConnector());
      }
    }

    return items;
  }

  Widget _buildNode() {
    return Container(
      width: nodeSize,
      height: nodeSize,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: nodeInnerSize,
          height: nodeInnerSize,
          decoration: BoxDecoration(
            color: secondaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: nodeInnerMostSize,
              height: nodeInnerMostSize,
              decoration: BoxDecoration(
                color: tertiaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnector() {
    return CustomPaint(
      size: Size(lineWidth, lineHeight),
      painter: DashedLinePainter(
        color: Colors.white,
        dashLength: dashLength,
        dashGap: dashGap,
        strokeWidth: lineWidth,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashLength;
  final double dashGap;
  final double strokeWidth;

  DashedLinePainter({
    required this.color,
    required this.dashLength,
    required this.dashGap,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startY = 0;
    final double endY = size.height;

    while (startY < endY) {
      // Draw a dash
      final dashEndY = startY + dashLength;
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, dashEndY > endY ? endY : dashEndY),
        paint,
      );

      // Move to the start of the next dash
      startY = dashEndY + dashGap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
