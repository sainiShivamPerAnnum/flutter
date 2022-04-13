import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key key}) : super(key: key);

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
            ElevatedButton(
              onPressed: () {
                AppState.screenStack.removeLast();
                AppState.screenStack.add(ScreenItem.dialog);
                AppState.backButtonDispatcher.didPopRoute();
              },
              child: Text("Pop Screen"),
            )
          ],
        ),
      ),
    );
  }
}
