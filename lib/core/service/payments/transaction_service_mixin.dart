import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';

import 'base_transaction_service.dart';

/// A mixin for performing transaction prediction with default behavior
/// on [BaseTransactionService].
///
/// This mixin provides a common implementation for predicting transaction
/// outcomes based on the response from the Paytm repository.
mixin TransactionPredictionDefaultMixing
    on BaseTransactionService<ApiResponse<TransactionResponseModel>> {
  /// The Paytm repository used to fetch transaction status.
  PaytmRepository get paytmRepo;

  /// Default rescheduling limit.
  ///
  /// On an average a call of [PaytmRepository.getTransactionStatus] may take
  /// around 25-30 secs so in general it will provide [run] to max run span of
  /// 60 secs.
  @override
  int get rescheduleLimit => 2;

  /// Fetches the transaction information from [paytmRepo].
  @override
  Future<ApiResponse<TransactionResponseModel>> task() async {
    final res = await paytmRepo.getTransactionStatus(currentTxnOrderId);
    return res;
  }

  /// A predicate for rescheduling.
  ///
  /// Signals [run] to continue or to rescheduling or to process further based
  /// on predicate condition. [run] continues prediction if it returns `false`
  /// or else will be processing response via [onSuccess].
  ///
  /// Determine whether the transaction is successful or failed
  /// based on the response from [paytmRepo].
  @override
  bool predicate(ApiResponse<TransactionResponseModel> value) {
    final status = value.model?.data?.status;
    return value.isSuccess() &&
        status != null &&
        (status == Constants.TXN_STATUS_RESPONSE_SUCCESS ||
            status == Constants.TXN_STATUS_RESPONSE_FAILURE);
  }
}
