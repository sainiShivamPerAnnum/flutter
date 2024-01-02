import 'package:felloapp/ui/pages/asset_prefs/asset_pref_vm.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetSelector extends StatefulWidget {
  const AssetSelector(
      {Key? key, required this.assetPrefOptions, required this.model})
      : super(key: key);
  final AssetPrefOptions assetPrefOptions;
  final AssetPreferenceViewModel model;

  @override
  State<AssetSelector> createState() => _AssetSelectorState();
}

class _AssetSelectorState extends State<AssetSelector>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.model.selectedAsset != widget.assetPrefOptions) {
          widget.model.changeSelectedAsset(widget.assetPrefOptions);
          widget.model.triggerAnimation(_controller, widget.assetPrefOptions);
        }
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding20),
                child: Container(
                  width: SizeConfig.padding1 * 23,
                  height: SizeConfig.padding1 * 23,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: UiConstants.grey2)),
                  padding: EdgeInsets.all(SizeConfig.padding4),
                  child: Opacity(
                      opacity: _controller.value,
                      child: SvgPicture.asset(a.Assets.assetPrefRadio)),
                ),
              ),
              SizedBox(
                width: SizeConfig.padding16,
              ),
              Stack(
                children: [
                  Transform.translate(
                      offset:
                          Offset(0, _controller.value * SizeConfig.padding44),
                      child: LearnMoreSlider(
                          assetPrefOption: widget.assetPrefOptions)),
                  AssetCard(
                    opacity: _controller.value,
                    assetPrefOption: widget.assetPrefOptions,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding24 +
                _controller.value * (SizeConfig.padding44),
          ),
        ],
      ),
    );
  }
}

class LearnMoreSlider extends StatelessWidget {
  LearnMoreSlider({Key? key, required this.assetPrefOption}) : super(key: key);
  AssetPrefOptions assetPrefOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.padding1 * 335,
      height: SizeConfig.padding20 * 9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
            ? UiConstants.teal5
            : UiConstants.goldSellCardColor,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.padding16,
              right: SizeConfig.padding16,
              bottom: SizeConfig.padding12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                    ? "₹12Cr+ invested on Fello P2P"
                    : "Trust By 1 Lac+ Fello Investors",
                style: TextStyles.sourceSans.body4.colour(Colors.white),
              ),
              Text(
                "LEARN MORE",
                style: TextStyles.rajdhaniB.body2.colour(Colors.white),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class AssetCard extends StatelessWidget {
  AssetCard({super.key, required this.opacity, required this.assetPrefOption});
  double opacity;
  AssetPrefOptions assetPrefOption;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: SizeConfig.padding4),
      width: SizeConfig.padding1 * 335,
      height: SizeConfig.padding20 * 9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                ? UiConstants.teal2.withOpacity(opacity)
                : UiConstants.kBlogTitleColor.withOpacity(opacity),
            width: 1.5),
        color: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
            ? UiConstants.teal4
            : UiConstants.kSaveDigitalGoldCardBg,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding10),
                child: SvgPicture.asset(
                  (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                      ? a.Assets.floAsset
                      : a.Assets.digitalGold,
                  height: SizeConfig.padding30,
                ),
              ),
              SizedBox(
                width: SizeConfig.padding12,
              ),
              Text(
                (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                    ? "Fello P2P"
                    : "Digital Gold",
                style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.padding14,
                right: SizeConfig.padding14,
                top: SizeConfig.padding4),
            child: Text(
              "A P2P lending asset powered by Lendbox with 8%, 10% & 12% returns plans",
              style: TextStyles.sourceSans.body3.colour(Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
                bottom: SizeConfig.padding4,
                left: SizeConfig.padding4,
                right: SizeConfig.padding4),
            child: DetailsRow(
              upperText1: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                  ? "P2P"
                  : "24K",
              lowerText1: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                  ? "Asset"
                  : "Gold",
              upperText2: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                  ? "Upto 12%"
                  : "Stable Returns",
              lowerText2: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                  ? "Returns"
                  : "@Market Rate",
              upperText3: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                  ? "KYC"
                  : "No KYC",
              lowerText3: "Required",
              bgColor: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                  ? UiConstants.teal5
                  : UiConstants.goldSellCardColor,
            ),
          )
        ],
      ),
    );
  }
}

class DetailsRow extends StatelessWidget {
  const DetailsRow(
      {required this.upperText1,
      required this.lowerText1,
      required this.upperText2,
      required this.lowerText2,
      required this.upperText3,
      required this.lowerText3,
      required this.bgColor,
      super.key});
  final String upperText1;
  final String lowerText1;
  final String upperText2;
  final String lowerText2;
  final String upperText3;
  final String lowerText3;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.padding4 * 19,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: bgColor),
      padding: EdgeInsets.only(
          top: SizeConfig.padding10,
          bottom: SizeConfig.padding8,
          right: SizeConfig.padding16,
          left: SizeConfig.padding16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.padding8,
            bottom: SizeConfig.padding8,
          ),
          child: Column(
            children: [
              Text(
                upperText1,
                style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
              ),
              const Spacer(),
              Text(lowerText1,
                  style: TextStyles.rajdhani.body4.colour(Colors.white))
            ],
          ),
        ),
        Spacer(),
        const VerticalDivider(
          color: UiConstants.grey2,
          thickness: 1,
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.padding8,
            bottom: SizeConfig.padding8,
          ),
          child: Column(
            children: [
              Text(
                upperText2,
                style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
              ),
              const Spacer(),
              Text(lowerText2,
                  style: TextStyles.rajdhani.body4.colour(Colors.white))
            ],
          ),
        ),
        Spacer(),
        const VerticalDivider(
          color: UiConstants.grey2,
          thickness: 1,
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.padding8,
            bottom: SizeConfig.padding8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                upperText3,
                style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
              ),
              const Spacer(),
              Text(lowerText3,
                  style: TextStyles.rajdhani.body4.colour(Colors.white))
            ],
          ),
        ),
      ]),
    );
  }
}
