import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:rive/rive.dart';

class DailyPicksDrawModel extends BaseModel {
  BaseUtil _baseUtil = locator<BaseUtil>();
  DBModel _dbModel = locator<DBModel>();
  final Log log = new Log("DailyPicksDraw-ViewModel");
  bool isInitCompleted = false;
  RiveAnimationController boxController = SimpleAnimation('idle');
  double radius = 0;
  double rowWidth = 0;
  double opacity = 0;
  bool showTxt = false;
  double ringWidth = 0;
  List<int> todaysPicks = [];

  init() async {
    setState(ViewState.Busy);
    await fetchWeeklyPicks();
    setState(ViewState.Idle);
    startAnimation();
  }

  startAnimation() {
    Future.delayed(Duration(seconds: 1), () {
      showPicksDraw();
    }).then((_) {
      Future.delayed(Duration(seconds: 1), () {
        showText();
      }).then((value) {
        // FOR AUTOMATICALLY REPLACING THIS SCREEN WITH THE TAMBOLA HOME SCREEN
        // Future.delayed(Duration(seconds: 2), () {
        //   delegate.appState.currentAction =
        //       PageAction(state: PageState.replace, page: THomePageConfig);
        // });
      });
    });
  }

  showPicksDraw() {
    radius = SizeConfig.screenWidth * 0.14;
    rowWidth = SizeConfig.screenWidth;
    ringWidth = SizeConfig.screenWidth * 0.1;
    opacity = 1;
    notifyListeners();
  }

  showText() {
    showTxt = true;
    notifyListeners();
  }

  fetchWeeklyPicks() async {
    await Future.delayed(Duration(seconds: 4));
    // !_baseUtil.weeklyDrawFetched
    if (true) {
      try {
        log.debug('Requesting for weekly picks');
        DailyPick _picks = await _dbModel.getWeeklyPicks();
        _baseUtil.weeklyDrawFetched = true;
        if (_picks != null) {
          _baseUtil.weeklyDigits = _picks;
        }
        switch (DateTime.now().weekday) {
          case 1:
            _baseUtil.todaysPicks = _baseUtil.weeklyDigits.mon;
            break;
          case 2:
            _baseUtil.todaysPicks = _baseUtil.weeklyDigits.tue;
            break;
          case 3:
            _baseUtil.todaysPicks = _baseUtil.weeklyDigits.wed;
            break;
          case 4:
            _baseUtil.todaysPicks = _baseUtil.weeklyDigits.thu;
            break;
          case 5:
            _baseUtil.todaysPicks = _baseUtil.weeklyDigits.fri;
            break;
          case 6:
            _baseUtil.todaysPicks = _baseUtil.weeklyDigits.sat;
            break;
          case 7:
            _baseUtil.todaysPicks = _baseUtil.weeklyDigits.sun;
            break;
        }
        if (_baseUtil.todaysPicks == null) {
          todaysPicks = [1, 2, 3];
          log.debug("Today's picks are not generated yet");
        }
        notifyListeners();
      } catch (e) {
        log.error('$e');
      }
    }
    if (_baseUtil.todaysPicks != null) todaysPicks = _baseUtil.todaysPicks;
    print(todaysPicks);
  }
}
