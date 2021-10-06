import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class FelloDialog extends StatelessWidget {
  final Widget content;
  final bool showCrossIcon;
  FelloDialog({
    this.content,
    this.showCrossIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dialog(
          child: Container(
            child: Wrap(
              children: [content],
            ),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
