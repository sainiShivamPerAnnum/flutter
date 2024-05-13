import 'package:felloapp/core/model/transaction_response_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';

class MyFundsBloc
    extends PaginationBloc<UserTransaction, TransactionResponse, int, Object> {
  MyFundsBloc({
    required TransactionHistoryRepository transactionHistoryRepo,
  }) : super(
          initialPageReference: 0,
          resultConverterCallback: (result) {
            return result.transactions ?? [];
          },
          paginationCallBack: (pageReference) async {
            final response = await transactionHistoryRepo.getUserTransactions(
              type: "DEPOSIT",
              subtype: "LENDBOXP2P",
              lbActiveFunds: true,
              offset: pageReference,
            );
            if (response.isSuccess()) {
              return PaginationResult.success(result: response.model!);
            }
            return PaginationResult.failure(error: response.errorMessage!);
          },
          referenceConverterCallBack: (result, previousState, interrupter) {
            if (result.isLastPage ?? false) {
              interrupter.call();
            }
            return previousState + 1;
          },
        );
}
