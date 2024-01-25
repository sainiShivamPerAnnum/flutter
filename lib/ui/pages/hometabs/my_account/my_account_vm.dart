import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/model/fello_facts_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/dialogs/user_avatars_dialog.dart';
import 'package:felloapp/ui/elements/fello_dialog/fello_in_app_review.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/tutorial_keys.dart';
import 'package:felloapp/ui/pages/static/profile_image.dart';
import 'package:felloapp/ui/pages/userProfile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcaseview.dart';

class MyAccountVM extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final UserRepository? userRepo = locator<UserRepository>();
  final CampaignRepo _campaignRepo = locator<CampaignRepo>();
  final UserRepository _userRepo = locator<UserRepository>();

  S locale = locator<S>();

  Timer? _timer;
  List<FelloFactsModel>? fellofacts = [];
  bool _isFelloFactsLoading = false;

  bool get isFelloFactsLoading => _isFelloFactsLoading;

  set isFelloFactsLoading(value) {
    _isFelloFactsLoading = value;
    notifyListeners();
  }

  final bool _isShareAlreadyClicked = false;

  bool get isShareAlreadyClicked => _isShareAlreadyClicked;

  bool shareWhatsappInProgress = false;
  bool shareLinkInProgress = false;
  final bool _isShareLoading = false;

  bool get isShareLoading => _isShareLoading;
  final String _refUrl = "";

  String get refUrl => _refUrl;

  double get getUnclaimedPrizeBalance =>
      _userService.userFundWallet!.unclaimedBalance;

  SuperFelloLevel get superFelloLevel => _userService.baseUser!.superFelloLevel;

  XFile? selectedProfilePicture;

  Future<void> init() async {
    await getFelloFacts();
    // _lbService!.fetchReferralLeaderBoard();
    await locator<ScratchCardService>().updateUnscratchedGTCount();
  }

  void clear() {
    _timer?.cancel();
  }

  String getWinningsButtonText() {
    return _userService.userFundWallet!.isPrizeBalanceUnclaimed()
        ? locale.redeem
        : locale.share;
  }

  void navigateToMyWinnings() {
    AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: MyWinningsPageConfig,
        widget: const MyWinningsView());
  }

  void navigateToRefer() {
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: ReferralDetailsPageConfig,
    );
  }

  void navigateToWinnings() {
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: MyWinningsPageConfig,
    );
  }

  void openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  double calculateFillHeight(
      double winningAmount, double containerHeight, int redeemAmount) {
    double fillPercent = (winningAmount / redeemAmount) * 100;
    double heightToFill = (fillPercent / 100) * containerHeight;

    return heightToFill;
  }

  Future<void> getFelloFacts() async {
    isFelloFactsLoading = true;
    final res = await _campaignRepo.getFelloFacts();
    if (res.isSuccess()) {
      fellofacts = res.model;
      _logger.d("Fello Facts Fetched Length: ${fellofacts!.length}");
    } else {
      fellofacts = [];
    }
    _logger.d("Fello Facts Length: ${fellofacts!.length}");
    isFelloFactsLoading = false;
  }

  Future<void> showLastWeekSummary() async {
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: LastWeekOverviewConfig,
      widget: const LastWeekOverView(
        callCampaign: false,
      ),
    );
  }

  void showRatingSheet() {
    Haptic.vibrate();

    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      enableDrag: false,
      hapticVibrate: true,
      isBarrierDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      content: const FelloInAppReview(),
    );
  }

  Future<void> showTutorial(BuildContext context) async {
    Haptic.vibrate();
    AppState.delegate!.onTapItem(RootController.saveNavBarItem);
    // await AppState.backButtonDispatcher!.didPopRoute();
    ShowCaseWidget.of(context).startShowCase([
      TutorialKeys.tutorialkey1,
      TutorialKeys.tutorialkey2,
      TutorialKeys.tutorialkey3,
      TutorialKeys.tutorialkey4,
      TutorialKeys.tutorialkey5,
      TutorialKeys.tutorialkey6
    ]);
  }

  Future<void> showCustomAvatarsDialog() async {
    await BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissible: false,
      hapticVibrate: true,
      content: UserAvatarSelectionDialog(
        onCustomAvatarSelection: handleDPOperation,
        onPresetAvatarSelection: updateUserAvatar,
      ),
    );

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.addProfilePicture,
      properties: {
        'location': 'profile',
      },
    );
  }

  Future<void> updateUserAvatar({String? avatarId}) async {
    final res = await _userRepo.updateUser(
        dMap: {BaseUser.fldAvatarId: avatarId},
        uid: _userService.baseUser!.uid);
    await AppState.backButtonDispatcher!.didPopRoute();
    if (res.isSuccess() && res.model!) {
      _userService.setMyAvatarId(avatarId);

      return BaseUtil.showPositiveAlert(
          locale.updatedSuccessfully, locale.profileUpdated);
    } else {
      BaseUtil.showNegativeAlert(locale.obSomeThingWentWrong, locale.tryLater);
    }
  }

  Future<void> handleDPOperation() async {
    if (await BaseUtil.showNoInternetAlert()) return;
    await AppState.backButtonDispatcher!.didPopRoute();
    await checkGalleryPermission();
  }

  Future<bool> checkGalleryPermission() async {
    if (await BaseUtil.showNoInternetAlert()) return false;
    var status = await Permission.photos.status;
    if (status.isRestricted || status.isLimited || status.isDenied) {
      await BaseUtil.openDialog(
        isBarrierDismissible: false,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: locale.reqPermission,
          description: locale.galleryAccess,
          buttonText: locale.btnContinue,
          asset: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Image.asset(
              "images/gallery.png",
              height: SizeConfig.screenWidth! * 0.24,
            ),
          ),
          confirmAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
            _chooseProfilePicture();
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
          },
        ),
      );
    } else if (status.isGranted) {
      await _chooseProfilePicture();
    } else {
      BaseUtil.showNegativeAlert(
        locale.permissionUnavailable,
        locale.enablePermission,
      );
      return false;
    }
    return false;
  }

  Future<void> _chooseProfilePicture() async {
    selectedProfilePicture = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 45);
    if (selectedProfilePicture != null) {
      await BaseUtil.openDialog(
        addToScreenStack: true,
        isBarrierDismissible: false,
        content: ConfirmationDialog(
          asset: NewProfileImage(
            showAction: false,
            image: ClipOval(
              child: Image.file(
                File(selectedProfilePicture!.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          buttonText: locale.btnSave,
          cancelBtnText: locale.btnDiscard,
          description: locale.profileUpdateAlert,
          confirmAction: () {
            _userService.updateProfilePicture(selectedProfilePicture).then(
                  _postProfilePictureUpdate,
                );
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
          },
          title: locale.updatePicture,
        ),
      );
      // _rootViewModel.refresh();
      notifyListeners();
    }
  }

  void _postProfilePictureUpdate(bool flag) {
    if (flag) {
      BaseAnalytics.logProfilePictureAdded();
      BaseUtil.showPositiveAlert(
        locale.btnComplete,
        locale.profileUpdated1,
      );
    } else {
      BaseUtil.showNegativeAlert(
        locale.failed,
        locale.profileUpdateFailedSubtitle,
      );
    }
    AppState.backButtonDispatcher!.didPopRoute();
  }
}
