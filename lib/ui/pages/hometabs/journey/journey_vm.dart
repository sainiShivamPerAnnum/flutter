import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/milestone_details_modal.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class JourneyPageViewModel extends BaseModel {
  final logger = locator<CustomLogger>();
  final _dbModel = locator<DBModel>();
  final _journeyService = locator<JourneyService>();
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
  bool _isLoading = false, isEnd = false;

  AnimationController get controller => _journeyService.controller;

  Offset get avatarPosition => _journeyService.avatarPosition;

  set controller(AnimationController c) {
    _journeyService.controller = c;
  }

  Path get avatarPath => _journeyService.avatarPath;

  // set controller(value) => this._controller = value;

  bool get isLoading => this._isLoading;

  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  dump() {
    _journeyService.mainController?.dispose();
    controller?.dispose();
  }

  journeyRepo() {
    print(_journeyService.vsync.toString());
  }

  init(TickerProvider ticker) async {
    log("Journey VM init Called");
    isLoading = true;
    print("Journey Ticker: ${ticker.toString()}");
    _journeyService.vsync = ticker;
    // Map<String, dynamic> res =
    //     await _dbModel.fetchJourneyPage(lastDoc: lastDoc);
    // pages = res["pages"];
    // await _journeyService.fetchNetworkPages();
    logger.d("Pages length: ${_journeyService.pages.length}");
    // lastDoc = res["lastDoc"];
    // log("${lastDoc.id}");
    _journeyService.setCurrentMilestones();
    _journeyService.setCustomPathItems();
    _journeyService.setJourneyPathItems();
    _journeyService.getAvatarCachedMilestoneIndex();
    await _journeyService.updateUserJourneyStats();

    if (_journeyService.isThereAnyMilestoneLevelChange()) {
      _journeyService.createPathForAvatarAnimation(
          _journeyService.avatarCachedMlIndex,
          _journeyService.avatarRemoteMlIndex);
      _journeyService.createAvatarAnimationObject();
    } else {
      _journeyService.placeAvatarAtTheCurrentMileStone();
      // baseGlow = 1;
    }

    _journeyService.mainController = ScrollController();
    //   ..addListener(() {
    //     if (mainController.offset > mainController.position.maxScrollExtent &&
    //         !isLoading &&
    //         !isEnd) addPageToTop(mainController.offset);
    //   });
    isLoading = false;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await _journeyService.scrollPageToAvatarPosition();
      _journeyService.animateAvatar();
    });
  }

  Future<void> checkIfThereIsAMilestoneLevelChange() =>
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

  // addPageToTop(double currentOffset) async {
  //   print("Adding page to top");
  //   if (isEnd) return;
  //   isLoading = true;
  //   final res = await _dbModel.fetchJourneyPage(lastDoc: lastDoc);
  //   pages.addAll(res["pages"]);
  //   logger.d("TotalPages length: ${pages.length}");
  //   // isEnd = pages.length >= 4;
  //   if (res['pages'].isEmpty)
  //     isEnd = true;
  //   else
  //     lastDoc = res['lastDoc'];

  //   await Future.delayed(Duration(seconds: 2));
  //   pageCount = pages.length;
  //   currentFullViewHeight = pageHeight * pageCount;
  //   // addMilestones(res['pages']);
  //   // addCustomPathItems(res['pages']);
  //   // addJourneyPathItems(res['pages']);
  //   _journeyService.setCurrentMilestones();
  //   _journeyService.setCustomPathItems();
  //   _journeyService.setJourneyPathItems();
  //   startPage = pages[0].page;
  //   lastPage = pages[pages.length - 1].page;
  //   // avatarPath = drawPath();
  //   // setAvatarPostion();

  //   mainController.animateTo(
  //     mainController.offset + 100,
  //     curve: Curves.easeOutCubic,
  //     duration: Duration(seconds: 1),
  //   );
  //   isLoading = false;
  // }

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

    if (milestone.index == 1) {
      return AppState.delegate.parseRoute(Uri.parse("AppWalkthrough"));
    }
    AppState.screenStack.add(ScreenItem.modalsheet);

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: false,
      useRootNavigator: true,
      context: context,
      // isScrollControlled: true,
      builder: (ctx) {
        return JourneyMilestoneDetailsModalSheet(
          milestone: milestone,
          status: status,
        );
      },
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
