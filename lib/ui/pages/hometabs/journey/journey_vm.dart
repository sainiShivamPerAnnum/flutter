import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/milestone_details_modal.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class JourneyPageViewModel extends BaseViewModel {
  final CustomLogger? logger = locator<CustomLogger>();

  final JourneyService _journeyService = locator<JourneyService>();
  final UserService _userService = locator<UserService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  DocumentSnapshot? lastDoc;

  get avatarAnimation => _journeyService.avatarAnimation;

  List<JourneyPage>? get pages => _journeyService.pages;

  List<AvatarPathModel> get customPathDataList =>
      _journeyService.customPathDataList;

  List<MilestoneModel> get currentMilestoneList =>
      _journeyService.currentMilestoneList;

  List<JourneyPathModel> get journeyPathItemsList =>
      _journeyService.journeyPathItemsList;

  List<MilestoneModel> get completedMilestoneList =>
      _journeyService.completedMilestoneList;

  List<ScratchCard> get completedMilestonePrizeList =>
      _journeyService.completedMilestonesPrizeList;

  ScrollController? get mainController => _journeyService.mainController;

  double? get pageWidth => _journeyService.pageWidth;

  double? get pageHeight => _journeyService.pageHeight;

  double? get currentFullViewHeight => _journeyService.currentFullViewHeight;

  int get lastPage => _journeyService.lastPage;

  int get startPage => _journeyService.startPage;

  int get pageCount => _journeyService.pageCount;

  int? get avatarActiveMilestoneLevel => _journeyService.avatarRemoteMlIndex;
  int userMilestoneLevel = 1, userJourneyLevel = 1;
  bool isEnd = false, _isRefreshing = false;

  AnimationController? get controller => _journeyService.controller;

  Offset? get avatarPosition => _journeyService.avatarPosition;

  set controller(AnimationController? c) {
    _journeyService.controller = c;
  }

  Path? get avatarPath => _journeyService.avatarPath;

  bool get isRefreshing => _isRefreshing;

  set isRefreshing(bool isRefreshing) {
    _isRefreshing = isRefreshing;
    notifyListeners();
  }

  void dump() {
    log("Journey View model dispose called");
  }

//Milestones helper getter methods
  bool isComplete(int index) => _journeyService.avatarRemoteMlIndex > index;

  bool isOngoing(int index) => _journeyService.avatarRemoteMlIndex == index;

  bool isInComplete(int? index) => _journeyService.avatarRemoteMlIndex < index;

  Future<void> init(TickerProvider ticker) async {
    log("Journey VM init Called");

    setState(ViewState.Busy);

    await locator<JourneyRepository>().init();
    await _journeyService.init();

    setState(ViewState.Idle);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _journeyService.isLoading = true;
      _journeyService.vsync = ticker;
      logger!.d("Pages length: ${_journeyService.pages?.length ?? 0}");
      _journeyService.mainController =
          ScrollController(initialScrollOffset: 600);
      _journeyService.buildJourney();
    });
  }

  Future<void> updatingJourneyView() async {
    if (isRefreshing) return;
    logger!.d("Refreshing Journey Stats");
    isRefreshing = true;
    await _journeyService.checkForMilestoneLevelChange();
    isRefreshing = false;
  }

  Future<void> checkIfThereIsAMilestoneLevelChange() async =>
      _journeyService.checkForMilestoneLevelChange();

  void canMorePagesBeFetched() =>
      _journeyService.getJourneyLevelBlurData() == null;

  void animateAvatar() {
    _journeyService.animateAvatar();
  }

  void addMilestones(List<JourneyPage> pgs) {
    pgs.forEach((page) {
      currentMilestoneList.addAll(page.milestones);
    });
  }

  void addCustomPathItems(List<JourneyPage> pgs) {
    pgs.forEach((page) {
      customPathDataList.addAll(page.avatarPath);
    });
  }

  void addJourneyPathItems(List<JourneyPage> pgs) {
    pgs.forEach((page) {
      journeyPathItemsList.addAll(page.paths);
    });
  }

  void showMilestoneDetailsModalSheet(
      MilestoneModel milestone, BuildContext context) {
    JOURNEY_MILESTONE_STATUS status = JOURNEY_MILESTONE_STATUS.INCOMPLETE;
    if (_journeyService.avatarRemoteMlIndex > milestone.index) {
      status = JOURNEY_MILESTONE_STATUS.COMPLETED;
      _analyticsService.track(
          eventName: AnalyticsEvents.journeyMileStoneTapped,
          properties:
              AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
            "version": _userService.userJourneyStats!.version,
            "Capsule text": AnalyticsProperties.getJouneryCapsuleText(),
            "MileStone text": AnalyticsProperties.getJourneyMileStoneText(),
            "MileStone sub Text":
                AnalyticsProperties.getJourneyMileStoneSubText(),
            "MileStone number": milestone.index,
            "Milestone completed": true,
          }));
    } else if (_journeyService.avatarRemoteMlIndex == milestone.index) {
      status = JOURNEY_MILESTONE_STATUS.ACTIVE;
      _analyticsService.track(
          eventName: AnalyticsEvents.journeyMileStoneTapped,
          properties:
              AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
            "version": _userService.userJourneyStats!.version,
            "Capsule text": AnalyticsProperties.getJouneryCapsuleText(),
            "MileStone text": AnalyticsProperties.getJourneyMileStoneText(),
            "MileStone sub Text":
                AnalyticsProperties.getJourneyMileStoneSubText(),
            "MileStone number": milestone.index,
            "Milestone completed": false,
          }));
    } else {
      _analyticsService.track(
          eventName: AnalyticsEvents.journeyMileStoneTapped,
          properties:
              AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
            "version": _userService.userJourneyStats!.version,
            "Capsule text": AnalyticsProperties.getJouneryCapsuleText(),
            "MileStone text": AnalyticsProperties.getJourneyMileStoneText(),
            "MileStone sub Text":
                AnalyticsProperties.getJourneyMileStoneSubText(),
            "MileStone number": milestone.index,
            "Milestone completed": false,
          }));
    }
    log("Current Screen Stack: ${AppState.screenStack}");

    BaseUtil.openModalBottomSheet(
      backgroundColor: Colors.transparent,
      isBarrierDismissible: true,
      addToScreenStack: true,
      hapticVibrate: true,
      isScrollControlled: true,
      content: JourneyMilestoneDetailsModalSheet(
        milestone: milestone,
        version: _userService.userJourneyStats!.version,
        status: status,
      ),
    );
  }

  ///---------- TEST METHODS [[ ONLY FOR DEV USE ]]  ----------///

// testCreateAvatarPath(List<AvatarPathModel> pathListData) {
//   _journeyService.drawPath(pathListData);
// }

// void testReadyAvatarToPath() {
//   _journeyService.setAvatarPostion();
//   _journeyService.createAvatarAnimationObject();
// }

// void testAnimate() {
//   _journeyService.animateAvatar();
// }
// setDimensions(BuildContext context) {
//   JourneyPageViewModel.pageHeight = MediaQuery.of(context).size.width * 2.165;
//   JourneyPageViewModel.pageWidth = MediaQuery.of(context).size.width;
//   JourneyPageViewModel.currentFullViewHeight = JourneyPageViewModel.pageHeight * noOfSlides;
// }
}
