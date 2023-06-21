import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class TambolaHomeDetailsViewModel extends BaseViewModel {
  TambolaService? tambolaService;
  GameModel? tambolaGameData;
  void init() {
    tambolaService = locator<TambolaService>();
    tambolaGameData = tambolaService!.tambolaGameData;
    tambolaService!.getPastWeekWinners();
    tambolaService!.getPrizes();
  }

  void dump() {
    tambolaService = null;
  }
}
