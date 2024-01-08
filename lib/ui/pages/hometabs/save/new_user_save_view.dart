import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_section.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:flutter/material.dart';

import '../../../../util/styles/styles.dart';

class NewUserSaveView extends StatelessWidget {
  const NewUserSaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StoriesSection(),
          SizedBox(height: SizeConfig.padding32),
          const InvestmentSteps(),
          SizedBox(height: SizeConfig.padding32),
          const LabelSection(),
          SizedBox(height: SizeConfig.padding32),
          const MiniAssetSection(),
          SizedBox(height: SizeConfig.padding32),
        ],
      ),
    );
  }
}

class MiniAssetSection extends StatelessWidget {
  const MiniAssetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ),
          child: Text(
            'Know more about Assets',
            style: TextStyles.sourceSansSB.body1,
          ),
        ),
        SizedBox(height: SizeConfig.padding2),
        const MiniAssetsGroupSection(),
      ],
    );
  }
}

class LabelSection extends StatelessWidget {
  const LabelSection({super.key});

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
  const InvestmentSteps({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ),
          child: Text(
            'Start by Investing in',
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
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? SizeConfig.padding20 : SizeConfig.padding16,
                    right: i == 2 ? SizeConfig.padding20 : 0,
                  ),
                  child: const _InvestmentStep(),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class _InvestmentStep extends StatelessWidget {
  const _InvestmentStep();

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
          const BoxShadow(
            offset: Offset(-4, 4),
            color: Color(0x64F79780),
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
              const AppImage(
                Assets.floWithoutShadow,
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: SizeConfig.padding12,
              ),
              Text(
                'P2P or Gold?',
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Text(
            'Continue your Investment\nselection to enjoy Returns',
            style: TextStyles.sourceSans.body3,
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          const _InvestmentStepCTA()
        ],
      ),
    );
  }
}

class _InvestmentStepCTA extends StatelessWidget {
  const _InvestmentStepCTA();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.peach3.withOpacity(.10),
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
            'Continue',
            style: TextStyles.sourceSansSB.body4.copyWith(
              color: UiConstants.peach3,
              height: 1.5,
            ),
          ),
          const AppImage(
            Assets.chevRonRightArrow,
            color: UiConstants.peach3,
          )
        ],
      ),
    );
  }
}

class StoriesSection extends StatelessWidget {
  const StoriesSection({
    super.key,
  });

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
