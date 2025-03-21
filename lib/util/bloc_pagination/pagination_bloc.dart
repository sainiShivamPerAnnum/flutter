import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

/// Represents the result of a paginated request.
///
/// This sealed class can represent either a successful result or a failure.
/// - [Result] the type of the successful result.
/// - [Error] the type of the error.
sealed class PaginationResult<Result, Error> {
  const PaginationResult._();

  /// A successful paginated request.
  const factory PaginationResult.success({
    required Result result,
  }) = _Success<Result, Error>;

  /// A failed paginated request.
  const factory PaginationResult.failure({
    required Error error,
  }) = _Failed<Result, Error>;

  /// Pattern matching to handle different outcomes of a paginated request.
  ///
  /// - [onFailure] when the result is a failure.
  /// - [onSuccess] when the result is a success.
  ///
  /// Returns a value [R] determined by the specific result type.
  R _when<R>(
    R Function(Error error) onFailure,
    R Function(Result result) onSuccess,
  ) {
    return switch (this) {
      _Success(:final result) => onSuccess(result),
      _Failed(:final error) => onFailure(error),
    };
  }
}

/// Represents a successful paginated result.
class _Success<T, E> extends PaginationResult<T, E> {
  const _Success({required this.result}) : super._();
  final T result;
}

/// Represents a failed paginated result.
class _Failed<T, E> extends PaginationResult<T, E> {
  const _Failed({
    required this.error,
  }) : super._();

  final E error;
}

/// A type alias for a callback that fetches paginated data.
///
/// - [Result] The type of the data being fetched.
/// - [PageReference] The reference used to fetch the data.
/// - [Error] The type of error that can occur.
///
/// Takes a `PageReference` and returns a `Future` with a `PaginationResult`.
typedef PaginationCallBack<Result, PageReference, Error>
    = Future<PaginationResult<Result, Error>> Function(
  PageReference pageReference,
);

/// A type alias for a callback that converts results into a list of entries.
///
/// - [R] the input result type.
/// - [T] the output type.
typedef ConverterCallBack<R, T> = T Function(R result);

/// A type alias for a callback that converts results into a new page reference.
///
/// - [R] The input result type.
/// - [T] The output page reference type.
typedef PaginationStateReferenceCallBack<R, T> = T Function(
  R result,
  T previousState,
  VoidCallback interrupter,
);

