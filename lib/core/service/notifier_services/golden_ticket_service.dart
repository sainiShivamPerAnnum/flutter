import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final GlobalKey ticketImageKey = GlobalKey();

class GoldenTicketService extends ChangeNotifier {
  final _logger = locator<CustomLogger>();
  final _dbModel = locator<DBModel>();
  final _userService = locator<UserService>();
  // static bool hasGoldenTicket = false;

  static String goldenTicketId;
  static GoldenTicket currentGT;

  List<GoldenTicket> _activeGoldenTickets;

  List<GoldenTicket> get activeGoldenTickets => this._activeGoldenTickets ?? [];

  set activeGoldenTickets(List<GoldenTicket> value) {
    this._activeGoldenTickets = value;
    notifyListeners();
    log("GoldenTicket list updated");
  }

  Future<bool> fetchAndVerifyGoldenTicketByID() async {
    if (goldenTicketId != null && goldenTicketId.isNotEmpty) {
      currentGT = await _dbModel.getGoldenTicketById(
          _userService.baseUser.uid, goldenTicketId);
      goldenTicketId = null;
      if (currentGT != null && isGTValid(currentGT)) {
        return true;
      }
    }
    return false;
  }

  showInstantGoldenTicketView(
      {@required GTSOURCE source, String title, double amount = 0}) {
    if (currentGT != null) {
      Future.delayed(Duration(milliseconds: 200), () {
        // if (source != GTSOURCE.deposit)
        AppState.screenStack.add(ScreenItem.dialog);

        Navigator.of(AppState.delegate.navigatorKey.currentContext)
            .push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) => GTInstantView(
                      source: source,
                      title: title,
                      amount: amount,
                    )));
      });
    }
  }

  //HELPERS

  isGTValid(GoldenTicket ticket) {
    if (ticket.isRewarding != null &&
        ticket.gtId != null &&
        ticket.gtType != null &&
        ticket.timestamp != null &&
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
                  _dbModel.logFailure(_userService.baseUser.uid,
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
                  _dbModel.logFailure(_userService.baseUser.uid,
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
        _dbModel.logFailure(_userService.baseUser.uid,
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
            _dbModel.logFailure(_userService.baseUser.uid,
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
            _dbModel.logFailure(_userService.baseUser.uid,
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
}
