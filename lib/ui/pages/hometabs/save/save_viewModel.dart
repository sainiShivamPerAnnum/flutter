import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/save_assets_view.dart';
import 'package:felloapp/ui/pages/others/finance/blogs/all_blogs_view.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/detail_page/lendbox_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SaveViewModel extends BaseViewModel {
  final _campaignRepo = locator<CampaignRepo>();
  final _saveRepo = locator<SaveRepo>();
  final _userService = locator<UserService>();
  BaseUtil baseProvider;
  final BankAndPanService _sellService = locator<BankAndPanService>();
  final _transactionHistoryRepo = locator<TransactionHistoryRepository>();
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
  bool _isLoading = true;
  bool _isChallenegsLoading = false;
  List<String> _sellingReasons = [];
  String _selectedReasonForSelling = '';
  Map<String, dynamic> _filteredList = {};
  bool _isKYCVerified = false;
  bool _isVPAVerified = false;
  bool _isGoldSaleActive = false;
  bool _isongoing = false;
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
  // bool get isKYCVerified => _isKYCVerified;
  // bool get isVPAVerified => _isVPAVerified;
  bool get isGoldSaleActive => _isGoldSaleActive;
  bool get isongoing => _isongoing;
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
    // _baseUtil.fetchUserAugmontDetail();
    baseProvider = BaseUtil();
    getCampaignEvents();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // fetchLockedGoldQnt();
      _sellService.init();
      // _sellService.updateSellButtonDetails();
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

  getSaveViewBlogs() async {
    final response = await _saveRepo.getBlogs(5);
    if (response.isSuccess()) {
      blogPosts = response.model;
      print(blogPosts.length);
    } else {
      print(response.errorMessage);
    }
    updateIsLoading(false);
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

  void navigateToSaveAssetView(
    InvestmentType investmentType,
  ) {
    Haptic.vibrate();

    if (investmentType == InvestmentType.AUGGOLD99)
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SaveAssetsViewConfig,
        widget: SaveAssetView(),
      );
    else
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: LendboxDetailsPageConfig,
        widget: LendboxDetailsView(),
      );
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
