import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/milestone_details_modal.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class JourneyPageViewModel extends BaseViewModel {
  final logger = locator<CustomLogger>();
  final _dbModel = locator<DBModel>();
  final _journeyService = locator<JourneyService>();
  final _userService = locator<UserService>();
  DocumentSnapshot lastDoc;

  get avatarAnimation => _journeyService.avatarAnimation;
  List<JourneyPage> get pages => _journeyService.pages;
  List<AvatarPathModel> get customPathDataList =>
      _journeyService.customPathDataList;
  List<MilestoneModel> get currentMilestoneList =>
      _journeyService.currentMilestoneList;
  List<JourneyPathModel> get journeyPathItemsList =>
      _journeyService.journeyPathItemsList;
  ScrollController get mainController => _journeyService.mainController;

  // set avatarAnimation(value) => this._avatarAnimation = value;
  double get pageWidth => _journeyService.pageWidth;
  double get pageHeight => _journeyService.pageHeight;
  double get currentFullViewHeight => _journeyService.currentFullViewHeight;
  int get lastPage => _journeyService.lastPage;
  int get startPage => _journeyService.startPage;
  int get pageCount => _journeyService.pageCount;
  int get avatarActiveMilestoneLevel => _journeyService.avatarRemoteMlIndex;
  int userMilestoneLevel = 1, userJourneyLevel = 1;
  bool _isLoading = false,
      isEnd = false,
      _isRefreshing = false,
      _isLoaderRequired = false;

  AnimationController get controller => _journeyService.controller;

  Offset get avatarPosition => _journeyService.avatarPosition;

  set controller(AnimationController c) {
    _journeyService.controller = c;
  }

  Path get avatarPath => _journeyService.avatarPath;

  // set controller(value) => this._controller = value;

  bool get isLoading => this._isLoading;
  bool get isLoaderRequired => this._isLoaderRequired;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  set isLoaderRequired(bool value) {
    this._isLoaderRequired = value;
    notifyListeners();
  }

  bool get isRefreshing => this._isRefreshing;

  set isRefreshing(bool isRefreshing) {
    this._isRefreshing = isRefreshing;
    notifyListeners();
  }

  dump() {
    log("Journey View model dispose called");
  }

  journeyRepo() {
    print(_journeyService.vsync.toString());
  }

//Milestones helper getter methods
  isComplete(int index) => (_journeyService.avatarRemoteMlIndex > index);
  isOngoing(int index) => (_journeyService.avatarRemoteMlIndex == index);
  isInComplete(int index) => (_journeyService.avatarRemoteMlIndex < index);

  init(TickerProvider ticker) async {
    log("Journey VM init Called");
    isLoading = true;
    _journeyService.vsync = ticker;
    logger.d("Pages length: ${_journeyService.pages.length}");
    _journeyService.getAvatarCachedMilestoneIndex();
    await _journeyService.updateUserJourneyStats();
    if (_journeyService.isThereAnyMilestoneLevelChange()) {
      _journeyService.createPathForAvatarAnimation(
          _journeyService.avatarCachedMlIndex,
          _journeyService.avatarRemoteMlIndex);
      _journeyService.createAvatarAnimationObject();
    } else {
      _journeyService.placeAvatarAtTheCurrentMileStone();
    }

    _journeyService.mainController = ScrollController(initialScrollOffset: 400);
    isLoading = false;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (_journeyService.avatarRemoteMlIndex < 3) {
        await _journeyService.mainController.animateTo(
          0,
          duration: const Duration(seconds: 2),
          curve: Curves.easeOutCubic,
        );
      } else
        await _journeyService.scrollPageToAvatarPosition();
      _journeyService.animateAvatar();
      _journeyService.mainController.addListener(() {
        if (_journeyService.mainController.offset >
            _journeyService.mainController.position.maxScrollExtent) {
          if (!canMorePagesBeFetched())
            return updatingJourneyView();
          else
            return addPageToTop();
        }
      });
    });
  }

  Future<void> updatingJourneyView() async {
    if (isRefreshing) return;
    logger.d("Refreshing Journey Stats");
    isRefreshing = true;
    await _journeyService.checkForMilestoneLevelChange();
    isRefreshing = false;
  }

  Future<void> checkIfThereIsAMilestoneLevelChange() async =>
      _journeyService.checkForMilestoneLevelChange();

  //  (pages.length - model.page) * pageHeight +
  //               pageHeight -
  //               (pageHeight * model.coords[1]))

  // init(int stPage) async {
  //   isLoading = true;
  //   await Future.delayed(Duration(seconds: 5));
  //   pages = pages.sublist(0, 2);
  //   pageWidth = SizeConfig.screenWidth;
  //   pageHeight = pageWidth * 2.165;
  //   startPage = stPage;
  //   pageCount = pages.length;
  //   currentFullViewHeight = pageHeight * pageCount;
  //   startPage = pages[0].page;
  //   lastPage = pages[pages.length - 1].page;
  //   setCurrentMilestones();
  //   setCustomPathItems();
  //   setJourneyPathItems();
  //   // avatarPath = drawPath();
  //   // setAvatarPostion();
  //   createPathForAvatarAnimation(2, 5);

  //   await Future.delayed(Duration(seconds: 2));
  //   isLoading = false;
  // }

  addPageToTop() async {
    if (isLoading) return;
    logger.d("Adding page to top");
    if (!canMorePagesBeFetched()) return;
    isLoading = true;
    isLoaderRequired = true;
    final prevPageslength = pages.length;
    await _journeyService.fetchMoreNetworkPages();
    logger.d("Total Pages length: ${pages.length}");
    if (prevPageslength < pages.length)
      await mainController.animateTo(
        mainController.offset + 100,
        curve: Curves.easeOutCubic,
        duration: Duration(seconds: 1),
      );
    _journeyService.placeAvatarAtTheCurrentMileStone();
    // _journeyService.refreshJourneyPath();
    isLoaderRequired = false;
    isLoading = false;
  }

  canMorePagesBeFetched() =>
      _journeyService.getJourneyLevelBlurData() == null ? true : false;

  animateAvatar() {
    _journeyService.animateAvatar();
  }

  // addPageToBottom(pgs) {
  //   pages.add(pgs);
  //   pageCount = pages.length;
  //   currentFullViewHeight = pageHeight * pageCount;
  //   addMilestones(pages);
  //   addMilestones(pgs);
  //   addCustomPathItems(pgs);
  //   addJourneyPathItems(pgs);
  //   notifyListeners();
  // }

  addMilestones(List<JourneyPage> pgs) {
    pgs.forEach((page) {
      currentMilestoneList.addAll(page.milestones);
    });
  }

  addCustomPathItems(List<JourneyPage> pgs) {
    pgs.forEach((page) {
      customPathDataList.addAll(page.avatarPath);
    });
  }

  addJourneyPathItems(List<JourneyPage> pgs) {
    pgs.forEach((page) {
      journeyPathItemsList.addAll(page.paths);
    });
  }

  showMilestoneDetailsModalSheet(
      MilestoneModel milestone, BuildContext context) {
    JOURNEY_MILESTONE_STATUS status = JOURNEY_MILESTONE_STATUS.INCOMPLETE;
    if (_journeyService.avatarRemoteMlIndex > milestone.index)
      status = JOURNEY_MILESTONE_STATUS.COMPLETED;
    else if (_journeyService.avatarRemoteMlIndex == milestone.index)
      status = JOURNEY_MILESTONE_STATUS.ACTIVE;
    log("Current Screen Stack: ${AppState.screenStack}");

    return BaseUtil.openModalBottomSheet(
      backgroundColor: Colors.transparent,
      isBarrierDismissable: true,
      addToScreenStack: true,
      hapticVibrate: true,
      isScrollControlled: true,
      content: JourneyMilestoneDetailsModalSheet(
        milestone: milestone,
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
