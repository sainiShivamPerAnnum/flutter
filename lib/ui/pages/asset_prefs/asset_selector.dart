import 'package:felloapp/base_util.dart';
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
              (widget.assetPrefOptions != AssetPrefOptions.NO_PREF)
                  ? Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Transform.translate(
                            offset: Offset(
                                0, _controller.value * SizeConfig.padding44),
                            child: LearnMoreSlider(
                              assetPrefOption: widget.assetPrefOptions,
                              offsetValue: _controller.value,
                            ),
                          ),
                          AssetCard(
                            opacity: _controller.value,
                            assetPrefOption: widget.assetPrefOptions,
                          ),
                        ],
                      ),
                    )
                  : NoPrefButton(
                      opacity: _controller.value,
                      assetPrefOption: widget.assetPrefOptions)
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
  LearnMoreSlider(
      {Key? key, required this.assetPrefOption, required this.offsetValue})
      : super(key: key);
  AssetPrefOptions assetPrefOption;
  double offsetValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
            ? UiConstants.teal5
            : UiConstants.goldSellCardColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.padding16,
            right: SizeConfig.padding16,
            bottom: SizeConfig.padding12,
            top: SizeConfig.padding22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getStatsText(assetPrefOption),
            SizedBox(
              width: SizeConfig.padding26,
            ),
            GestureDetector(
              onTap: () {
                print("object");
                BaseUtil.openModalBottomSheet(
                  isBarrierDismissible: true,
                  addToScreenStack: true,
                );
              },
              child: Text(
                "LEARN MORE",
                style: TextStyles.rajdhaniB.body2.colour(Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoPrefButton extends StatelessWidget {
  NoPrefButton(
      {super.key, required this.opacity, required this.assetPrefOption});
  double opacity;
  AssetPrefOptions assetPrefOption;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: Colors.white.withOpacity(opacity), width: 1.5),
          color: UiConstants.kTambolaMidTextColor,
        ),
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding12, horizontal: SizeConfig.padding104),
        child: Text(
          "I'm not sure",
          style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
        ));
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
      padding: EdgeInsets.only(
          left: SizeConfig.padding4,
          right: SizeConfig.padding4,
          bottom: SizeConfig.padding4,
          top: SizeConfig.padding12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                    ? a.Assets.floAsset
                    : a.Assets.digitalGold,
                height: SizeConfig.padding30,
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
            child: getDescriptionText(assetPrefOption),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: SizeConfig.padding4,
                left: SizeConfig.padding4,
                right: SizeConfig.padding4,
                top: SizeConfig.padding20),
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: bgColor),
      padding: EdgeInsets.only(
          top: SizeConfig.padding8,
          bottom: SizeConfig.padding8,
          right: SizeConfig.padding16,
          left: SizeConfig.padding16),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.padding4,
                bottom: SizeConfig.padding4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    upperText1,
                    style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
                  ),
                  Text(lowerText1,
                      style: TextStyles.rajdhani.body4.colour(Colors.white))
                ],
              ),
            ),
            const VerticalDivider(
              color: Colors.white,
              thickness: 2,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.padding4,
                bottom: SizeConfig.padding4,
              ),
              child: Column(
                children: [
                  Text(
                    upperText2,
                    style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
                  ),
                  Text(lowerText2,
                      style: TextStyles.rajdhani.body4.colour(Colors.white))
                ],
              ),
            ),
            const VerticalDivider(
              color: Colors.white,
              thickness: 2,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.padding4,
                bottom: SizeConfig.padding4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    upperText3,
                    style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
                  ),
                  Text(lowerText3,
                      style: TextStyles.rajdhani.body4.colour(Colors.white))
                ],
              ),
            ),
          ]),
    );
  }
}

Widget getStatsText(AssetPrefOptions assetPrefOptions) {
  return (assetPrefOptions == AssetPrefOptions.LENDBOX_P2P)
      ? RichText(
          text: TextSpan(
              text: "₹12Cr+ invested",
              style: TextStyles.sourceSansB.body4.colour(UiConstants.teal3),
              children: [
              TextSpan(
                  text: " on Fello P2P",
                  style: TextStyles.sourceSans.body4.colour(Colors.white))
            ]))
      : RichText(
          text: TextSpan(
              text: "Trusted by",
              style: TextStyles.sourceSans.body4.colour(Colors.white),
              children: [
              TextSpan(
                  text: " 1Lac+",
                  style: TextStyles.sourceSansB.body4
                      .colour(UiConstants.kBlogTitleColor)),
              TextSpan(
                  text: " Fello Investors",
                  style: TextStyles.sourceSans.body4.colour(Colors.white))
            ]));
}

Widget getDescriptionText(AssetPrefOptions assetPrefOptions) {
  return (assetPrefOptions == AssetPrefOptions.LENDBOX_P2P)
      ? RichText(
          text: TextSpan(
              text: "A P2P lending asset powered by",
              style: TextStyles.sourceSans.body3.colour(Colors.white),
              children: [
                TextSpan(
                    text: " Lendbox",
                    style: TextStyles.sourceSansB.body3.colour(Colors.white)),
                TextSpan(
                    text: " with 8%, 10% & 12% returns plans",
                    style: TextStyles.sourceSans.body3.colour(Colors.white))
              ]),
          textAlign: TextAlign.center,
        )
      : RichText(
          text: TextSpan(
              text: "Invest in trusted gold at market rates, powered by",
              style: TextStyles.sourceSans.body3.colour(Colors.white),
              children: [
                TextSpan(
                    text: " Augmont",
                    style: TextStyles.sourceSansB.body3.colour(Colors.white)),
                TextSpan(
                    text: " and get stable returns",
                    style: TextStyles.sourceSans.body3.colour(Colors.white))
              ]),
          textAlign: TextAlign.center,
        );
}
