import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/core/service/user_service.dart';
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
  static const int GENERATION_COMPLETE = 1;
  static const int GENERATION_FAILED = 0;
  static const int GENERATION_PARTIALLY_COMPLETE = 2;

  static const int DELETION_COMPLETE = 1;
  static const int DELETION_FAILED = 0;


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
      _tambolaService.userWeeklyBoards.sort((TambolaBoard a,TambolaBoard b) => a
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


  bool _onTicketDeletionRequestFailed() {
    _tambolaService.atomicTicketDeletionLeftCount =
        0; //so it can be tried again
    return false;
  }

  setTambolaTicketGenerationResultListener(ValueChanged<int> listener) {
    this._generationComplete = listener;
  }
}
