// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collection/collection.dart' show IterableExtension;
// import 'package:felloapp/core/enums/cache_type_enum.dart';
// import 'package:felloapp/core/enums/screen_item_enum.dart';
// import 'package:felloapp/core/model/golden_ticket_model.dart';
// import 'package:felloapp/core/model/timestamp_model.dart';
// import 'package:felloapp/core/service/cache_manager.dart';
// import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
// import 'package:felloapp/core/service/notifier_services/user_service.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/navigator/router/hero_router.dart';
// import 'package:felloapp/ui/architecture/base_vm.dart';
// import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/gt_detailed_view.dart';
// import 'package:felloapp/util/constants.dart';
// import 'package:felloapp/util/custom_logger.dart';
// import 'package:felloapp/util/locator.dart';
// import 'package:flutter/material.dart';

// class GoldenTicketsViewModel extends BaseViewModel {
//   //Dependencies
//   final UserService? _userService = locator<UserService>();
//   final CustomLogger? _logger = locator<CustomLogger>();
//   final GoldenTicketService? _gtService = locator<GoldenTicketService>();

//   //Local Variables
//   List<GoldenTicket>? _goldenTicketList;
//   List<GoldenTicket>? _arrangedGoldenTicketList;
//   List<DocumentSnapshot> _goldenTicketDocs = [];
//   late Query _query;
//   bool _isRequesting = false;
//   bool _isFinish = false;
//   bool showFirst = true;

//   //Getters and Setters
//   List<GoldenTicket>? get arrangedGoldenTicketList =>
//       this._arrangedGoldenTicketList;

//   List<GoldenTicket>? get goldenTicketList => this._goldenTicketList;

//   set goldenTicketList(List<GoldenTicket>? value) =>
//       this._goldenTicketList = value;

//   set arrangedGoldenTicketList(List<GoldenTicket>? value) =>
//       this._arrangedGoldenTicketList = value;

// // Core Methods

//   //Local Methods

// //Helper methods

// }
