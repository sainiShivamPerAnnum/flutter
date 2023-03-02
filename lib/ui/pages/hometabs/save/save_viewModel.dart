import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/finance/blogs/all_blogs_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_section.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/blogs.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/campaings.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SaveViewModel extends BaseViewModel {
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
  final SaveRepo? _saveRepo = locator<SaveRepo>();
  final UserService? _userService = locator<UserService>();
  BaseUtil? baseProvider;

  final BankAndPanService? _sellService = locator<BankAndPanService>();
  final TransactionHistoryRepository? _transactionHistoryRepo =
      locator<TransactionHistoryRepository>();
  final PaymentRepository? _paymentRepo = locator<PaymentRepository>();
  final TxnHistoryService? _txnHistoryService = locator<TxnHistoryService>();
  final UserCoinService? _userCoinService = locator<UserCoinService>();
  final BaseUtil? _baseUtil = locator<BaseUtil>();

  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final List<Color> randomBlogCardCornerColors = [
    UiConstants.kBlogCardRandomColor1,
    UiConstants.kBlogCardRandomColor2,
    UiConstants.kBlogCardRandomColor3,
    UiConstants.kBlogCardRandomColor4,
    UiConstants.kBlogCardRandomColor5
  ];
  double _nonWithdrawableQnt = 0.0;
  double _withdrawableQnt = 0.0;
  late final PageController offersController =
      PageController(viewportFraction: 0.9, initialPage: 1);
  List<EventModel>? _ongoingEvents;
  List<BlogPostModel>? _blogPosts;
  List<BlogPostModelByCategory>? _blogPostsByCategory;
  bool _isLoading = true;
  bool _isChallenegsLoading = true;
  List<String> _sellingReasons = [];
  String _selectedReasonForSelling = '';
  Map<String, dynamic> _filteredList = {};

  bool _isGoldSaleActive = false;
  bool _isongoing = false;
  bool _isLockInReached = false;
  bool _isSellButtonVisible = false;

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

  List<EventModel>? get ongoingEvents => this._ongoingEvents;
  List<BlogPostModel>? get blogPosts => this._blogPosts;
  List<BlogPostModelByCategory>? get blogPostsByCategory =>
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
  UserService? get userService => _userService;
  UserFundWallet? get userFundWallet => _userService!.userFundWallet;
  double get nonWithdrawableQnt => _nonWithdrawableQnt;
  double get withdrawableQnt => _withdrawableQnt;

  set ongoingEvents(List<EventModel>? value) {
    this._ongoingEvents = value;
    notifyListeners();
  }

  set blogPosts(List<BlogPostModel>? value) {
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // fetchLockedGoldQnt();
      _sellService!.init();
      getCampaignEvents();
      getSaveViewBlogs();
      // _sellService.updateSellButtonDetails();
    });
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

  openProfile() {
    _baseUtil!.openProfileDetailsScreen();
  }

  getSaveViewItems(SaveViewModel smodel) {
    List<Widget> saveViewItems = [];
    saveViewItems.add(SaveNetWorthSection(saveViewModel: smodel));

    DynamicUiUtils.saveViewOrder[1].forEach((key) {
      switch (key) {
        case 'AS':
          saveViewItems.add(AutosaveCard(locationKey: ValueKey('save')));
          break;
        case 'CH':
          saveViewItems.add(Campaigns(model: smodel));
          break;
        case 'BL':
          saveViewItems.add(Blogs(model: smodel));
          break;
      }
    });
    // saveViewItems.add(Container(
    //   margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
    //   child: AppPositiveBtn(
    //       btnText: "Subscribe",
    //       onPressed: () async {
    //         log(PreferenceHelper.getString("dpUrl", def: "NA"));
    //       }),
    // ));
    saveViewItems.add(
      Container(
        margin: EdgeInsets.only(top: SizeConfig.padding40),
        child: LottieBuilder.network(
            "https://d37gtxigg82zaw.cloudfront.net/scroll-animation.json"),
      ),
    );

    saveViewItems.add(SizedBox(
      height: SizeConfig.navBarHeight,
    ));
    return saveViewItems;
  }

  getCampaignEvents() async {
    final response = await _campaignRepo.getOngoingEvents();
    if (response.isSuccess()) {
      ongoingEvents = response.model;
      ongoingEvents!.sort((a, b) => a.position.compareTo(b.position));
    } else {
      ongoingEvents = [];
    }

    isChallengesLoading = false;
  }

  getSaveViewBlogs() async {
    final response = await _saveRepo!.getBlogs(5);
    if (response.isSuccess()) {
      blogPosts = response.model;
      print(blogPosts!.length);
    } else {
      print(response.errorMessage);
    }
    updateIsLoading(false);
  }

  getAllBlogs() async {
    updateIsLoading(true);
    final response = await _saveRepo!.getBlogs(30);
    blogPosts = response.model;
    blogPosts!
        .sort(((a, b) => a.acf!.categories!.compareTo(b.acf!.categories!)));
    this._blogPostsByCategory = getAllBlogsByCategory();
    print(blogPosts!.length);
    updateIsLoading(false);
    notifyListeners();
  }

  refreshTransactions(InvestmentType investmentType) async {
    await _txnHistoryService!.updateTransactions(investmentType);
    await _userCoinService!.getUserCoinBalance();
    await _userService!.getUserFundWalletData();
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
    } else
      return 0;
  }

  List<BlogPostModelByCategory> getAllBlogsByCategory() {
    List<BlogPostModelByCategory> result = [];

    String? cat = this.blogPosts![0].acf!.categories;
    List<BlogPostModel> blogs = [];

    this.blogPosts!.forEach((blog) {
      if (blog.acf!.categories != cat) {
        result.add(new BlogPostModelByCategory(category: cat, blogs: blogs));
        cat = blog.acf!.categories;
        blogs = [blog];
      } else {
        blogs.add(blog);
      }
    });

    result.add(new BlogPostModelByCategory(category: cat, blogs: blogs));
    return result;
  }

  /// `Navigation`
  navigateToBlogWebView(String? slug, String? title) {
    _analyticsService!.track(eventName: AnalyticsEvents.blogWebView);

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
      _analyticsService!.track(
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
      _analyticsService!.track(
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
        state: PageState.addWidget,
        page: SaveAssetsViewConfig,
        widget: AssetSectionView(
          type: investmentType,
        ),
      );
    }
  }

  trackChallangeTapped(String name, int order) {
    _analyticsService!.track(
        eventName: AnalyticsEvents.challengeCtaTapped,
        properties: AnalyticsProperties.getDefaultPropertiesMap(
            extraValuesMap: {
              "Challlaneg Name": name,
              "Order": order,
              "Location": "Save Section"
            }));
  }

  trackBannerClickEvent(int orderNumber) {
    _analyticsService!
        .track(eventName: AnalyticsEvents.bannerClick, properties: {
      "Location": "Fin Gyaan",
      "Order": orderNumber,
    });
  }

  navigateToCompleteKYC() {
    Haptic.vibrate();
    _analyticsService!.track(eventName: AnalyticsEvents.openKYCSection);

    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: KycDetailsPageConfig,
    );
  }

  navigateToVerifyVPA() {
    Haptic.vibrate();

    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: EditAugBankDetailsPageConfig,
    );
  }

  navigateToViewAllBlogs() {
    Haptic.vibrate();
    _analyticsService!.track(eventName: AnalyticsEvents.allblogsview);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: ViewAllBlogsViewConfig,
      widget: ViewAllBlogsView(),
    );
  }
}
