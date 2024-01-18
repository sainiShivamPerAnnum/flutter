import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/cache_model/story_model.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/core/repository/local/stories_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/save/stories/stories_page.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart' hide Action;

class StoriesSection extends StatefulWidget {
  const StoriesSection({
    required this.data,
    required this.style,
    super.key,
  });

  final sections.StoriesData data;
  final Map<String, sections.StoryStyle> style;

  @override
  State<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  late final StoriesRepository _storiesRepo = locator();

  @override
  void initState() {
    super.initState();
    _storiesRepo.addOrUpdateStories(widget.data.stories);
  }

  void _onTapStory(int index) {
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: StoriesPageConfig,
      widget: StoriesPage(
        stories: widget.data.stories,
        entryIndex: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding24,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(SizeConfig.roundness32),
        ),
        gradient: const LinearGradient(
          colors: [
            UiConstants.bg,
            UiConstants.bg1,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            offset: Offset(0, SizeConfig.padding4),
            blurRadius: 25,
          )
        ],
      ),
      child: StreamBuilder<List<StoryCollection>>(
        stream: _storiesRepo.listenChangesInStories(),
        builder: (context, snapshot) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < widget.data.stories.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? SizeConfig.padding20 : SizeConfig.padding24,
                    right: i == widget.data.stories.length - 1
                        ? SizeConfig.padding20
                        : 0,
                  ),
                  child: InkWell(
                    onTap: () => _onTapStory(i),
                    child: _StoryCard(
                      style: widget.style[widget.data.stories[i].style]!,
                      storyStatus: _storiesRepo.getStoryStatusById(
                        widget.data.stories[i].id,
                      ),
                      story: widget.data.stories[i],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends StatefulWidget {
  final StoryStatus storyStatus;
  final sections.Story story;
  final sections.StoryStyle style;

  const _StoryCard({
    required this.story,
    required this.storyStatus,
    required this.style,
  });

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _focusAnimationController;
  late final Animation<double> _tween;

  @override
  void initState() {
    super.initState();
    _focusAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _tween = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _focusAnimationController,
      curve: Curves.easeIn,
    ));

    if (widget.storyStatus.isFocused) {
      _focusAnimationController.repeat(
        reverse: true,
      );
    }
  }

  @override
  void didUpdateWidget(covariant _StoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.storyStatus.isFocused && !widget.storyStatus.isFocused) {
      _focusAnimationController.reset();
    }

    if (!oldWidget.storyStatus.isFocused && widget.storyStatus.isFocused) {
      _focusAnimationController.repeat(
        reverse: true,
      );
    }
  }

  Color _getColorByStatus() {
    return switch (widget.storyStatus) {
      StoryStatus.focused => UiConstants.teal3,
      StoryStatus.toBeViewed => Colors.white,
      StoryStatus.viewed => Colors.white.withOpacity(.5)
    };
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;

    return Column(
      children: [
        CustomPaint(
          painter: _StoryFocusPainter(
            radius: Radius.circular(SizeConfig.roundness16),
            animation: _tween,
            borderColor: _getColorByStatus(),
          ),
          child: Container(
            padding: EdgeInsets.all(SizeConfig.padding1 * 5),
            height: 88,
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.roundness12),
              ),
              child: CachedNetworkImage(
                imageUrl: story.thumbnail,
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.padding8,
        ),
        Text(
          story.title,
          style: TextStyles.sourceSansSB.body4.copyWith(
            color: widget.style.subtitleColor.toColor(),
            height: 1.5,
          ),
        ),
        Text(
          story.subtitle,
          style: TextStyles.sourceSansSB.body4.copyWith(
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _StoryFocusPainter extends CustomPainter {
  final Color borderColor;
  final Radius radius;
  final Animation<double> animation;

  const _StoryFocusPainter({
    required this.radius,
    required this.animation,
    this.borderColor = Colors.white,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final outerRectPainter = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = 1.5;

    final innerRectPainter = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = 4.5 * animation.value;

    final rect = Offset.zero & size;

    final innerRect = rect.deflate(
      1,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, radius),
      innerRectPainter,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, radius),
      outerRectPainter,
    );
  }

  @override
  bool shouldRepaint(covariant _StoryFocusPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor ||
      oldDelegate.radius != radius ||
      oldDelegate.animation != animation;
}
