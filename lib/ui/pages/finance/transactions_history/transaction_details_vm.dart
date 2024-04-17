import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';

class TransactionDetailsVM extends BaseViewModel {
  TransactionDetailsVM(this._transactionInfo);

  final UserTransaction _transactionInfo;

  Future<void> updateMaturityPreference() async {
    assert(
      _transactionInfo.subType == InvestmentType.LENDBOXP2P.name,
      'Can\'t change the preference other than sub-asset of `LENDBOXP2P`',
    );
  }
}
