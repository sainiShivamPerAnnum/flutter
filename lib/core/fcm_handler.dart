import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class FcmHandler extends ChangeNotifier {
  Log log = new Log("FcmHandler");
  ValueChanged<Map> notifListener;
  String url;
  int tab;

  Future<bool> handleMessage(Map data) async {
    log.debug(data.toString());
    if (data['command'] != null) {
      String title = data['dialog_title'];
      String body = data['dialog_body'];
      if (title != null &&
          title.isNotEmpty &&
          body != null &&
          body.isNotEmpty) {
        log.debug('Recevied message from server: $title $body');
        Map<String, String> _map = {'title': title, 'body': body};
        if (this.notifListener != null) this.notifListener(_map);
      }
    }
    try {
      url = data["deep_uri"] ?? '';
      print("------------------->" + url);
      AppState().setFcmData = url;

      tab = int.tryParse(data["misc_data"]) ?? 0;
    }catch(e) {
      log.error('$e');
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
}
