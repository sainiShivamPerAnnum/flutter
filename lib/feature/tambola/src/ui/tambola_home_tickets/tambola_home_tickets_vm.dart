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
    await tambolaService!.getBestTambolaTickets();
    await tambolaService!.fetchWeeklyPicks();
    unawaited(tambolaService!.getPastWeekWinners());
    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    tambolaService = null;
    super.dispose();
  }
}
