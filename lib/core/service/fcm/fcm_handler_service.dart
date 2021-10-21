import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FcmHandler extends ChangeNotifier {
  final Logger logger = locator<Logger>();
  Log log = new Log("FcmHandler");
  ValueChanged<Map> notifListener;
  String url;
  int tab;

  Future<bool> handleMessage(Map data) async {
    logger.d(data.toString());
    if (data['command'] != null) {
      String title = data['dialog_title'];
      String body = data['dialog_body'];
      String command = data['command'];

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
            //Navigate back to CricketView
            if (AppState.circGameInProgress) {
              AppState.circGameInProgress = false;
              AppState.backButtonDispatcher.didPopRoute();
            }
          }
          break;
        default:
      }
    }

    // try {
    //   url = data["deep_uri"] ?? '';
    //   print("------------------->" + url);
    //   if (url.isNotEmpty) {
    //     AppState().setFcmData = url;
    //   }
    //   tab = int.tryParse(data["misc_data"]) ?? 0;
    // } catch (e) {
    //   log.error('$e');
    // }

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
}
