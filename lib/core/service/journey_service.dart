import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/journey_models/avatar_path_model.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/model/journey_models/journey_page_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

const String AVATAR_CURRENT_MILESTONE_LEVEL = "avatarcurrentMilestoneLevel";
const String AVATAR_CURRENT_JOURNEY_LEVEL = "avatarcurrentJourneyLevel";

class JourneyService extends PropertyChangeNotifier<JourneyServiceProperties> {
  //Dependency Injection
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final ScratchCardService _gtService = locator<ScratchCardService>();
  final ScratchCardRepository _gtRepo = locator<ScratchCardRepository>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  final RootController _rootController = locator<RootController>();
  final S locale = locator<S>();

  //Local Variables
  List<JourneyLevel>? _levels = [];
  static bool isAvatarAnimationInProgress = false;
  double? pageWidth;
  double? pageHeight;
  double? currentFullViewHeight;
  int? _avatarCachedMlIndex = 1;
  int? _avatarRemoteMlIndex = 1;
  int lastPage = 0;
  int startPage = 0;
  int pageCount = 0;
  double _baseGlow = 0;
  TickerProvider? _vsync;
  ScrollController? _mainController;
  Timer? timer;
  List<MilestoneModel> currentMilestoneList = [];
  List<JourneyPathModel> journeyPathItemsList = [];
  List<AvatarPathModel> customPathDataList = [];
  List<MilestoneModel> completedMilestoneList = [];
  List<ScratchCard> completedMilestonesPrizeList = [];
  Path? _avatarPath;
  Offset? _avatarPosition;
  List<JourneyPage>? _pages;
  Animation? _avatarAnimation;
  AnimationController? controller;
  int? fcmRemoteAvatarLevel;

  // UserJourneyStatsModel _userJourneyStats;
  bool _journeyBuildFailure = false;
  bool _showLevelUpAnimation = false;
  bool _isUserJourneyOnboarded = false;
  bool _showFocusRing = false;

  get showFocusRing => _showFocusRing;

  set showFocusRing(value) {
    _showFocusRing = value;
    notifyListeners(JourneyServiceProperties.Onboarding);
  }

  get isUserJourneyOnboarded => _isUserJourneyOnboarded;
  List<ScratchCard>? _unscratchedGTList;

  get unscratchedGTList => _unscratchedGTList;

  set unscratchedGTList(value) {
    _unscratchedGTList = value;
    notifyListeners(JourneyServiceProperties.Prizes);
  }

  set isUserJourneyOnboarded(value) {
    _isUserJourneyOnboarded = value;
    notifyListeners(JourneyServiceProperties.Onboarding);
    _logger.d("User Journey Onboarded");
  }

  bool _isRefreshing = false;

  bool get isRefreshing => _isRefreshing;

