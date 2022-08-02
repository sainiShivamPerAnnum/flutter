import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/model/user_milestone_model.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';

class GoldenMilestonesViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final _gtService = locator<GoldenTicketService>();
  final _gtRepo = locator<GoldenTicketRepository>();

  List<UserMilestone> _milestones;

  List<UserMilestone> get milestones => _milestones;

  set milestones(List<UserMilestone> ms) {
    _milestones = ms;
    notifyListeners();
  }

  init() async {
    fetchMilestones();
  }

  formatData() {
    arrangeMilestonesList();
    notifyListeners();
  }

  arrangeMilestonesList() {
    //NOTE: This is sorting logic for milestones.
    List<UserMilestone> temp = [];
    _milestones.forEach((e) {
      if (e.isCompleted != null && e.isCompleted == true) {
        temp.add(e);
      }
    });
    _milestones.forEach((e) {
      if (e.isCompleted == null || e.isCompleted == false) {
        temp.add(e);
      }
    });
    _milestones = temp;
    //HARDCODED CHECKS FOR SIGNUP AND KYC_VERIFY
    _milestones.forEach((e) {
      if (e.prizeSubtype == 'KYC_VERIFY') {
        e.isCompleted = _userService.baseUser.isSimpleKycVerified ?? false;
      }
      if (e.prizeSubtype == 'NEW_USER') {
        e.isCompleted = true;
      }
    });

    //CHECK IF THE MILESTONE REWARD IS SCRATCHED OR NOT
    _milestones.forEach((m) {
      if (m.isCompleted) {
        if (_gtService.activeGoldenTickets.firstWhere(
                (gt) => gt.prizeSubtype == m.prizeSubtype,
                orElse: () => null) !=
            null) {
          GoldenTicket gt = _gtService.activeGoldenTickets
              .firstWhere((gt) => gt.prizeSubtype == m.prizeSubtype);
          if (gt.redeemedTimestamp == null ||
              gt.redeemedTimestamp ==
                  TimestampModel(seconds: 0, nanoseconds: 0))
            m.isCompleted = false;
        }
      }
    });
  }

  fetchMilestones() async {
    ApiResponse<List<UserMilestone>> response = await _gtRepo.fetchMilestones();
    if (response.code == 200) {
      _milestones = response.model;
      formatData();
    }
  }

  navigateMilestones(String url) {
    if (url != null && url.isNotEmpty)
      AppState.delegate.parseRoute(Uri.parse(url));
  }
}
