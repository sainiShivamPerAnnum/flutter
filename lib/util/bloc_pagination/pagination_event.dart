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

/// An event to close the pagination state.
///
/// This event clears the pagination state to its initial state
class _Dispose extends PaginationEvent {
  const _Dispose();
}

/// An event to update items in the pagination state.
///
/// This event is triggered when items in the already loaded data need
/// to be updated. It supports different update strategies.
class _UpdateItemEvent<Type> extends PaginationEvent {
  const _UpdateItemEvent({
    this.updateByIndex,
    this.updateByPredicate,
    this.updateAll,
    this.customUpdater,
  }) : assert(
          updateByIndex != null ||
              updateByPredicate != null ||
              updateAll != null ||
              customUpdater != null,
          'At least one update strategy must be provided',
        );

  /// Update a specific item at the given index.
  final ({int index, Type item})? updateByIndex;

  /// Update all items that match the given predicate.
  final ({
    bool Function(Type item) predicate,
    Type Function(Type) updater
  })? updateByPredicate;

  /// Update all items using the given updater function.
  final Type Function(Type)? updateAll;

  /// Custom update logic that works directly with the entire list.
  final List<Type> Function(List<Type> currentItems)? customUpdater;
}
