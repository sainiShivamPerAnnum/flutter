import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecurityModalSheet extends StatelessWidget {
  const SecurityModalSheet();

  @override
  Widget build(BuildContext context) {
    final baseProvider = Provider.of<BaseUtil>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 1.5,
          ),
          Expanded(
            child: Image.asset(
              "images/safe-small.png",
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 1.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Secure Fello',
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: UiConstants.primaryColor,
                    fontSize: SizeConfig.largeTextSize * 1.2,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Text(
              'Protect your Fello account by using your phone\'s default security.',
              textAlign: TextAlign.center,
              style: TextStyles.body2),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.padding16, bottom: SizeConfig.padding24),
            width: SizeConfig.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FelloButtonLg(
                  color: UiConstants.primaryColor,
                  child: Text('Enable',
                      style: TextStyles.body2.bold.colour(Colors.white)),
                  onPressed: () {
                    baseProvider.flipSecurityValue(true);
                    AppState.backButtonDispatcher.didPopRoute();
                  },
                ),
                SizedBox(height: SizeConfig.padding16),
                FelloButtonLg(
                  color: UiConstants.tertiarySolid,
                  child: Text('Not Now',
                      style: TextStyles.body2.bold.colour(Colors.white)),
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
