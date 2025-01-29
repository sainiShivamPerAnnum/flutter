import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MiniAssetsGroupSection extends StatelessWidget {
  const MiniAssetsGroupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
        vertical: SizeConfig.padding14,
      ),
      child: Row(
        children: [
          const Expanded(
            child: MiniAssetCard(
              color: UiConstants.kSaveDigitalGoldCardBg,
              asset: Assets.goldAsset,
              title: "Digital Gold",
              subtitle: "Know Digital Gold",
              actionUri: "goldDetails",
            ),
          ),
          SizedBox(width: SizeConfig.padding16),
          const Expanded(
            child: MiniAssetCard(
              color: UiConstants.kSaveStableFelloCardBg,
              asset: Assets.floAsset,
              title: "Fello P2P",
              subtitle: "Know Fello P2P",
              actionUri: "floDetails",
            ),
          ),
        ],
      ),
    );
  }
}

class MiniAssetCard extends StatelessWidget {
  final String asset, title, subtitle;
  final String actionUri;
  final Color color;

  const MiniAssetCard({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.actionUri,
    super.key,
  });

  void _onTapCard() {
    Haptic.vibrate();
    AppState.delegate!.parseRoute(Uri.parse(actionUri));
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
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  asset,
                  height: SizeConfig.padding60,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.padding10),
                  child: SvgPicture.asset(
                    Assets.chevRonRightArrow,
                    color: Colors.white,
                    width: SizeConfig.padding24,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "  $title",
                  style: TextStyles.rajdhaniSB.title5.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "    $subtitle",
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
