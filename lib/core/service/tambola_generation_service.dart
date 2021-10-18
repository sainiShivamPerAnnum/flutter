import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/ticket_request_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:synchronized/synchronized.dart';

class TambolaGenerationService extends ChangeNotifier {
  Log log = new Log('TambolaGenerationService');
  Lock _genLock = new Lock();
  Lock _delLock = new Lock();

  TambolaGenerationService();

  DBModel dbProvider = locator<DBModel>();
  final _userService = locator<UserService>();
  final _tambolaService = locator<TambolaService>();
  StreamSubscription<DocumentSnapshot> _currentSubscription;
  ValueChanged<int> _generationComplete;
  bool _generationStartedAndPartiallyCompleted = false;
  static const int GENERATION_COMPLETE = 1;
  static const int GENERATION_FAILED = 0;
  static const int GENERATION_PARTIALLY_COMPLETE = 2;

  static const int DELETION_COMPLETE = 1;
  static const int DELETION_FAILED = 0;

  ///checks if new tickets need to be generated
  Future<bool> processTicketGenerationRequirement(
      int currentTambolaBoardCount) async {
    return await _genLock.synchronized(() async {
      ///check if there is atomic field was updated before
      if (_tambolaService.atomicTicketGenerationLeftCount > 0) return false;

      _tambolaService.ticketGenerateCount = 0;
      if (currentTambolaBoardCount != null &&
          _tambolaService.userTicketWallet.getActiveTickets() > 0) {
        if (currentTambolaBoardCount <
            _tambolaService.userTicketWallet.getActiveTickets()) {
          log.debug(
              'Currently generated ticket count is less than needed tickets');
          _tambolaService.ticketGenerateCount =
              _tambolaService.userTicketWallet.getActiveTickets() -
                  currentTambolaBoardCount;
        }
      }
      if (_tambolaService.ticketGenerateCount > 0 &&
          _tambolaService.atomicTicketGenerationLeftCount == 0) {
        ///check if there is any active ticket generation in progress presently
        bool _activeTicketGenInProgress = await dbProvider
            .isTicketGenerationInProcess(_userService.baseUser.uid);
        if (_activeTicketGenInProgress) {
          log.debug('Ticket generation already in progress');
          return false;
        } else {
          _tambolaService.atomicTicketGenerationLeftCount =
              _tambolaService.ticketGenerateCount;
          _initiateTicketGeneration();
          return true;
        }
      } else {
        log.debug('New tickets do not/can not be generated right now');
      }
      return false;
    });
  }

  Future<bool> processTicketDeletionRequirement(
      int currentTambolaBoardCount) async {
    return await _genLock.synchronized(() async {
      ///check if there is atomic field was updated before
      if (_tambolaService.atomicTicketDeletionLeftCount > 0) return false;

      int _ticketDeleteCount = 0;
      if (currentTambolaBoardCount != null &&
          _tambolaService.userTicketWallet.getActiveTickets() > 0) {
        if (currentTambolaBoardCount >
            _tambolaService.userTicketWallet.getActiveTickets()) {
          log.debug(
              'Currently generated ticket count is more than needed tickets');
          _ticketDeleteCount = currentTambolaBoardCount -
              _tambolaService.userTicketWallet.getActiveTickets();
        }
      }
      if (_ticketDeleteCount > 0 &&
          _tambolaService.atomicTicketDeletionLeftCount == 0) {
        _tambolaService.atomicTicketDeletionLeftCount = _ticketDeleteCount;
        return await _initiateTicketDeletion();
      } else {
        log.debug('New tickets do not/can not be deleted right now');
      }
      return false;
    });
  }

