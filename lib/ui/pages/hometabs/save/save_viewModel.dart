import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/service/notifier_services/sell_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_assets_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/view_all_blogs_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_view.dart';
import 'package:felloapp/ui/pages/others/profile/bank_details/bank_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SaveViewModel extends BaseModel {
  final _campaignRepo = locator<CampaignRepo>();
  final _saveRepo = locator<SaveRepo>();
  final _userService = locator<UserService>();
  BaseUtil baseProvider;
  final SellService _sellService = locator<SellService>();
  final _paymentRepo = locator<PaymentRepository>();
  final _baseUtil = locator<BaseUtil>();
  final List<Color> randomBlogCardCornerColors = [
    UiConstants.kBlogCardRandomColor1,
    UiConstants.kBlogCardRandomColor2,
    UiConstants.kBlogCardRandomColor3,
    UiConstants.kBlogCardRandomColor4,
    UiConstants.kBlogCardRandomColor5
  ];
  double _nonWithdrawableQnt = 0.0;
  double _withdrawableQnt = 0.0;

  List<EventModel> _ongoingEvents;
  List<BlogPostModel> _blogPosts;
  List<BlogPostModelByCategory> _blogPostsByCategory;
  bool _isLoading = false;
  bool _isChallenegsLoading = false;
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
  List<BlogPostModelByCategory> get blogPostsByCategory =>
      this._blogPostsByCategory;
  bool get isLoading => _isLoading;
  bool get isChallengesLoading => _isChallenegsLoading;
  List<String> get sellingReasons => _sellingReasons;
  String get selectedReasonForSelling => _selectedReasonForSelling;
  Map<String, dynamic> get filteredBlogList => _filteredList;
  bool get isKYCVerified => _isKYCVerified;
  bool get isVPAVerified => _isVPAVerified;
  bool get isGoldSaleActive => _isGoldSaleActive;
  bool get isOngoingTransaction => _isOngoingTransaction;
  bool get isLockInReached => _isLockInReached;
  bool get isSellButtonVisible => _isSellButtonVisible;
  UserService get userService => _userService;
  UserFundWallet get userFundWallet => _userService.userFundWallet;
  double get nonWithdrawableQnt => _nonWithdrawableQnt;
  double get withdrawableQnt => _withdrawableQnt;

  set ongoingEvents(List<EventModel> value) {
    this._ongoingEvents = value;
    notifyListeners();
  }

  set blogPosts(List<BlogPostModel> value) {
    this._blogPosts = value;
    notifyListeners();
  }

  set setWithdrawableQnt(double value) {
    this._withdrawableQnt = value;
    notifyListeners();
  }

  set setNonWithdrawableQnt(double value) {
    this._nonWithdrawableQnt = value;
    notifyListeners();
  }

  set selectedReasonForSelling(String val) {
    this._selectedReasonForSelling = val;
    notifyListeners();
  }

  init() {
    _baseUtil.fetchUserAugmontDetail();
    baseProvider = BaseUtil();
    getCampaignEvents();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchLockedGoldQnt();
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

  void updateIsChallengesLoading(bool value) {
    _isChallenegsLoading = value;
    notifyListeners();
  }

  openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  updateSellButtonDetails() async {
    _isKYCVerified = _sellService?.isKYCVerified ?? false;
    _isVPAVerified = _sellService?.isVPAVerified ?? false;
    if (withdrawableQnt <= nonWithdrawableQnt) {
      _isLockInReached = true;
    }
    _isGoldSaleActive = _baseUtil.augmontDetail?.isSellLocked ?? false;
    _isOngoingTransaction = _sellService?.isOngoingTransaction ?? false;
    notifyListeners();
  }

  getCampaignEvents() async {
    updateIsChallengesLoading(true);
    final response = await _campaignRepo.getOngoingEvents();
    if (response.code == 200) {
      ongoingEvents = response.model;
      ongoingEvents.sort((a, b) => a.position.compareTo(b.position));
      ongoingEvents.forEach((element) {
        print(element.toString());
      });
    } else {
      ongoingEvents = [];
    }
    updateIsChallengesLoading(false);
  }

  fetchLockedGoldQnt() async {
    await _userService.getUserFundWalletData();
    ApiResponse<double> qunatityApiResponse =
        await _paymentRepo.getWithdrawableAugGoldQuantity();
    if (qunatityApiResponse.code == 200) {
      setWithdrawableQnt = qunatityApiResponse.model;
      if (_withdrawableQnt == null || _withdrawableQnt < 0) {
        setWithdrawableQnt = 0.0;
      }
      if (userFundWallet == null ||
          userFundWallet.augGoldQuantity == null ||
          userFundWallet.augGoldQuantity <= 0.0) {
        setNonWithdrawableQnt = 0.0;
      } else {
        setNonWithdrawableQnt = BaseUtil.digitPrecision(
            math.max(0.0, userFundWallet.augGoldQuantity - _withdrawableQnt),
            4,
            false);
      }
    } else {
      setNonWithdrawableQnt = 0.0;
      setWithdrawableQnt = 0.0;
    }
    refresh();
  }

  Color getRandomColor() {
    math.Random random = math.Random();
    return randomBlogCardCornerColors[random.nextInt(5)];
  }

  bool getButtonAvailibility() {
    if (_isKYCVerified && _isVPAVerified) {
      if (!_isGoldSaleActive && (_isKYCVerified && _isVPAVerified)) {
        return true;
      }
      if (!_isLockInReached && (_isKYCVerified && _isVPAVerified)) {
        return true;
      }
      if (!_isOngoingTransaction && (_isKYCVerified && _isVPAVerified)) {
        return true;
      }
    }
    return false;
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
    this._blogPostsByCategory = getAllBlogsByCategory();
    print(blogPosts.length);
    updateIsLoading(false);
    notifyListeners();
  }

  List<BlogPostModelByCategory> getAllBlogsByCategory() {
    List<BlogPostModelByCategory> result = [];

    String cat = this.blogPosts[0].acf.categories;
    List<BlogPostModel> blogs = [];

    this.blogPosts.forEach((blog) {
      if (blog.acf.categories != cat) {
        result.add(new BlogPostModelByCategory(category: cat, blogs: blogs));
        cat = blog.acf.categories;
        blogs = [blog];
      } else {
        blogs.add(blog);
      }
    });

    result.add(new BlogPostModelByCategory(category: cat, blogs: blogs));
    return result;
  }

  /// `Navigation`
  navigateToBlogWebView(String slug, String title) {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: BlogPostWebViewConfig,
        widget: BlogWebView(
          initialUrl: 'https://fello.in/blogs/$slug?content_only=true',
          title: title,
        ));
  }

  navigateToSaveAssetView() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SaveAssetsViewConfig,
        widget: SaveAssetView());
  }

  navigateToSellGoldPage() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: AugmontGoldSellPageConfig,
        widget: AugmontGoldSellView());
  }

  navigateToCompleteKYC() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: KycDetailsPageConfig,
        widget: KYCDetailsView());
  }

  navigateToVerifyVPA() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: EditAugBankDetailsPageConfig,
    );
  }

  navigateToViewAllBlogs() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: ViewAllBlogsViewConfig,
      widget: ViewAllBlogsView(),
    );
  }
}
