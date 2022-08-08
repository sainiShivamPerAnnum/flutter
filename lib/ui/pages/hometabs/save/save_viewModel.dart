import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class SaveViewModel extends BaseModel {
  final _campaignRepo = locator<CampaignRepo>();
  final _saveRepo = locator<SaveRepo>();

  List<EventModel> _ongoingEvents;
  List<BlogPostModel> _blogPosts;
  bool _isLoading = false;

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
    final response = await _campaignRepo.getOngoingEvents();
    if (response.code == 200) {
      ongoingEvents = response.model;
      ongoingEvents.sort((a, b) => a.position.compareTo(b.position));
      ongoingEvents.forEach((element) {
        print(element.toString());
      });
    } else
      ongoingEvents = [];
  }

  getBlogs() async {
    updateIsLoading(true);
    final response = await _saveRepo.getBlogs();
    blogPosts = response.model;
    print(blogPosts.length);
    updateIsLoading(false);
    notifyListeners();
  }
}
