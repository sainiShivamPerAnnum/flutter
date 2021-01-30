import 'package:felloapp/util/assets.dart';
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 1.0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: _height * 0.6,
        width: _width,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28),
              ),
              Divider(),
              (imagePath != null && imagePath.isNotEmpty)
                  ? Image.asset(
                      Assets.iciciGraphic,
                      fit: BoxFit.contain,
                      height: 100,
                      width: 100,
                    )
                  : Container(),
              Text(
                text,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
