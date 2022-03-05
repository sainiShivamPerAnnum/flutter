import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/fcm_commands_constants.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
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

  Future<bool> reviewDialogCanAppear(String command) async {
    int hitCount;
    String isUserRated;
    List<int> arr = [2, 5, 7, 11, 13, 15];
    try {
      String htc = await CacheManager.readCache(
          key: CacheManager.CACHE_RATING_HIT_COUNT);
      if (htc == null) {
        await CacheManager.writeCache(
            key: CacheManager.CACHE_RATING_HIT_COUNT,
            value: 2.toString(),
            type: CacheType.string);
        hitCount = 2;
      } else {
        hitCount = int.tryParse(htc) + 1;
        await CacheManager.writeCache(
            key: CacheManager.CACHE_RATING_HIT_COUNT,
            value: hitCount.toString(),
            type: CacheType.string);
      }
      isUserRated =
          await CacheManager.readCache(key: CacheManager.CACHE_RATING_IS_RATED);
      String dsc = await CacheManager.readCache(
          key: CacheManager.CACHE_RATING_DIALOG_OPEN_COUNT);
      if (dsc == null) {
        await CacheManager.writeCache(
            key: CacheManager.CACHE_RATING_DIALOG_OPEN_COUNT,
            value: 1.toString(),
            type: CacheType.string);
        dailogShowCount = 1;
      } else {
        dailogShowCount = int.tryParse(dsc);
      }
    } catch (e) {
      _logger.e(e.toString());
    }

    if ((isUserRated == null || isUserRated != command) &&
        arr.contains(hitCount) &&
        dailogShowCount < 5) return true;
    return false;
  }

  userPrizeWinPrompt() async {
    if (await reviewDialogCanAppear(FcmCommands.COMMAND_USER_PRIZE_WIN_2)) {
      AppState.delegate.appState.setCurrentTabIndex = 2;
      notifyListeners();
      Future.delayed(Duration(seconds: 4), () {
        BaseUtil.openDialog(
            addToScreenStack: true,
            isBarrierDismissable: false,
            hapticVibrate: false,
            content: FelloRatingDialog(
              dailogShowCount: dailogShowCount,
            ));
      });
    }
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
}
