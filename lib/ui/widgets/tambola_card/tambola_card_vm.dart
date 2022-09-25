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
  bool isForDemo = false;

  //GETTER SETTER

  GameModel get game => _game;
  set game(value) {
    this._game = value;
  }

  bool get isGameModelLoading => _isGameModelLoading;
  set isGameModelLoading(value) {
    this._isGameModelLoading = _isGameModelLoading;
  }

  int get dailyPicksCount => _tambolaService.dailyPicksCount ?? 0;
  List<int> get todaysPicks => _tambolaService.todaysPicks;

  init() async {
    await getGameDetails();
  }

  getGameDetails() async {
    final response =
        await _gamesRepo.getGameByCode(gameCode: Constants.GAME_TYPE_TAMBOLA);
    if (response.isSuccess()) {
      game = response.model;
      isGameModelLoading = false;
    }
  }
}
