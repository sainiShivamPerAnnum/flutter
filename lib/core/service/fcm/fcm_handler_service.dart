import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/leaderboard_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_rating_dialog.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';

class FcmHandler extends ChangeNotifier {
  static const COMMAND_USER_PRIZE_WIN = 'userPrizeWin';
  static const COMMAND_USER_PRIZE_WIN_2 = 'userPrizeWinWithPrompt';

  final CustomLogger logger = locator<CustomLogger>();
  final _lbService = locator<LeaderboardService>();
  Log log = new Log("FcmHandler");
  ValueChanged<Map> notifListener;
  String url;
  int tab, dailogShowCount;

  Future<bool> handleMessage(Map data) async {
    logger.d(data.toString());
    if (data['command'] != null) {
      String title = data['dialog_title'];
      String body = data['dialog_body'];
      String command = data['command'];
      String url = data['deep_uri'];

      if (url != null && url.isNotEmpty) {
        AppState.delegate.parseRoute(Uri.parse(url));
      }

      if (title != null &&
          title.isNotEmpty &&
          body != null &&
          body.isNotEmpty) {
        logger.d('Recevied message from server: $title $body');
        Map<String, String> _map = {'title': title, 'body': body};
        if (this.notifListener != null) this.notifListener(_map);
      }

      switch (command) {
        case 'cric2020GameEnd':
          {
            logger.i("FCM Command received to end Cricket game");
            //Navigate back to CricketView
            if (AppState.circGameInProgress) {
              AppState.circGameInProgress = false;
              AppState.backButtonDispatcher.didPopRoute();
              Future.delayed(Duration(milliseconds: 100), () {
                BaseUtil.openDialog(
                  addToScreenStack: true,
                  isBarrierDismissable: true,
                  hapticVibrate: false,
                  content: FelloInfoDialog(
                    showCrossIcon: false,
                    title: "Game Over",
                    subtitle:
                        "Your score is: ${data['game_score'] ?? 'Unavailable'}.",
                    action: Container(
                      width: SizeConfig.screenWidth,
                      child: FelloButtonLg(
                        child: Text(
                          "OK",
                          style: TextStyles.body2.bold.colour(Colors.white),
                        ),
                        onPressed: () =>
                            AppState.backButtonDispatcher.didPopRoute(),
                      ),
                    ),
                  ),
                );
              });
            }
            // update cricket scoreboard
            Future.delayed(Duration(milliseconds: 2500), () {
              _lbService
                  .fetchCricketLeaderBoard()
                  .then((value) => _lbService.scrollToUserIndexIfAvaiable());
            });
          }
          break;
        case 'showDialog':
          {
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
                    onPressed: () =>
                        AppState.backButtonDispatcher.didPopRoute(),
                  ),
                ),
              ),
            );
          }
          break;
        case COMMAND_USER_PRIZE_WIN_2:
          {
            if (await reviewDialogCanAppear(COMMAND_USER_PRIZE_WIN_2)) {
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
          break;
        default:
      }
    }

    return true;
  }

  Future<bool> handleNotification(String title, String body) async {
    Map<String, String> _map = {'title': title, 'body': body};
    if (this.notifListener != null) this.notifListener(_map);

    return true;
  }

  addIncomingMessageListener(ValueChanged<Map> listener) {
    this.notifListener = listener;
  }

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
      // if (isUserRated == null) {
      //   await CacheManager.writeCache(
      //       key: CacheManager.CACHE_RATING_IS_RATED,
      //       value: command,
      //       type: CacheType.string);
      //   isUserRated = false.toString();
      // }

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
      logger.e(e.toString());
    }

    if ((isUserRated == null || isUserRated != command) &&
        arr.contains(hitCount) &&
        dailogShowCount < 5) return true;
    return false;
  }
}
