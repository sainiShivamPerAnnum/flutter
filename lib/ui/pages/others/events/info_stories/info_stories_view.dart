import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/events/info_stories/info_stories_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
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
            body: Container(
          decoration: model.backgroundDecoration,
          child: model.state == ViewState.Busy
              ? Center(
                  child: FullScreenLoader(),
                )
              : StoryView(
                  inline: false,
                  storyItems: model.storyItems,
                  controller: model.controller,
                  repeat: false,
                  onStoryShow: (s) {},
                  onComplete: () {
                    AppState.backButtonDispatcher.didPopRoute();
                  },
                  onVerticalSwipeComplete: (direction) {}),
        ));
      },
    );
  }
}
