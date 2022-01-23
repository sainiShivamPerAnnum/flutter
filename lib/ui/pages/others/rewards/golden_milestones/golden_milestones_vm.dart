import 'dart:developer';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/golden_ticket_service.dart';
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
  final _gtService = locator<GoldenTicketService>();

  List<dynamic> _rawData;
  List<MilestoneRecord> _milestones;
  UserAugmontDetail _userAugmontDetails;
  List<UserMilestoneModel> userMilestones;
  List<FelloMilestoneModel> felloMilestones;

  List<MilestoneRecord> get milestones => _milestones;

  set milestones(List<MilestoneRecord> ms) {
    _milestones = ms;
    notifyListeners();
  }

  init() async {
    fetchMilestones();
  }

  formatData() {
    _milestones = [];
    felloMilestones.forEach((fe) {
      if (userMilestones.firstWhere((ue) => ue.type == fe.prizeSubtype,
              orElse: () => null) !=
          null) {
        FelloMilestoneModel _fms = fe;
        UserMilestoneModel _ums =
            userMilestones.firstWhere((ue) => fe.prizeSubtype == ue.type);
        _milestones.add(MilestoneRecord(
            title: _fms.title,
            subtilte: _fms.title,
            isCompleted: true,
            amt: _ums.netAmt,
            type: _ums.type,
            showPrize: true,
            flc: _ums.netFlc));
      } else {
        _milestones.add(MilestoneRecord(
            title: fe.title,
            subtilte: fe.title,
            isCompleted: false,
            type: fe.prizeSubtype,
            amt: 0,
            showPrize: false,
            flc: 0));
      }
    });
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
    //HARDCODED CHECKS FOR SIGNUP AND KYC_VERIFY
    _milestones.forEach((e) {
      if (e.type == 'KYC_VERIFY') {
        e.isCompleted = _userService.baseUser.isSimpleKycVerified ?? false;
      }
      if (e.type == 'NEW_USER') {
        e.isCompleted = true;
      }
    });

    //CHECK IF THE MILESTONE REWARD IS SCRATCHED OR NOT
    _milestones.forEach((m) {
      if (m.isCompleted) {
        if (_gtService.activeGoldenTickets.firstWhere(
                (gt) => gt.prizeSubtype == m.type,
                orElse: () => null) !=
            null) {
          GoldenTicket gt = _gtService.activeGoldenTickets
              .firstWhere((gt) => gt.prizeSubtype == m.type);
          if (gt.redeemedTimestamp == null) m.showPrize = false;
        }
      }
    });
  }

  fetchMilestones() async {
    felloMilestones = await _dbModel.getMilestonesList();
    userMilestones =
        await _dbModel.getUserAchievedMilestones(_userService.baseUser.uid);
    formatData();
  }
}

class MilestoneRecord {
  String title;
  String subtilte;
  bool isCompleted;
  int amt;
  int flc;
  String type;
  bool showPrize;

  MilestoneRecord({
    @required this.title,
    @required this.subtilte,
    @required this.isCompleted,
    @required this.amt,
    @required this.flc,
    @required this.type,
    this.showPrize,
  });
}

class FelloMilestoneModel {
  String id;
  String prizeSubtype;
  String title;

  FelloMilestoneModel({this.id, this.prizeSubtype, this.title});

  FelloMilestoneModel.fromJson(Map<String, dynamic> data) {
    id = data['id'] ?? "";
    prizeSubtype = data['prizeSubtype'] ?? "";
    title = data['title'] ?? "";
  }
}

class UserMilestoneModel {
  int netAmt;
  int netFlc;
  String type;
  bool isRedeemed;

  UserMilestoneModel({this.netAmt, this.netFlc, this.type, this.isRedeemed});

  UserMilestoneModel.fromJson(Map<String, dynamic> data) {
    netAmt = data['netAmt'] ?? 0;
    netFlc = data['netFlc'] ?? 0;
    type = data['type'] ?? "";
    isRedeemed = data['isRedeemed'] ?? false;
  }
}
