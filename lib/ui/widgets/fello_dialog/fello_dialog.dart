import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class FelloDialog extends StatelessWidget {
  final Widget content;
  final bool showCrossIcon;
  FelloDialog({
    this.content,
    this.showCrossIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dialog(
          child: Container(
            padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
            child: Wrap(
              children: [content],
            ),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.roundness40),
          ),
        ),
        if (showCrossIcon)
          Material(
            color: Colors.transparent,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[700]),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ),
      ],
    );
  }
}
