import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class FcmHandler extends ChangeNotifier {
  Log log = new Log("FcmHandler");
  ValueChanged<Map> playListener;
  ValueChanged<Map> saveListener;
  ValueChanged<Map> referListener;

  FcmHandler() {}

  Future<bool> handleMessage(Map data) async{
    log.debug(data.toString());
    if(data['command'] != null){
      String title = data['dialog_title'];
      String body = data['dialog_body'];
      if(title != null && title.isNotEmpty && body != null && body.isNotEmpty) {
        log.debug('Recevied message from server: $title $body');
        Map<String, String> _map = {'title': title, 'body': body};
        if(playListener != null) playListener(_map);
        else if(saveListener != null) saveListener(_map);
        else if(referListener != null) referListener(_map);
      }
    }
    return true;
  }

  addIncomingMessageListener(ValueChanged<Map> listener, int page) {
    if(page == 0)playListener = listener;
    else if(page == 1)saveListener = listener;
    else if(page == 2)referListener = listener;
  }

}