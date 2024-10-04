import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';

///Package imports
import 'package:flutter/material.dart';

///[WhiteboardScreenshareStore] is a store that stores the state of the whiteboard screenshare
class WhiteboardScreenshareStore extends ChangeNotifier {
  MeetingStore meetingStore;
  bool isFullScreen = false;

  WhiteboardScreenshareStore({required this.meetingStore}) {
    isFullScreen = meetingStore.isScreenshareWhiteboardFullScreen;
  }

  void toggleFullScreen() {
    isFullScreen = !isFullScreen;
    meetingStore.isScreenshareWhiteboardFullScreen = isFullScreen;
    notifyListeners();
  }
}
