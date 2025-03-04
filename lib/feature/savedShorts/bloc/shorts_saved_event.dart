part of 'shorts_saved_bloc.dart';

sealed class SavedShortsEvents {
  const SavedShortsEvents();
}

class LoadSavedData extends SavedShortsEvents {
  const LoadSavedData();
}

class ToogleNotification extends SavedShortsEvents {
  final String theme;
  final bool isFollowed;
  const ToogleNotification(this.theme, this.isFollowed);
}

class RemoveSaved extends SavedShortsEvents {
  const RemoveSaved(
    this.id,
  );
  final String id;
}
