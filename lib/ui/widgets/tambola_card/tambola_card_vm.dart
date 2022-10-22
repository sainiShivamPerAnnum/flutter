import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';

class TambolaCardModel extends BaseViewModel {
  final GameRepo _gamesRepo = locator<GameRepo>();
  final TambolaService _tambolaService = locator<TambolaService>();

  //VARIABLES
  GameModel _game;
  bool _isGameModelLoading = true;

  int _dailyPicksCount;
  List<int> _todaysPicks;

  //GETTER SETTER

  GameModel get game => _game;
  set game(value) {
    this._game = value;
  }

  bool get isGameModelLoading => _isGameModelLoading;
  set isGameModelLoading(value) {
    this._isGameModelLoading = _isGameModelLoading;
  }

  int get dailyPicksCount => _dailyPicksCount;
  List<int> get todaysPicks => _todaysPicks;

  init() async {
    setState(ViewState.Busy);
    await getGameDetails();
    await _tambolaService.fetchWeeklyPicks();
    fetchPickCounts();
    setState(ViewState.Idle);
  }

  fetchPickCounts() {
    _dailyPicksCount = _tambolaService.dailyPicksCount;
    _todaysPicks = _tambolaService.todaysPicks;

    notifyListeners();
  }

  getGameDetails() async {
    final response =
        await _gamesRepo.getGameByCode(gameCode: Constants.GAME_TYPE_TAMBOLA);
    if (response.isSuccess()) {
      game = response.model;
      isGameModelLoading = false;
    } else {
      BaseUtil.showNegativeAlert("", response.errorMessage);
    }
  }
}
