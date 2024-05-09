import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';

import '../../../../core/repository/subscription_repo.dart';

class SIPTransactionBloc extends PaginationBloc<SubscriptionTransactionModel,
    List<SubscriptionTransactionModel>, int, Object> {
  SIPTransactionBloc({
    required SubscriptionRepo subscriptionRepo,
  }) : super(
          initialPageReference: 0,
          resultConverterCallback: (result) {
            return result;
          },
          paginationCallBack: (pageReference) async {
            final response =
                await subscriptionRepo.getSubscriptionTransactionHistory(
              asset: "LENDBOXP2P",
              limit: 30,
              offset: pageReference,
            );
            if (response.isSuccess()) {
              return PaginationResult.success(result: response.model!);
            }
            return PaginationResult.failure(error: response.errorMessage!);
          },
          referenceConverterCallBack: (result, previousState, interrupter) {
            if (result.length < 30) {
              interrupter.call();
            }
            return previousState++;
          },
        );
}
