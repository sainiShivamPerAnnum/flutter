import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';

const String AVATAR_CURRENT_LEVEL = "avatarcurrentLevel";

class JourneyService extends PropertyChangeNotifier<JourneyServiceProperties> {
  //Dependency Injection
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final GoldenTicketService _gtService = locator<GoldenTicketService>();
  final _internalOpsService = locator<InternalOpsService>();

  //Local Variables
  List<JourneyLevel> _levels = [];
  static bool isAvatarAnimationInProgress = false;
  double pageWidth;
  double pageHeight;
  double currentFullViewHeight;
  int _avatarCachedMlIndex = 1;
  int _avatarRemoteMlIndex = 1;
  int lastPage = 0;
  int startPage = 0;
  int pageCount = 0;
  double _baseGlow = 0;
  TickerProvider _vsync;
  ScrollController _mainController;
  Timer timer;
  List<MilestoneModel> currentMilestoneList = [];
  List<JourneyPathModel> journeyPathItemsList = [];
  List<AvatarPathModel> customPathDataList = [];
  Path _avatarPath;
  Offset _avatarPosition;
  List<JourneyPage> _pages;
  Animation _avatarAnimation;
  AnimationController controller;
  int fcmRemoteAvatarLevel;
  // UserJourneyStatsModel _userJourneyStats;
  bool _journeyBuildFailure = false;

  //Getters and Setters

  TickerProvider get vsync => this._vsync;
  set vsync(TickerProvider value) => this._vsync = value;

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

  List<JourneyPage> get pages => _pages;

  set pages(List<JourneyPage> value) {
    this._pages = value;
    setPageItemsAndProperties();
    notifyListeners(JourneyServiceProperties.Pages);
  }

  addMorePages(List<JourneyPage> newPages) {
    newPages.forEach((page) {
      this._pages.add(page);
    });
    setPageItemsAndProperties();
    notifyListeners(JourneyServiceProperties.Pages);
  }

  get avatarCachedMlIndex => this._avatarCachedMlIndex;

  set avatarCachedMlIndex(value) => this._avatarCachedMlIndex = value;

  get avatarRemoteMlIndex => this._avatarRemoteMlIndex;
  double get baseGlow => this._baseGlow;

  set baseGlow(double value) {
    this._baseGlow = value;
    notifyListeners(JourneyServiceProperties.BaseGlow);
  }

  set avatarRemoteMlIndex(value) {
    this._avatarRemoteMlIndex = value;
    notifyListeners(JourneyServiceProperties.AvatarRemoteMilestoneIndex);
  }

  // UserJourneyStatsModel get userJourneyStats => this._userJourneyStats;

  // set userJourneyStats(value) {
  //   this._userJourneyStats = value;
  //   notifyListeners(JourneyServiceProperties.UserJourneyStats);
  // }

  get avatarPath => this._avatarPath;

  set avatarPath(value) {
    this._avatarPath = value;
    // notifyListeners();
  }

  Offset get avatarPosition => this._avatarPosition;

  set avatarPosition(Offset value) {
    this._avatarPosition = value;
    notifyListeners(JourneyServiceProperties.AvatarPosition);
  }

  get journeyBuildFailure => this._journeyBuildFailure;

  set journeyBuildFailure(value) {
    this._journeyBuildFailure = value;
    notifyListeners(JourneyServiceProperties.JourneyBuildFailure);
  }

  List<JourneyLevel> get levels => this._levels;

  set levels(value) {
    this._levels = value;
    _logger.d("Levels updated: ${levels[0].toString()}");
  }

  ScrollController get mainController => this._mainController;

  set mainController(ScrollController value) => this._mainController = value;

  // INIT MAIN
  Future<void> init() async {
    pageWidth = SizeConfig.screenWidth;
    pageHeight = pageWidth * 2.165;
    await getJourneyLevels();
    await updateUserJourneyStats();
    await fetchNetworkPages();
  }

  Future<void> dump() async {
    _userService.userJourneyStats = null;
    controller?.dispose();
    mainController?.dispose();
    avatarRemoteMlIndex = 1;
    avatarCachedMlIndex = 1;
    resetJourneyData();
    PreferenceHelper.remove(AVATAR_CURRENT_LEVEL);
    levels.clear();
    vsync = null;
    pages.clear();
    log("Journey Service dumped");
  }

