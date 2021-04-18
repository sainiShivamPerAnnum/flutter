import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';

class TambolaGenerationService extends ChangeNotifier {
  Log log = new Log('TambolaGenerationService');

  TambolaGenerationService();

  BaseUtil baseProvider = locator<BaseUtil>();
  DBModel dbProvider = locator<DBModel>();

  ///checks if new tickets need to be generated
  processTicketGenerationRequirement(int currentTambolaBoardCount) async{
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
    if(_ticketGenerateCount > 0 && BaseUtil.atomicTicketGenerationLeftCount == 0) {
      bool flag = await dbProvider.setTicketGenerationInProgress(baseProvider.myUser.uid, _ticketGenerateCount);
      if(flag) {
        log.debug('Ticket generation process can be started');
        _initiateTicketGeneration(_ticketGenerateCount);
      }
    }else{
      log.debug('New tickets do not/can not be generated right now');
    }
  }

  _initiateTicketGeneration(int generateCount) async{
    int iterationsRequired = (generateCount/BaseUtil.MAX_TICKET_GEN_PER_REQUEST).ceil();

  }

}
