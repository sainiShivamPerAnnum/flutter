part of 'autosave_cubit.dart';

final class AutosaveStatee extends Equatable {
  int currentPage;
  SubscriptionModel? activeSubscription;
  bool isFetchingTransactions;
  AutosaveStatee({
    this.currentPage = 0,
    this.activeSubscription,
    this.isFetchingTransactions = false,
  });

  AutosaveStatee copyWith({required bool visible}) {
    return AutosaveStatee();
  }

  @override
  List<Object> get props => [currentPage, isFetchingTransactions];
}
