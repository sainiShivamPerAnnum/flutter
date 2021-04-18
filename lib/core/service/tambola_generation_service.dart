import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:synchronized/synchronized.dart';
import 'package:felloapp/core/model/TicketRequest.dart';

class TambolaGenerationService extends ChangeNotifier {
  Log log = new Log('TambolaGenerationService');
  Lock _genLock = new Lock();

  TambolaGenerationService();

  BaseUtil baseProvider = locator<BaseUtil>();
  DBModel dbProvider = locator<DBModel>();
  StreamSubscription<DocumentSnapshot> _currentSubscription;
  ValueChanged<bool> _generationComplete;

  ///checks if new tickets need to be generated
  // processTicketGenerationRequirement(int currentTambolaBoardCount) async{
  //   int _ticketGenerateCount = 0;
  //   if (currentTambolaBoardCount != null &&
  //       baseProvider.userTicketWallet.getActiveTickets() > 0) {
  //     if (currentTambolaBoardCount <
  //         baseProvider.userTicketWallet.getActiveTickets()) {
  //       log.debug(
  //           'Currently generated ticket count is less than needed tickets');
  //       _ticketGenerateCount =
  //           baseProvider.userTicketWallet.getActiveTickets() -
  //               currentTambolaBoardCount;
  //     }
  //   }
  //   if(_ticketGenerateCount > 0 && BaseUtil.atomicTicketGenerationLeftCount == 0) {
  //     bool flag = await dbProvider.setTicketGenerationInProgress(baseProvider.myUser.uid, _ticketGenerateCount);
  //     if(flag) {
  //       log.debug('Ticket generation process can be started');
  //       _initiateTicketGeneration(_ticketGenerateCount);
  //     }
  //   }else{
  //     log.debug('New tickets do not/can not be generated right now');
  //   }
  // }

  Future<bool> processTicketGenerationRequirement(
      int currentTambolaBoardCount) async {
    return await _genLock.synchronized(() async {
      ///check if there is atomic field was updated before
      if (BaseUtil.atomicTicketGenerationLeftCount > 0) return false;

      ///check if there is any active ticket generation in progress presently

      int _ticketGenerateCount = 0;
      if (currentTambolaBoardCount != null &&
          baseProvider.userTicketWallet.getActiveTickets() > 0) {
        if (currentTambolaBoardCount <
            baseProvider.userTicketWallet.getActiveTickets()) {
          log.debug(
              'Currently generated ticket count is less than needed tickets');
          _ticketGenerateCount =
              baseProvider.userTicketWallet.getActiveTickets() -
                  currentTambolaBoardCount;
        }
      }
      if (_ticketGenerateCount > 0 &&
          BaseUtil.atomicTicketGenerationLeftCount == 0) {
        bool _activeTicketGenInProgress = await dbProvider
            .isTicketGenerationInProcess(baseProvider.myUser.uid);
        if (_activeTicketGenInProgress) {
          log.debug('Ticket generation already in progress');
          return false;
        } else {
          BaseUtil.atomicTicketGenerationLeftCount = _ticketGenerateCount;
          _initiateTicketGeneration();
          return true;
        }
      } else {
        log.debug('New tickets do not/can not be generated right now');
      }

      return false;
    });
  }

  _initiateTicketGeneration() async {
    int iterationsRequired = (BaseUtil.atomicTicketGenerationLeftCount /
            BaseUtil.MAX_TICKET_GEN_PER_REQUEST)
        .ceil();

    int _countPacket = (BaseUtil.atomicTicketGenerationLeftCount >
            BaseUtil.MAX_TICKET_GEN_PER_REQUEST)
        ? BaseUtil.MAX_TICKET_GEN_PER_REQUEST
        : BaseUtil.atomicTicketGenerationLeftCount;
    _currentSubscription = await dbProvider.subscribeToTicketRequest(
        baseProvider.myUser, _countPacket);
    if (_currentSubscription == null)
      _onTicketGenerationRequestFailed();
    else
      dbProvider.setTicketRequestListener(_onTicketsGenerated);
  }

  _onTicketsGenerated(TicketRequest request) {
    if(request != null && request.status == 'P') {
      //skip this
      return;
    }
    else if (request.status == 'F') {
      _clearVariables();
      _onTicketGenerationRequestFailed();
    }else if (request.status == 'C') {
      _clearVariables();
      BaseUtil.atomicTicketGenerationLeftCount =
          BaseUtil.atomicTicketGenerationLeftCount - request.count;
      if (BaseUtil.atomicTicketGenerationLeftCount == 0) {
        _onTicketGenerationRequestComplete();
      } else {
        if(BaseUtil.atomicTicketGenerationLeftCount < 0) {
          //what the hell happened
          _onTicketGenerationRequestFailed();
        }else{
          //more tickets need to be generated
          _initiateTicketGeneration();
        }
      }
    }
  }

  _clearVariables() {
    if (_currentSubscription != null) {
      _currentSubscription.cancel();
      _currentSubscription = null;
    }
    dbProvider.setTicketRequestListener(null);
  }

  _onTicketGenerationRequestFailed() {
    log.error('Ticket generation failed at one or many steps');
    BaseUtil.atomicTicketGenerationLeftCount = 0;// clear this so it can be attempted again
    if (_generationComplete != null) _generationComplete(false);
  }

  _onTicketGenerationRequestComplete() {
    _generationComplete(true);
  }

  setTambolaTicketGenerationResultListener(ValueChanged<bool> listener) {
    this._generationComplete = listener;
  }
}