/// A BLoC class for managing paginated data fetching.
///
/// - [Type] The type of the data entries.
/// - [Result] The type of the raw results.
/// - [PageReference: The type of the page reference.
/// - [Error] The type of error that can occur during fetching.
class PaginationBloc<Type, Result, PageReference, Error extends Object>
    extends Bloc<PaginationEvent, PaginationState<Type, PageReference, Error>> {
  /// Creates a `PaginationBloc` with the given parameters.
  ///
  /// - [initialPageReference] The initial page reference.
  /// - [paginationCallBack] The callback function to fetch paginated data.
  /// - [resultConverterCallback] The callback to convert raw results into a
  ///   list of entries.
  /// - [referenceConverterCallBack] The callback to convert results into the
  ///   next page reference.
  PaginationBloc({
    required PageReference initialPageReference,
    required PaginationCallBack<Result, PageReference, Error>
        paginationCallBack,
    required ConverterCallBack<Result, List<Type>> resultConverterCallback,
    required PaginationStateReferenceCallBack<Result, PageReference>
        referenceConverterCallBack,
  })  : _paginationCallBack = paginationCallBack,
        _resultConverterCallback = resultConverterCallback,
        _referenceConverterCallBack = referenceConverterCallBack,
        _initialPageReference = initialPageReference,
        super(
          PaginationState(
            pageReference: initialPageReference,
          ),
        ) {
    on<_FetchInitialPage>(_fetchInitialPage);
    on<_FetchNextPage>(_fetchNextPage);
    on<_Reset>(_reset);
    on<_Dispose>(_dispose);
    on<_UpdateItemEvent<Type>>(_updateItem);
  }

  final PaginationCallBack<Result, PageReference, Error> _paginationCallBack;
  final PaginationStateReferenceCallBack<Result, PageReference>
      _referenceConverterCallBack;
  final ConverterCallBack<Result, List<Type>> _resultConverterCallback;
  final PageReference _initialPageReference;

  /// Handles the event to fetch the initial page.
  ///
  /// If successful, updates the state with new entries and page reference.
  /// Otherwise, sets an error status.
  Future<void> _fetchInitialPage(
    _FetchInitialPage event,
    Emitter<PaginationState<Type, PageReference, Error>> emitter,
  ) async {
    final response = await _paginationCallBack(_initialPageReference);

    response._when<void>(
      (error) {
        emitter(
          state.copyWith(
            error: error,
            status: PaginationStatus.failedToLoadInitialPage,
          ),
        );
      },
      (result) {
        final entries = _resultConverterCallback(result);

        PaginationStatus status = PaginationStatus.stable;

        if (entries.isEmpty) {
          status = PaginationStatus.doesNotContainResults;
        }

        void terminationCallback() {
          status = PaginationStatus.fetchedAllPage;
        }

        final pageReference = _referenceConverterCallBack(
          result,
          _initialPageReference,
          terminationCallback,
        );

        emitter(
          state.copyWith(
            result: entries,
            status: status,
            pageReference: pageReference,
          ),
        );
      },
    );
  }

  /// Handles the event to fetch the next page.
  ///
  /// If not all pages have been fetched, it updates the state with additional
  /// entries and page reference.
  ///
  /// Otherwise, sets an error status.
  Future<void> _fetchNextPage(
    _FetchNextPage event,
    Emitter<PaginationState<Type, PageReference, Error>> emitter,
  ) async {
    emitter(
      state.copyWith(status: PaginationStatus.fetchingSuccessivePage),
    );

    final response = await _paginationCallBack(state.pageReference);

    response._when<void>(
      (error) {
        emitter(
          state.copyWith(
            error: error,
            status: PaginationStatus.failedAtSomePage,
          ),
        );
      },
      (result) {
        final entries = _resultConverterCallback(result);

        PaginationStatus status = entries.isEmpty
            ? PaginationStatus.fetchedAllPage
            : PaginationStatus.stable;

        void terminationCallback() {
          status = PaginationStatus.fetchedAllPage;
        }

        final pageReference = _referenceConverterCallBack(
          result,
          state.pageReference,
          terminationCallback,
        );

        emitter(
          state.copyWith(
            result: state.entries..addAll(entries),
            pageReference: pageReference,
            status: status,
          ),
        );
      },
    );
  }

  /// Handles the event to update items in the loaded data.
  Future<void> _updateItem(
    _UpdateItemEvent<Type> event,
    Emitter<PaginationState<Type, PageReference, Error>> emitter,
  ) async {
    List<Type> updatedEntries = List<Type>.from(state.entries);
    if (event.updateByIndex != null) {
      final update = event.updateByIndex!;
      if (update.index >= 0 && update.index < updatedEntries.length) {
        updatedEntries[update.index] = update.item;
      }
    } else if (event.updateByPredicate != null) {
      final update = event.updateByPredicate!;
      for (int i = 0; i < updatedEntries.length; i++) {
        if (update.predicate(updatedEntries[i])) {
          updatedEntries[i] = update.updater(updatedEntries[i]);
        }
      }
    } else if (event.updateAll != null) {
      for (int i = 0; i < updatedEntries.length; i++) {
        updatedEntries[i] = event.updateAll!(updatedEntries[i]);
      }
    } else if (event.customUpdater != null) {
      updatedEntries = event.customUpdater!(updatedEntries);
    }
    emitter(
      state.copyWith(
        result: updatedEntries,
      ),
    );
  }

  /// Handles the event to reset the pagination to its initial state.
  ///
  /// Fetches the initial page and updates the state accordingly.
  Future<void> _reset(
    _Reset event,
    Emitter<PaginationState<Type, PageReference, Error>> emitter,
  ) async {
    emitter(
      state.copyWith(
        status: PaginationStatus.fetchingInitialPage,
      ),
    );

    final response = await _paginationCallBack(_initialPageReference);

    response._when<void>(
      (error) {
        emitter(
          state.copyWith(
            error: error,
            status: PaginationStatus.failedToLoadInitialPage,
          ),
        );
      },
      (result) {
        final entries = _resultConverterCallback(result);

        PaginationStatus status = PaginationStatus.stable;

        void terminationCallback() {
          status = PaginationStatus.fetchedAllPage;
        }

        final pageReference = _referenceConverterCallBack(
          result,
          _initialPageReference,
          terminationCallback,
        );

        emitter(
          state.copyWith(
            result: entries,
            status: status,
            pageReference: pageReference,
          ),
        );
      },
    );
  }

  /// Handles the event to dispose the pagination to its initial state.
  Future<void> _dispose(
    _Dispose event,
    Emitter<PaginationState<Type, PageReference, Error>> emitter,
  ) async {
    emitter(
      PaginationState(pageReference: _initialPageReference),
    );
  }

  // Add these public methods to the
  //PaginationBloc class to expose the update functionality

  /// Triggers the event to fetch the first page.
  void fetchFirstPage() {
    if (state.entries.isNotEmpty ||
        state.status.hasNoResultForPage ||
        state.status.hasFetchedAllPage) {
      return;
    }

    add(const _FetchInitialPage());
  }

  /// Triggers the event to fetch the next page.
  void fetchNextPage() {
    if (state.status.hasFetchedAllPage) {
      return;
    }

    add(const _FetchNextPage());
  }

  /// Triggers the event to reset the pagination.
  void reset() {
    add(const _Reset());
  }

  void dispose() {
    add(const _Dispose());
  }

  /// Updates an item at a specific index.
  void updateItemAtIndex(int index, Type item) {
    add(
      _UpdateItemEvent<Type>(
        updateByIndex: (index: index, item: item),
      ),
    );
  }

  /// Updates all items that match the given predicate.
  void updateItemsWhere(
    bool Function(Type item) predicate,
    Type Function(Type) updater,
  ) {
    add(
      _UpdateItemEvent<Type>(
        updateByPredicate: (predicate: predicate, updater: updater),
      ),
    );
  }

  /// Updates all items using the given updater function.
  void updateAllItems(Type Function(Type) updater) {
    add(
      _UpdateItemEvent<Type>(
        updateAll: updater,
      ),
    );
  }

  /// Updates the items using custom logic.
  void updateItemsWithCustomLogic(
    List<Type> Function(List<Type> currentItems) customUpdater,
  ) {
    add(
      _UpdateItemEvent<Type>(
        customUpdater: customUpdater,
      ),
    );
  }
}
