part of 'pagination_bloc.dart';

enum PaginationStatus {
  fetchingInitialPage,
  doesNotContainResults,
  failedToLoadInitialPage,
  fetchingSuccessivePage,
  failedAtSomePage,
  stable,
  fetchedAllPage;

  bool get isFetchingInitialPage =>
      this == PaginationStatus.fetchingInitialPage;

  bool get isFetchingSuccessive =>
      this == PaginationStatus.fetchingSuccessivePage;

  bool get isStable => this == PaginationStatus.stable;

  bool get isFailedAfterSomeTransactions =>
      this == PaginationStatus.failedAtSomePage;

  bool get isFailedToLoadInitial =>
      this == PaginationStatus.failedToLoadInitialPage;

  bool get hasNoResultForPage => this == PaginationStatus.doesNotContainResults;

  bool get hasFetchedAllPage => this == PaginationStatus.fetchedAllPage;
}

class PaginationState<Type, PageReference, E extends Object?>
    with EquatableMixin {
  final E? error;
  final List<Type> entries;
  final PaginationStatus status;
  final PageReference pageReference;

  const PaginationState({
    required this.pageReference,
    this.error,
    this.entries = const [],
    this.status = PaginationStatus.fetchingInitialPage,
  });

  PaginationState<Type, PageReference, E> copyWith({
    List<Type>? result,
    PaginationStatus? status,
    E? error,
    PageReference? pageReference,
  }) {
    return PaginationState(
      entries: result ?? this.entries,
      status: status ?? this.status,
      error: error ?? this.error,
      pageReference: pageReference ?? this.pageReference,
    );
  }

  @override
  List<Object?> get props => [
        error,
        entries,
        status,
        pageReference,
      ];
}
