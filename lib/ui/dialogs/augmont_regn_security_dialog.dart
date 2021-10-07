import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class AugmontRegnSecurityDialog extends StatelessWidget {
  final String title;
  final String text;
  final String imagePath;
  double _height, _width;

  AugmontRegnSecurityDialog(
      {@required this.title, @required this.text, this.imagePath});

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 1.0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
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
                        height: 150,
                        width: 150,
                      )
                    : Container(),
                Text(
                  text,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: SizeConfig.smallTextSize * 1.4,
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }
}
