import 'package:felloapp/core/model/action.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/ui/pages/root/tutorial_keys.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/shared/show_case.dart';
import 'package:felloapp/util/action_resolver.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:showcaseview/showcaseview.dart';

class StepsSection extends StatelessWidget {
  const StepsSection({
    required this.data,
    required this.styles,
    super.key,
  });
  final sections.StepsData data;
  final Map<String, sections.StepStyle> styles;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
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
                if (i == 0)
                  Padding(
                    padding: EdgeInsets.only(
                      left:
                          i == 0 ? SizeConfig.padding20 : SizeConfig.padding16,
                      right: i == steps.length - 1 ? SizeConfig.padding20 : 0,
                    ),
                    child: ShowCaseView(
                      globalKey: TutorialKeys.tutorialkey1,
                      title: null,
                      description: locale.tutorial1,
                      toolTipPosition: TooltipPosition.top,
                      targetPadding:
                          EdgeInsets.only(left: SizeConfig.padding10),
                      shapeBorder: const RoundedRectangleBorder(),
                      targetBorderRadius: BorderRadius.circular(10),
                      child: ShowCaseView(
                        globalKey: TutorialKeys.tutorialkey2,
                        title: null,
                        description: locale.tutorial2,
                        targetPadding:
                            EdgeInsets.only(left: SizeConfig.padding10),
                        toolTipPosition: TooltipPosition.bottom,
                        shapeBorder: const RoundedRectangleBorder(),
                        targetBorderRadius: BorderRadius.circular(10),
                        child: ShowCaseView(
                          globalKey: TutorialKeys.tutorialkey6,
                          title: null,
                          description: locale.tutorial6,
                          targetPadding:
                              EdgeInsets.only(left: SizeConfig.padding10),
                          toolTipPosition: TooltipPosition.bottom,
                          shapeBorder: const RoundedRectangleBorder(),
                          targetBorderRadius: BorderRadius.circular(10),
                          child: _Step(
                            step: steps[i],
                            style: styles[steps[i].style]!,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(
                      left:
                          i == 0 ? SizeConfig.padding20 : SizeConfig.padding16,
                      right: i == steps.length - 1 ? SizeConfig.padding20 : 0,
                    ),
                    child: _Step(
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

class _Step extends StatelessWidget {
  const _Step({
    required this.step,
    required this.style,
  });
  final sections.Step step;
  final sections.StepStyle style;

  void _onTapCard(Action? action) {
    if (action == null) return;
    ActionResolver.instance.resolve(action);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTapCard(step.cta.action),
      child: Container(
        margin: const EdgeInsets.only(
          right: 3,
          bottom: 8,
          top: 3,
        ), // for shadows
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
            _StepCTA(
              cta: step.cta,
              labelColor: style.ctaColor.toColor(),
              backgroundColor: style.shadowColor.toColor(),
            )
          ],
        ),
      ),
    );
  }
}

class _StepCTA extends StatelessWidget {
  const _StepCTA({
    required this.cta,
    this.backgroundColor,
    this.labelColor,
  });
  final sections.Cta cta;
  final Color? backgroundColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