  //Fetching journeypages from Journey Repository
  Future<void> fetchNetworkPages() async {
    JourneyLevel currentLevel = levels.firstWhere(
        (levelData) => levelData.level == _userService.userJourneyStats.level);
    final int fetches = (currentLevel.pageEnd / 2).ceil();
    for (int i = 0; i < fetches; i++) {
      //fetch all the pages till where user is currently on
      ApiResponse<List<JourneyPage>> response =
          await _journeyRepo.fetchJourneyPages(
              pageCount + 1, JourneyRepository.PAGE_DIRECTION_UP);
      if (!response.isSuccess()) {
        _internalOpsService.logFailure(
          _userService.baseUser?.uid ?? '',
          FailType.Journey,
          {'error': "failed to fetch journey pages"},
        );
        return BaseUtil.showNegativeAlert("Unable to fetch pages at the moment",
            "Please try again in some time");
      } else {
        if (pages == null || pages.isEmpty)
          pages = response.model;
        else
          addMorePages(response.model);
      }
    }
  }

  //Fetching additional journeypages from Journey Repository
  Future<void> fetchMoreNetworkPages() async {
    ApiResponse<List<JourneyPage>> response = await _journeyRepo
        .fetchJourneyPages(pageCount + 1, JourneyRepository.PAGE_DIRECTION_UP);
    if (!response.isSuccess()) {
      _internalOpsService.logFailure(
        _userService.baseUser?.uid ?? '',
        FailType.Journey,
        {'error': "failed to fetch journey pages"},
      );
      return BaseUtil.showNegativeAlert("Unable to fetch pages at the moment",
          "Please try again in some time");
    } else {
      if (pages == null || pages.isEmpty)
        pages = response.model;
      else
        addMorePages(response.model);
    }
  }

  //Get User journey stats from userservice
  // getUserJourneyStats() {
  // userJourneyStats = _userService.userJourneyStats;
  //   avatarRemoteMlIndex = userJourneyStats.mlIndex;
  // }

  //Update the user Journey status
  updateUserJourneyStats() async {
    bool res = await _userService.getUserJourneyStats();
    if (res) {
      _userService.userJourneyStats = _userService.userJourneyStats;
      avatarRemoteMlIndex = _userService.userJourneyStats.mlIndex;
    } else {
      journeyBuildFailure = true;
      _internalOpsService.logFailure(
        _userService.baseUser?.uid ?? '',
        FailType.Journey,
        {'error': "failed to fetch journey stats"},
      );
    }
  }

  //Fetch Levels of Journey
  getJourneyLevels() async {
    final res = await _journeyRepo.getJourneyLevels();
    if (res.isSuccess())
      levels = res.model;
    else {
      journeyBuildFailure = true;
      _internalOpsService.logFailure(
        _userService.baseUser?.uid ?? '',
        FailType.Journey,
        {'error': "failed to fetch journey levels"},
      );
    }
  }

  fcmHandleJourneyUpdateStats(Map<String, dynamic> data) {
    _logger.d("fcm journey update called: $data");
    avatarRemoteMlIndex = int.tryParse(data["mlIndex"]);
    if (avatarRemoteMlIndex != 2)
      GoldenTicketService.goldenTicketId = data["gtId"];
    else
      GoldenTicketService.goldenTicketId = null;
    _logger.d("Avatar Remote start level: $avatarRemoteMlIndex");
    checkAndAnimateAvatar();
  }

  //Checks
  //** if there is a difference between cached and remote mlIndex
  //** if user is at journey screen
  //locks the screen and animate avatar
  //if any Golden Ticket is present at the moment, pops up after animation
  checkAndAnimateAvatar() {
    // Future.delayed(Duration(seconds: 2), () {
    _logger.d("Checking if there is any animation left to happen");
    if (isThereAnyMilestoneLevelChange() &&
        userIsAtJourneyScreen() &&
        !isAvatarAnimationInProgress) {
      _logger.d("Animation possible");
      createPathForAvatarAnimation(avatarCachedMlIndex, avatarRemoteMlIndex);
      createAvatarAnimationObject();
      animateAvatar();
    } else {
      _logger.i(
          "User not a Journey screen at the moment. skipping animation for now");
    }
    // });
  }

