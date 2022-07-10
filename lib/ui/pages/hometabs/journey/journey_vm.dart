import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/journey_page_data.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class JourneyPageViewModel extends BaseModel {
  final logger = locator<CustomLogger>();
  final _dbModel = locator<DBModel>();
  AnimationController _controller;
  ScrollController _mainController;
  Animation _avatarAnimation;
  DocumentSnapshot lastDoc;

  get avatarAnimation => this._avatarAnimation;

  set avatarAnimation(value) => this._avatarAnimation = value;
  double pageWidth, pageHeight, currentFullViewHeight;
  int lastPage, startPage, pageCount;
  List<JourneyPage> pages;
  int userMilestoneLevel = 1, userJourneyLevel = 1;
  bool _isLoading = false, isEnd = false;
  Offset _avatarPosition;
  Path _avatarPath;

  get controller => this._controller;

  set controller(value) => this._controller = value;

  ScrollController get mainController => this._mainController;

  set mainController(value) => this._mainController = value;

  Offset get avatarPosition => this._avatarPosition;

  set avatarPosition(Offset value) {
    this._avatarPosition = value;
    notifyListeners();
  }

  get avatarPath => this._avatarPath;

  set avatarPath(value) {
    this._avatarPath = value;
    notifyListeners();
  }

  List<MilestoneModel> currentMilestoneList = [];
  List<JourneyPathModel> journeyPathItemsList = [];
  List<AvatarPathModel> customPathDataList = [];

  bool get isLoading => this._isLoading;

  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  dump() {
    mainController?.dispose();
    controller?.dispose();
  }

  tempInit() async {
    isLoading = true;
    Future.delayed(Duration(seconds: 2));
    // Map<String, dynamic> res =
    //     await _dbModel.fetchJourneyPage(lastDoc: lastDoc);
    // pages = res["pages"];
    pages = jourenyPages; //.sublist(0, 2);
    // lastDoc = res["lastDoc"];
    // log("${lastDoc.id}");
    // pages.sublist(0, 2);
    pageWidth = SizeConfig.screenWidth;
    pageHeight = pageWidth * 2.165;
    startPage = 0;
    pageCount = pages.length;
    currentFullViewHeight = pageHeight * pageCount;
    startPage = pages[0].page;
    lastPage = pages[pages.length - 1].page;
    setCurrentMilestones();
    setCustomPathItems();
    setJourneyPathItems();

    // avatarPath = drawPath();
    // setAvatarPostion();
    createPathForAvatarAnimation(2, 5);

    createAvatarAnimationObject();

    mainController = ScrollController();
    //   ..addListener(() {
    //     if (mainController.offset > mainController.position.maxScrollExtent &&
    //         !isLoading &&
    //         !isEnd) addPageToTop(mainController.offset);
    //   });

    isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainController.jumpTo(300);
      mainController.animateTo(_mainController.position.minScrollExtent,
          duration: const Duration(seconds: 3), curve: Curves.easeOutCubic);
    });
  }

  //  (pages.length - model.page) * pageHeight +
  //               pageHeight -
  //               (pageHeight * model.coords[1]))

  init(int stPage) async {
    isLoading = true;
    await Future.delayed(Duration(seconds: 5));
    pages = pages.sublist(0, 2);
    pageWidth = SizeConfig.screenWidth;
    pageHeight = pageWidth * 2.165;
    startPage = stPage;
    pageCount = pages.length;
    currentFullViewHeight = pageHeight * pageCount;
    startPage = pages[0].page;
    lastPage = pages[pages.length - 1].page;
    setCurrentMilestones();
    setCustomPathItems();
    setJourneyPathItems();
    // avatarPath = drawPath();
    // setAvatarPostion();
    createPathForAvatarAnimation(2, 5);

    await Future.delayed(Duration(seconds: 2));
    isLoading = false;
  }

  addPageToTop(double currentOffset) async {
    print("Adding page to top");
    if (isEnd) return;
    isLoading = true;
    final res = await _dbModel.fetchJourneyPage(lastDoc: lastDoc);
    pages.addAll(res["pages"]);
    logger.d("TotalPages length: ${pages.length}");
    // isEnd = pages.length >= 4;
    if (res['pages'].isEmpty)
      isEnd = true;
    else
      lastDoc = res['lastDoc'];

    await Future.delayed(Duration(seconds: 2));
    pageCount = pages.length;
    currentFullViewHeight = pageHeight * pageCount;
    // addMilestones(res['pages']);
    // addCustomPathItems(res['pages']);
    // addJourneyPathItems(res['pages']);
    setCurrentMilestones();
    setCustomPathItems();
    setJourneyPathItems();
    startPage = pages[0].page;
    lastPage = pages[pages.length - 1].page;
    // avatarPath = drawPath();
    // setAvatarPostion();

    mainController.animateTo(
      mainController.offset + 100,
      curve: Curves.easeOutCubic,
      duration: Duration(seconds: 1),
    );
    isLoading = false;
  }

  addPageToBottom(pgs) {
    pages.add(pgs);
    pageCount = pages.length;
    currentFullViewHeight = pageHeight * pageCount;
    addMilestones(pages);
    addMilestones(pgs);
    addCustomPathItems(pgs);
    addJourneyPathItems(pgs);
    notifyListeners();
  }

  setAvatarPostion() {
    // avatarPosition = Offset(pages.first.avatarPath.first.coords[0],
    //     pages.first.avatarPath.first.coords[1]);
    avatarPosition = calculatePosition(0);
  }

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

  setCurrentMilestones() {
    currentMilestoneList.clear();
    pages.forEach((page) {
      currentMilestoneList.addAll(page.milestones);
    });
  }

  setCustomPathItems() {
    customPathDataList.clear();
    pages.forEach((page) {
      customPathDataList.addAll(page.avatarPath);
    });
  }

  setJourneyPathItems() {
    journeyPathItemsList.clear();
    pages.forEach((page) {
      journeyPathItemsList.addAll(page.paths);
    });
  }

  createPathForAvatarAnimation(int start, int end) {
    List<AvatarPathModel> requiredPathItems = [];
    int startPos =
        customPathDataList.lastIndexWhere((path) => path.mlIndex == start);
    for (int i = startPos; i < customPathDataList.length; i++) {
      if (customPathDataList[i].mlIndex <= end)
        requiredPathItems.add(customPathDataList[i]);
      else
        break;
    }
    logger.d("Calculated Path list length: ${requiredPathItems.length}");
    avatarPath = drawPath(requiredPathItems);
    setAvatarPostion();
  }

  Offset calculatePosition(double value) {
    PathMetrics pathMetrics = avatarPath.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

  void createAvatarAnimationObject() {
    avatarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    )..addListener(() {
        avatarPosition = calculatePosition(avatarAnimation.value);
        // double avatarPositionFromBottom =
        //     currentFullViewHeight - _avatarPosition.dy;
        // double scrollPostion = currentFullViewHeight - _mainController.offset;
        // if (avatarPositionFromBottom >= scrollPostion) {
        //   _mainController.animateTo(scrollPostion - pageHeight * 0.5,
        //       duration: const Duration(seconds: 2), curve: Curves.easeOutCubic);
        // }
        // log("Avatar Position( $avatarPositionFromBottom , $scrollPostion )");
        //if(scrollOffsetfromBottom >= avatarBottomOffset) avatar is hidden
        //
      });
  }
  // setDimensions(BuildContext context) {
  //   JourneyPageViewModel.pageHeight = MediaQuery.of(context).size.width * 2.165;
  //   JourneyPageViewModel.pageWidth = MediaQuery.of(context).size.width;
  //   JourneyPageViewModel.currentFullViewHeight = JourneyPageViewModel.pageHeight * noOfSlides;
  // }

  Path drawPath(List<AvatarPathModel> pathData) {
    // Size size = Size(JourneyPageViewModel.pageWidth, JourneyPageViewModel.pageHeight);
    Path path = Path();
    for (int i = 0; i < pathData.length; i++) {
      path = generateCustomPath(
          path, pathData[i], i == 0 ? "move" : pathData[i].moveType);
    }
    return path;
  }

  Path generateCustomPath(Path path, AvatarPathModel model, String moveType) {
    switch (moveType) {
      case "linear":
        path.lineTo(
            pageWidth * model.coords[0],
            (pages.length - model.page) * pageHeight +
                pageHeight * model.coords[1]);
        return path;
      case "arc":
        return path;
      case "move":
        path.moveTo(
            pageWidth * model.coords[0],
            (pages.length - model.page) * pageHeight +
                pageHeight * model.coords[1]);
        return path;
      case "rect":
        return path;
      case "quadratic":
        // path.quadraticBezierTo(
        //     pageWidth * model.coords[0],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[1],
        //     pageWidth * model.coords[2],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[3]);
        return path;
      case "cubic":
        // path.cubicTo(
        //     pageWidth * model.coords[0],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[1],
        //     pageWidth * model.coords[2],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[3],
        //     pageWidth * model.coords[4],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.coords[5]);
        return path;
      default:
        return path;
    }
  }
}
