import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class FcmHandler extends ChangeNotifier
{
  Log log = new Log("FcmHandler");
  ValueChanged<Map> notifListener;

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
        if (this.notifListener != null)
          this.notifListener(_map);
      }
    }
    return true;
  }

  Future<bool> handleNotification(String title, String body) async{
    Map<String, String> _map = {'title': title, 'body': body};
    if (this.notifListener != null)
      this.notifListener(_map);

    return true;
  }

  addIncomingMessageListener(ValueChanged<Map> listener) {
    this.notifListener = listener;
  }

}

