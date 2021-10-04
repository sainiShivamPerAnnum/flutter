import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:rive/rive.dart';

class DailyPicksDrawViewModel extends BaseModel {
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
  List<int> todaysPicks;

  init() async {
    setState(ViewState.Busy);
    await _baseUtil.fetchWeeklyPicks();
    todaysPicks = _baseUtil.todaysPicks;
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
}
