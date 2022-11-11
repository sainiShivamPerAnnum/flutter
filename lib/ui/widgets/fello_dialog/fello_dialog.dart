import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class FelloDialog extends StatelessWidget {
  final Widget content;
  final bool showCrossIcon;

  final bool isAddedToScreenStack;
  final bool defaultPadding;
  FelloDialog(
      {this.content,
      this.showCrossIcon = false,
      this.isAddedToScreenStack = false,
      this.defaultPadding = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dialog(
          child: Container(
            padding: EdgeInsets.all(
                defaultPadding ? SizeConfig.pageHorizontalMargins : 0),
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
                    if (isAddedToScreenStack)
                      AppState.backButtonDispatcher.didPopRoute();
                    else
                      Navigator.pop(context);
                  }),
            ),
          ),
      ],
    );
  }
}
