import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class SegmentChips extends StatelessWidget {
  final model;
  final String text;

  SegmentChips({this.model, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyles.body3.bold.colour(
          getBorder(),
        ),
      ),
    );
  }

  getBorder() {
    if (model.isDaily) {
      if (text == "Daily")
        return Colors.white;
      else
        return Colors.grey;
    } else {
      if (text == "Daily")
        return Colors.grey;
      else
        return Colors.white;
    }
  }
}
