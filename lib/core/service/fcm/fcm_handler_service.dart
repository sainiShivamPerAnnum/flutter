import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/golden_ticket_service.dart';
import 'package:felloapp/core/service/leaderboard_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_rating_dialog.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

enum MsgSource { Foreground, Background, Terminated }

class FcmHandler extends ChangeNotifier {
  static const COMMAND_USER_PRIZE_WIN = 'userPrizeWin';
  static const COMMAND_USER_PRIZE_WIN_2 = 'userPrizeWinWithPrompt';
  static const COMMAND_CRIC_GAME_END = 'cric2020GameEnd';
  static const COMMAND_GOLDEN_TICKET_WIN = 'goldenTicketWin';

  final CustomLogger logger = locator<CustomLogger>();
  final _lbService = locator<LeaderboardService>();
  GoldenTicketService _gtService = GoldenTicketService();
  Log log = new Log("FcmHandler");
  ValueChanged<Map> notifListener;
  String url;
  int tab, dailogShowCount;

  Future<bool> handleMessage(Map data, MsgSource source) async {
    bool showSnackbar = true;
    String title = data['dialog_title'];
    String body = data['dialog_body'];
    String command = data['command'];
    String url = data['deep_uri'];

    // If notifications contains an url for navigation
    if (url != null && url.isNotEmpty) {
      if (source == MsgSource.Background || source == MsgSource.Terminated) {
        showSnackbar = false;
        AppState.delegate.parseRoute(Uri.parse(url));
        return true;
      }
    }

    // If message has a command payload
    if (data['command'] != null) {
      showSnackbar = false;
      switch (command) {
        case COMMAND_CRIC_GAME_END:
          {
            logger.i("FCM Command received to end Cricket game");
            //  check if payload has a golden ticket
            if (data['gt_id'] != null && data['gt_id'].toString().isNotEmpty) {
              logger.d(data.toString());
              GoldenTicketService.goldenTicketId = data['gt_id'];
            }
            //Navigate back to CricketView
            if (AppState.circGameInProgress) {
              AppState.circGameInProgress = false;
              AppState.backButtonDispatcher.didPopRoute();
              Future.delayed(Duration(milliseconds: 100), () {
                if (GoldenTicketService.goldenTicketId != null) {
                  _gtService.showInstantGoldenTicketView();
                } else
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
                            onPressed: () {
                              AppState.backButtonDispatcher.didPopRoute();
                              // _gtService.showGoldenTicketAvailableDialog();
                            }),
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
        case COMMAND_GOLDEN_TICKET_WIN:
          {
            // if (AppState.backButtonDispatcher.isAnyDialogOpen())
            //   GoldenTicketService.hasGoldenTicket = true;
            // else
            //   _gtService.showGoldenTicketFlushbar();
          }
          break;
        default:
      }
    }

    // If app is in foreground and needs to show a snackbar
    if (source == MsgSource.Foreground && showSnackbar == true) {
      handleNotification(title, body);
    }

    return true;
  }

  Future<bool> handleNotification(String title, String body) async {
    if (title != null && title.isNotEmpty && body != null && body.isNotEmpty) {
      Map<String, String> _map = {'title': title, 'body': body};
      if (this.notifListener != null) this.notifListener(_map);
    }
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
