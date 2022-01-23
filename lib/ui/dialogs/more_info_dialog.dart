import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter/material.dart';

class MoreInfoDialog extends StatelessWidget {
  final String title;
  final String text;
  final String imagePath;
  double _height, _width;

  MoreInfoDialog({@required this.title, @required this.text, this.imagePath});

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
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
                    style: TextStyle(fontSize: 24),
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
                          height: 200,
                          width: 200,
                        )
                      : Container(),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
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
