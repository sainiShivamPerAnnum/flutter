import 'package:flutter/material.dart';

class ChartFundItem {
  final String fundName;
  final double fundAmount;
  final String logo;
  final Color color;
  final List<String> description;
  final String buttonText;
  final Function function;
  final bool isHighlighted;

  ChartFundItem({
    @required this.fundName,
    @required this.buttonText,
    @required this.color,
    @required this.description,
    @required this.function,
    @required this.fundAmount,
    @required this.logo,
    @required this.isHighlighted,
  });
}
