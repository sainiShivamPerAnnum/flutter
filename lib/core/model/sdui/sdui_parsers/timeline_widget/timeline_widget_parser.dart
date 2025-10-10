import 'dart:math';

import 'package:felloapp/core/model/sdui/sdui_parsers/timeline_widget/timeline_widget.dart';
import 'package:felloapp/util/stac/lib/src/utils/color_utils.dart';
import 'package:felloapp/util/stac_framework/lib/src/stac_parser.dart';
import 'package:flutter/material.dart';

class TimelineWidgetParser extends StacParser<TimelineWidget> {
  const TimelineWidgetParser();

  @override
  TimelineWidget getModel(Map<String, dynamic> json) =>
      TimelineWidget.fromJson(json);

  @override
  String get type => 'timeline';

  @override
  Widget parse(BuildContext context, TimelineWidget model) {
    return _CustomTimelineBuilder(
      model: model,
    );
  }
}

class _CustomTimelineBuilder extends StatefulWidget {
  const _CustomTimelineBuilder({
    required this.model,
  });

  final TimelineWidget model;

  @override
  State<_CustomTimelineBuilder> createState() => _CustomTimelineBuilderState();
}

class _CustomTimelineBuilderState extends State<_CustomTimelineBuilder> {
  @override
  Widget build(BuildContext context) {
    return ConfigurableTimelineWidget(
      nodes: widget.model.nodes,
      primaryColor: widget.model.primaryColor?.toColor(context) ??
          const Color(0xFF1E2532),
      secondaryColor: widget.model.secondaryColor?.toColor(context) ??
          const Color(0xFF2A3343),
      tertiaryColor: widget.model.tertiaryColor?.toColor(context) ??
          const Color(0xFF4CD080),
      nodeSize: widget.model.nodeSize ?? 40.0,
      nodeInnerSize: widget.model.nodeInnerSize ?? 28.0,
      nodeInnerMostSize: widget.model.nodeInnerMostSize ?? 16.0,
      lineHeight: widget.model.lineHeight ?? 80.0,
      dashLength: widget.model.dashLength ?? 8.0,
      dashGap: widget.model.dashGap ?? 4.0,
      lineWidth: widget.model.lineWidth ?? 2.0,
      spacing: widget.model.spacing ?? 16.0,
      titleSpacing: widget.model.titleSpacing ?? 8.0,
    );
  }
}

class ConfigurableTimelineWidget extends StatefulWidget {
  final List<TimelineNode> nodes;
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
  final double spacing;
  final double titleSpacing;

  const ConfigurableTimelineWidget({
    required this.nodes,
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
    this.spacing = 16.0,
    this.titleSpacing = 8.0,
  }) : super(key: key);

  @override
  State<ConfigurableTimelineWidget> createState() =>
      _ConfigurableTimelineWidgetState();
}

