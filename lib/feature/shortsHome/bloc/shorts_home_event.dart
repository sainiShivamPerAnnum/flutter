part of 'shorts_home_bloc.dart';

sealed class ShortsHomeEvents {
  const ShortsHomeEvents();
}

class LoadHomeData extends ShortsHomeEvents {
  const LoadHomeData();
}

class SearchShorts extends ShortsHomeEvents {
  final String query;
  const SearchShorts(this.query);
}

class ApplyCategory extends ShortsHomeEvents {
  final String query;
  const ApplyCategory(this.query);
}
