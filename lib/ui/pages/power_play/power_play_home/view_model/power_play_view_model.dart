// import 'dart:developer';

// import 'package:felloapp/core/enums/view_state_enum.dart';
// import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
// import 'package:felloapp/core/service/power_play_service.dart';
// import 'package:felloapp/ui/architecture/base_vm.dart';
// import 'package:felloapp/util/locator.dart';

// class PowerPlayHomeViewModel extends BaseViewModel {
//   final PowerPlayService _powerPlayService = locator<PowerPlayService>();



//   final List<String> _tabs = ["Live", "Upcoming", "Completed"];
//   List<MatchData?>? _liveMatchData = [];
//   List<MatchData?>? _upcomingMatchData = [];
//   List<MatchData> _completedMatchData = [];
//   bool _isLive = true;
//   List<Map<String, dynamic>>? cardCarousel;

//   bool get isLive => _isLive;

//   set isLive(bool value) {
//     _isLive = value;
//     notifyListeners();
//   }

//   List<MatchData?>? get liveMatchData => _liveMatchData;

//   set liveMatchData(List<MatchData?>? value) {
//     _liveMatchData = value;
//   }

//   List<MatchData?>? get upcomingMatchData => _upcomingMatchData;

//   set upcomingMatchData(List<MatchData?>? value) {
//     _upcomingMatchData = value;
//   }

//   List<MatchData> get completedMatchData => _completedMatchData;

//   set completedMatchData(List<MatchData> value) {
//     _completedMatchData = value;
//   }

//   List<String> get tabs => _tabs;

//   int _selectedIndex = 0;

//   int get selectedIndex => _selectedIndex;

//   set selectedIndex(int value) {
//     _selectedIndex = value;
//     notifyListeners();
//   }

//   // @override
//   // void dispose() {
//   //   // _powerPlayService.dump();
//   //   super.dispose();
//   // }

//   Future<void> init() async {
//     state = ViewState.Busy;
//     _powerPlayService.init();
//     getCardCarousle();

//     await _powerPlayService.getMatchesByStatus("active", 10, 0);
//     if (_powerPlayService.liveMatchData.isNotEmpty) {
//       liveMatchData = _powerPlayService.liveMatchData;
//     }

//     log("VM -- liveMatchData: ${liveMatchData?.length}");

//     state = ViewState.Idle;
//     notifyListeners();
//   }

//   Future<void> getMatchesByStatus(String status, int limit, int offset) async {
//     state = ViewState.Busy;
//     await _powerPlayService.getMatchesByStatus(status, limit, offset);

//     if (_powerPlayService.liveMatchData.isNotEmpty &&
//         status == MatchStatus.active.getValue) {
//       liveMatchData = _powerPlayService.liveMatchData;
//     } else if (_powerPlayService.upcomingMatchData.isNotEmpty &&
//         status == MatchStatus.upcoming.getValue) {
//       // log("VM -- _powerPlayService.upcomingMatchData: ${_powerPlayService.upcomingMatchData.length}");

//       upcomingMatchData = _powerPlayService.upcomingMatchData;
//       // log("VM -- upcomingMatchData: ${upcomingMatchData?.length}");
//     } else if (_powerPlayService.completedMatchData.isNotEmpty &&
//         status == MatchStatus.completed.getValue) {
//       completedMatchData = _powerPlayService.completedMatchData;
//     }

//     state = ViewState.Idle;
//     notifyListeners();
//   }

//   void getCardCarousle() {
//     // var appConfigData =
//     //     AppConfig.getValue<Map<String, dynamic>>(AppConfigKey.powerplayConfig);
//     //
//     // appConfigData['predictScreen'].forEach((key, value) {
//     //   log('key => $key');
//     //   log('value => $value');
//     // });
//     //
//     // cardCarousel = appConfigData['predictScreen'];
//   }
// }
