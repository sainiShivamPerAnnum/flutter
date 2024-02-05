import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/core/model/sip_model/select_asset_options.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectSipScreen extends StatefulWidget {
  const SelectSipScreen({super.key});

  @override
  State<SelectSipScreen> createState() => _SelectSipScreenState();
}

class _SelectSipScreenState extends State<SelectSipScreen> {
  final List<String> images = [
    'assets/svg/iphone.svg',
    'assets/svg/car.svg',
    'assets/svg/trip.svg',
  ];

  final List<String> titles = [
    'SIP for an Iphone',
    'SIP For a Car',
    'SIP for a trip',
  ];
  final List<String> subTitle = [
    'With a daily SIP you can save for an Iphone in a year',
    'With a monthly SIP You can save enough for a Car in a year',
    'With a weekly SIP You can save enough for a Goa trip in a year',
  ];

  @override
  Widget build(BuildContext context) {
    final sipmodel = context.watch<AutosaveCubit>();
    var assets = sipmodel.state.sipScreenData?.selectAssetScreen?.options;
    var assetsLength = assets?.length ?? 0;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.padding24,
              top: SizeConfig.padding24,
              right: SizeConfig.padding24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Asset",
                style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
              ),
              SizedBox(
                height: SizeConfig.padding30,
              ),
              Column(
                children: [
                  for (int i = 0; i < assetsLength; i++) ...[
                    AssetBlock(
                      option: assets![i],
                      index: i,
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                  ]
                ],
              ),
              //
            ],
          ),
        ),
        const Spacer(),
        DecoratedBox(
          decoration:
              BoxDecoration(color: UiConstants.kTextColor4.withOpacity(0.5)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 20, right: 43),
                child: SizedBox(
                  height: SizeConfig.padding104,
                  width: SizeConfig.screenHeight,
                  child: CarouselSlider.builder(
                    itemCount: 3,
                    itemBuilder: (context, index, realIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: SizeConfig.padding176,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  titles[index],
                                  style: TextStyles.rajdhaniB.body2
                                      .colour(UiConstants.kTextColor),
                                ),
                                SizedBox(
                                  height: SizeConfig.padding8,
                                ),
                                Text(
                                  subTitle[index],
                                  style: TextStyles.sourceSans.body4
                                      .colour(UiConstants.kTextColor),
                                ),
                              ],
                            ),
                          ),
                          AppImage(
                            images[index],
                            height: SizeConfig.padding100,
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1,
                      scrollPhysics: const AlwaysScrollableScrollPhysics(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.padding24),
                child: Opacity(
                  opacity: sipmodel.state.selectedAsset != -1 ? 1 : 0.5,
                  child: SecondaryButton(
                      onPressed: sipmodel.state.selectedAsset != -1
                          ? () {
                              sipmodel.pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            }
                          : () {},
                      label: "3 CLICKS AWAY"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class AssetBlock extends StatefulWidget {
  const AssetBlock({required this.option, required this.index, super.key});
  final AssetOptions option;
  final int index;

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
      setState(() {});
    });
    final model = context.read<AutosaveCubit>();
    if (model.state.selectedAsset == widget.index) {
      _controller.forward(from: 0.0);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final model = context.read<AutosaveCubit>();
        model.changeSelectedAsset(widget.index);
      },
      child: BlocListener<AutosaveCubit, AutosaveCubitState>(
        listener: (context, state) {
          if (state.selectedAsset == widget.index) {
            _controller.forward(from: 0.0);
          } else if (_controller.value == 1.0) {
            _controller.reverse(from: 1.0);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: UiConstants.teal3.withOpacity(_controller.value)),
              color: UiConstants.kArrowButtonBackgroundColor,
              borderRadius: BorderRadius.circular(SizeConfig.roundness8)),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding16,
            vertical: SizeConfig.padding16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImage(
                widget.option.imageUrl!,
                width: SizeConfig.padding44,
                height: SizeConfig.padding40,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                width: SizeConfig.padding18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.option.title!,
                    style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
                  ),
                  Text(
                    widget.option.subText!,
                    style: TextStyles.sourceSans.body3,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
