import 'package:isar/isar.dart';

part 'story_model.g.dart';

@Collection()
class StoryCollection {
  Id id = Isar.autoIncrement;
  String? storyId;
  bool? seen;
  int order = 0;

  StoryCollection({
    this.storyId,
    this.seen,
    this.order = 0,
  });
}
