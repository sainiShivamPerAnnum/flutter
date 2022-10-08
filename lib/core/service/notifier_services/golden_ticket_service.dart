import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/golden_ticket_service_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:share_plus/share_plus.dart';

final GlobalKey ticketImageKey = GlobalKey();

class GoldenTicketService extends ChangeNotifier {
  final _logger = locator<CustomLogger>();
  final _gtRepo = locator<GoldenTicketRepository>();
  final _userService = locator<UserService>();
  final _paytmService = locator<PaytmService>();
  final _internalOpsService = locator<InternalOpsService>();
  // static bool hasGoldenTicket = false;
  int _unscratchedTicketsCount = 0;
  int get unscratchedTicketsCount => this._unscratchedTicketsCount;

  set unscratchedTicketsCount(int value) {
    this._unscratchedTicketsCount = value;
    // notifyListeners(GoldenTicketServiceProperties.UnscratchedCount);
  }

  static String goldenTicketId;
  static String gameEndMsgText;
  static GoldenTicket currentGT;
  static String lastGoldenTicketId;
  static String previousPrizeSubtype = '';

  List<GoldenTicket> _activeGoldenTickets;

  List<GoldenTicket> get activeGoldenTickets => this._activeGoldenTickets ?? [];

  set activeGoldenTickets(List<GoldenTicket> value) {
    this._activeGoldenTickets = value;
    notifyListeners();
    log("GoldenTicket list updated");
  }

  Future<bool> fetchAndVerifyGoldenTicketByID() async {
    if (goldenTicketId != null && goldenTicketId.isNotEmpty) {
      ApiResponse<GoldenTicket> ticketResponse =
          await _gtRepo.getGoldenTicketById(
        goldenTicketId: goldenTicketId,
      );

      if (ticketResponse.code == 200 && isGTValid(ticketResponse.model)) {
        currentGT = ticketResponse.model;
        goldenTicketId = null;
        return true;
      } else {
        currentGT = null;
        goldenTicketId = null;
        return false;
      }
    }
    return false;
  }

  Future<bool> fetchAndVerifyGoldenTicketByPrizeSubtype() async {
    if (previousPrizeSubtype != null && previousPrizeSubtype.isNotEmpty) {
      ApiResponse<GoldenTicket> ticketResponse =
          await _gtRepo.getGTByPrizeSubtype(
        previousPrizeSubtype,
      );

      if (ticketResponse.code == 200 && isGTValid(ticketResponse.model)) {
        currentGT = ticketResponse.model;
        return true;
      } else {
        currentGT = null;
        return false;
      }
    }
    return false;
  }

