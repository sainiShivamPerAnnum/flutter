import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart' hide Action;

/// TODO(@DK070202): Current active story.
class StoriesSection extends StatelessWidget {
  const StoriesSection({
    required this.data,
    super.key,
  });

  final sections.StoriesData data;

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
            Color(0xff29292B),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < 10; i++)
              Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? SizeConfig.padding20 : SizeConfig.padding24,
                  right: i == 9 ? SizeConfig.padding20 : 0,
                ),
                child: _StoryCard(
                  shouldHighlight: i == 0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatefulWidget {
  final bool shouldHighlight;

  const _StoryCard({
    this.shouldHighlight = false,
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

    if (widget.shouldHighlight) {
      _focusAnimationController.repeat(
        reverse: true,
      );
    }
  }

  @override
  void didUpdateWidget(covariant _StoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.shouldHighlight && !widget.shouldHighlight) {
      _focusAnimationController.reset();
    }

    if (!oldWidget.shouldHighlight && widget.shouldHighlight) {
      _focusAnimationController.repeat(
        reverse: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(
      SizeConfig.roundness16,
    );

    final innerRadius = Radius.circular(
      SizeConfig.roundness12,
    );

    return Column(
      children: [
        CustomPaint(
          painter: _StoryFocusPainter(
            radius: radius,
            animation: _tween,
            borderColor:
                widget.shouldHighlight ? UiConstants.teal3 : Colors.white,
          ),
          child: Container(
            padding: EdgeInsets.all(SizeConfig.padding4),
            height: 88,
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.all(innerRadius),
              child: CachedNetworkImage(
                imageUrl:
                    'https://ik.imagekit.io/9xfwtu0xm/story%20thumbnail/fello.png',
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.padding8,
        ),
        Text(
          'KNOW',
          style: TextStyles.sourceSansSB.body4.copyWith(
            color: UiConstants.teal3,
            height: 1.5,
          ),
        ),
        Text(
          'FELLO',
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
      ..strokeWidth = 1;

    final innerRectPainter = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = 4 * animation.value;

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
