import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class SaveViewModel extends BaseModel {
  final _campaignRepo = locator<CampaignRepo>();

  List<EventModel> _ongoingEvents;

  List<EventModel> get ongoingEvents => this._ongoingEvents;

  set ongoingEvents(List<EventModel> value) {
    this._ongoingEvents = value;
    notifyListeners();
  }

  init() {
    getCampaignEvents();
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
}
