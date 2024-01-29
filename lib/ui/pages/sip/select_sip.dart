import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/sip/sip_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectSipScreen extends StatefulWidget {
  const SelectSipScreen({super.key});

  @override
  State<SelectSipScreen> createState() => _SelectSipScreenState();
}

class _SelectSipScreenState extends State<SelectSipScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<SipViewModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(
              Assets.normalChevronLeftArrow,
            ),
            onPressed: () {},
          ),
          title: Text(
            "Sip With Fello",
            style: TextStyles.rajdhaniSB.title4.colour(Colors.white),
          ),
          centerTitle: true,
          backgroundColor: UiConstants.kBackgroundColor,
          elevation: 0,
        ),
        backgroundColor: UiConstants.kBackgroundColor,
        body: Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.padding24, top: SizeConfig.padding40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Asset",
                style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Row(
                children: [
                  AssetBlock(
                    asset: AssetType.FELLOP2P,
                    model: model,
                  ),
                  SizedBox(
                    width: SizeConfig.padding16,
                  ),
                  AssetBlock(
                    asset: AssetType.AUGMONT_GOLD,
                    model: model,
                  )
                ],
              ),
              const Spacer(),
              Opacity(
                  opacity: model.selectedType != null ? 1 : 0.5,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.padding24),
                    child: SecondaryButton(
                        onPressed: () {}, label: "3 CLICKS AWAY"),
                  ))
            ],
          ),
        ),
      );
    });
  }
}

class AssetBlock extends StatefulWidget {
  const AssetBlock({super.key, required this.asset, required this.model});
  final AssetType asset;
  final SipViewModel model;

  @override
  State<AssetBlock> createState() => _AssetBlockState();
}

class _AssetBlockState extends State<AssetBlock> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _controller.addListener(() {
      print("object");
      setState(() {});
    });
    widget.model.addListener(() {
      if (widget.model.selectedType == widget.asset) {
        _controller.forward(from: 0.0);
      } else if (_controller.value == 1.0) {
        _controller.reverse(from: 1.0);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.model.changeSelectedAsset(widget.asset);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: UiConstants.teal3.withOpacity(_controller.value)),
            color: UiConstants.kArrowButtonBackgroundColor,
            borderRadius: BorderRadius.circular(SizeConfig.roundness8)),
        padding: EdgeInsets.only(
            left: SizeConfig.padding16,
            right: SizeConfig.padding16,
            top: SizeConfig.padding16,
            bottom: SizeConfig.padding18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              widget.asset == AssetType.FELLOP2P
                  ? Assets.floWithoutShadow
                  : Assets.goldWithoutShadow,
              height: SizeConfig.padding42,
            ),
            SizedBox(
              height: SizeConfig.padding8,
            ),
            Text(
              widget.asset == AssetType.FELLOP2P
                  ? "SIP with Fello P2P"
                  : "SIP in Digital Gold",
              style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
            ),
            Text(
              widget.asset == AssetType.FELLOP2P
                  ? "10% Consistent Returns"
                  : "@Market Rate",
              style: TextStyles.sourceSans.body3,
            )
          ],
        ),
      ),
    );
  }
}