  set isRefreshing(bool value) {
    _isRefreshing = value;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isLoaderRequired = false;

  get isLoaderRequired => _isLoaderRequired;

  set isLoaderRequired(value) {
    _isLoaderRequired = value;
    notifyListeners();
  }

  bool isJourneyOnboardingInView = false;

  AnimationController? levelUpLottieController;

  //Getters and Setters

  TickerProvider? get vsync => _vsync;

  set vsync(TickerProvider? value) => _vsync = value;

  get getController => controller;

  set setController(c) {
    controller = c;
    // notifyListeners();
  }

  get avatarAnimation => _avatarAnimation;

  set avatarAnimation(value) {
    _avatarAnimation = value;
    // notifyListeners();
  }

  List<JourneyPage>? get pages => _pages;

  set pages(List<JourneyPage>? value) {
    _pages = value;
    setPageItemsAndProperties();
    notifyListeners(JourneyServiceProperties.Pages);
  }

  addMorePages(List<JourneyPage> newPages) {
    for (final page in newPages) {
      _pages!.add(page);
    }
    setPageItemsAndProperties();
    notifyListeners(JourneyServiceProperties.Pages);
  }

  get avatarCachedMlIndex => _avatarCachedMlIndex;

  set avatarCachedMlIndex(value) => _avatarCachedMlIndex = value;

  get avatarRemoteMlIndex => _avatarRemoteMlIndex;

  double get baseGlow => _baseGlow;

  set baseGlow(double value) {
    _baseGlow = value;
    notifyListeners(JourneyServiceProperties.BaseGlow);
  }

  set avatarRemoteMlIndex(value) {
    _avatarRemoteMlIndex = value;
    notifyListeners(JourneyServiceProperties.AvatarRemoteMilestoneIndex);
  }

  // UserJourneyStatsModel get userJourneyStats => this._userJourneyStats;

  // set userJourneyStats(value) {
  //   this._userJourneyStats = value;
  //   notifyListeners(JourneyServiceProperties.UserJourneyStats);
  // }

  get avatarPath => _avatarPath;

  set avatarPath(value) {
    _avatarPath = value;
    // notifyListeners();
  }

  Offset? get avatarPosition => _avatarPosition;

  set avatarPosition(Offset? value) {
    _avatarPosition = value;
    notifyListeners(JourneyServiceProperties.AvatarPosition);
  }

  get journeyBuildFailure => _journeyBuildFailure;

  set journeyBuildFailure(value) {
    _journeyBuildFailure = value;
    notifyListeners(JourneyServiceProperties.JourneyBuildFailure);
  }

  List<JourneyLevel>? get levels => _levels;

  set levels(value) {
    _levels = value;
    _logger.d("Levels updated: ${levels![0].toString()}");
  }

  ScrollController? get mainController => _mainController;

  set mainController(ScrollController? value) => _mainController = value;

  get showLevelUpAnimation => _showLevelUpAnimation;

  set showLevelUpAnimation(value) {
    _showLevelUpAnimation = value;
    notifyListeners(JourneyServiceProperties.LevelCompletion);
  }

  // INIT MAIN
  Future<void> init() async {
    pageWidth = SizeConfig.screenWidth;
    pageHeight = pageWidth! * 2.165;
    await updateUserJourneyStats();
    await getJourneyLevels();
    await fetchNetworkPages();
    checkIfJourneyOnboardingRequried();
  }

  Future<void> dump() async {
    _userService.userJourneyStats = null;
    controller?.dispose();
    mainController?.dispose();
    levelUpLottieController?.dispose();
    avatarRemoteMlIndex = 1;
    avatarCachedMlIndex = 1;
    resetJourneyData();
    PreferenceHelper.remove(AVATAR_CURRENT_MILESTONE_LEVEL);
    levels?.clear();
    vsync = null;
    pages?.clear();
    log("Journey Service dumped");
  }

  buildJourney() async {
    _logger.d("BUILD JOURNEY CALLED");
    getAvatarCachedMilestoneIndex();
    await updateUserJourneyStats();
    if (isThereAnyMilestoneLevelChange()!) {
      createPathForAvatarAnimation(avatarCachedMlIndex, avatarRemoteMlIndex);
      createAvatarAnimationObject();
    } else {
      placeAvatarAtTheCurrentMileStone();
    }
    isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (avatarRemoteMlIndex < 3) {
        await mainController!.animateTo(
          0,
          duration: const Duration(seconds: 2),
          curve: Curves.easeOutCubic,
        );
      } else {
        await scrollPageToAvatarPosition();
      }
      if (avatarRemoteMlIndex == 1) showFocusRing = true;
      await animateAvatar();
      updateRewardSTooltips();
      mainController!.addListener(() {
        if (mainController!.offset > mainController!.position.maxScrollExtent) {
          if (!canMorePagesBeFetched()) {
            return updatingJourneyView();
          } else {
            return addPageToTop();
          }
        }
      });
    });
  }

  void updatingJourneyView() async {
    if (isRefreshing) return;
    _logger.d("Refreshing Journey Stats");
    isRefreshing = true;
    await checkForMilestoneLevelChange();
    isRefreshing = false;
  }

  canMorePagesBeFetched() => getJourneyLevelBlurData() == null ? true : false;

  addPageToTop() async {
    if (isLoading) return;
    _logger.d("Adding page to top");
    if (!canMorePagesBeFetched()) return;
    isLoading = true;
    isLoaderRequired = true;
    final prevPageslength = pages!.length;
    await fetchMoreNetworkPages();
    _logger.d("Total Pages length: ${pages!.length}");
    if (prevPageslength < pages!.length) {
      await mainController!.animateTo(
        mainController!.offset + 100,
        curve: Curves.easeOutCubic,
        duration: const Duration(seconds: 1),
      );
    }
    placeAvatarAtTheCurrentMileStone();
    // _journeyService.refreshJourneyPath();
    isLoaderRequired = false;
    isLoading = false;
  }

  //Fetching journeypages from Journey Repository
  Future<void> fetchNetworkPages() async {
    JourneyLevel currentLevel = levels!.firstWhere(
        (levelData) => levelData.level == _userService.userJourneyStats!.level,
        orElse: () => levels![0]);
    final int fetches = (currentLevel.pageEnd! / 2).ceil();
    for (int i = 0; i < fetches; i++) {
      //fetch all the pages till where user is currently on
      ApiResponse<List<JourneyPage>> response =
          await _journeyRepo.fetchNewJourneyPages(
              pageCount + 1,
              JourneyRepository.PAGE_DIRECTION_UP,
              _userService.userJourneyStats!.version);
      if (!response.isSuccess()) {
        _internalOpsService.logFailure(
          _userService.baseUser?.uid ?? '',
          FailType.Journey,
          {'error': "failed to fetch journey pages"},
        );
        return BaseUtil.showNegativeAlert("", response.errorMessage);
      } else {
        if (pages == null || pages!.isEmpty) {
          pages = response.model;
        } else {
          addMorePages(response.model!);
        }
      }
    }
  }

  void checkIfJourneyOnboardingRequried() {
    _isUserJourneyOnboarded = PreferenceHelper.getBool(
        PreferenceHelper.CACHE_IS_USER_JOURNEY_ONBOARDED,
        def: false);
  }

  //Fetching additional journeypages from Journey Repository
  Future<void> fetchMoreNetworkPages() async {
    ApiResponse<List<JourneyPage>> response =
        await _journeyRepo.fetchNewJourneyPages(
            pageCount + 1,
            JourneyRepository.PAGE_DIRECTION_UP,
            _userService.userJourneyStats!.version);
    if (!response.isSuccess()) {
      if (response.code == 500) return;
      _internalOpsService.logFailure(
        _userService.baseUser?.uid ?? '',
        FailType.Journey,
        {'error': "failed to fetch journey pages"},
      );
      return BaseUtil.showNegativeAlert("", response.errorMessage);
    } else {
      if ((response.model ?? []).isEmpty) return;
      if (pages == null || pages!.isEmpty) {
        pages = response.model;
      } else {
        addMorePages(response.model!);
      }
    }
  }

  //Update the user Journey status
  Future<void> updateUserJourneyStats() async {
    bool res = await _userService.getUserJourneyStats();
    if (res) {
      avatarRemoteMlIndex = _userService.userJourneyStats!.mlIndex;
    } else {
      journeyBuildFailure = true;
      _internalOpsService.logFailure(
        _userService.baseUser?.uid ?? '',
        FailType.Journey,
        {'error': "failed to fetch journey stats"},
      );
    }
  }

  Future<void> getUnscratchedGT() async {
    final ApiResponse<List<ScratchCard>> res =
        await _gtRepo.getUnscratchedScratchCards();
    if (res.isSuccess()) {
      unscratchedGTList = res.model;
    }
  }

  //Fetch Levels of Journey
  Future<void> getJourneyLevels() async {
    final res = await _journeyRepo
        .getJourneyLevels(_userService.userJourneyStats?.version ?? 'v1');
    if (res.isSuccess()) {
      levels = res.model;
    } else {
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
    ScratchCardService.scratchCardId = data["gtId"];
    _logger.d("Avatar Remote start level: $avatarRemoteMlIndex");
    if (!userIsAtJourneyScreen()) {
      BaseUtil.showPositiveAlert(
          locale.newMileStoneAlert1, locale.newMileStoneAlert2,
          seconds: 2);
    }
    checkAndAnimateAvatar();
  }

  //Checks
  //** if there is a difference between cached and remote mlIndex
  //** if user is at journey screen
  //locks the screen and animate avatar
  //if any Scratch Card is present at the moment, pops up after animation
  void checkAndAnimateAvatar() {
    // Future.delayed(Duration(seconds: 2), () {
    if (AppState.delegate!.currentConfiguration!.path != JourneyViewPath) {
      return;
    }
    if (avatarCachedMlIndex == avatarRemoteMlIndex) {
      placeAvatarAtTheCurrentMileStone();
    }
    _logger.d("Checking if there is any animation left to happen");
    if (isThereAnyMilestoneLevelChange()! &&
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
    _logger.d("Placing avatar at current milestone");
    AvatarPathModel path = customPathDataList
        .lastWhere((path) => path.mlIndex == avatarCachedMlIndex ?? 0 as bool);
    avatarPosition = Offset(
        pageWidth! * path.coords[0],
        (pages!.length - path.page) * pageHeight! +
            pageHeight! * path.coords[1]);
    baseGlow = 1;
  }

  //Check if user has completed the Journey Level
  int? getUserCurrentJourneyLevel() {
    for (int i = 0; i < levels!.length; i++) {
      log("Avatar Cache Level: $avatarCachedMlIndex || ${levels![i]} || Avatar remote level: $avatarRemoteMlIndex");
      if (avatarRemoteMlIndex < levels![i].end &&
          avatarRemoteMlIndex >= levels![i].start) return levels![i].level;
    }
    return 0;
  }

  bool checkIfUserHasCompletedJourneyLevel() {
    int? existingLevel = 1;
    int? updatedLevel = 1;
    for (final l in levels!) {
      if (avatarCachedMlIndex <= l.end && avatarCachedMlIndex >= l.start) {
        existingLevel = l.level;
      }
    }
    for (final l in levels!) {
      if (avatarRemoteMlIndex <= l.end && avatarRemoteMlIndex >= l.start) {
        updatedLevel = l.level;
      }
    }
    print("Existing level : $existingLevel || Updated Level: $updatedLevel");
    return existingLevel != updatedLevel;
  }

  //Returns if there is any cached mlIndex
  //else sets mlIndex to 1 and cache it to shared prefs
  void getAvatarCachedMilestoneIndex() {
    if (PreferenceHelper.exists(AVATAR_CURRENT_MILESTONE_LEVEL)) {
      avatarCachedMlIndex =
          PreferenceHelper.getInt(AVATAR_CURRENT_MILESTONE_LEVEL);
    } else {
      avatarCachedMlIndex = 1;
      PreferenceHelper.setInt(
          AVATAR_CURRENT_MILESTONE_LEVEL, avatarCachedMlIndex);
    }
  }

  //Updates cached mlIndex to remote mlIndex
  void updateAvatarLocalLevel() {
    avatarCachedMlIndex = avatarRemoteMlIndex;
    PreferenceHelper.setInt(
        AVATAR_CURRENT_MILESTONE_LEVEL, avatarCachedMlIndex);
  }

  //fetches the current mlIndex from remote and
  //compares it with cached mlIndex
  //if difference found, animates the avatar and process necessary changes
  Future<void> checkForMilestoneLevelChange() async {
    updateUserJourneyStats().then((_) {
      checkAndAnimateAvatar();
    });
  }

  updateAvatarIndexDirectly() {
    avatarRemoteMlIndex += 1;
    final currentMilestone = currentMilestoneList
        .firstWhere((milestone) => milestone.index == avatarRemoteMlIndex);
    int? jLevel = getUserCurrentJourneyLevel();
    _userService.userJourneyStats = UserJourneyStatsModel(
        page: currentMilestone.page,
        level: jLevel,
        mlIndex: currentMilestone.index,
        mlId: currentMilestone.id,
        prizeSubtype: currentMilestone.prizeSubType,
        skipCount: _userService.userJourneyStats!.skipCount! + 1,
        version: _userService.userJourneyStats!.version);
  }

  //Check if there is a need to blur next level milestones
  JourneyLevel? getJourneyLevelBlurData() {
    try {
      int? lastMileStoneIndex = currentMilestoneList.last.index;
      // // int userCurrentLevel = userJourneyStats.level;
      // log("Current Data Lastmilestone ${lastMileStoneIndex}");

      // int userCurrentMilestoneIndex = avatarRemoteMlIndex;
      log("levelData ${levels![0].toString()}");

      JourneyLevel currentlevelData = levels!.firstWhere(
          (level) => level.level == _userService.userJourneyStats!.level);

      if (lastMileStoneIndex! > currentlevelData.end!) {
        return currentlevelData;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //Scrolls Page to avatar Position
  Future<void> scrollPageToAvatarPosition() async {
    // int noOfPages = _journeyService.pageCount;
    int? cMLIndex = avatarRemoteMlIndex;
    if (cMLIndex == 1) {
      mainController!.jumpTo(300.0);
    }
    MilestoneModel cMl = currentMilestoneList
        .firstWhere((milestone) => milestone.index == cMLIndex);
    double offset = cMl.y! * pageHeight! + (cMl.page - 1) * pageHeight!;
    await Future.delayed(const Duration(seconds: 1), () {
      if (mainController!.hasClients) {
        mainController!.animateTo(offset - SizeConfig.screenHeight! * 0.5,
            duration: const Duration(seconds: 2), curve: Curves.easeOutCubic);
      }
    });
  }

  Future<void> updateRewardSTooltips() async {
    completedMilestonesPrizeList.clear();
    setCompletedMilestonesList();
    await getUnscratchedGT();
    if (unscratchedGTList == null || unscratchedGTList!.isEmpty) return;
    for (final milestone in completedMilestoneList) {
      var matchTicket = unscratchedGTList!.firstWhere(
          (ticket) => ticket.prizeSubtype == milestone.prizeSubType,
          orElse: () => ScratchCard.none());
      completedMilestonesPrizeList.add(matchTicket);
    }

    notifyListeners(JourneyServiceProperties.Prizes);
    _logger.d("Prizes List Updated ${completedMilestoneList.length} ");
    _logger.d("Prizes List Updated");
    _logger.d("Prizes List Updated ${completedMilestonesPrizeList.toString()}");
  }

  void updateRewardStatus(String prizeSubtype) {
    int activeRewardIndex = completedMilestonesPrizeList.indexWhere((reward) =>
        reward != ScratchCard.none() && reward.prizeSubtype == prizeSubtype);
    if (unscratchedGTList != null) {
      unscratchedGTList!.removeWhere((gt) => gt.prizeSubtype == prizeSubtype);
    }
    if (activeRewardIndex != -1) {
      completedMilestonesPrizeList[activeRewardIndex] = ScratchCard.none();
      notifyListeners(JourneyServiceProperties.Prizes);
      _logger.d("Prizes List Updated for prize ;$prizeSubtype ");
    }
  }

//-------------------------------|-HELPER METHODS-START-|---------------------------------

  userIsAtJourneyScreen() {
    return AppState.screenStack.length == 1 &&
        _rootController.currentNavBarItemModel ==
            RootController.journeyNavBarItem;
  }

  setAvatarPostion() => avatarPosition = calculatePosition(0);

  bool? isThereAnyMilestoneLevelChange() {
    _logger.i(
        "Avatar Remote Index: $avatarRemoteMlIndex && Avatar Cached Ml Index: $avatarCachedMlIndex");
    return avatarRemoteMlIndex > (avatarCachedMlIndex ?? 1);
  }

  getMilestoneLevelFromIndex(int index) {
    int? levelData;
    for (var levelData in levels!) {
      if (index >= levelData.start! && index <= levelData.end!) {
        levelData = levelData.level as JourneyLevel;
      }
    }
    return levelData;
  }

//---------------------------------|-HELPER METHODS-END-|---------------------------------

//-------------------|-PAGE ITEMS AND PROPERTIES SETUP METHODS-START-|--------------------

  setPageItemsAndProperties() {
    setPageProperties();
    setCurrentMilestones();
    setCustomPathItems();
    setJourneyPathItems();
    setCompletedMilestonesList();
    notifyListeners(JourneyServiceProperties.JourneyAssets);
  }

  setPageProperties() {
    pageCount = pages!.length;
    currentFullViewHeight = pageHeight! * pageCount;
    startPage = pages![0].page;
    lastPage = pages![pages!.length - 1].page;
    log("Pages Details: PageCount: $pageCount Current FullView Height: $currentFullViewHeight Start page: $startPage End Page: $lastPage currentMilestoneList length: ${currentMilestoneList.length} customPathDataList length: ${customPathDataList.length} journeyPathItemsList length: ${journeyPathItemsList.length}");
  }

  setCurrentMilestones() {
    currentMilestoneList.clear();
    for (final page in pages!) {
      currentMilestoneList.addAll(page.milestones);
    }
  }

  setCustomPathItems() {
    customPathDataList.clear();
    for (final page in pages!) {
      customPathDataList.addAll(page.avatarPath);
    }
  }

  setJourneyPathItems() {
    journeyPathItemsList.clear();
    for (final page in pages!) {
      journeyPathItemsList.addAll(page.paths);
    }
  }

  setCompletedMilestonesList() {
    completedMilestoneList.clear();
    for (final milestone in currentMilestoneList) {
      if (milestone.index! < avatarRemoteMlIndex) {
        completedMilestoneList.add(milestone);
      }
    }
  }

  resetJourneyData() {
    pageCount = 0;
    currentFullViewHeight = (pageHeight ?? 1) * pageCount;
    startPage = 1;
    lastPage = 2;
    currentMilestoneList.clear();
    customPathDataList.clear();
    journeyPathItemsList.clear();
    completedMilestoneList.clear();
    unscratchedGTList?.clear();
    completedMilestonesPrizeList.clear();

    log("Pages Details: PageCount: $pageCount Current FullView Height: $currentFullViewHeight Start page: $startPage End Page: $lastPage currentMilestoneList length: ${currentMilestoneList.length} customPathDataList length: ${customPathDataList.length} journeyPathItemsList length: ${journeyPathItemsList.length}");
  }

  //-------------------|-PAGE ITEMS AND PROPERTIES SETUP METHODS-END-|--------------------

  //----------------------------|-PATH CREATION METHODS-START-|----------------------------

  createPathForAvatarAnimation(int start, int end) {
    if (end - start > 4) {
      start = end - 2;
    }
    baseGlow = 0;
    List<AvatarPathModel> requiredPathItems = [];
    int startPos =
        customPathDataList.lastIndexWhere((path) => path.mlIndex == start);
    for (int i = startPos; i < customPathDataList.length; i++) {
      if (customPathDataList[i].mlIndex <= end) {
        requiredPathItems.add(customPathDataList[i]);
      } else {
        break;
      }
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
            pageWidth! * model.coords[0],
            (pages!.length - model.page) * pageHeight! +
                pageHeight! * model.coords[1].toDouble());
        return path;
      case "arc":
        return path;
      case "move":
        path.moveTo(
            pageWidth! * model.coords[0],
            (pages!.length - model.page) * pageHeight! +
                pageHeight! * model.coords[1]);
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
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }

  //----------------------------|-PATH CREATION METHODS-END-|------------------------------

  //----------------------------|-ANIMATION CREATION METHODS-START-|-----------------------

  void createAvatarAnimationObject() {
    double maxRange = 0.1;
    int duration = avatarRemoteMlIndex - avatarCachedMlIndex > 4
        ? 6
        : 2 * (avatarRemoteMlIndex - avatarCachedMlIndex) as int;
    controller = AnimationController(
      vsync: vsync!,
      duration: Duration(
        seconds: duration,
      ),
    );

    avatarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller!, curve: Curves.easeInOutCirc),
    )..addListener(() {
        avatarPosition = calculatePosition(avatarAnimation.value);
        print(controller!.value);
        if (controller!.value > maxRange) {
          Haptic.strongVibrate();
          maxRange += 0.05;
        }
      });
  }

  Future<void> animateAvatar() async {
    if (avatarPath == null || !isThereAnyMilestoneLevelChange()!) return;
    isAvatarAnimationInProgress = true;
    if (checkIfUserHasCompletedJourneyLevel()) {
      levelUpLottieController = AnimationController(
          vsync: vsync!, duration: const Duration(seconds: 3));
      showLevelUpAnimation = true;

      unawaited(levelUpLottieController!.forward().then((value) {
        showLevelUpAnimation = false;
      }));
      Future.delayed(const Duration(milliseconds: 800), () {});
    }
    controller?.reset();
    await scrollPageToAvatarPosition();
    await _gtService.fetchAndVerifyScratchCardByPrizeSubtype();
    unawaited(controller!.forward().whenComplete(() async {
      log("Animation Complete");
      unawaited(updateRewardSTooltips());
      updateAvatarLocalLevel();
      baseGlow = 1;
      Future.delayed(const Duration(milliseconds: 500),
          () => isAvatarAnimationInProgress = false);
      // _gtService.showInstantGoldenTicketView(
      //     title: 'Congratulations!', source: GTSOURCE.newuser, onJourney: true);
    }));
  }

  // checkIfUserIsOldAndNeedsStoryView() {
  //   Future.delayed(
  //     const Duration(seconds: 2),
  //     () {
  //       if (_userService!.baseUser!.isOldUser! && avatarRemoteMlIndex == 2) {
  //         isJourneyOnboardingInView = true;
  //         PreferenceHelper.setBool(
  //             PreferenceHelper.CACHE_IS_USER_JOURNEY_ONBOARDED, true);
  //         AppState.screenStack.add(ScreenItem.dialog);
  //         Navigator.of(AppState.delegate!.navigatorKey.currentContext!).push(
  //           PageRouteBuilder(
  //             pageBuilder: (context, animation, anotherAnimation) {
  //               return const InfoStories(
  //                 topic: "onboarding",
  //               );
  //             },
  //             transitionDuration: const Duration(milliseconds: 500),
  //             transitionsBuilder:
  //                 (context, animation, anotherAnimation, child) {
  //               animation = CurvedAnimation(
  //                   curve: Curves.easeInCubic, parent: animation);
  //               return Align(
  //                 child: SizeTransition(
  //                   sizeFactor: animation,
  //                   child: child,
  //                   axisAlignment: 0.0,
  //                 ),
  //               );
  //             },
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
}
