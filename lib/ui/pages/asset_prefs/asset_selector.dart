import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

const _kAnimationDuration = Duration(milliseconds: 200);
const _kCurve = Curves.easeIn;

class AssetOptionWidget extends StatefulWidget {
  const AssetOptionWidget({
    required this.onSelect,
    required this.isSelected,
    required this.assetPrefOption,
    super.key,
  });

  final AssetPrefOption assetPrefOption;
  final ValueChanged<AssetPrefType> onSelect;
  final bool Function(AssetPrefType) isSelected;

  @override
  State<AssetOptionWidget> createState() => _AssetOptionWidgetState();
}

class _AssetOptionWidgetState extends State<AssetOptionWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected(widget.assetPrefOption.assetType);
    return InkWell(
      onTap: () => widget.onSelect(widget.assetPrefOption.assetType),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Radio(
                isSelected: isSelected,
              ),
              SizedBox(
                width: SizeConfig.padding16,
              ),
              Expanded(
                child: switch (widget.assetPrefOption.assetType) {
                  AssetPrefType.NONE => NoPrefButton(
                      isSelected: isSelected,
                      assetPrefOption: widget.assetPrefOption,
                    ),
                  AssetPrefType.P2P || AssetPrefType.GOLD => AssetCard(
                      isSelected: isSelected,
                      assetPrefOption: widget.assetPrefOption,
                    )
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({
    this.isSelected = false,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.padding1 * 23,
      height: SizeConfig.padding1 * 23,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: UiConstants.grey2),
      ),
      padding: EdgeInsets.all(SizeConfig.padding4),
      child: AnimatedOpacity(
        duration: _kAnimationDuration,
        curve: _kCurve,
        opacity: isSelected ? 1 : 0,
        child: Container(
          padding: EdgeInsets.all(SizeConfig.padding4),
          decoration: const BoxDecoration(
            color: UiConstants.teal3,
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: UiConstants.kBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}

class NoPrefButton extends StatelessWidget {
  const NoPrefButton({
    required this.assetPrefOption,
    this.isSelected = false,
    super.key,
  });

  final AssetPrefOption assetPrefOption;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _kAnimationDuration,
      curve: _kCurve,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: UiConstants.kTambolaMidTextColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
      child: Text(
        assetPrefOption.title,
        style: TextStyles.rajdhaniSB.body1,
      ),
    );
  }
}

class AssetCard extends StatelessWidget {
  const AssetCard({
    required this.isSelected,
    required this.assetPrefOption,
    super.key,
  });

  final bool isSelected;
  final AssetPrefOption assetPrefOption;

  Color _getBorderColor() {
    if (!isSelected) {
      return Colors.transparent;
    }

    return switch (assetPrefOption.assetType) {
      AssetPrefType.P2P => UiConstants.teal2,
      AssetPrefType.GOLD => UiConstants.blue3,
      _ => Colors.transparent,
    };
  }

  Color _getBackGroundColor() {
    return switch (assetPrefOption.assetType) {
      AssetPrefType.P2P => UiConstants.teal4,
      AssetPrefType.GOLD => UiConstants.kSaveDigitalGoldCardBg,
      _ => Colors.transparent,
    };
  }

  Color _benefitsBackgroundColor() {
    return switch (assetPrefOption.assetType) {
      AssetPrefType.P2P => UiConstants.teal5,
      AssetPrefType.GOLD => UiConstants.goldSellCardColor,
      _ => Colors.transparent,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        LearnMoreSlider(
          assetPrefOption: assetPrefOption.assetType,
        ),
        AnimatedPadding(
          duration: _kAnimationDuration,
          curve: _kCurve,
          padding: EdgeInsets.only(
            bottom: isSelected ? SizeConfig.padding44 : 0,
          ),
          child: AnimatedContainer(
            duration: _kAnimationDuration,
            curve: _kCurve,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              border: Border.all(
                color: _getBorderColor(),
                width: 1.5,
              ),
              color: _getBackGroundColor(),
            ),
            padding: EdgeInsets.only(
              left: SizeConfig.padding4,
              right: SizeConfig.padding4,
              bottom: SizeConfig.padding4,
              top: SizeConfig.padding12,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(
                      assetPrefOption.icon,
                      height: SizeConfig.padding30,
                    ),
                    SizedBox(
                      width: SizeConfig.padding12,
                    ),
                    Text(
                      assetPrefOption.title,
                      style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.padding14,
                    right: SizeConfig.padding14,
                    top: SizeConfig.padding4,
                  ),
                  child: Text(
                    assetPrefOption.description,
                    style: TextStyles.sourceSans.body3.copyWith(
                      color: Colors.white60,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.padding4,
                    left: SizeConfig.padding4,
                    right: SizeConfig.padding4,
                    top: SizeConfig.padding20,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.roundness8,
                      ),
                      color: _benefitsBackgroundColor(),
                    ),
                    child: _Benefits(
                      info: assetPrefOption.info,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Benefits extends StatelessWidget {
  const _Benefits({
    required this.info,
  });

  final List<AssetOptionInfo> info;

  CrossAxisAlignment getColumnAlignment(int i) {
    switch (i) {
      case 0:
        return CrossAxisAlignment.start;
      case 2:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding8,
        horizontal: SizeConfig.padding16,
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < info.length; i++) ...[
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.padding4,
                  bottom: SizeConfig.padding4,
                ),
                child: Column(
                  crossAxisAlignment: getColumnAlignment(i),
                  children: [
                    Text(
                      info[i].title,
                      style: TextStyles.rajdhaniSB.body1
                          .colour(Colors.white.withOpacity(0.8)),
                    ),
                    Text(
                      info[i].subtitle,
                      style: TextStyles.rajdhani.body4
                          .colour(Colors.white.withOpacity(0.4)),
                    )
                  ],
                ),
              ),
              if (i != 2)
                SizedBox(
                  height: SizeConfig.padding36,
                  child: const VerticalDivider(
                    color: UiConstants.greyDivider,
                    thickness: .2,
                  ),
                )
            ],
          ]),
    );
  }
}

class LearnMoreSlider extends StatelessWidget {
  const LearnMoreSlider({
    required this.assetPrefOption,
    super.key,
  });

  final AssetPrefType assetPrefOption;

  void _onTap() {
    switch (assetPrefOption) {
      case AssetPrefType.P2P:
        AppState.backButtonDispatcher!.didPopRoute();
        AppState.delegate!.parseRoute(Uri.parse('/floDetails'));
        break;
      case AssetPrefType.GOLD:
        AppState.backButtonDispatcher!.didPopRoute();
        AppState.delegate!.parseRoute(Uri.parse('/goldDetails'));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(SizeConfig.roundness8),
        ),
        color: (assetPrefOption == AssetPrefType.P2P)
            ? UiConstants.teal5
            : UiConstants.goldSellCardColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.padding16,
          right: SizeConfig.padding16,
          bottom: SizeConfig.padding12,
          top: SizeConfig.padding22,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getStatsText(assetPrefOption),
            SizedBox(
              width: SizeConfig.padding26,
            ),
            InkWell(
              onTap: _onTap,
              child: Text(
                locale.learnMore,
                style: TextStyles.rajdhaniB.body2.colour(Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget getStatsText(AssetPrefType assetPrefOptions) {
  return (assetPrefOptions == AssetPrefType.P2P)
      ? RichText(
          text: TextSpan(
            text: "₹12Cr+ invested",
            style: TextStyles.sourceSansB.body4.colour(UiConstants.teal3),
            children: [
              TextSpan(
                text: " on Fello P2P",
                style: TextStyles.sourceSans.body4.colour(Colors.white),
              )
            ],
          ),
        )
      : RichText(
          text: TextSpan(
            text: "Trusted by",
            style: TextStyles.sourceSans.body4.colour(Colors.white),
            children: [
              TextSpan(
                text: " 1Lac+",
                style: TextStyles.sourceSansB.body4
                    .colour(UiConstants.kBlogTitleColor),
              ),
              TextSpan(
                text: " Fello Investors",
                style: TextStyles.sourceSans.body4.colour(Colors.white),
              )
            ],
          ),
        );
}
