import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/modalsheets/transaction_cancel_warning_modal.dart';

import '../core/enums/investment_type.dart';

typedef OnAmountChanged = void Function(double);

class BackButtonActions {
  BackButtonActions();

  bool isTransactionCancelled = false;

  Future<void> showWantToCloseTransactionBottomSheet(
      int amt, InvestmentType type, void Function() onTap) async {
    if (!(isTransactionCancelled)) return;

    return BaseUtil.openModalBottomSheet(
        isBarrierDismissible: true,
        addToScreenStack: true,
        content: TransactionCancelBottomSheet(
          amt: amt,
          onContinue: () => onTap(),
          investMentType: type,
        )).then((value) => isTransactionCancelled = false);
  }
}
