import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
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
  bool _viewScratched = false;
  double _opacity = 0;
  double get opacity => this._opacity;
  bool isTicketRedeemedSuccessfully = false;

  set opacity(double value) {
    this._opacity = value;
    notifyListeners();
  }

  get viewScratched => this._viewScratched;

  set viewScratched(value) => this._viewScratched = value;

  get viewScratcher => this._viewScratcher;

  set viewScratcher(value) => this._viewScratcher = value;

  get detailsModalHeight => this._detailsModalHeight;

  set detailsModalHeight(value) => this._detailsModalHeight = value;

  get bottompadding => this._bottompadding;

  set bottompadding(value) => this._bottompadding = value;

  showDetailsModal() {
    opacity = 1;
    _bottompadding = false;
    _detailsModalHeight = SizeConfig.screenHeight * 0.5;
    notifyListeners();
  }

  changeToUnlockedUI() {
    opacity = 1;
    _bottompadding = false;
    _detailsModalHeight = SizeConfig.screenHeight * 0.5;
    _viewScratched = true;
    notifyListeners();
  }

  redeemCard(GoldenTicketsViewModel superModel, String gtId) async {
    scratchKey.currentState.reveal();
    showDetailsModal();
    setState(ViewState.Busy);
    isTicketRedeemedSuccessfully = await superModel.redeemTicket(gtId);
    setState(ViewState.Idle);
  }

  init() {
    Future.delayed(Duration(seconds: 0), () {
      _viewScratcher = true;
      notifyListeners();
    });
  }
}
