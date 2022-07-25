import 'dart:developer';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/journey_page_data.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

const String AVATAR_CURRENT_LEVEL = "avatarcurrentLevel";

class JourneyService extends PropertyChangeNotifier<JourneyServiceProperties> {
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  final DBModel _dbModel = locator<DBModel>();
  final UserService _userService = locator<UserService>();
  static bool isAvatarAnimationInProgress = false;
  double pageWidth;
  double pageHeight;
  double currentFullViewHeight;
  int _avatarCachedMlIndex;
  int _avatarRemoteMlIndex;
  int lastPage;
  int startPage;
  int pageCount;

  List<int> levels = [1, 4, 8];

  List<MilestoneModel> currentMilestoneList = [];
  List<JourneyPathModel> journeyPathItemsList = [];
  List<AvatarPathModel> customPathDataList = [];
  Path _avatarPath;
  Offset _avatarPosition;
  List<JourneyPage> _pages;
  Animation _avatarAnimation;
  AnimationController controller;
  int fcmRemoteAvatarLevel;

  get getController => this.controller;

  set setController(c) {
    this.controller = c;
    // notifyListeners();
  }

  get avatarAnimation => this._avatarAnimation;

  set avatarAnimation(value) {
    this._avatarAnimation = value;
    // notifyListeners();
  }

  List<JourneyPage> get pages => this._pages;

  set pages(List<JourneyPage> value) {
    this._pages = value;
    notifyListeners();
  }

  get avatarCachedMlIndex => this._avatarCachedMlIndex;

  set avatarCachedMlIndex(value) => this._avatarCachedMlIndex = value;

  get avatarRemoteMlIndex => this._avatarRemoteMlIndex;

  set avatarRemoteMlIndex(value) => this._avatarRemoteMlIndex = value;

  UserJourneyStatsModel _userJourneyStats;
  UserJourneyStatsModel get userJourneyStats => this._userJourneyStats;

  set userJourneyStats(value) {
    this._userJourneyStats = value;
    notifyListeners(JourneyServiceProperties.UserJourneyStats);
  }

  get avatarPath => this._avatarPath;

  set avatarPath(value) {
    this._avatarPath = value;
    notifyListeners();
  }

  Offset get avatarPosition => this._avatarPosition;

  set avatarPosition(Offset value) {
    this._avatarPosition = value;
    notifyListeners();
  }

  Future<void> init() async {
    // await getAvatarRemoteLevel();
    // getAvatarLocalLevel();
    pageWidth = SizeConfig.screenWidth;
    pageHeight = pageWidth * 2.165;
  }

  // fetchPages() {
  // pages = jourenyPages; //.sublist(0, 2);
  // createPathForAvatarAnimation(avatarCachedMlIndex, avatarRemoteMlIndex);
  // createAvatarAnimationObject();
  // }

  fetchNetworkPages() async {
    if (pages == null || pages.isEmpty) {
      ApiResponse<List<JourneyPage>> response = await _journeyRepo
          .fetchJourneyPages(1, JourneyRepository.PAGE_DIRECTION_UP);
      if (response.code == 200) {
        pages = response.model;
        setPageProperties();
      } else
        pages = [];
    }
  }

