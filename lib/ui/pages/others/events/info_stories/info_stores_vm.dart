import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

// import 'story';
class InfoStoriesViewModel extends BaseViewModel {
  final controller = StoryController();

  List<StoryItem> storyItems;

  init(String topic) {
    storyItems = [
      StoryItem.text(
        title: "Hello World",
        backgroundColor: Colors.black,
        textStyle: TextStyles.rajdhaniB.title3,
      ),
      StoryItem.pageImage(
          controller: controller,
          url:
              "https://images.unsplash.com/photo-1508995476428-43d70c3d0042?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8aGFsbG93ZWVufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
      StoryItem.pageImage(
          controller: controller,
          url:
              "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9kZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60"),
      StoryItem.pageVideo(
        "https://www.youtube.com/watch?v=pgvBPAsDf2A",
        controller: controller,
      )
    ];
  }

  dump() {}
}