  //On startup, if cached and remote mlIndex is same, then just place the avatar at the requried milestone and turn on glow
  void placeAvatarAtTheCurrentMileStone() {
    AvatarPathModel path = customPathDataList
        .lastWhere((path) => path.mlIndex == avatarCachedMlIndex ?? 0);
    avatarPosition = Offset(pageWidth * path.coords[0],
        (pages.length - path.page) * pageHeight + pageHeight * path.coords[1]);
    baseGlow = 1;
  }

  //Check if user has completed the Journey Level
  int checkForGameLevelChange() {
    for (int i = 0; i < levels.length; i++) {
      log("Avatar Cache Level: $avatarCachedMlIndex || ${levels[i]} || Avatar remote level: $avatarRemoteMlIndex");
      if (avatarRemoteMlIndex < levels[i].end &&
          avatarRemoteMlIndex >= levels[i].start) return levels[i].level;
    }
    return 0;
  }

  //Returns if there is any cached mlIndex
  //else sets mlIndex to 1 and cache it to shared prefs
  getAvatarCachedMilestoneIndex() {
    if (PreferenceHelper.exists(AVATAR_CURRENT_LEVEL))
      avatarCachedMlIndex = PreferenceHelper.getInt(AVATAR_CURRENT_LEVEL);
    else {
      avatarCachedMlIndex = 1;
      PreferenceHelper.setInt(AVATAR_CURRENT_LEVEL, avatarCachedMlIndex);
    }
  }

  //Updates cached mlIndex to remote mlIndex
  updateAvatarLocalLevel() {
    avatarCachedMlIndex = avatarRemoteMlIndex;
    PreferenceHelper.setInt(AVATAR_CURRENT_LEVEL, avatarCachedMlIndex);
  }

  //fetches the current mlIndex from remote and
  //compares it with cached mlIndex
  //if difference found, animates the avatar and process necessary changes
  Future<void> checkForMilestoneLevelChange() async {
    await updateUserJourneyStats().then((val) {
      checkAndAnimateAvatar();
    });
  }

  updateAvatarIndexDirectly() {
    avatarRemoteMlIndex += 1;
    final currentMilestone = currentMilestoneList
        .firstWhere((milestone) => milestone.index == avatarRemoteMlIndex);
    int jLevel = checkForGameLevelChange();
    _userService.userJourneyStats = UserJourneyStatsModel(
        page: currentMilestone.page,
        level: jLevel,
        mlIndex: currentMilestone.index,
        mlId: currentMilestone.id,
        prizeSubtype: currentMilestone.prizeSubType,
        skipCount: _userService.userJourneyStats.skipCount + 1);
  }

  //Check if there is a need to blur next level milestones
  JourneyLevel getJourneyLevelBlurData() {
    int lastMileStoneIndex = currentMilestoneList.last.index;
    // // int userCurrentLevel = userJourneyStats.level;
    // log("Current Data Lastmilestone ${lastMileStoneIndex}");

    // int userCurrentMilestoneIndex = avatarRemoteMlIndex;
    log("levelData ${levels[0].toString()}");

    JourneyLevel currentlevelData = levels.firstWhere(
        (level) =>
            avatarRemoteMlIndex >= level.start &&
            avatarRemoteMlIndex <= level.end,
        orElse: null);

    if (currentlevelData != null && lastMileStoneIndex > currentlevelData.end) {
      return currentlevelData;
    } else
      return null;
  }

  //Scrolls Page to avatar Position
  Future<void> scrollPageToAvatarPosition() async {
    // int noOfPages = _journeyService.pageCount;
    int cMLIndex = avatarRemoteMlIndex;
    if (cMLIndex == 1) {
      mainController.jumpTo(300.0);
    }
    MilestoneModel cMl = currentMilestoneList
        .firstWhere((milestone) => milestone.index == cMLIndex);
    double offset = cMl.y * pageHeight + (cMl.page - 1) * pageHeight;
    await Future.delayed(Duration(seconds: 1), () {
      mainController.animateTo(offset - SizeConfig.screenHeight * 0.5,
          duration: const Duration(seconds: 2), curve: Curves.easeOutCubic);
    });
  }

//-------------------------------|-HELPER METHODS-START-|---------------------------------

  userIsAtJourneyScreen() => (AppState.screenStack.length == 1 &&
      AppState.delegate.appState.getCurrentTabIndex == 0);

  setAvatarPostion() => avatarPosition = calculatePosition(0);

