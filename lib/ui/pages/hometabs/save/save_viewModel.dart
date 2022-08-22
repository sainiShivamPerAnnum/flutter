import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/service/notifier_services/sell_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_assets.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/view_all_blogs_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_view.dart';
import 'package:felloapp/ui/pages/others/profile/bank_details/bank_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SaveViewModel extends BaseModel {
  final _campaignRepo = locator<CampaignRepo>();
  final _saveRepo = locator<SaveRepo>();
  final userService = locator<UserService>();
  BaseUtil baseProvider;
  final SellService _sellService = locator<SellService>();
  final _baseUtil = locator<BaseUtil>();
  final List<Color> randomBlogCardCornerColors = [
    UiConstants.kBlogCardRandomColor1,
    UiConstants.kBlogCardRandomColor2,
    UiConstants.kBlogCardRandomColor3,
    UiConstants.kBlogCardRandomColor4,
    UiConstants.kBlogCardRandomColor5
  ];

  List<EventModel> _ongoingEvents;
  List<BlogPostModel> _blogPosts;
  bool _isLoading = false;
  List<String> _sellingReasons = [];
  String _selectedReasonForSelling = '';
  Map<String, dynamic> _filteredList = {};
  bool _isKYCVerified = false;
  bool _isVPAVerified = false;
  bool _isGoldSaleActive = false;
  bool _isOngoingTransaction = false;
  bool _isLockInReached = false;
  bool _isSellButtonVisible = false;

  final String fetchBlogUrl =
      'https://felloblog815893968.wpcomstaging.com/wp-json/wp/v2/blog/';

  List<EventModel> get ongoingEvents => this._ongoingEvents;
  List<BlogPostModel> get blogPosts => this._blogPosts;
  bool get isLoading => _isLoading;
  List<String> get sellingReasons => _sellingReasons;
  String get selectedReasonForSelling => _selectedReasonForSelling;
  Map<String, dynamic> get filteredBlogList => _filteredList;
  bool get isKYCVerified => _isKYCVerified;
  bool get isVPAVerified => _isVPAVerified;
  bool get isGoldSaleActive => _isGoldSaleActive;
  bool get isOngoingTransaction => _isOngoingTransaction;
  bool get isLockInReached => _isLockInReached;
  bool get isSellButtonVisible => _isSellButtonVisible;

  set ongoingEvents(List<EventModel> value) {
    this._ongoingEvents = value;
    notifyListeners();
  }

  set blogPosts(List<BlogPostModel> value) {
    this._blogPosts = value;
    notifyListeners();
  }

  set selectedReasonForSelling(String val) {
    this._selectedReasonForSelling = val;
    notifyListeners();
  }

  init() {
    _sellingReasons = [
      'Not interested anymore',
      'Not interested anymore',
      'Not interested anymore',
      'Others'
    ];
    baseProvider = BaseUtil();
    getCampaignEvents();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _sellService.init();
      updateSellButtonDetails();
    });
    getSaveViewBlogs();
    notifyListeners();
  }

  void updateIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  updateSellButtonDetails() {
    _isKYCVerified = _sellService.isKYCVerified;
    _isVPAVerified = _sellService.isVPAVerified;
    _isGoldSaleActive = _sellService.isGoldSaleActive;
    _isLockInReached = _sellService.isLockInReached;
    _isOngoingTransaction = _sellService.isOngoingTransaction;
  }

  getCampaignEvents() async {
    updateIsLoading(true);
    final response = await _campaignRepo.getOngoingEvents();
    if (response.code == 200) {
      ongoingEvents = response.model;
      ongoingEvents.sort((a, b) => a.position.compareTo(b.position));
      ongoingEvents.forEach((element) {
        print(element.toString());
      });
    } else
      ongoingEvents = [];
    updateIsLoading(false);
  }

  Color getRandomColor() {
    Random random = Random();
    return randomBlogCardCornerColors[random.nextInt(5)];
  }

  getSaveViewBlogs() async {
    updateIsLoading(true);
    final response = await _saveRepo.getBlogs(5);
    blogPosts = response.model;
    print(blogPosts.length);
    updateIsLoading(false);
    notifyListeners();
  }

  getAllBlogs() async {
    updateIsLoading(true);
    final response = await _saveRepo.getBlogs(30);
    blogPosts = response.model;
    blogPosts.sort(((a, b) => a.acf.categories.compareTo(b.acf.categories)));
    print(blogPosts.length);
    updateIsLoading(false);
    notifyListeners();
  }

  /// `Navigation`
  navigateToBlogWebView(String slug) {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: BlogPostWebViewConfig,
        widget: BlogWebView(
          initialUrl: 'https://fello.in/blogs/$slug?content_only=true',
        ));
  }

  navigateToSaveAssetView() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SaveAssetsViewConfig,
        widget: SaveAssetView());
  }

  navigateToSellGoldPage() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: AugmontGoldSellPageConfig,
        widget: AugmontGoldSellView());
  }

  navigateToCompleteKYC() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: KycDetailsPageConfig,
        widget: KYCDetailsView());
  }

  navigateToVerifyVPA() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: BankDetailsPageConfig,
        widget: BankDetailsView());
  }

  navigateToViewAllBlogs() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: ViewAllBlogsViewConfig,
        widget: ViewAllBlogsView());
  }
}
