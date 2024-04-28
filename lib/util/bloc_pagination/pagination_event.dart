part of 'pagination_bloc.dart';

/// The base class for pagination events.
///
/// This sealed class is used to represent various events that can occur during
/// the pagination process, such as fetching the initial page, fetching the next
/// page, or resetting the pagination state.
sealed class PaginationEvent {
  const PaginationEvent();
}

/// An event to fetch the initial page.
///
/// This event triggers the loading of the first page of a paginated dataset.
class _FetchInitialPage extends PaginationEvent {
  const _FetchInitialPage();
}

/// An event to fetch the next page.
///
/// This event triggers the loading of the next page in the pagination sequence.
class _FetchNextPage extends PaginationEvent {
  const _FetchNextPage();
}

/// An event to reset the pagination state.
///
/// This event resets the pagination to its initial state and triggers
/// refetching of the initial page.
class _Reset extends PaginationEvent {
  const _Reset();
}
