import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/action.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/action_resolver.dart';
import 'package:felloapp/util/assets.dart';
import 'package:flutter/material.dart' hide Action;

import '../../../../util/styles/styles.dart';

class NewUserSaveView extends StatelessWidget {
  const NewUserSaveView({
    required this.data,
    super.key,
  });
  final sections.PageData data;

  Widget _getWidgetBySection(sections.HomePageSection? section) {
    final widget = switch (section) {
      sections.StoriesSection(data: final d) => StoriesSection(
          data: d,
        ),
      sections.StepsSection(data: final d) => InvestmentSteps(
          data: d,
          styles: data.styles.steps,
        ),
      sections.QuickActions(data: final d) => QuickActionsSection(
          data: d,
          styles: data.styles.infoCards,
        ),
      sections.ImageSection(data: final d) => ImageSection(
          data: d,
        ),
      sections.NudgeSection() => const NudgeSection(),
      _ => const SizedBox.shrink()
    };

    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.padding30),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homePageData = data.screens.home;
    final sectionOrder = homePageData.sectionOrder;
    final section = homePageData.sections;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < sectionOrder.length; i++)
            _getWidgetBySection(section[sectionOrder[i]]),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({required this.data, super.key});
  final sections.ImageSectionData data;

  void _onTapImage() {
    final action = data.action;
    if (action == null) return;

    ActionResolver.instance.resolve(action);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: InkWell(
        onTap: _onTapImage,
        child: CachedNetworkImage(
          imageUrl: data.url,
        ),
      ),
    );
  }
}

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    required this.data,
    this.styles = const {},
    super.key,
  });
  final sections.QuickActionsCardsData data;
  final Map<String, sections.InfoCardStyle> styles;

  void _onTap(Action? action) {
    if (action == null) return;
    ActionResolver.instance.resolve(action);
  }

  Color _getColor(String key) {
    final style = styles[key];
    return style!.bgColor.toColor() ?? UiConstants.teal3;
  }

  @override
  Widget build(BuildContext context) {
    final cards = data.cards;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: TextStyles.sourceSansSB.body1,
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Row(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                Expanded(
                  child: _MiniAssetCard(
                    color: _getColor(cards[i].style),
                    asset: cards[i].icon,
                    title: cards[i].title,
                    subtitle: cards[i].subtitle,
                    onTap: () => _onTap(cards[i].action),
                  ),
                ),
                if (i != cards.length - 1)
                  SizedBox(
                    width: SizeConfig.padding16,
                  ),
              ]
            ],
          )
        ],
      ),
    );
  }
}

class _MiniAssetCard extends StatelessWidget {
  final String asset;
  final String title;
  final String subtitle;

  final Color color;
  final VoidCallback? onTap;

  const _MiniAssetCard({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  void _onTapCard() {
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTapCard,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 6,
              spreadRadius: 4,
              color: Colors.black.withOpacity(.15),
            ),
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 3,
              spreadRadius: 0,
              color: Colors.black.withOpacity(.30),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          left: SizeConfig.padding16,
          right: SizeConfig.padding16,
          top: SizeConfig.padding16,
          bottom: SizeConfig.padding14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppImage(
                  asset,
                  height: SizeConfig.padding46,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.padding10),
                  child: AppImage(
                    Assets.chevRonRightArrow,
                    color: Colors.white,
                    width: SizeConfig.padding24,
                  ),
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.padding8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.rajdhaniSB.title5.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyles.sourceSans.body4.colour(Colors.white54),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.padding14)
          ],
        ),
      ),
    );
  }
}

class NudgeSection extends StatelessWidget {
  const NudgeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.padding12),
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness12,
        ),
        color: UiConstants.grey4,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(.15),
            blurRadius: 6,
            spreadRadius: 2,
          ),
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(.30),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          AppImage(
            Assets.giftGameAsset,
            height: SizeConfig.padding26,
          ),
          SizedBox(
            width: SizeConfig.padding16,
          ),
          Text(
            'Claim ₹50 referral bonus by saving',
            style: TextStyles.rajdhaniSB.body2,
          ),
          const Spacer(),
          const AppImage(
            Assets.chevRonRightArrow,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class InvestmentSteps extends StatelessWidget {
  const InvestmentSteps({
    required this.data,
    required this.styles,
    super.key,
  });
  final sections.StepsData data;
  final Map<String, sections.StepStyle> styles;

  @override
  Widget build(BuildContext context) {
    final steps = data.steps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ),
          child: Text(
            data.title,
            style: TextStyles.sourceSansSB.body1,
          ),
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < steps.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? SizeConfig.padding20 : SizeConfig.padding16,
                    right: i == steps.length - 1 ? SizeConfig.padding20 : 0,
                  ),
                  child: _InvestmentStep(
                    step: steps[i],
                    style: styles[steps[i].style]!,
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class _InvestmentStep extends StatelessWidget {
  const _InvestmentStep({
    required this.step,
    required this.style,
  });
  final sections.Step step;
  final sections.StepStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3, bottom: 8, top: 3), // for shadows
      decoration: BoxDecoration(
        color: UiConstants.grey5,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            color: Colors.black.withOpacity(.25),
          ),
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 3,
            color: Colors.black.withOpacity(.15),
          ),
          BoxShadow(
            offset: const Offset(-4, 4),
            color: style.shadowColor.toColor()!,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      width: SizeConfig.padding200,
      padding: EdgeInsets.fromLTRB(
        SizeConfig.padding12,
        SizeConfig.padding16,
        SizeConfig.padding12,
        SizeConfig.padding12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppImage(
                step.icon,
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: SizeConfig.padding12,
              ),
              Text(
                step.title,
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Text(
            step.description,
            style: TextStyles.sourceSans.body3,
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          _InvestmentStepCTA(
            cta: step.cta,
            labelColor: style.ctaColor.toColor(),
            backgroundColor: style.shadowColor.toColor(),
          )
        ],
      ),
    );
  }
}

class _InvestmentStepCTA extends StatelessWidget {
  const _InvestmentStepCTA({
    required this.cta,
    this.backgroundColor,
    this.labelColor,
  });
  final sections.Cta cta;
  final Color? backgroundColor;
  final Color? labelColor;

  void _onTapCard(Action? action) {
    if (action == null) return;
    ActionResolver.instance.resolve(action);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTapCard(cta.action),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        ),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding6,
          horizontal: SizeConfig.padding8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cta.label,
              style: TextStyles.sourceSansSB.body4.copyWith(
                color: labelColor,
                height: 1.5,
              ),
            ),
            AppImage(
              Assets.chevRonRightArrow,
              color: labelColor,
            )
          ],
        ),
      ),
    );
  }
}

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
                child: StoryCardView(
                  shouldHighlight: i == 0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StoryCardView extends StatefulWidget {
  final bool shouldHighlight;

  const StoryCardView({
    super.key,
    this.shouldHighlight = false,
  });

  @override
  State<StoryCardView> createState() => _StoryCardViewState();
}

class _StoryCardViewState extends State<StoryCardView>
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
  void didUpdateWidget(covariant StoryCardView oldWidget) {
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
