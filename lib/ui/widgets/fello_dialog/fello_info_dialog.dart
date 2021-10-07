import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FelloInfoDialog extends StatelessWidget {
  final String title, subtitle, body;
  final Widget customContent;
  FelloInfoDialog({this.title, this.body, this.subtitle, this.customContent});
  @override
  Widget build(BuildContext context) {
    return FelloDialog(
      content: customContent != null
          ? customContent
          : Container(
              margin: EdgeInsets.all(SizeConfig.globalMargin * 2),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 4.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: UiConstants.primaryColor,
                        fontSize: SizeConfig.largeTextSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: SizeConfig.mediumTextSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    body,
                    style: TextStyle(
                      color: Colors.black54,
                      letterSpacing: 4,
                      fontSize: SizeConfig.mediumTextSize,
                    ),
                  )
                ],
              ),
            ),
      showCrossIcon: true,
    );
  }
}
