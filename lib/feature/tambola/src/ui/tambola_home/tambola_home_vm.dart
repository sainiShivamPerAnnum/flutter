/**
 * 
 * // [[DEPRECATED]]
 * 
 */

// import 'dart:async';

// import 'package:felloapp/core/enums/view_state_enum.dart';
// import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
// import 'package:felloapp/ui/architecture/base_vm.dart';
// import 'package:felloapp/util/locator.dart';

// class TambolaHomeViewModel extends BaseViewModel {
//   TambolaService? tambolaService;
//   int activeTambolaCardCount = 0;

//   Future<void> init() async {
//     tambolaService = locator<TambolaService>();
//     state = ViewState.Busy;
//     final res = await tambolaService!.getGameDetails();
//     if (res) {
//       activeTambolaCardCount = await tambolaService!.getTambolaTicketsCount();
//     }
//     // getLastWeekData();
//     setState(ViewState.Idle);
//   }

//   Future<void> refresh() async {
//     await init();
//   }

//   void dump() {
//     activeTambolaCardCount = 0;
//     tambolaService = null;
//     super.dispose();
//   }

//   Future<void> refreshTambolaTickets() async {}
// }
