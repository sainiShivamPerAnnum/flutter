import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/bookings/upcoming_booking.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/core/model/testimonials_model.dart';
// import 'package:felloapp/core/model/top_expert_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/p2p_home/home/ui/p2p_home_view.dart';
import 'package:felloapp/feature/shorts/src/core/analytics_manager.dart';
import 'package:felloapp/feature/shorts/src/service/shorts_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/blogs/all_blogs_view.dart';
import 'package:felloapp/ui/pages/hometabs/home/cards_new.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/blogs.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/campaings.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/experts.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/first_free_call.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/footer.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/live.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/past_bookings.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/quick_links.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/testimonials.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/upcoming_bookings.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaveViewModel extends ChangeNotifier {
  S? locale;

  SaveViewModel({this.locale}) {
    locale = locator<S>();
    boxTitllesGold.addAll([
      locale!.boxGoldTitles1,
      locale!.boxGoldTitles2,
      locale!.boxGoldTitles3,
    ]);
    boxTitllesFlo.addAll(
        [locale!.boxFloTitles1, locale!.boxFloTitles2, locale!.boxFloTitles3]);
  }

  final CampaignRepo _campaignRepo = locator<CampaignRepo>();
  final SaveRepo _saveRepo = locator<SaveRepo>();
  final UserService _userService = locator<UserService>();

  // BaseUtil? baseProvider;

  final BankAndPanService _sellService = locator<BankAndPanService>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final GetterRepository _getterRepo = locator<GetterRepository>();

  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final List<Color> randomBlogCardCornerColors = [
    UiConstants.kBlogCardRandomColor1,
    UiConstants.kBlogCardRandomColor2,
    UiConstants.kBlogCardRandomColor3,
    UiConstants.kBlogCardRandomColor4,
    UiConstants.kBlogCardRandomColor5
  ];
  double _nonWithdrawableQnt = 0.0;
  double _withdrawableQnt = 0.0;
  List<EventModel>? _ongoingEvents;
  List<BlogPostModel>? _blogPosts;
  List<Booking> _upcomingBookings = [];
  List<Booking> _pastBookings = [];
  ExpertsHome? _topExperts;
  List<UserInterestedAdvisor> _userInterestedAdvisors = [];
  LiveHome? _liveData;
  bool _freeCallAvailable = false;
  List<BlogPostModelByCategory>? _blogPostsByCategory;
  bool _isLoading = true;
  bool _isChallenegsLoading = true;
  bool _isTopAdvisorLoading = true;
  final List<String> _sellingReasons = [];
  List<TestimonialsModel> _testimonials = [
    TestimonialsModel(
      userName: "Shivam Saini",
      review:
          "Throughout the planning and execution phase, they worked with me in a professional manner, answered all my questions patiently, and guided me through the whole process in a methodical way. Fello's expert advice made all the difference in my financial journey.",
      createdAt: "2023-03-15T14:20:00Z",
      avatarId: "AV1",
      rating: 4,
    ),
    TestimonialsModel(
      userName: "Aarti Sharma",
      review:
          "I am extremely happy with the financial advice I received from Fello. The team understood my goals and provided tailored solutions that really helped me get my finances on track. Their professional approach and dedication gave me peace of mind.",
      createdAt: "2023-02-28T10:45:00Z",
      avatarId: "AV2",
      rating: 4.5,
    ),
    TestimonialsModel(
      userName: "Ravi Kumar",
      review:
          "Fello's financial advisors helped me with investment strategies that have been extremely profitable. I appreciated their transparency and how they took the time to explain complex concepts in a way that was easy to understand.",
      createdAt: "2023-03-01T16:30:00Z",
      avatarId: "AV3",
      rating: 5,
    ),
  ];

  String _selectedReasonForSelling = '';
  final Map<String, dynamic> _filteredList = {};

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
  List<String> boxTitllesGold = [];
  List<String> boxTitllesFlo = [];

  List<EventModel>? get ongoingEvents => _ongoingEvents;

  List<BlogPostModel>? get blogPosts => _blogPosts;

  List<Booking> get upcomingBookings => _upcomingBookings;
  List<Booking> get pastBookings => _pastBookings;
  List<UserInterestedAdvisor> get userInterestedAdvisors =>
      _userInterestedAdvisors;
  ExpertsHome? get topExperts => _topExperts;
  LiveHome? get liveData => _liveData;
  List<TestimonialsModel> get testimonials => _testimonials;
  bool get freeCallAvailable => _freeCallAvailable;

  List<BlogPostModelByCategory>? get blogPostsByCategory =>
      _blogPostsByCategory;

  bool get isLoading => _isLoading;

  bool get isChallengesLoading => _isChallenegsLoading;
  bool get isTopAdvisorLoading => _isTopAdvisorLoading;

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

  set upcomingBookings(List<Booking> value) {
    _upcomingBookings = value;
    notifyListeners();
  }

  set pastBookings(List<Booking> value) {
    _pastBookings = value;
    notifyListeners();
  }

  set topExperts(ExpertsHome? value) {
    _topExperts = value;
    notifyListeners();
  }

  set userInterestedAdvisors(List<UserInterestedAdvisor> value) {
    _userInterestedAdvisors = value;
    notifyListeners();
  }

  set testimonials(List<TestimonialsModel> value) {
    _testimonials = value;
    notifyListeners();
  }

  set liveData(LiveHome? value) {
    _liveData = value;
    notifyListeners();
  }

  set freeCallAvailable(bool value) {
    _freeCallAvailable = value;
    notifyListeners();
  }

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

  Future<void> pullRefresh() async {
    await Future.wait([
      _userCoinService.getUserCoinBalance(),
      _userService.getUserFundWalletData(),
      getUpcomingBooking(),
      getPastBooking(),
      getTopExperts(),
      getLiveData(),
    ]);
    _txnHistoryService.signOut();
  }

  Future<void> init() async {
    // _baseUtil.fetchUserAugmontDetail();
    // baseProvider = BaseUtil();
    await _userService.getUserFundWalletData();
    await _userCoinService.getUserCoinBalance();
    await getUpcomingBooking();
    await getPastBooking();
    await getTopExperts();
    await getLiveData();
    await getCampaignEvents();
    await locator<SubService>().init();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _sellService.init();
      getSaveViewBlogs();
      getTestimonials();
      final repository = locator<ShortsRepo>();
      AnalyticsRetryManager.pushQueuedEvents(repository);
    });
  }

  void dump() {}

  void updateIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set isChallengesLoading(bool value) {
    _isChallenegsLoading = value;
    notifyListeners();
  }

  set isTopAdvisorLoading(bool value) {
    _isTopAdvisorLoading = value;
    notifyListeners();
  }

  void openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  List<Widget> getSaveViewItems(SaveViewModel smodel) {
    List<Widget> saveViewItems = [];
    for (final key in DynamicUiUtils.saveViewOrder[1]) {
      switch (key) {
        case 'PBL':
          saveViewItems.add(const PortfolioCard());
          break;
        case "QL":
          saveViewItems.add(const QuickLinks());
          break;
        case "LV":
          saveViewItems.add(
            const TopLive(),
          );
          break;
        case "EXP":
          saveViewItems.add(
            const Experts(),
          );
          break;
        case "SN":
          saveViewItems.add(const Testimonials());
          break;
        case 'NAS':
          saveViewItems.add(const AutosaveCard());
          break;
        case 'CH':
          saveViewItems.add(const Campaigns());
          break;
        case 'BL':
          saveViewItems.add(const Blogs());
          break;
        case 'UPB':
          saveViewItems.add(const UpcomingBookingsComponent());
          break;
        case 'PB':
          saveViewItems.add(const PastBookingsComponent());
          break;
        case 'FC':
          saveViewItems.add(const FirstFreeCall());
          break;
        case 'TST':
          saveViewItems.add(const Testimonials());
          break;
        case 'FT':
          saveViewItems.add(const SaveViewFooter());
          break;
      }
    }
    saveViewItems.add(
      SizedBox(
        height: 60.h,
      ),
    );
    return saveViewItems;
  }

  Future<void> getCampaignEvents() async {
    final response = await _campaignRepo.getOngoingEvents();
    if (response.isSuccess()) {
      ongoingEvents = response.model;
      ongoingEvents!.sort((a, b) => a.position.compareTo(b.position));
    } else {
      ongoingEvents = [];
    }

    isChallengesLoading = false;
  }

  Future<void> getUpcomingBooking() async {
    final response = await _saveRepo.getUpcomingBookings();
    if (response.isSuccess()) {
      upcomingBookings = response.model ?? [];
    } else {
      upcomingBookings = [];
    }
  }

  Future<void> getTestimonials() async {
    final response = await _saveRepo.getTestimonials();
    if (response.isSuccess()) {
      testimonials = response.model ?? [];
    } else {
      testimonials = [];
    }
  }

  Future<void> getPastBooking() async {
    final response = await _saveRepo.getPastBookings();
    if (response.isSuccess()) {
      pastBookings = response.model ?? [];
    } else {
      pastBookings = [];
    }
  }

  Future<void> getTopExperts() async {
    final response = await _saveRepo.getTopExpertsData();
    if (response.isSuccess()) {
      topExperts = response.model?.$1;
      freeCallAvailable = response.model?.$2 ?? false;
      userInterestedAdvisors = response.model?.$1.userInterestedAdvisors ?? [];
    } else {
      topExperts = null;
    }
    if (topExperts != null) {
      final otherSections = topExperts!.list
          .where((section) => !section.toLowerCase().contains('top'))
          .toList();
      RootController.expertsSections = otherSections;
    }
    isTopAdvisorLoading = false;
  }

  Future<void> getLiveData() async {
    final response = await _saveRepo.getLiveHomeData();
    if (response.isSuccess()) {
      liveData = response.model;
    } else {
      print(response.errorMessage);
    }
  }

  Future<void> getSaveViewBlogs() async {
    final response = await _saveRepo.getBlogs(5);
    if (response.isSuccess()) {
      blogPosts = response.model;
    } else {
      blogPosts = [];
    }
    updateIsLoading(false);
  }

  Future<void> getAllBlogs() async {
    updateIsLoading(true);
    final response = await _saveRepo.getBlogs(30);
    blogPosts = response.model;
    blogPosts!.sort((a, b) => a.acf!.categories!.compareTo(b.acf!.categories!));
    _blogPostsByCategory = getAllBlogsByCategory();
    updateIsLoading(false);
    notifyListeners();
  }

  Future<void> refreshTransactions(InvestmentType investmentType) async {
    await _txnHistoryService.updateTransactions(investmentType);
    await _userCoinService.getUserCoinBalance();
    await _userService.getUserFundWalletData();
  }

  double getQuantity(
    UserFundWallet? fund,
    var investmentType,
  ) {
    final quantity = investmentType == InvestmentType.AUGGOLD99
        ? fund?.augGoldQuantity
        : fund?.wLbBalance;

    if (quantity != null) {
      return quantity;
    } else {
      return 0;
    }
  }

  double getInvestedQuantity(UserFundWallet? fund) {
    final quantity = fund?.wLbPrinciple;

    if (quantity != null) {
      return quantity;
    } else {
      return 0;
    }
  }

  List<BlogPostModelByCategory> getAllBlogsByCategory() {
    List<BlogPostModelByCategory> result = [];

    String? cat = blogPosts![0].acf!.categories;
    List<BlogPostModel> blogs = [];

    for (final blog in blogPosts!) {
      if (blog.acf!.categories != cat) {
        result.add(BlogPostModelByCategory(category: cat, blogs: blogs));
        cat = blog.acf!.categories;
        blogs = [blog];
      } else {
        blogs.add(blog);
      }
    }

    result.add(BlogPostModelByCategory(category: cat, blogs: blogs));
    return result;
  }

  /// `Navigation`
  void navigateToBlogWebView(String? slug, String? title) {
    _analyticsService.track(eventName: AnalyticsEvents.blogWebView);

    AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: BlogPostWebViewConfig,
        widget: BlogWebView(
          initialUrl: 'https://fello.in/blogs/$slug?content_only=true',
          title: title!,
        ));
  }

  void navigateToSaveAssetView(
    InvestmentType investmentType,
  ) {
    Haptic.vibrate();

    if (investmentType == InvestmentType.AUGGOLD99) {
      _analyticsService.track(
          eventName: AnalyticsEvents.assetBannerTapped,
          properties:
              AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
            'Asset': 'Gold',
            "Failed transaction count": AnalyticsProperties.getFailedTxnCount(),
            "Successs transaction count":
                AnalyticsProperties.getSucessTxnCount(),
            "Pending transaction count":
                AnalyticsProperties.getPendingTxnCount(),
          }));

      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SaveAssetsViewConfig,
        widget: AssetSectionView(
          type: investmentType,
        ),
      );
    } else {
      _analyticsService.track(
          eventName: AnalyticsEvents.assetBannerTapped,
          properties:
              AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
            'Asset': 'Flo',
            "Failed transaction count": AnalyticsProperties.getFailedTxnCount(),
            "Successs transaction count":
                AnalyticsProperties.getSucessTxnCount(),
            "Pending transaction count":
                AnalyticsProperties.getPendingTxnCount(),
          }));

      AppState.delegate!.appState.currentAction = PageAction(
        page: P2PHomePageConfig,
        widget: const P2PHomePage(),
        state: PageState.addWidget,
      );
    }
  }

  void trackChallengeTapped(String bannerUri, String actionUri, int order) {
    _analyticsService.track(
      eventName: AnalyticsEvents.offerBannerTapped,
      properties: AnalyticsProperties.getDefaultPropertiesMap(
        extraValuesMap: {
          "banner_uri": bannerUri,
          "Sequence": order,
          "action_uri": actionUri
        },
      ),
    );
  }

  void trackBannerClickEvent(int orderNumber) {
    _analyticsService
        .track(eventName: AnalyticsEvents.bannerClick, properties: {
      "Location": "Fin Gyaan",
      "Order": orderNumber,
    });
  }

  void navigateToViewAllBlogs() {
    Haptic.vibrate();
    _analyticsService.track(eventName: AnalyticsEvents.allblogsview);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: ViewAllBlogsViewConfig,
      widget: const ViewAllBlogsView(),
    );
  }

  Future<void> getGoldRatesGraphData() async {
    await _getterRepo.getGoldRatesGraphItems();
  }
}
