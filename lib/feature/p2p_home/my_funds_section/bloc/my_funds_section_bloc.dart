import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/sip_transaction_model.dart';
import 'package:felloapp/core/model/transaction_response_model.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';
import 'package:tuple/tuple.dart';

class MyFundsBloc extends PaginationBloc<dynamic,
    Tuple2<TransactionResponse, List<Subs>>, int, Object> {
  MyFundsBloc({
    required TransactionHistoryRepository transactionHistoryRepo,
  }) : super(
          initialPageReference: 0,
          resultConverterCallback: (result) {
            List<dynamic> combinedList = [];
            int transactionSize = (result.item1.transactions ?? []).length;
            int sipTransactionSize = result.item2.length;
            int i = 0, j = 0;
            for (int k = 0; k < max(transactionSize, sipTransactionSize); k++) {
              if (result.item1.transactions![i].timestamp!.compareTo(
                    Timestamp.fromDate(
                      DateTime.parse(result.item2[j].startDate),
                    ),
                  ) >=
                  0) {
                combinedList.add(result.item1.transactions![i]);
                i++;
              } else {
                combinedList.add(result.item2[j]);
                j++;
              }
            }
            while (i < transactionSize) {
              combinedList.add(result.item1.transactions![i]);
              i++;
            }
            while (j < sipTransactionSize) {
              combinedList.add(result.item2[j]);
              j++;
            }
            return combinedList;
          },
          paginationCallBack: (pageReference) async {
            if (pageReference == 0) {
              ApiResponse<MySIPFunds> subsResponse =
                  await transactionHistoryRepo.getSubsTransactions();
              final response = await transactionHistoryRepo.getUserTransactions(
                type: "DEPOSIT",
                subtype: "LENDBOXP2P",
                limit: 500,
                lbActiveFunds: true,
                offset: pageReference,
              );
              if (response.isSuccess() && subsResponse.isSuccess()) {
                return PaginationResult.success(
                  result: Tuple2(
                    response.model!,
                    subsResponse.model?.data.subs ?? [],
                  ),
                );
              } else {
                PaginationResult.failure(
                  error: response.errorMessage ?? subsResponse.errorMessage,
                );
              }
            } else {
              final response = await transactionHistoryRepo.getUserTransactions(
                type: "DEPOSIT",
                subtype: "LENDBOXP2P",
                lbActiveFunds: true,
                offset: pageReference,
              );
              return response.isSuccess()
                  ? PaginationResult.success(
                      result: Tuple2(
                        response.model!,
                        [],
                      ),
                    )
                  : PaginationResult.failure(
                      error: response.errorMessage ?? 'error',
                    );
            }
            return const PaginationResult.failure(
              error: 'Unknown error',
            );
          },
          referenceConverterCallBack: (result, previousState, interrupter) {
            if (result.item1.isLastPage ?? false) {
              interrupter.call();
            }
            return previousState + result.item1.transactions!.length;
          },
        );
}