  showInstantGoldenTicketView(
      {@required GTSOURCE source,
      String title,
      double amount = 0,
      bool onJourney = false,
      bool showAutoSavePrompt = false}) {
    if (AppState.isWebGameLInProgress || AppState.isWebGamePInProgress) return;
    if (currentGT != null) {
      log("previousPrizeSubtype $previousPrizeSubtype  && current gt prizeSubtype: ${GoldenTicketService.currentGT.prizeSubtype} ");
      if (previousPrizeSubtype == GoldenTicketService.currentGT.prizeSubtype &&
          !onJourney) return;
      Future.delayed(Duration(milliseconds: 200), () {
        // if (source != GTSOURCE.deposit)
        AppState.screenStack.add(ScreenItem.dialog);

        Navigator.of(AppState.delegate.navigatorKey.currentContext).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) => GTInstantView(
              source: source,
              title: title,
              amount: amount,
              showAutosavePrompt: showAutoSavePrompt,
            ),
          ),
        );
      });
    }
  }

  Future<void> updateUnscratchedGTCount() async {
    final res = await _gtRepo.getGTByPrizeType("UNSCRATCHED");
    if (res.isSuccess())
      unscratchedTicketsCount = res.model.length;
    else
      unscratchedTicketsCount = 0;
  }

  //HELPERS

  isGTValid(GoldenTicket ticket) {
    if (ticket.isRewarding != null &&
        ticket.gtId != null &&
        ticket.gtType != null &&
        ticket.timestamp != null) return true;
    return false;
  }

  Future shareGoldenTicket(GoldenTicket ticket) async {
    {
      try {
        String url = await _userService.createDynamicLink(true, 'Other');
        caputure(
            'Hey, I won ${ticket.rewardArr.length > 1 ? "these prizes" : "this prize"} on Fello! \nLet\'s save and play together: $url');
      } catch (e) {
        _logger.e(e.toString());
        BaseUtil.showNegativeAlert("An error occured!", "Please try again");
      }
    }
  }

  caputure(String shareMessage) {
    Future.delayed(Duration(seconds: 1), () {
      captureCard().then((image) {
        if (image != null)
          shareCard(image, shareMessage);
        else {
          try {
            if (Platform.isIOS) {
              Share.share(shareMessage).catchError((onError) {
                if (_userService.baseUser.uid != null) {
                  Map<String, dynamic> errorDetails = {
                    'error_msg': 'Share reward text in My winnings failed'
                  };
                  _internalOpsService.logFailure(_userService.baseUser.uid,
                      FailType.FelloRewardTextShareFailed, errorDetails);
                }
                _logger.e(onError);
              });
            } else {
              FlutterShareMe()
                  .shareToSystem(msg: shareMessage)
                  .catchError((onError) {
                if (_userService.baseUser.uid != null) {
                  Map<String, dynamic> errorDetails = {
                    'error_msg': 'Share reward text in My winnings failed'
                  };
                  _internalOpsService.logFailure(_userService.baseUser.uid,
                      FailType.FelloRewardTextShareFailed, errorDetails);
                }
                _logger.e(onError);
              });
            }
          } catch (e) {
            _logger.e(e.toString());
          }
        }
      });
    });
  }

  Future<Uint8List> captureCard() async {
    try {
      RenderRepaintBoundary imageObject =
          ticketImageKey.currentContext.findRenderObject();
      final image = await imageObject.toImage(pixelRatio: 2);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      if (_userService.baseUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Share reward card creation failed'
        };
        _internalOpsService.logFailure(_userService.baseUser.uid,
            FailType.FelloRewardCardShareFailed, errorDetails);
      }

      AppState.backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(
          "Task Failed", "Unable to capture the card at the moment");
    }
    return null;
  }

  shareCard(Uint8List image, String shareMessage) async {
    try {
      if (Platform.isAndroid) {
        final directory = (await getExternalStorageDirectory()).path;
        String dt = DateTime.now().toString();
        File imgg = new File('$directory/fello-reward-$dt.png');
        imgg.writeAsBytesSync(image);
        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
        ).catchError((onError) {
          if (_userService.baseUser.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _internalOpsService.logFailure(_userService.baseUser.uid,
                FailType.FelloRewardCardShareFailed, errorDetails);
          }
          print(onError);
        });
      } else if (Platform.isIOS) {
        String dt = DateTime.now().toString();

        final directory = await getTemporaryDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);

        final File imgg =
            await new File('${directory.path}/fello-reward-$dt.jpg').create();
        imgg.writeAsBytesSync(image);

        _logger.d("Image file created and sharing, ${imgg.path}");

        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
        ).catchError((onError) {
          if (_userService.baseUser.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _internalOpsService.logFailure(_userService.baseUser.uid,
                FailType.FelloRewardCardShareFailed, errorDetails);
          }
          print(onError);
        });
      }
    } catch (e) {
      // backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(
          "Task Failed", "Unable to share the picture at the moment");
    }
  }

  showAutosavePrompt() {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissable: false,
      hapticVibrate: true,
      content: FelloInfoDialog(
        title: "Put your savings on autopilot",
        subtitle:
            "Now you can save in Digital Gold automatically without opening the app. Setup Fello autosave now!",
        png: Assets.preAutosave,
        action: AppPositiveBtn(
          btnText: "Setup Autosave",
          onPressed: () {
            AppState.backButtonDispatcher.didPopRoute();
            openAutosave();
          },
        ),
      ),
    );
  }

  openAutosave() {
    if (_paytmService.activeSubscription != null) {
      AppState.delegate.appState.currentAction = PageAction(
          page: AutosaveProcessViewPageConfig,
          widget: AutosaveProcessView(page: 2),
          state: PageState.addWidget);
    } else {
      AppState.delegate.appState.currentAction = PageAction(
        page: AutosaveDetailsViewPageConfig,
        state: PageState.addPage,
      );
    }
  }
}
