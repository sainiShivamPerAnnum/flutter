///Package imports
import 'package:flutter/widgets.dart';

class MeetingNavigationVisibilityController extends ChangeNotifier {
  bool showControls = true;

  ///This variable stores whether the timer is active or not
  ///
  ///This is done to avoid multiple timers running at the same time

  ///This method toggles the visibility of the buttons
  void toggleControlsVisibility() {
    showControls = !showControls;
    notifyListeners();
  }
}
