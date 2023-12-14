import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_in_app_review.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class FcmHandlerDataPayloads extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();

  ValueChanged<Map>? notifListener;
  String? url;
  int? tab, dailogShowCount = 0;

  Future<void> userPrizeWinPrompt() async {
    AppState.delegate!.appState.setCurrentTabIndex = 3;
    notifyListeners();
    Future.delayed(
      const Duration(seconds: 4),
      () {
        BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissible: false,
          hapticVibrate: false,
          content: const FelloInAppReview(),
        );
      },
    );
  }

  showDialog(title, body) {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissible: true,
      hapticVibrate: false,
      content: FelloInfoDialog(
        title: title,
        subtitle: body,
        action: SizedBox(
          width: SizeConfig.screenWidth,
          child: FelloButtonLg(
            child: Text(
              "OK",
              style: TextStyles.body2.bold.colour(Colors.white),
            ),
            onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
          ),
        ),
      ),
    );
  }

  updateSubscriptionStatus(data) {
    _logger.d(data);
  }
}
