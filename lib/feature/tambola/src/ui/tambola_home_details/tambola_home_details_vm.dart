import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class TambolaHomeDetailsViewModel extends BaseViewModel {
  TambolaService? tambolaService;
  void init() {
    tambolaService = locator<TambolaService>();
    tambolaService!.getPastWeekWinners();
    tambolaService!.getTambolaTickets(limit: 1);
    tambolaService!.getPrizes();
  }

  void dump() {
    tambolaService = null;
  }
}