class _ConfigurableTimelineWidgetState
    extends State<ConfigurableTimelineWidget> {
  // List to store node heights as they are calculated
  final List<double> _nodeHeights = [];

  @override
  void initState() {
    super.initState();
    // Initialize node heights list with default heights
    _nodeHeights.clear();
    for (int i = 0; i < widget.nodes.length; i++) {
      _nodeHeights.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          // The vertical dashed line
          _buildConnectingLines(),
          // Column of timeline nodes
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTimelineItems(context),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingLines() {
    if (widget.nodes.length <= 1) return const SizedBox();

    // Determine vertical offsets for line
    double topOffset = 0;

    // Calculate position of first node vertically
    final double firstNodeHeight = _calculateNodeHeight(widget.nodes[0]);
    // Center the line with the first node
    topOffset =
        max((firstNodeHeight - widget.nodeSize) / 2, 0) + (widget.nodeSize / 2);

    // Calculate total height for the line
    double totalHeight = 0;

    // Add heights for all nodes except the last one
    for (int i = 0; i < widget.nodes.length - 1; i++) {
      totalHeight += _calculateNodeHeight(widget.nodes[i]);

      // Add line height between nodes
      totalHeight += widget.lineHeight;
    }

    // For the last node, we include just enough to reach its center
    totalHeight += widget.nodeSize / 2;

    return Positioned(
      left: widget.nodeSize / 2 - widget.lineWidth / 2,
      top:
          topOffset, // Start from the center of the first node, accounting for vertical centering
      child: SizedBox(
        height: totalHeight,
        width: widget.lineWidth,
        child: CustomPaint(
          painter: DashedLinePainter(
            color: Colors.white,
            dashLength: widget.dashLength,
            dashGap: widget.dashGap,
            strokeWidth: widget.lineWidth,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTimelineItems(BuildContext context) {
    final List<Widget> items = [];

    for (int i = 0; i < widget.nodes.length; i++) {
      // Add node with title and description
      items.add(
        _buildNodeWithContent(context, widget.nodes[i], i),
      );

      // Add spacer between nodes (if not the last node)
      if (i < widget.nodes.length - 1) {
        items.add(SizedBox(height: widget.lineHeight));
      }
    }

    return items;
  }

  // Calculate node height estimation based on content
  double _calculateNodeHeight(TimelineNode node) {
    double height = widget.nodeSize; // Base height (circle size)

    // Add estimated text heights (rough approximation)
    if (node.title != null) {
      // Estimate one line of title text
      height = max(height, widget.nodeSize);

      // Add estimated additional lines for longer titles (rough approximation)
      int estimatedLines =
          (node.title!.length / 30).ceil(); // ~30 chars per line
      if (estimatedLines > 1) {
        height += (estimatedLines - 1) * ((node.titleFontSize ?? 16.0) * 1.2);
      }
    }

    if (node.title != null && node.description != null) {
      height += widget.titleSpacing;
    }

    if (node.description != null) {
      // Estimate description text height
      int estimatedLines =
          (node.description!.length / 40).ceil(); // ~40 chars per line
      height += estimatedLines * ((node.descriptionFontSize ?? 14.0) * 1.2);
    }

    return height;
  }

  Widget _buildNodeWithContent(
    BuildContext context,
    TimelineNode node,
    int index,
  ) {
    final Color nodeColor = node.nodeColor?.toColor(context) ??
        (node.completed == true ? widget.tertiaryColor : widget.primaryColor);

    // Store estimated node height for line calculations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final double nodeHeight = _calculateNodeHeight(node);
        if (_nodeHeights.length > index && _nodeHeights[index] != nodeHeight) {
          setState(() {
            _nodeHeights[index] = nodeHeight;
          });
        }
      }
    });

    // Content column for title and description
    final Widget contentColumn = node.title != null || node.description != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (node.title != null)
                Text(
                  node.title!,
                  style: TextStyle(
                    color: node.titleColor?.toColor(context) ?? Colors.white,
                    fontSize: node.titleFontSize ?? 16.0,
                    fontWeight:
                        _getFontWeight(node.titleFontWeight) ?? FontWeight.bold,
                  ),
                ),
              SizedBox(
                height: node.title != null && node.description != null
                    ? widget.titleSpacing
                    : 0,
              ),
              if (node.description != null)
                Text(
                  node.description!,
                  style: TextStyle(
                    color: node.descriptionColor?.toColor(context) ??
                        Colors.white70,
                    fontSize: node.descriptionFontSize ?? 14.0,
                    fontWeight: _getFontWeight(node.descriptionFontWeight) ??
                        FontWeight.normal,
                  ),
                ),
            ],
          )
        : const SizedBox();

    // Circle node widget
    final Widget circleNode = Container(
      width: widget.nodeSize,
      height: widget.nodeSize,
      decoration: BoxDecoration(
        color: widget.primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: widget.nodeInnerSize,
          height: widget.nodeInnerSize,
          decoration: BoxDecoration(
            color: widget.secondaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: widget.nodeInnerMostSize,
              height: widget.nodeInnerMostSize,
              decoration: BoxDecoration(
                color: nodeColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center, // Center alignment for vertical centering
      children: [
        // Timeline Node - now centered vertically
        circleNode,
        SizedBox(width: widget.spacing),
        // Title and Description Section
        if (node.title != null || node.description != null)
          Expanded(child: contentColumn),
      ],
    );
  }

  FontWeight? _getFontWeight(String? fontWeight) {
    if (fontWeight == null) return null;

    switch (fontWeight.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      case 'light':
        return FontWeight.w300;
      case 'medium':
        return FontWeight.w500;
      case 'semibold':
        return FontWeight.w600;
      default:
        return FontWeight.normal;
    }
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
