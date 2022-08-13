import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_assets.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/sell_assets/sell_assets_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';

class SaveViewModel extends BaseModel {
  final _campaignRepo = locator<CampaignRepo>();
  final _saveRepo = locator<SaveRepo>();
  final userService = locator<UserService>();

  List<EventModel> _ongoingEvents;
  List<BlogPostModel> _blogPosts;
  bool _isLoading = false;

  final String fetchBlogUrl =
      'https://felloblog815893968.wpcomstaging.com/wp-json/wp/v2/blog/';

  List<EventModel> get ongoingEvents => this._ongoingEvents;
  List<BlogPostModel> get blogPosts => this._blogPosts;
  bool get isLoading => _isLoading;

  set ongoingEvents(List<EventModel> value) {
    this._ongoingEvents = value;
    notifyListeners();
  }

  set blogPosts(List<BlogPostModel> value) {
    this._blogPosts = value;
    notifyListeners();
  }

  init() {
    getCampaignEvents();
    getBlogs();
  }

  void updateIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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

  getBlogs() async {
    updateIsLoading(true);
    final response = await _saveRepo.getBlogs();
    blogPosts = response.model;
    print(blogPosts.length);
    updateIsLoading(false);
    notifyListeners();
  }

  verifyVPAAddress() async {
    ApiResponse response =
        await _saveRepo.verifyVPAAddress(userService.idToken);
    print(response.model);
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

  navigateToSellAsset() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SellAssetsViewConfig,
        widget: SellAssetsView());
  }
}
