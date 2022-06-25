import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/journey_page_data.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class JourneyPageViewModel extends BaseModel {
  double pageWidth, pageHeight, currentFullViewHeight;
  int lastPage, startPage, pageCount;
  List<JourneyPage> pages;
  int userMilestoneLevel = 1, userJourneyLevel = 1;
  bool _isLoading = false, isEnd = false;
  Offset _avatarPosition;
  Offset get avatarPosition => this._avatarPosition;

  set avatarPosition(Offset value) {
    this._avatarPosition = value;
  }

  List<MilestoneModel> currentMilestoneList = [];
  List<JourneyPathModel> journeyPathItemsList = [];
  List<AvatarPathModel> customPathDataList = [];

  bool get isLoading => this._isLoading;

  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  tempInit() {
    pages = jourenyPages;
    pageWidth = SizeConfig.screenWidth;
    pageHeight = pageWidth * 2.165;
    startPage = 0;
    pageCount = pages.length;
    currentFullViewHeight = pageHeight * pageCount;
    startPage = jourenyPages[0].page;
    lastPage = jourenyPages[jourenyPages.length - 1].page;
    setCurrentMilestones(pages);
    setCustomPathItems(pages);
    setJourneyPathItems(pages);
    setAvatarPostion();
  }

  init(int stPage) async {
    isLoading = true;
    await Future.delayed(Duration(seconds: 2));
    pages = jourenyPages.sublist(0, 2);
    pageWidth = SizeConfig.screenWidth;
    pageHeight = pageWidth * 2.165;
    startPage = stPage;
    pageCount = pages.length;
    currentFullViewHeight = pageHeight * pageCount;
    startPage = jourenyPages[0].page;
    lastPage = jourenyPages[jourenyPages.length - 1].page;
    setCurrentMilestones(pages);
    setCustomPathItems(pages);
    setJourneyPathItems(pages);
    setAvatarPostion();
    await Future.delayed(Duration(seconds: 2));
    isLoading = false;
  }

  addPageToTop() async {
    if (isEnd) return;
    isLoading = true;
    await Future.delayed(Duration(seconds: 2));
    pages.addAll(jourenyPages.sublist(2));
    isEnd = true;
    pageCount = pages.length;
    currentFullViewHeight = pageHeight * pageCount;
    addMilestones(jourenyPages.sublist(2));
    addCustomPathItems(jourenyPages.sublist(2));
    addJourneyPathItems(jourenyPages.sublist(2));
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
    avatarPosition = Offset(pages.first.avatarPath.first.cords[0],
        pages.first.avatarPath.first.cords[1]);
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
      journeyPathItemsList.addAll(page.path);
    });
  }

  setCurrentMilestones(List<JourneyPage> pages) {
    pages.forEach((page) {
      currentMilestoneList.addAll(page.milestones);
    });
  }

  setCustomPathItems(List<JourneyPage> pages) {
    pages.forEach((page) {
      customPathDataList.addAll(page.avatarPath);
    });
  }

  setJourneyPathItems(List<JourneyPage> pages) {
    pages.forEach((page) {
      journeyPathItemsList.addAll(page.path);
    });
  }
  // setDimensions(BuildContext context) {
  //   JourneyPageViewModel.pageHeight = MediaQuery.of(context).size.width * 2.165;
  //   JourneyPageViewModel.pageWidth = MediaQuery.of(context).size.width;
  //   JourneyPageViewModel.currentFullViewHeight = JourneyPageViewModel.pageHeight * noOfSlides;
  // }

  Path drawPath() {
    // Size size = Size(JourneyPageViewModel.pageWidth, JourneyPageViewModel.pageHeight);
    Path path = Path();
    for (int i = 0; i < customPathDataList.length; i++) {
      path = generateCustomPath(path, customPathDataList[i],
          i == 0 ? "move" : customPathDataList[i].pathType);
    }
    return path;
  }

  Path generateCustomPath(Path path, AvatarPathModel model, String pathType) {
    switch (pathType) {
      case "linear":
        path.lineTo(pageWidth * model.cords[0],
            pageHeight * (model.page - 1) + pageHeight * model.cords[1]);
        return path;
      case "arc":
        return path;
      case "move":
        path.moveTo(pageWidth * model.cords[0],
            pageHeight * (model.page - 1) + pageHeight * model.cords[1]);
        return path;
      case "rect":
        return path;
      case "quadratic":
        // path.quadraticBezierTo(
        //     pageWidth * model.cords[0],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.cords[1],
        //     pageWidth * model.cords[2],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.cords[3]);
        return path;
      case "cubic":
        // path.cubicTo(
        //     pageWidth * model.cords[0],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.cords[1],
        //     pageWidth * model.cords[2],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.cords[3],
        //     pageWidth * model.cords[4],
        //     pageHeight * (pageCount - model.page).abs() +
        //         pageHeight * model.cords[5]);
        return path;
      default:
        return path;
    }
  }
}
