import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/sip_model/select_asset_options.dart';
import 'package:felloapp/feature/sip/cubit/selectedAsset_cubit.dart';
import 'package:felloapp/feature/sip/cubit/sip_data_holder.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_amount_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SipAssetSelectView extends StatelessWidget {
  const SipAssetSelectView({
    required this.isMandateAvailable,
    super.key,
  });
  final bool isMandateAvailable;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectAssetCubit(),
      child: SipAsssetSelect(isMandateAvailable: isMandateAvailable),
    );
  }
}

class SipAsssetSelect extends StatefulWidget {
  const SipAsssetSelect({
    required this.isMandateAvailable,
    super.key,
  });
  final bool isMandateAvailable;

  @override
  State<SipAsssetSelect> createState() => _SipAsssetSelectState();
}

class _SipAsssetSelectState extends State<SipAsssetSelect> {
  final locale = locator<S>();
  final List<String> images = [
    Assets.iphone,
    Assets.car,
    Assets.trip,
  ];
  List<String> titles = [];
  List<String> subTitle = [];

  @override
  void initState() {
    titles = [locale.SipIphoneTitle, locale.SipCarTitle, locale.SipTripTitle];
    subTitle = [locale.sipForIphone, locale.sipForCar, locale.sipForTrip];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var assets = SipDataHolder.instance.data.selectAssetScreen.options;

    var assetsLength = assets.length;
    final selectedAssetModel = context.watch<SelectAssetCubit>();
    final isBtnActive = selectedAssetModel.state.selectedAsset != null;
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async =>
              await AppState.backButtonDispatcher!.didPopRoute(),
          icon: const Icon(
            Icons.chevron_left,
            size: 32,
          ),
        ),
        backgroundColor: UiConstants.bg,
        title: Text(locale.siptitle),
        titleTextStyle: TextStyles.rajdhaniSB.title4.setHeight(1.3),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
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
                  locale.selectAsset,
                  style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
                ),
                SizedBox(
                  height: SizeConfig.padding30,
                ),
                Column(
                  children: [
                    for (int i = 0; i < assetsLength; i++) ...[
                      AssetBlock(
                        option: assets[i],
                        asset: assets[i].type,
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
                  padding: EdgeInsets.only(
                      left: SizeConfig.padding32,
                      top: SizeConfig.padding20,
                      right: SizeConfig.padding44),
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
                    opacity: isBtnActive ? 1 : 0.5,
                    child: SecondaryButton(
                        onPressed: isBtnActive
                            ? () {
                                AppState.delegate!.appState.currentAction =
                                    PageAction(
                                  page: SipFormPageConfig,
                                  widget: SipFormAmountView(
                                    mandateAvailable: widget.isMandateAvailable,
                                    sipAssetType:
                                        selectedAssetModel.state.selectedAsset!,
                                  ),
                                  state: PageState.addWidget,
                                );
                              }
                            : () => null,
                        label: locale.threeClicksAway),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AssetBlock extends StatefulWidget {
  const AssetBlock({required this.option, required this.asset, super.key});
  final AssetOptions option;
  final SIPAssetTypes asset;

  @override
  State<AssetBlock> createState() => _AssetBlockState();
}

class _AssetBlockState extends State<AssetBlock> with TickerProviderStateMixin {
  late AnimationController _controller;
  final locale = locator<S>();

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    final model = context.read<SelectAssetCubit>();
    if (model.state.selectedAsset == widget.asset) {
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
        if (widget.asset != SIPAssetTypes.UNKNOWN) {
          final model = context.read<SelectAssetCubit>();
          model.setSelectedAsset(widget.asset);
        }
      },
      child: BlocListener<SelectAssetCubit, SelectAssetCubitState>(
        listener: (context, state) {
          if (state.selectedAsset == widget.asset) {
            _controller.forward(from: 0.0);
          } else if (_controller.value == 1.0) {
            _controller.reverse(from: 1.0);
          }
        },
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: UiConstants.teal3.withOpacity(_controller.value),
                    ),
                    color: UiConstants.kArrowButtonBackgroundColor,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding16,
                    vertical: SizeConfig.padding16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppImage(
                        widget.option.imageUrl,
                        width: SizeConfig.padding44,
                        height: SizeConfig.padding40,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(width: SizeConfig.padding18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.option.title,
                            style: TextStyles.rajdhaniSB.body1
                                .colour(Colors.white),
                          ),
                          Text(
                            widget.option.subText,
                            style: TextStyles.sourceSans.body3,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            if (widget.asset == SIPAssetTypes.UNKNOWN)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                      color: UiConstants.kTextColor4.withOpacity(0.6),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8)),
                  child: Center(
                      child: Text(
                    locale.comingSoon,
                    style: TextStyles.rajdhaniSB.body0
                        .colour(UiConstants.kTextColor),
                  )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
