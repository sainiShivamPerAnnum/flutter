import 'dart:async';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class TambolaHomeTicketsViewModel extends BaseViewModel {
  TambolaService? tambolaService;
  Future<void> init() async {
    setState(ViewState.Busy);
    tambolaService = locator<TambolaService>();
    await tambolaService!.fetchWeeklyPicks();
    await tambolaService!.getBestTambolaTickets();
    unawaited(tambolaService!.getOffers());
    unawaited(tambolaService!.getPrizes());
    unawaited(tambolaService!.getPastWeekWinners());
    unawaited(tambolaService!.getTambolaTickets(limit: 1));
    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    tambolaService = null;
    super.dispose();
  }
}
