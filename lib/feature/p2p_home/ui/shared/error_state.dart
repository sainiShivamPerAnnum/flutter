import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? btnLabel;

  const ErrorPage({
    this.onPressed,
    this.btnLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Oops, this one is on us',
              style:
                  TextStyles.rajdhaniSB.title4.colour(UiConstants.kTextColor),
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Text(
              'Our team is trying to resolve it earliest possible',
              style: TextStyles.sourceSans.body3.colour(
                UiConstants.textGray70,
              ),
            ),
            SizedBox(
              height: SizeConfig.padding42,
            ),
            AppImage(
              'assets/images/sip_error.png',
              height: SizeConfig.padding252,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: SizeConfig.padding20,
          left: SizeConfig.padding20,
          right: SizeConfig.padding20,
        ),
        child: SecondaryButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          label: btnLabel ?? 'CLOSE',
        ),
      ),
    );
  }
}
