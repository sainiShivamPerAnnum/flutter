import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class MoreInfoDialog extends StatelessWidget {
  final String title;
  final String text;
  final String imagePath;
  final Size imageSize;

  MoreInfoDialog(
      {@required this.title,
      @required this.text,
      this.imagePath,
      this.imageSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 1.0,
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyles.title4.bold,
                  ),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  (imagePath != null && imagePath.isNotEmpty)
                      ? Image.asset(
                          imagePath,
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          height:
                              imageSize?.height ?? SizeConfig.screenWidth * 0.8,
                          width:
                              imageSize?.width ?? SizeConfig.screenWidth * 0.8,
                        )
                      : Container(),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyles.body2,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )),
        Material(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
          ),
        )
      ],
    );
  }
}
