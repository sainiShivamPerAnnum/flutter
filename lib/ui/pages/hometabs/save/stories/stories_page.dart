import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/core/repository/local/stories_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '_story.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({
    this.stories = const [],
    this.entryIndex = 0,
    super.key,
  });

  final List<sections.Story> stories;
  final int entryIndex;

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  late final StoryController _storyController = StoryController();
  StoriesRepository? _repository = locator();

  void _markStoryViewed(String storyId) {
    _repository?.markStoryAsViewed(storyId);
  }

  @override
  void dispose() {
    _storyController.dispose();
    _repository = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: UiConstants.bg,
        body: Column(
          children: [
            Expanded(
              child: StoryView(
                initialIndex: widget.entryIndex,
                onStoryShow: (value) => _markStoryViewed(value.id),
                controller: _storyController,
                storyItems: widget.stories
                    .map(
                      (e) => StoryItem.pageVideo(
                        id: e.id,
                        e.story,
                        controller: _storyController,
                        overlay: Positioned(
                          bottom: SizeConfig.padding24,
                          child: Column(
                            children: [
                              for (var i = 0; i < e.cta.length; i++)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: SizeConfig.padding14,
                                    left: SizeConfig.pageHorizontalMargins,
                                    right: SizeConfig.pageHorizontalMargins,
                                  ),
                                  child: DSLButtonResolver(
                                    preResolve: () => AppState
                                        .backButtonDispatcher!
                                        .didPopRoute(),
                                    cta: e.cta[i],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
