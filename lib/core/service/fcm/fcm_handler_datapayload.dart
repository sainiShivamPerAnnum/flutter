import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_rating_dialog.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class FcmHandlerDataPayloads extends ChangeNotifier {
  final _logger = locator<CustomLogger>();

  ValueChanged<Map> notifListener;
  String url;
  int tab, dailogShowCount = 0;

  userPrizeWinPrompt() async {
    AppState.delegate.appState.setCurrentTabIndex = 3;
    notifyListeners();
    Future.delayed(Duration(seconds: 4), () {
      BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissable: false,
          hapticVibrate: false,
          content: FelloRatingDialog());
    });
  }

  showDialog(title, body) {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissable: true,
      hapticVibrate: false,
      content: FelloInfoDialog(
        showCrossIcon: false,
        title: title,
        subtitle: body,
        action: Container(
          width: SizeConfig.screenWidth,
          child: FelloButtonLg(
            child: Text(
              "OK",
              style: TextStyles.body2.bold.colour(Colors.white),
            ),
            onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
          ),
        ),
      ),
    );
  }

  updateSubscriptionStatus(data) {
    _logger.d(data);
  }
}
