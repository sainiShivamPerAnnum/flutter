import 'package:flutter/material.dart';

class ChartFundItem {
  final String fundName;
  final double fundAmount;
  final String logo;
  final Color color;
  final List<String> description;
  final bool action;
  final Function function;
  final bool isHighlighted;

  ChartFundItem({
    @required this.fundName,
    @required this.action,
    @required this.color,
    @required this.description,
    @required this.function,
    @required this.fundAmount,
    @required this.logo,
    @required this.isHighlighted,
  });
}
