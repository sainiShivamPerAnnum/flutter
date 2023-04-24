import 'dart:async';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/feature/tambola/lib/src/services/tambola_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class TambolaHomeViewModel extends BaseViewModel {
  TambolaService? tambolaService;
  int activeTambolaCardCount = 0;
  Future<void> init() async {
    tambolaService = locator<TambolaService>();
    state = ViewState.Busy;
    final res = await tambolaService!.getGameDetails();
    if (res) {
      activeTambolaCardCount = await tambolaService!.getTambolaTicketsCount();
    }
    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    activeTambolaCardCount = 0;
    tambolaService = null;
    super.dispose();
  }

  Future<void> refreshTambolaTickets() async {}
}
