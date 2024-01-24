import 'package:felloapp/core/model/action.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/action_resolver.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart' hide Action;

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
                  child: _QuickActionCard(
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

class _QuickActionCard extends StatelessWidget {
  final String asset;
  final String title;
  final String subtitle;

  final Color color;
  final VoidCallback? onTap;

  const _QuickActionCard({
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