  bool isThereAnyMilestoneLevelChange() {
    _logger.i(
        "Avatar Remote Index: $avatarRemoteMlIndex && Avatar Cached Ml Index: $avatarCachedMlIndex");
    return avatarRemoteMlIndex > (avatarCachedMlIndex ?? 1);
  }

  getMilestoneLevelFromIndex(int index) {
    levels.forEach((levelData) {
      if (index >= levelData.start && index <= levelData.end)
        return levelData.level;
    });
    return null;
  }

//---------------------------------|-HELPER METHODS-END-|---------------------------------

//-------------------|-PAGE ITEMS AND PROPERTIES SETUP METHODS-START-|--------------------

  setPageItemsAndProperties() {
    setPageProperties();
    setCurrentMilestones();
    setCustomPathItems();
    setJourneyPathItems();
    notifyListeners(JourneyServiceProperties.JourneyAssets);
  }

  setPageProperties() {
    pageCount = pages.length;
    currentFullViewHeight = pageHeight * pageCount;
    startPage = pages[0].page;
    lastPage = pages[pages.length - 1].page;
    log("Pages Details: PageCount: $pageCount Current FullView Height: $currentFullViewHeight Start page: $startPage End Page: $lastPage currentMilestoneList length: ${currentMilestoneList.length} customPathDataList length: ${customPathDataList.length} journeyPathItemsList length: ${journeyPathItemsList.length}");
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

  resetJourneyData() {
    pageCount = 0;
    currentFullViewHeight = pageHeight * pageCount;
    startPage = 1;
    lastPage = 2;
    currentMilestoneList.clear();
    customPathDataList.clear();
    journeyPathItemsList.clear();
    log("Pages Details: PageCount: $pageCount Current FullView Height: $currentFullViewHeight Start page: $startPage End Page: $lastPage currentMilestoneList length: ${currentMilestoneList.length} customPathDataList length: ${customPathDataList.length} journeyPathItemsList length: ${journeyPathItemsList.length}");
  }
  //-------------------|-PAGE ITEMS AND PROPERTIES SETUP METHODS-END-|--------------------

  //----------------------------|-PATH CREATION METHODS-START-|----------------------------

  createPathForAvatarAnimation(int start, int end) {
    if (end - start > 4) {
      start = end - 4;
    }
    baseGlow = 0;
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

  void drawPath(List<AvatarPathModel> pathData) {
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

  //Calculates the position of avatar based on the path created
  Offset calculatePosition(double value) {
    PathMetrics pathMetrics = avatarPath.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

  //----------------------------|-PATH CREATION METHODS-END-|------------------------------

  //----------------------------|-ANIMATION CREATION METHODS-START-|-----------------------

  void createAvatarAnimationObject() {
    double maxRange = 0.1;
    int duration = avatarRemoteMlIndex - avatarCachedMlIndex > 4
        ? 6
        : 2 * (avatarRemoteMlIndex - avatarCachedMlIndex);
    controller = AnimationController(
      vsync: vsync,
      duration: Duration(
        seconds: duration,
      ),
    );

    avatarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCirc),
    )..addListener(() {
        avatarPosition = calculatePosition(avatarAnimation.value);
        print(controller.value);
        if (controller.value > maxRange) {
          Haptic.strongVibrate();
          maxRange += 0.05;
        }
      });
  }

  animateAvatar() async {
    if (avatarPath == null || !isThereAnyMilestoneLevelChange()) return;
    isAvatarAnimationInProgress = true;
    controller.reset();
    await scrollPageToAvatarPosition();
    controller.forward().whenComplete(() {
      log("Animation Complete");
      // int gameLevelChangeResult = checkForGameLevelChange();
      // if (gameLevelChangeResult != 0)
      BaseUtil.showPositiveAlert("Milestone $avatarRemoteMlIndex unlocked!!",
          "New Milestones on your way!");
      updateAvatarLocalLevel();
      baseGlow = 1;
      Future.delayed(
          Duration(seconds: 1), () => isAvatarAnimationInProgress = false);

      if (avatarRemoteMlIndex > 2)
        _gtService.fetchAndVerifyGoldenTicketByID().then((bool res) {
          if (res)
            _gtService.showInstantGoldenTicketView(
                title: 'Congratulations!', source: GTSOURCE.newuser);
        });
    });
  }
}
