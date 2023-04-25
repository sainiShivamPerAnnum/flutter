import 'dart:async';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_view.dart';
import 'package:felloapp/util/locator.dart';

import '../../../../../navigator/router/ui_pages.dart';

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
    // getLastWeekData();
    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    activeTambolaCardCount = 0;
    tambolaService = null;
    super.dispose();
  }

  Future<void> refreshTambolaTickets() async {}

  Future<void> getLastWeekData() async {
    final data = await tambolaService!.getLastWeekData();

    if (data != null) {
      AppState.delegate!.appState.currentAction ==
          PageAction(
            state: PageState.addWidget,
            page: LastWeekOverviewConfig,
            widget: LastWeekOverView(
                // model: data,
                ),
          );
    }
  }
}
