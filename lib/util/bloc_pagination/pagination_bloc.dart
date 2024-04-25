import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

sealed class PaginationResult<Result, Error> {
  const PaginationResult._();

  const factory PaginationResult.success({
    required Result result,
  }) = _Success<Result, Error>;

  const factory PaginationResult.failure({
    required Error error,
  }) = _Failed<Result, Error>;

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

class _Success<T, E> extends PaginationResult<T, E> {
  const _Success({required this.result}) : super._();
  final T result;
}

class _Failed<T, E> extends PaginationResult<T, E> {
  const _Failed({
    required this.error,
  }) : super._();

  final E error;
}

typedef PaginationCallBack<Result, PageReference, Error>
    = Future<PaginationResult<Result, Error>> Function(
  PageReference pageReference,
);

typedef ConverterCallBack<R, T> = T Function(R result);

typedef PaginationStateReferenceCallBack<R, T> = T Function(
  R result,
  T previousState,
  VoidCallback interrupter,
);

class PaginationBloc<Type, Result, PageReference, Error extends Object>
    extends Bloc<PaginationEvent, PaginationState<Type, PageReference, Error>> {
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
  }

  final PaginationCallBack<Result, PageReference, Error> _paginationCallBack;
  final PaginationStateReferenceCallBack<Result, PageReference>
      _referenceConverterCallBack;
  final ConverterCallBack<Result, List<Type>> _resultConverterCallback;
  final PageReference _initialPageReference;

  Future<void> _fetchInitialPage(
    _FetchInitialPage event,
    Emitter<PaginationState<Type, PageReference, Error>> emitter,
  ) async {
    if (state.status.hasNoResultForPage || state.status.hasFetchedAllPage) {
      return;
    }

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

  Future<void> _fetchNextPage(
    _FetchNextPage event,
    Emitter<PaginationState<Type, PageReference, Error>> emitter,
  ) async {
    if (state.status.hasFetchedAllPage) {
      return;
    }

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
          state.pageReference,
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

  void fetchFirstPage() {
    add(const _FetchInitialPage());
  }

  void fetchNextPage() {
    add(const _FetchNextPage());
  }

  void reset() {
    add(const _Reset());
  }
}
