part of 'pagination_bloc.dart';

/// Represents the different statuses in the pagination process.
///
/// This enum is used to describe the current state of pagination.
enum PaginationStatus {
  /// Indicates that the initial page is being fetched.
  fetchingInitialPage,

  /// Indicates that the page does not contain any results.
  doesNotContainResults,

  /// Indicates that there was a failure while loading the initial page.
  failedToLoadInitialPage,

  /// Indicates that successive pages are being fetched.
  fetchingSuccessivePage,

  /// Indicates that there was a failure at some point during pagination.
  failedAtSomePage,

  /// Indicates that pagination is stable (not currently fetching).
  stable,

  /// Indicates that all pages have been fetched.
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

/// Represents the state of the pagination process.
///
/// This class holds information about the current state of pagination,
/// including the current list of entries, the status, any errors, and the
/// current page reference.
///
/// - [Type] The type of the paginated data.
/// - [PageReference] The type of the page reference.
/// - [E] The type of error that can occur during pagination.
class PaginationState<Type, PageReference, E extends Object?>
    with EquatableMixin {
  /// The error encountered during pagination, if any.
  final E? error;

  /// The list of data entries currently in the pagination state.
  final List<Type> entries;

  /// The current status of the pagination.
  final PaginationStatus status;

  /// The current page reference used for fetching successive pages.
  final PageReference pageReference;

  /// Creates a new [PaginationState] with the given parameters.
  const PaginationState({
    required this.pageReference,
    this.error,
    this.entries = const [],
    this.status = PaginationStatus.fetchingInitialPage,
  });

  /// Creates a copy of the current [PaginationState] with modified values.
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
