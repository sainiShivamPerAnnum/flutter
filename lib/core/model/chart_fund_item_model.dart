import 'package:flutter/material.dart';

class ChartFundItem {
  final String fundName;
  final double fundAmount;
  final String logo;
  final Color color;
  final List<String> description;
  final bool isHighlighted;

  ChartFundItem({
    @required this.fundName,
    @required this.color,
    @required this.description,
    @required this.fundAmount,
    @required this.logo,
    @required this.isHighlighted,
  });
}
