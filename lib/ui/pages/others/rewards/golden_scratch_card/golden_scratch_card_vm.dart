import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/golden_ticket_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/golden_scratch_card_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';

class GoldenScratchCardViewModel extends BaseModel {
  bool _viewScratcher = false;
  double _detailsModalHeight = 0;
  bool _bottompadding = true;
  bool _viewScratchedCard = false;
  bool isCardScratched = false;
  // bool _isTicketRedeemedSuccessfully = true;

  // get isTicketRedeemedSuccessfully => this._isTicketRedeemedSuccessfully;

  // set isTicketRedeemedSuccessfully(value) {
  //   this._isTicketRedeemedSuccessfully = value;
  //   notifyListeners();
  // }

  get viewScratchedCard => this._viewScratchedCard;

  set viewScratchedCard(value) => this._viewScratchedCard = value;

  get viewScratcher => this._viewScratcher;

  set viewScratcher(value) => this._viewScratcher = value;

  get detailsModalHeight => this._detailsModalHeight;

  set detailsModalHeight(value) => this._detailsModalHeight = value;

  get bottompadding => this._bottompadding;

  set bottompadding(value) => this._bottompadding = value;

  // showDetailsModal(bool isRewarding) {
  //   _bottompadding = false;
  //   _detailsModalHeight = isRewarding
  //       ? SizeConfig.screenHeight * 0.5
  //       : SizeConfig.screenHeight * 0.2;
  //   notifyListeners();
  // }

  changeToUnlockedUI() {
    _bottompadding = false;
    _detailsModalHeight = SizeConfig.screenHeight * 0.5;
    isCardScratched = true;
    //isTicketRedeemedSuccessfully = true;
    _viewScratchedCard = true;
    notifyListeners();
  }

  redeemCard(GoldenTicketsViewModel superModel, GoldenTicket ticket) async {
    scratchKey.currentState.reveal();
    // showDetailsModal(ticket.isRewarding);
    isCardScratched = true;
    setState(ViewState.Busy);
    await superModel.redeemTicket(ticket);
    log(ticket.redeemedTimestamp.toString());
    setState(ViewState.Idle);
  }

  init(GoldenTicket ticket) {
    if (ticket.redeemedTimestamp != null) {
      //Redeemed ticket
      changeToUnlockedUI();
    } else {
      if (ticket.isRewarding) {
        //ticket has some reward
      } else {
        //Pity ticket
      }
    }
    Future.delayed(Duration(seconds: 0), () {
      _viewScratcher = true;
      notifyListeners();
    });
  }
}
