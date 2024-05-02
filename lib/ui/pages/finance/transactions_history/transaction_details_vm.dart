import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

import '../../../../core/repository/lendbox_repo.dart';

class TransactionDetailsVM extends BaseViewModel {
  TransactionDetailsVM(this._transactionInfo, this._transactionPrefence);

  final UserTransaction _transactionInfo;
  final LendboxRepo _lendboxRepo = locator<LendboxRepo>();
  bool _isProcessingPreference = false;
  String _transactionPrefence;

  bool get isProcessingPreference => _isProcessingPreference;

  set isProcessingPreference(bool value) {
    _isProcessingPreference = value;
    notifyListeners();
  }

  String get transactionPrefence => _transactionPrefence;

  set transactionPrefence(String value) {
    _transactionPrefence = value;
    notifyListeners();
  }

  Future<bool> updateMaturityPreference(bool value) async {
    assert(
      _transactionInfo.subType == InvestmentType.LENDBOXP2P.name,
      'Can\'t change the preference other than sub-asset of `LENDBOXP2P`',
    );
    isProcessingPreference = true;
    try {
      var res = await _lendboxRepo.updateUserInvestmentPreference(
        _transactionInfo.id,
        value ? '1' : '0',
        hasConfirmed: true,
      );
      isProcessingPreference = false;

      if (res.code != 200) {
        BaseUtil.showNegativeAlert(
            'Preference update failed', res.errorMessage.toString());
      } else {
        transactionPrefence = value ? '1' : '0';
      }
      return res.model ?? false;
    } catch (e) {
      BaseUtil.showNegativeAlert('Preference update failed', e.toString());
      isProcessingPreference = false;
      return false;
    }
  }
}
