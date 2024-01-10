import 'package:collection/collection.dart';
import 'package:felloapp/core/model/cache_model/story_model.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as section;
import 'package:felloapp/core/service/cache_service.dart';
import 'package:isar/isar.dart';

enum StoryStatus {
  focused,
  viewed,
  toBeViewed;

  bool get isFocused => this == StoryStatus.focused;
}

class StoriesRepository {
  const StoriesRepository(this._db);
  final LocalDbService _db;

  void addOrUpdateStories(List<section.Story> stories) {
    List<StoryCollection> toBeAdded = [];
    List<StoryCollection> toBeUpdated = [];

    final storiesId = stories.map((e) => e.id).toList();
    final cachedStories = _db.isar.storyCollections
        .filter()
        .anyOf(storiesId, (q, element) => q.storyIdEqualTo(element))
        .build()
        .findAllSync();

    for (var i = 0; i < stories.length; i++) {
      final story = stories[i];
      final cachedMapping = cachedStories.firstWhereOrNull(
        (element) => element.storyId == story.id,
      );

      if (cachedMapping == null) {
        toBeAdded.add(StoryCollection(
          storyId: story.id,
          order: story.order,
          seen: false,
        ));
      } else {
        if (cachedMapping.order != story.order) {
          cachedMapping.order = story.order;
          toBeUpdated.add(cachedMapping);
        }
      }
    }

    _db.isar.writeTxnSync(() {
      _db.isar.storyCollections.putAllSync(
        [...toBeUpdated, ...toBeAdded],
      );
    });
  }

  StoryStatus getStoryStatusById(String storyId) {
    final story = _db.isar.storyCollections
        .filter()
        .storyIdEqualTo(storyId)
        .findFirstSync();

    if (story != null && (story.seen ?? false)) {
      return StoryStatus.viewed;
    }

    final nextStoryToBeFocused = _db.isar.storyCollections
        .where()
        .sortByOrder()
        .findAllSync()
        .firstWhereOrNull((element) => !(element.seen ?? false));

    if (nextStoryToBeFocused?.storyId == storyId) {
      return StoryStatus.focused;
    }

    return StoryStatus.toBeViewed;
  }

  Future<void> markStoryAsViewed(String storyId) async {
    final story = _db.isar.storyCollections
        .filter()
        .storyIdEqualTo(storyId)
        .findFirstSync();

    if (story != null) {
      _db.isar.writeTxnSync(
        () {
          story.seen = true;
          _db.isar.storyCollections.putSync(story);
        },
      );
    }
  }

  Stream<List<StoryCollection>> listenChangesInStories() {
    return _db.isar.storyCollections.where().watch();
  }
}
