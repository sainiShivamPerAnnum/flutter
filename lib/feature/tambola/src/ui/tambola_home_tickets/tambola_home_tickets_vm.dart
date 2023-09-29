import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class TambolaHomeTicketsViewModel extends BaseViewModel {
  TambolaService? tambolaService;
  void init() {
    tambolaService = locator<TambolaService>();

    tambolaService!.getTambolaTickets(limit: 1);
    tambolaService!.fetchWeeklyPicks();
    tambolaService!.getPastWeekWinners();
  }

  @override
  void dispose() {
    tambolaService = null;
    super.dispose();
  }
}
