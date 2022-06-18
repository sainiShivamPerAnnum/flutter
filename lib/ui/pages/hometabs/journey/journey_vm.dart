import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class JourneyPageViewModel extends BaseModel {
  static double pageWidth, pageHeight, currentFullViewHeight;
  static int bottomPage, pageCount;
  static List<JourneyPage> pages;
  static List<MilestoneModel> currentMilestoneList = [];
  static List<JourneyPathModel> journeyPathItemsList = [];
  static List<AvatarPathModel> customPathDataList = [];

  JourneyPageViewModel(int stPage, int pgCount, List<JourneyPage> pgs) {
    pageWidth = SizeConfig.screenWidth;
    pageHeight = pageWidth * 2.165;
    bottomPage = stPage;
    pageCount = pgCount;
    currentFullViewHeight = pageHeight * pgCount;
    pages = pgs;
    setCurrentMilestones(pgs);
    setCurrentPathItems(pgs);
    setJourneyPathItems(pgs);
  }

  setCurrentMilestones(List<JourneyPage> pages) {
    pages.forEach((page) {
      currentMilestoneList.addAll(page.milestones);
    });
  }

  setCurrentPathItems(List<JourneyPage> pages) {
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

  static Path drawPath() {
    // Size size = Size(JourneyPageViewModel.pageWidth, JourneyPageViewModel.pageHeight);
    Path path = Path();
    for (int i = 0; i < customPathDataList.length; i++) {
      path = JourneyPageViewModel.generateCustomPath(
          path,
          customPathDataList[i],
          i == 0 ? "move" : customPathDataList[i].pathType);
    }
    return path;
  }

  static Path generateCustomPath(
      Path path, AvatarPathModel model, String pathType) {
    switch (pathType) {
      case "linear":
        path.lineTo(
            pageWidth * model.cords[0],
            pageHeight * (pageCount - model.page).abs() +
                pageHeight * model.cords[1]);
        return path;
      case "arc":
        return path;
      case "move":
        path.moveTo(
            pageWidth * model.cords[0],
            pageHeight * (pageCount - model.page).abs() +
                pageHeight * model.cords[1]);
        return path;
      case "rect":
        return path;
      case "quadratic":
        path.quadraticBezierTo(
            pageWidth * model.cords[0],
            pageHeight * (pageCount - model.page).abs() +
                pageHeight * model.cords[1],
            pageWidth * model.cords[2],
            pageHeight * (pageCount - model.page).abs() +
                pageHeight * model.cords[3]);
        return path;
      case "cubic":
        path.cubicTo(
            pageWidth * model.cords[0],
            pageHeight * (pageCount - model.page).abs() +
                pageHeight * model.cords[1],
            pageWidth * model.cords[2],
            pageHeight * (pageCount - model.page).abs() +
                pageHeight * model.cords[3],
            pageWidth * model.cords[4],
            pageHeight * (pageCount - model.page).abs() +
                pageHeight * model.cords[5]);
        return path;
      default:
        return path;
    }
  }
}
