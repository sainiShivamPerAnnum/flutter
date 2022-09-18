import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FaqButtonRounded extends StatelessWidget {
  final String category;
  const FaqButtonRounded({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: SizeConfig.avatarRadius,
      child: IconButton(
        icon: Icon(
          Icons.question_mark_rounded,
          color: Colors.white,
          size: SizeConfig.avatarRadius * 0.8,
        ),
        onPressed: () {
          Haptic.vibrate();

          //TODO open FAQs webview using category
        },
      ),
    );
  }
}
