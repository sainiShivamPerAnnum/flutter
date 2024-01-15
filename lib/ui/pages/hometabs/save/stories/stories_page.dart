import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/core/repository/local/stories_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/stories/story_view/story_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  Future<void> _preResolveAction() async {
    await AppState.backButtonDispatcher!.didPopRoute();
    await Future.delayed(
        const Duration(milliseconds: 200)); // nasty navigation 🤷🏻
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
                onComplete: () => AppState.backButtonDispatcher!.didPopRoute(),
                initialIndex: widget.entryIndex,
                onStoryShow: (value) => _markStoryViewed(value.id as String),
                controller: _storyController,
                storyItems: widget.stories
                    .map(
                      (e) => StoryItem.pageVideo(
                        e.story,
                        id: e.id,
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
                                    preResolve: _preResolveAction,
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
