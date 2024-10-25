import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/event_model.dart';
// import 'package:felloapp/core/model/top_expert_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/advisor/advisor_components/call.dart';
import 'package:felloapp/ui/pages/advisor/advisor_components/live.dart';
import 'package:felloapp/ui/pages/support-new/support_components/find_us.dart';
import 'package:felloapp/ui/pages/support-new/support_components/help.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class AdvisorViewModel extends BaseViewModel {
  S? locale;

  AdvisorViewModel({this.locale}) {
    locale = locator<S>();
    boxTitllesGold.addAll([
      locale!.boxGoldTitles1,
      locale!.boxGoldTitles2,
      locale!.boxGoldTitles3,
    ]);
    boxTitllesFlo.addAll(
        [locale!.boxFloTitles1, locale!.boxFloTitles2, locale!.boxFloTitles3]);
  }

  final UserService _userService = locator<UserService>();

  // BaseUtil? baseProvider;

  final BaseUtil _baseUtil = locator<BaseUtil>();

  final List<Color> randomBlogCardCornerColors = [
    UiConstants.kBlogCardRandomColor1,
    UiConstants.kBlogCardRandomColor2,
    UiConstants.kBlogCardRandomColor3,
    UiConstants.kBlogCardRandomColor4,
    UiConstants.kBlogCardRandomColor5
  ];
  double _nonWithdrawableQnt = 0.0;
  double _withdrawableQnt = 0.0;
  Timer? _timer;

  late final PageController offersController = PageController(initialPage: 0);
  List<EventModel>? _ongoingEvents;
  List<BlogPostModel>? _blogPosts;
  // List<TopExpertModel>? _topExperts;
  List<BlogPostModelByCategory>? _blogPostsByCategory;
  bool _isLoading = true;
  bool _isChallenegsLoading = true;
  final List<String> _sellingReasons = [];
  String _selectedReasonForSelling = '';
  final Map<String, dynamic> _filteredList = {};
  final UserCoinService _userCoinService = locator<UserCoinService>();

  final bool _isGoldSaleActive = false;
  final bool _isongoing = false;
  final bool _isLockInReached = false;
  final bool _isSellButtonVisible = false;
  int _currentPage = 0;

  int get currentPage => _currentPage;

  set currentPage(value) {
    _currentPage = value;
    notifyListeners();
  }

  final String fetchBlogUrl =
      'https://felloblog815893968.wpcomstaging.com/wp-json/wp/v2/blog/';

  List<String> boxAssetsGold = [
    "assets/svg/single_gold_bar_asset.svg",
    Assets.singleCoinAsset,
    Assets.goldSecure,
  ];
  List<String> boxTitllesGold = [];
  List<String> boxTitllesFlo = [];
  List<String> boxAssetsFlo = [
    Assets.star,
    Assets.singleCoinAsset,
    Assets.flatIsland,
  ];

  List<EventModel>? get ongoingEvents => _ongoingEvents;

  List<BlogPostModel>? get blogPosts => _blogPosts;

  // List<TopExpertModel>? get topExperts => _topExperts;

  List<BlogPostModelByCategory>? get blogPostsByCategory =>
      _blogPostsByCategory;

  bool get isLoading => _isLoading;

  bool get isChallengesLoading => _isChallenegsLoading;

  List<String> get sellingReasons => _sellingReasons;

  String get selectedReasonForSelling => _selectedReasonForSelling;

  Map<String, dynamic> get filteredBlogList => _filteredList;

  // bool get isKYCVerified => _isKYCVerified;
  // bool get isVPAVerified => _isVPAVerified;
  bool get isGoldSaleActive => _isGoldSaleActive;

  bool get isongoing => _isongoing;

  bool get isLockInReached => _isLockInReached;

  bool get isSellButtonVisible => _isSellButtonVisible;

  UserService? get userService => _userService;

  UserFundWallet? get userFundWallet => _userService.userFundWallet;

  double get nonWithdrawableQnt => _nonWithdrawableQnt;

  double get withdrawableQnt => _withdrawableQnt;

  set ongoingEvents(List<EventModel>? value) {
    _ongoingEvents = value;
    notifyListeners();
  }

  // set topExperts(List<TopExpertModel>? value) {
  //   _topExperts = value;
  //   notifyListeners();
  // }

  set blogPosts(List<BlogPostModel>? value) {
    _blogPosts = value;
    notifyListeners();
  }

  set setWithdrawableQnt(double value) {
    _withdrawableQnt = value;
    notifyListeners();
  }

  set setNonWithdrawableQnt(double value) {
    _nonWithdrawableQnt = value;
    notifyListeners();
  }

  set selectedReasonForSelling(String val) {
    _selectedReasonForSelling = val;
    notifyListeners();
  }

  Future<void> init() async {
    // _baseUtil.fetchUserAugmontDetail();
    // baseProvider = BaseUtil();
    await _userService.getUserFundWalletData();
    await _userCoinService.getUserCoinBalance();
    // await getTopExperts();
    // await locator<SubService>().init();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _sellService.init();
      // getCampaignEvents().then((val) {
      //   if ((ongoingEvents?.length ?? 0) > 1) {
      //     _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      //       if (currentPage < ongoingEvents!.length - 1) {
      //         currentPage++;
      //       } else {
      //         currentPage = 0;
      //       }
      //       if (offersController.hasClients) {
      //         offersController.animateToPage(
      //           currentPage,
      //           duration: const Duration(milliseconds: 350),
      //           curve: Curves.easeIn,
      //         );
      //       }
      //     });
      //   }
      // });
      // getSaveViewBlogs();
    });
  }

  void dump() {
    _timer?.cancel();
  }

  void updateIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set isChallengesLoading(bool value) {
    _isChallenegsLoading = value;
    print("ROOT: Challenges loading : $value");
    notifyListeners();
  }

  void openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  List<Widget> getSaveViewItems(AdvisorViewModel smodel) {
    List<Widget> saveViewItems = [];
    for (final key in DynamicUiUtils.advisor) {
      print(key);
      switch (key) {
        case "LV":
          saveViewItems.add(Live(
            model: smodel,
          ));
          break;
        // case "QL":
        //   saveViewItems.add(WhatNew(
        //     model: smodel,
        //   ));
        //   break;

        case "UC":
          saveViewItems.add(Call(callType: "upcoming"));
          break;
        case "PC":
          saveViewItems.add(Call(callType: "past"));
          break;
      }
    }

    saveViewItems.addAll([
      SizedBox(
        height: SizeConfig.navBarHeight * 0.5,
      )
    ]);
    return saveViewItems;
  }
}
