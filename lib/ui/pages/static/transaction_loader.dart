import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TransactionLoader extends StatelessWidget {
  const TransactionLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(
              color: UiConstants.primaryColor,
              size: SizeConfig.padding24,
            ),
            SizedBox(height: 60),
            Text(
              "Transaction in progress, please wait.",
              style: TextStyles.body2.bold.colour(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
