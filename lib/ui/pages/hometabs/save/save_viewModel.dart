import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/referral_claim_widget.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/tambola_mini_info_card.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/finance/blogs/all_blogs_view.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/help_fab.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_section.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/blogs.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/campaings.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_welcome_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/power_play/root_card.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/model/quick_links_model.dart';

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

  // BaseUtil? baseProvider;

  final BankAndPanService? _sellService = locator<BankAndPanService>();
  final TransactionHistoryRepository? _transactionHistoryRepo =
      locator<TransactionHistoryRepository>();
  final PaymentRepository? _paymentRepo = locator<PaymentRepository>();
  final TxnHistoryService? _txnHistoryService = locator<TxnHistoryService>();
  final UserCoinService? _userCoinService = locator<UserCoinService>();
  final BaseUtil? _baseUtil = locator<BaseUtil>();
  final GetterRepository _getterRepo = locator<GetterRepository>();

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
  Timer? _timer;

  late final PageController offersController = PageController(initialPage: 0);
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
  int _currentPage = 0;

  get currentPage => _currentPage;

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

  UserFundWallet? get userFundWallet => _userService!.userFundWallet;

  double get nonWithdrawableQnt => _nonWithdrawableQnt;

  double get withdrawableQnt => _withdrawableQnt;

  set ongoingEvents(List<EventModel>? value) {
    _ongoingEvents = value;
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

  Future<void> init() async {
    // _baseUtil.fetchUserAugmontDetail();
    // baseProvider = BaseUtil();
    await _userService!.getUserFundWalletData();
    await _userCoinService!.getUserCoinBalance();
    await locator<SubService>().init();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _sellService!.init();
      getCampaignEvents().then((val) {
        if ((ongoingEvents?.length ?? 0) > 1) {
          _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
            if (currentPage < ongoingEvents!.length - 1) {
              currentPage++;
            } else {
              currentPage = 0;
            }
            if (offersController.hasClients) {
              offersController.animateToPage(
                currentPage,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeIn,
              );
            }
          });
        }
      });
      getSaveViewBlogs();
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
    _baseUtil!.openProfileDetailsScreen();
  }

  List<Widget> getSaveViewItems(SaveViewModel smodel) {
    List<Widget> saveViewItems = [];
    saveViewItems.addAll([
      Selector<CardActionsNotifier, bool>(
        selector: (p0, p1) => p1.isVerticalView,
        builder: (context, value, child) => AnimatedContainer(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
          height: SizeConfig.screenWidth! * (value ? 1.54 : 0.8),
        ),
      ),
    ]);

    DynamicUiUtils.saveViewOrder[1].forEach((key) {
      switch (key) {
        case "QL":
          saveViewItems.add(const QuickLinks());
          break;
        case "TM":
          saveViewItems.add(const TambolaMiniInfoCard());
          break;

        case "PP":
          saveViewItems.add(const PowerPlayCard());
          break;
        case "AST":
          saveViewItems.add(const MiniAssetsGroupSection());
          break;
        case "QZ":
          saveViewItems.add(const QuizSection());
          break;
        case 'NAS':
          saveViewItems.add(const AutosaveCard());
          break;
        case 'CH':
          saveViewItems.add(Campaigns(model: smodel));
          break;
        case 'BL':
          saveViewItems.add(Blogs(model: smodel));
          break;
      }
    });

    saveViewItems.addAll([
      SizedBox(height: SizeConfig.padding32),
      const SaveAssetsFooter(),
      const HelpFooter(),
      SizedBox(
        height: SizeConfig.navBarHeight * 0.5,
      )
    ]);
    return saveViewItems;
  }

  List<Widget> getNewUserSaveViewItems(SaveViewModel smodel) {
    List<Widget> saveViewItems = [];
    saveViewItems.addAll([
      const SaveWelcomeCard(),
    ]);

    saveViewItems.add(const ReferralClaimWidget());

    DynamicUiUtils.saveViewOrder[2].forEach((key) {
      switch (key) {
        case "AST":
          saveViewItems.add(SaveAssetsGroupCard(saveViewModel: smodel));
          break;
        case "QL":
          saveViewItems.add(const QuickLinks());
          break;
        case "TM":
          saveViewItems.add(const TambolaMiniInfoCard());
          break;
        case "PP":
          saveViewItems.add(const PowerPlayCard());
          break;
        case 'NAS':
          saveViewItems.add(const AutosaveCard());
          break;
        case "QZ":
          saveViewItems.add(const QuizSection());
          break;

        case 'CH':
          saveViewItems.add(Campaigns(model: smodel));
          break;
        case 'BL':
          saveViewItems.add(Blogs(model: smodel));
          break;
      }
    });
    saveViewItems.addAll([
      SizedBox(height: SizeConfig.padding32),
      const SaveAssetsFooter(),
      const HelpFooter(),
      SizedBox(
        height: SizeConfig.navBarHeight * 0.5,
      )
    ]);
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

  Future<void> getSaveViewBlogs() async {
    final response = await _saveRepo!.getBlogs(5);
    if (response.isSuccess()) {
      blogPosts = response.model;
      print(blogPosts!.length);
    } else {
      print(response.errorMessage);
    }
    updateIsLoading(false);
  }

  Future<void> getAllBlogs() async {
    updateIsLoading(true);
    final response = await _saveRepo!.getBlogs(30);
    blogPosts = response.model;
    blogPosts!
        .sort(((a, b) => a.acf!.categories!.compareTo(b.acf!.categories!)));
    _blogPostsByCategory = getAllBlogsByCategory();
    print(blogPosts!.length);
    updateIsLoading(false);
    notifyListeners();
  }

  Future<void> refreshTransactions(InvestmentType investmentType) async {
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

    String? cat = blogPosts![0].acf!.categories;
    List<BlogPostModel> blogs = [];

    blogPosts!.forEach((blog) {
      if (blog.acf!.categories != cat) {
        result.add(BlogPostModelByCategory(category: cat, blogs: blogs));
        cat = blog.acf!.categories;
        blogs = [blog];
      } else {
        blogs.add(blog);
      }
    });

    result.add(BlogPostModelByCategory(category: cat, blogs: blogs));
    return result;
  }

  /// `Navigation`
  void navigateToBlogWebView(String? slug, String? title) {
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

  void trackChallengeTapped(String bannerUri, String actionUri, int order) {
    _analyticsService!.track(
        eventName: AnalyticsEvents.offerBannerTapped,
        properties: AnalyticsProperties.getDefaultPropertiesMap(
            extraValuesMap: {
              "banner_uri": bannerUri,
              "order": order,
              "action_uri": actionUri
            }));
  }

  void trackBannerClickEvent(int orderNumber) {
    _analyticsService!
        .track(eventName: AnalyticsEvents.bannerClick, properties: {
      "Location": "Fin Gyaan",
      "Order": orderNumber,
    });
  }

  void navigateToViewAllBlogs() {
    Haptic.vibrate();
    _analyticsService!.track(eventName: AnalyticsEvents.allblogsview);
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

class QuickLinks extends StatelessWidget {
  const QuickLinks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<QuickLinksModel> quickLinks = [
      QuickLinksModel(
          name: "Fello Flo",
          asset: Assets.floAsset,
          deeplink: "floDetails",
          color: UiConstants.kFloContainerColor),
      QuickLinksModel(
          name: "Digital Gold",
          asset: Assets.goldAsset,
          deeplink: "goldDetails",
          color: UiConstants.goldSellCardColor),
      QuickLinksModel(
          name: "Refer",
          asset: Assets.referralIcon,
          deeplink: "referrals",
          color: UiConstants.referralIconColor),
      QuickLinksModel(
          name: "Tickets",
          asset: Assets.singleTambolaTicket,
          deeplink: "tambolaHome",
          color: UiConstants.kGoldProBorder),
    ];

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.padding14,
          ),
          width: SizeConfig.screenWidth,
          child: Row(
            children: List.generate(
              quickLinks.length,
              (index) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    Haptic.vibrate();
                    AppState.delegate!
                        .parseRoute(Uri.parse(quickLinks[index].deeplink));
                    locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.iconTrayTapped,
                      properties: {'icon': quickLinks[index].name},
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: quickLinks[index].color,
                        radius: SizeConfig.roundness32,
                        child: SvgPicture.asset(
                          quickLinks[index].asset,
                          width: quickLinks[index].asset == Assets.goldAsset ||
                                  quickLinks[index].asset == Assets.floAsset
                              ? SizeConfig.padding56
                              : SizeConfig.padding36,
                          height: quickLinks[index].asset == Assets.goldAsset ||
                                  quickLinks[index].asset == Assets.floAsset
                              ? SizeConfig.padding56
                              : SizeConfig.padding36,
                        ),
                      ),
                      SizedBox(height: SizeConfig.padding8),
                      Text(
                        quickLinks[index].name,
                        style:
                            TextStyles.sourceSansSB.body3.colour(Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const FloPendingAction()
      ],
    );
  }
}

class FloPendingAction extends StatelessWidget {
  const FloPendingAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LendboxMaturityService>(builder: (context, model, child) {
      if (model.pendingMaturityCount > 0 &&
          (model.filteredDeposits != null &&
              model.filteredDeposits?[0] != null)) {
        return GestureDetector(
          onTap: () {
            Haptic.vibrate();
            BaseUtil.openModalBottomSheet(
              addToScreenStack: true,
              enableDrag: false,
              hapticVibrate: true,
              isBarrierDismissible: true,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              content: ReInvestmentSheet(
                decision: model.userDecision,
                depositData: model.filteredDeposits![0],
              ),
            );
          },
          child: Transform.translate(
            offset: Offset(-SizeConfig.padding10, -SizeConfig.padding16),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(SizeConfig.screenWidth!,
                      (SizeConfig.screenWidth! * 0.27).toDouble()),
                  painter: CustomToolTipPainter(),
                ),
                Positioned(
                  top: SizeConfig.padding36 + SizeConfig.padding1,
                  left: SizeConfig.padding38,
                  child: Row(
                    children: [
                      Text(
                        'Pending actions on ${model.pendingMaturityCount} Flo transactions',
                        style: TextStyles.sourceSans.body2.colour(Colors.white),
                      ),
                      SizedBox(width: SizeConfig.padding38),
                      Container(
                        width: SizeConfig.padding20,
                        height: SizeConfig.padding20,
                        decoration: const ShapeDecoration(
                          color: Color(0xFF1ADAB7),
                          shape: OvalBorder(),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: SizeConfig.padding12,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}

class CustomToolTipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.05434783, size.height * 0.3333333);
    path_0.cubicTo(
        size.width * 0.05434783,
        size.height * 0.2775475,
        size.width * 0.06651413,
        size.height * 0.2323232,
        size.width * 0.08152174,
        size.height * 0.2323232);
    path_0.lineTo(size.width * 0.123, size.height * 0.2323232);
    path_0.cubicTo(
        size.width * 0.1338652,
        size.height * 0.2323232,
        size.width * 0.1439611,
        size.height * 0.2064949,
        size.width * 0.1479837,
        size.height * 0.1673879);
    path_0.lineTo(size.width * 0.1589674, size.height * 0.06060606);
    path_0.lineTo(size.width * 0.1721984, size.height * 0.1720848);
    path_0.cubicTo(
        size.width * 0.1765438,
        size.height * 0.2086980,
        size.width * 0.1862946,
        size.height * 0.2323232,
        size.width * 0.1970603,
        size.height * 0.2323232);
    path_0.lineTo(size.width * 0.9184783, size.height * 0.2323232);
    path_0.cubicTo(
        size.width * 0.9334864,
        size.height * 0.2323232,
        size.width * 0.9456522,
        size.height * 0.2775475,
        size.width * 0.9456522,
        size.height * 0.3333333);
    path_0.lineTo(size.width * 0.9456522, size.height * 0.5555556);
    path_0.cubicTo(
        size.width * 0.9456522,
        size.height * 0.6113414,
        size.width * 0.9334864,
        size.height * 0.6565657,
        size.width * 0.9184783,
        size.height * 0.6565657);
    path_0.lineTo(size.width * 0.08152174, size.height * 0.6565657);
    path_0.cubicTo(
        size.width * 0.06651386,
        size.height * 0.6565657,
        size.width * 0.05434783,
        size.height * 0.6113414,
        size.width * 0.05434783,
        size.height * 0.5555556);
    path_0.lineTo(size.width * 0.05434783, size.height * 0.3333333);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff323232).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.05570652, size.height * 0.3333333);
    path_1.cubicTo(
        size.width * 0.05570652,
        size.height * 0.2803364,
        size.width * 0.06726440,
        size.height * 0.2373737,
        size.width * 0.08152174,
        size.height * 0.2373737);
    path_1.lineTo(size.width * 0.1226019, size.height * 0.2373737);
    path_1.cubicTo(
        size.width * 0.1344285,
        size.height * 0.2373737,
        size.width * 0.1450291,
        size.height * 0.2102535,
        size.width * 0.1492527,
        size.height * 0.1691909);
    path_1.lineTo(size.width * 0.1590571, size.height * 0.07387485);
    path_1.lineTo(size.width * 0.1709552, size.height * 0.1741232);
    path_1.cubicTo(
        size.width * 0.1755179,
        size.height * 0.2125677,
        size.width * 0.1857563,
        size.height * 0.2373737,
        size.width * 0.1970603,
        size.height * 0.2373737);
    path_1.lineTo(size.width * 0.9184783, size.height * 0.2373737);
    path_1.cubicTo(
        size.width * 0.9327364,
        size.height * 0.2373737,
        size.width * 0.9442935,
        size.height * 0.2803364,
        size.width * 0.9442935,
        size.height * 0.3333333);
    path_1.lineTo(size.width * 0.9442935, size.height * 0.5555556);
    path_1.cubicTo(
        size.width * 0.9442935,
        size.height * 0.6085525,
        size.width * 0.9327364,
        size.height * 0.6515152,
        size.width * 0.9184783,
        size.height * 0.6515152);
    path_1.lineTo(size.width * 0.08152174, size.height * 0.6515152);
    path_1.cubicTo(
        size.width * 0.06726440,
        size.height * 0.6515152,
        size.width * 0.05570652,
        size.height * 0.6085525,
        size.width * 0.05570652,
        size.height * 0.5555556);
    path_1.lineTo(size.width * 0.05570652, size.height * 0.3333333);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = const Color(0xff1ADAB7).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = const Color(0xff323232).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
