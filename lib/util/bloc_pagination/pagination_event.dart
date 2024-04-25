part of 'pagination_bloc.dart';

sealed class PaginationEvent {
  const PaginationEvent();
}

class _FetchInitialPage extends PaginationEvent {
  const _FetchInitialPage();
}

class _FetchNextPage extends PaginationEvent {
  const _FetchNextPage();
}

class _Reset extends PaginationEvent {
  const _Reset();
}
