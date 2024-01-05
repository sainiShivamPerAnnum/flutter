import 'package:felloapp/ui/pages/asset_prefs/asset_pref_vm.dart';
import 'package:felloapp/util/assets.dart' as a;
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetSelector extends StatefulWidget {
  const AssetSelector(
      {required this.assetPrefOptions,
      required this.model,
      required this.onSelect,
      super.key});
  final AssetPrefOptions assetPrefOptions;
  final AssetPreferenceViewModel model;
  final void Function(AssetPrefOptions) onSelect;

  @override
  State<AssetSelector> createState() => _AssetSelectorState();
}

class _AssetSelectorState extends State<AssetSelector>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    widget.model.addListener(() {
      if (widget.model.selectedAsset == widget.assetPrefOptions) {
        _controller.forward(from: 0.0);
      } else if (_controller.value == 1.0) {
        _controller.reverse(from: 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onSelect(widget.assetPrefOptions),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AssetRadioButton(controller: _controller),
              SizedBox(
                width: SizeConfig.padding16,
              ),
              switch (widget.assetPrefOptions) {
                AssetPrefOptions.NO_PREF => NoPrefButton(
                    controller: _controller,
                    assetPrefOption: widget.assetPrefOptions,
                  ),
                AssetPrefOptions.LENDBOX_P2P ||
                AssetPrefOptions.AUGMONT_GOLD =>
                  AssetRadioOption(
                    assetPrefOption: widget.assetPrefOptions,
                    controller: _controller,
                  )
              },
            ],
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
        ],
      ),
    );
  }
}

class AssetRadioButton extends StatefulWidget {
  const AssetRadioButton({
    required this.controller,
    super.key,
  });

  final AnimationController controller;

  @override
  State<AssetRadioButton> createState() => _AssetRadioButtonState();
}

class _AssetRadioButtonState extends State<AssetRadioButton> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.padding20),
      child: Container(
        width: SizeConfig.padding1 * 23,
        height: SizeConfig.padding1 * 23,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: UiConstants.grey2)),
        padding: EdgeInsets.all(SizeConfig.padding4),
        child: Opacity(
            opacity: widget.controller.value,
            child: Container(
              padding: EdgeInsets.all(SizeConfig.padding4),
              decoration: const BoxDecoration(
                  color: UiConstants.teal3, shape: BoxShape.circle),
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: UiConstants.kBackgroundColor),
              ),
            )),
      ),
    );
  }
}

class AssetRadioOption extends StatefulWidget {
  const AssetRadioOption({
    required this.assetPrefOption,
    required this.controller,
    super.key,
  });

  final AnimationController controller;
  final AssetPrefOptions assetPrefOption;

  @override
  State<AssetRadioOption> createState() => _AssetRadioOptionState();
}

class _AssetRadioOptionState extends State<AssetRadioOption> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          LearnMoreSlider(
            assetPrefOption: widget.assetPrefOption,
            offsetValue: widget.controller.value,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: widget.controller.value * SizeConfig.padding44),
            child: AssetCard(
              opacity: widget.controller.value,
              assetPrefOption: widget.assetPrefOption,
            ),
          )
        ],
      ),
    );
  }
}

class LearnMoreSlider extends StatelessWidget {
  const LearnMoreSlider(
      {required this.assetPrefOption, required this.offsetValue, super.key});
  final AssetPrefOptions assetPrefOption;
  final double offsetValue;
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
            InkWell(
              onTap: () {},
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

class NoPrefButton extends StatefulWidget {
  const NoPrefButton(
      {required this.controller, required this.assetPrefOption, super.key});
  final AnimationController controller;
  final AssetPrefOptions assetPrefOption;

  @override
  State<NoPrefButton> createState() => _NoPrefButtonState();
}

class _NoPrefButtonState extends State<NoPrefButton> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Colors.white.withOpacity(widget.controller.value),
                width: 1.5),
            color: UiConstants.kTambolaMidTextColor,
          ),
          padding: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
          child: Center(
            child: Text(
              locale.obAssetNoPrefButton,
              style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
            ),
          )),
    );
  }
}

class AssetCard extends StatelessWidget {
  const AssetCard(
      {required this.opacity, required this.assetPrefOption, super.key});
  final double opacity;
  final AssetPrefOptions assetPrefOption;

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
              benefits: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                  ? [
                      Benefit(title: "P2P", subtitle: "Asset"),
                      Benefit(title: "Upto 12%", subtitle: "Returns"),
                      Benefit(title: "KYC", subtitle: "Required")
                    ]
                  : [
                      Benefit(title: "24K", subtitle: "Gold"),
                      Benefit(
                          title: "Stable Returns", subtitle: "@Market Rate"),
                      Benefit(title: "No KYC", subtitle: "Required")
                    ],
              bgColor: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                  ? UiConstants.teal5
                  : UiConstants.goldSellCardColor,
              dividerColor: (assetPrefOption == AssetPrefOptions.LENDBOX_P2P)
                  ? UiConstants.greyDivider
                  : UiConstants.kBlogTitleColor,
            ),
          )
        ],
      ),
    );
  }
}

class DetailsRow extends StatelessWidget {
  const DetailsRow(
      {required this.benefits,
      required this.bgColor,
      required this.dividerColor,
      super.key});

  final Color bgColor;
  final Color dividerColor;
  final List<Benefit> benefits;

  CrossAxisAlignment? getColumnAlignment(int i) {
    switch (i) {
      case 0:
        return CrossAxisAlignment.start;
      case 1:
        return CrossAxisAlignment.center;
      case 2:
        return CrossAxisAlignment.end;
    }
    return null;
  }

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
            for (int i = 0; i < benefits.length; i++) ...[
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.padding4,
                  bottom: SizeConfig.padding4,
                ),
                child: Column(
                  crossAxisAlignment: getColumnAlignment(i)!,
                  children: [
                    Text(
                      benefits[i].title,
                      style: TextStyles.rajdhaniSB.body1
                          .colour(Colors.white)
                          .setOpacity(0.8),
                    ),
                    Text(benefits[i].subtitle,
                        style: TextStyles.rajdhani.body4
                            .colour(Colors.white)
                            .setOpacity(0.4))
                  ],
                ),
              ),
              if (i != 2)
                SizedBox(
                  height: SizeConfig.padding36,
                  child: VerticalDivider(
                    color: dividerColor,
                    thickness: 2,
                  ),
                )
            ],
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
              style: TextStyles.sourceSans.body3
                  .colour(Colors.white)
                  .setOpacity(0.6),
              children: [
                TextSpan(
                    text: " Lendbox",
                    style: TextStyles.sourceSansB.body3
                        .colour(Colors.white)
                        .setOpacity(0.6)),
                TextSpan(
                    text: " with 8%, 10% & 12% returns plans",
                    style: TextStyles.sourceSans.body3
                        .colour(Colors.white)
                        .setOpacity(0.6))
              ]),
          textAlign: TextAlign.center,
        )
      : RichText(
          text: TextSpan(
              text: "Invest in trusted gold at market rates, powered by",
              style: TextStyles.sourceSans.body3
                  .colour(Colors.white)
                  .setOpacity(0.6),
              children: [
                TextSpan(
                    text: " Augmont",
                    style: TextStyles.sourceSansB.body3
                        .colour(Colors.white)
                        .setOpacity(0.6)),
                TextSpan(
                    text: " and get stable returns",
                    style: TextStyles.sourceSans.body3
                        .colour(Colors.white)
                        .setOpacity(0.6))
              ]),
          textAlign: TextAlign.center,
        );
}
