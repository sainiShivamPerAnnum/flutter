// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collection/collection.dart' show IterableExtension;
// import 'package:felloapp/core/enums/cache_type_enum.dart';
// import 'package:felloapp/core/enums/screen_item_enum.dart';
// import 'package:felloapp/core/model/scratch_card_model.dart';
// import 'package:felloapp/core/model/timestamp_model.dart';
// import 'package:felloapp/core/service/cache_manager.dart';
// import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
// import 'package:felloapp/core/service/notifier_services/user_service.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/navigator/router/hero_router.dart';
// import 'package:felloapp/ui/architecture/base_vm.dart';
// import 'package:felloapp/ui/pages/rewards/golden_scratch_card/gt_detailed_view.dart';
// import 'package:felloapp/util/constants.dart';
// import 'package:felloapp/util/custom_logger.dart';
// import 'package:felloapp/util/locator.dart';
// import 'package:flutter/material.dart';

// class ScratchCardsViewModel extends BaseViewModel {
//   //Dependencies
//   final UserService? _userService = locator<UserService>();
//   final CustomLogger? _logger = locator<CustomLogger>();
//   final ScratchCardService? _gtService = locator<ScratchCardService>();

//   //Local Variables
//   List<ScratchCard>? _scratchCardList;
//   List<ScratchCard>? _arrangedScratchCardList;
//   List<DocumentSnapshot> _scratchCardDocs = [];
//   late Query _query;
//   bool _isRequesting = false;
//   bool _isFinish = false;
//   bool showFirst = true;

//   //Getters and Setters
//   List<ScratchCard>? get arrangedScratchCardList =>
//       this._arrangedScratchCardList;

//   List<ScratchCard>? get scratchCardList => this._scratchCardList;

//   set scratchCardList(List<ScratchCard>? value) =>
//       this._scratchCardList = value;

//   set arrangedScratchCardList(List<ScratchCard>? value) =>
//       this._arrangedScratchCardList = value;

// // Core Methods

//   //Local Methods

// //Helper methods

// }
