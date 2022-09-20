import 'package:felloapp/core/model/user_transaction_model.dart';

class TransactionResponse {
  final List<UserTransaction> transactions;
  final bool isLastPage;
  TransactionResponse({this.isLastPage, this.transactions});
}