  setPageProperties() {
    pageCount = pages.length;
    currentFullViewHeight = pageHeight * pageCount;
    startPage = pages[0].page;
    lastPage = pages[pages.length - 1].page;
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

  updateUserJourneyStats(Map<String, dynamic> data) {
    _logger.d("User journey stats update called");
    userJourneyStats = UserJourneyStatsModel(
        page: 1,
        level: 1,
        mlIndex: int.tryParse(data["level"]),
        mlId: "00${int.tryParse(data["level"])}",
        nextPrizeSubtype: "HESOYAM");
    avatarRemoteMlIndex = userJourneyStats.mlIndex;
    _logger.d("Avatar Remote start level: $avatarRemoteMlIndex");
    BaseUtil.showPositiveAlert(
        "Congratulations!!", "Your level increased to $avatarRemoteMlIndex");
    if (checkIfThereIsALevelChange() && userIsAtJourneyScreen()) {
      createPathForAvatarAnimation(avatarCachedMlIndex, avatarRemoteMlIndex);
      createAvatarAnimationObject();
      animateAvatar();
    }
  }

  checkIfAnyAnimationIsLeft() {
    log("Checking if there is any animation left to happen");
    if (checkIfThereIsALevelChange()) {
      createPathForAvatarAnimation(avatarCachedMlIndex, avatarRemoteMlIndex);
      createAvatarAnimationObject();
      animateAvatar();
    }
  }

  userIsAtJourneyScreen() {
    if (AppState.screenStack.length == 1 &&
        AppState.delegate.appState.getCurrentTabIndex == 1) return true;
    return false;
  }

  void placeAvatarAtTheCurrentMileStone() {
    AvatarPathModel path = customPathDataList
        .lastWhere((path) => path.mlIndex == avatarCachedMlIndex ?? 0);
    avatarPosition = Offset(pageWidth * path.coords[0],
        (pages.length - path.page) * pageHeight + pageHeight * path.coords[1]);
  }

  int checkForGameLevelChange() {
    for (int i = 0; i < levels.length; i++) {
      log("Avatar Cache Level: $avatarCachedMlIndex || ${levels[i]} || Avatar remote level: $avatarRemoteMlIndex");
      if (avatarCachedMlIndex < levels[i] && avatarRemoteMlIndex >= levels[i])
        return levels[i];
    }
    return 0;
  }

  getAvatarLocalLevel() {
    if (PreferenceHelper.exists(AVATAR_CURRENT_LEVEL))
      avatarCachedMlIndex = PreferenceHelper.getInt(AVATAR_CURRENT_LEVEL);
    else {
      avatarCachedMlIndex = 1;
      PreferenceHelper.setInt(AVATAR_CURRENT_LEVEL, avatarCachedMlIndex);
    }

    _logger.d("JOURNEYSERVICE: Avatar Local Level: $avatarCachedMlIndex");
  }

  Future<void> getAvatarRemoteLevel() async {
    //MAKE API CALL TO FETCH CURRENT LEVEL
    //DUMMY LEVEL FOR TESTING
    avatarRemoteMlIndex =
        await _dbModel.getRemoteMLIndex(_userService.baseUser.uid) ??
            avatarCachedMlIndex;
    // int startLevel = 3;
    _logger.d("JOURNEYSERVICE: Avatar Remote Level: $avatarRemoteMlIndex");
  }

  updateAvatarLocalLevel() {
    avatarCachedMlIndex = avatarRemoteMlIndex;
    PreferenceHelper.setInt(AVATAR_CURRENT_LEVEL, avatarCachedMlIndex);
  }

  bool checkIfThereIsALevelChange() =>
      avatarRemoteMlIndex > (avatarCachedMlIndex ?? 1);

  Future<bool> getUserJourneyStats() async {
    userJourneyStats = UserJourneyStatsModel(
        page: 1,
        level: 1,
        mlIndex: 3,
        mlId: "003",
        nextPrizeSubtype: "AEZAKMI");
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
    _logger.d("Calculated Path list length: ${requiredPathItems.length}");
    drawPath(requiredPathItems);
    setAvatarPostion();
  }

  setAvatarPostion() {
    avatarPosition = calculatePosition(0);
  }

  animateAvatar() {
    if (avatarPath == null || !checkIfThereIsALevelChange()) return;
    isAvatarAnimationInProgress = true;
    controller.reset();
    controller.forward().whenComplete(() {
      isAvatarAnimationInProgress = false;
      int gameLevelChangeResult = checkForGameLevelChange();
      if (gameLevelChangeResult != 0)
        BaseUtil.showPositiveAlert("Level $gameLevelChangeResult unlocked!!",
            "New Milestones on your way!");
      updateAvatarLocalLevel();
    });
  }

  void drawPath(List<AvatarPathModel> pathData) {
    // Size size = Size(JourneyPageViewModel.pageWidth, JourneyPageViewModel.pageHeight);
    Path path = Path();
    for (int i = 0; i < pathData.length; i++) {
      path = generateCustomPath(
          path, pathData[i], i == 0 ? "move" : pathData[i].moveType);
    }
    avatarPath = path;
  }

  Path generateCustomPath(Path path, AvatarPathModel model, String moveType) {
    switch (moveType) {
      case "linear":
        path.lineTo(
            pageWidth * model.coords[0],
            (pages.length - model.page) * pageHeight +
                pageHeight * model.coords[1].toDouble());
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

  void createAvatarAnimationObject() {
    avatarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    )..addListener(() {
        avatarPosition = calculatePosition(avatarAnimation.value);
        notifyListeners(JourneyServiceProperties.AvatarPosition);
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

  Offset calculatePosition(double value) {
    PathMetrics pathMetrics = avatarPath.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}
