//Project Imports
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

//Dart and Flutter Imports
import 'package:flutter/material.dart';

//Pub Imports
import 'package:provider/provider.dart';

class WalkthroughModalSheet extends StatelessWidget {
  const WalkthroughModalSheet();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(
          top: 25.0, bottom: 25.0, left: 45.0, right: 45.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 1.5,
          ),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Walkthrough',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: UiConstants.primaryColor,
                        fontSize: SizeConfig.largeTextSize * 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.5,
          ),
          Text(
              'Do you want to watch a quick walkthrough to understand how Fello works? \n This can be viewed later in the help section as well.',
              style: TextStyle(
                  color: UiConstants.textColor,
                  fontSize: SizeConfig.mediumTextSize * 1.4)),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.35,
                height: SizeConfig.blockSizeVertical * 5,
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(100.0),
                    color: UiConstants.primaryColor),
                child: new Material(
                  child: MaterialButton(
                    child: Text(
                      'Yes, I do',
                      style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.white,
                          fontSize: SizeConfig.largeTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    highlightColor: Colors.white30,
                    splashColor: Colors.white30,
                    onPressed: () {
                      appState.currentAction = PageAction(
                          state: PageState.addPage, page: WalkThroughConfig);
                      Navigator.of(context).pop();
                    },
                  ),
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(100.0),
                ),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.35,
                height: SizeConfig.blockSizeVertical * 5,
                // decoration: BoxDecoration(
                //   borderRadius: new BorderRadius.circular(100.0),
                //   border: Border.all(color : UiConstants.accentColor)
                // ),
                child: new Material(
                  child: MaterialButton(
                    child: Text(
                      'Not now',
                      style: Theme.of(context).textTheme.button.copyWith(
                          color: UiConstants.accentColor,
                          fontSize: SizeConfig.largeTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    highlightColor: Colors.grey[300],
                    splashColor: Colors.grey[300],
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        side: BorderSide(color: UiConstants.accentColor)),
                  ),
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 5,
          ),
        ],
      ),
    );
  }
}