  Future<bool> _initiateTicketDeletion() async {
    return await _delLock.synchronized(() async {
      if (_tambolaService.userWeeklyBoards == null ||
          _tambolaService.userWeeklyBoards.isEmpty ||
          _tambolaService.atomicTicketDeletionLeftCount == 0)
        return _onTicketDeletionRequestFailed();
      _tambolaService.userWeeklyBoards.sort((a, b) => a
          .assigned_time.millisecondsSinceEpoch
          .compareTo(b.assigned_time.millisecondsSinceEpoch));
      print('post sort');

      List<TambolaBoard> _tList = [];
      for (TambolaBoard board in _tambolaService.userWeeklyBoards) {
        _tList.add(board);
      }

      int _k = 0;
      int _t = _tambolaService.atomicTicketDeletionLeftCount;
      List<String> _deleteTicketRefList = [];
      while (_t > 0) {
        _deleteTicketRefList.add(_tambolaService.userWeeklyBoards[_k].doc_key);
        _k++;
        _t--;
      }
      if (_deleteTicketRefList.length > 0) {
        bool flag = await dbProvider.deleteSelectUserTickets(
            _userService.baseUser.uid, _deleteTicketRefList);
        if (flag) {
          _tambolaService.userWeeklyBoards
              .removeRange(0, _tambolaService.atomicTicketDeletionLeftCount);
          _tambolaService.atomicTicketDeletionLeftCount = 0;
          return true;
        }
      }
      return _onTicketDeletionRequestFailed();
    });
  }

  _initiateTicketGeneration() async {
    int iterationsRequired = (_tambolaService.atomicTicketGenerationLeftCount /
            Constants.MAX_TICKET_GEN_PER_REQUEST)
        .ceil();

    int _countPacket = (_tambolaService.atomicTicketGenerationLeftCount >
            Constants.MAX_TICKET_GEN_PER_REQUEST)
        ? Constants.MAX_TICKET_GEN_PER_REQUEST
        : _tambolaService.atomicTicketGenerationLeftCount;
    _currentSubscription = await dbProvider.subscribeToTicketRequest(
        _userService.baseUser, _countPacket);
    if (_currentSubscription == null)
      _onTicketGenerationRequestFailed();
    else
      dbProvider.setTicketRequestListener(_onTicketsGenerated);
  }

  _onTicketsGenerated(TicketRequest request) {
    if (request != null && request.status == 'P') {
      //skip this
      return;
    } else if (request.status == 'F') {
      _clearVariables();
      _onTicketGenerationRequestFailed();
    } else if (request.status == 'C') {
      _clearVariables();
      _tambolaService.atomicTicketGenerationLeftCount =
          _tambolaService.atomicTicketGenerationLeftCount - request.count;
      if (_tambolaService.atomicTicketGenerationLeftCount == 0) {
        _onTicketGenerationRequestComplete();
      } else {
        if (_tambolaService.atomicTicketGenerationLeftCount < 0) {
          //what the hell happened
          _onTicketGenerationRequestFailed();
        } else {
          _generationStartedAndPartiallyCompleted = true;
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
    if (_userService.baseUser.uid != null) {
      Map<String, dynamic> errorDetails = {
        'error_msg': 'Ticket generation failed at one or many steps',
        'atmoic_ticket_gen_left_count':
            _tambolaService.atomicTicketGenerationLeftCount.toString()
      };
      dbProvider.logFailure(_userService.baseUser.uid,
          FailType.TambolaTicketGenerationFailed, errorDetails);
    }
    _tambolaService.atomicTicketGenerationLeftCount =
        0; // clear this so it can be attempted again
    if (_generationComplete != null) {
      if (_generationStartedAndPartiallyCompleted)
        _generationComplete(GENERATION_PARTIALLY_COMPLETE);
      else
        _generationComplete(GENERATION_FAILED);
    }
  }

  _onTicketGenerationRequestComplete() {
    _generationComplete(GENERATION_COMPLETE);
  }

  bool _onTicketDeletionRequestFailed() {
    _tambolaService.atomicTicketDeletionLeftCount =
        0; //so it can be tried again
    return false;
  }

  setTambolaTicketGenerationResultListener(ValueChanged<int> listener) {
    this._generationComplete = listener;
  }
}
