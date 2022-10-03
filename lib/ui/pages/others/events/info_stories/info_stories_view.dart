import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/events/info_stories/info_stories_vm.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class InfoStories extends StatelessWidget {
  final String topic;

  const InfoStories({Key key, @required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<InfoStoriesViewModel>(
      onModelReady: (model) {
        model.init(topic);
      },
      onModelDispose: (model) {
        model.dump();
      },
      builder: (ctx, model, child) {
        return Scaffold(
            body: StoryView(
                storyItems: model.storyItems,
                controller: model.controller, // pass controller here too
                repeat: true, // should the stories be slid forever
                onStoryShow: (s) {},
                onComplete: () {},
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context);
                  }
                } // To disable vertical swipe gestures, ignore this parameter.
                // Preferrably for inline story view.
                ));
      },
    );
  }
}
