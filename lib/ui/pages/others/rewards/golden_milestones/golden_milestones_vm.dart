import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class GoldenMilestonesViewModel extends BaseModel {
  final _dbModel = locator<DBModel>();
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _augModel = locator<AugmontModel>();

  List<dynamic> _rawData;
  List<MilestoneRecord> _milestones;
  UserAugmontDetail _userAugmontDetails;

  List<MilestoneRecord> get milestones => _milestones;

  set milestones(List<MilestoneRecord> ms) {
    _milestones = ms;
    notifyListeners();
  }

  init() async {
    setState(ViewState.Busy);
    _userAugmontDetails =
        await _dbModel.getUserAugmontDetails(_userService.baseUser.uid);
    setState(ViewState.Idle);
    fetchMilestones();
  }

  formatData() {
    _milestones = [];
    for (int i = 0; i < _rawData.length; i++) {
      _milestones.add(MilestoneRecord(
        title: _rawData[i]['id'],
        subtilte: _rawData[i]['title'],
        isCompleted: checkIfCompleted(_rawData[i]['id']),
      ));
    }
    arrangeMilestonesList();

    notifyListeners();
  }

  arrangeMilestonesList() {
    List<MilestoneRecord> temp = [];
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
  }

  bool checkIfCompleted(String id) {
    switch (id) {
      case "signup":
        return true;
        break;
      case "kyc":
        return _userService.baseUser.isSimpleKycVerified;
        break;
      case "bankVerify":
        return _userAugmontDetails.bankAccNo != null &&
                _userAugmontDetails.bankAccNo.isNotEmpty
            ? true
            : false;
        break;
      case "firstCricketGame":
        return false;
        break;
      case "augregistration":
        return _userService.baseUser.isAugmontOnboarded;
        break;
      case "firstGoldBuy":
        return _userService.userFundWallet.augGoldBalance > 0;
        break;
      default:
        return false;
    }
  }

  fetchMilestones() async {
    var response = await _dbModel.getMilestonesList();
    _rawData = response["checkpoints"];
    formatData();
    _logger.d(response);
  }
}

class MilestoneRecord {
  final String title;
  final String subtilte;
  final bool isCompleted;

  MilestoneRecord(
      {@required this.title,
      @required this.subtilte,
      @required this.isCompleted});
}
