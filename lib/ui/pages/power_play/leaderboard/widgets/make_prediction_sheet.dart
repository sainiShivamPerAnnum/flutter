import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/pop_up_menu_route.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Type of available asset at time of investment through fello power play.
enum AssetType {
  gold(
    assetPath: Assets.goldWithoutShadow,
    label: "Digital Gold",
  );

  const AssetType({
    required this.assetPath,
    required this.label,
  });

  final String assetPath;
  final String label;
  bool get isGold => this == AssetType.gold;
}

class MakePredictionSheet extends StatefulWidget {
  final MatchData matchData;

  const MakePredictionSheet({
    required this.matchData,
    super.key,
  });

  @override
  State<MakePredictionSheet> createState() => _MakePredictionSheetState();
}

class _MakePredictionSheetState extends State<MakePredictionSheet> {
  late TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<AssetType> _assetType = ValueNotifier(
    AssetType.gold,
  );

  final ValueNotifier<bool> _showFormValidationError = ValueNotifier<bool>(
    false,
  );

  final FocusNode _predictionNode = FocusNode();

  final _isOldUser = locator<UserService>().userSegments.contains(
        Constants.US_FLO_OLD,
      );

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    PowerPlayService.powerPlayDepositFlow = false;
  }

  @override
  void dispose() {
    _textController.dispose();
    _assetType.dispose();
    _showFormValidationError.dispose();
    _predictionNode.dispose();
    super.dispose();
  }

  /// Pops up the current modal sheet and redirect user to relative asset page
  /// based on the available and selected asset.
  void _onTapPredict() {
    if (_validateValue(_textController.text, _assetType.value) != null) {
      _showFormValidationError.value = true;
      return;
    }
    _showFormValidationError.value = false;

    PowerPlayService.powerPlayDepositFlow = true;
    AppState.backButtonDispatcher!.didPopRoute();

    _openAssetPage(
      _assetType.value,
      int.tryParse(_textController.text),
    );

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.iplPredictNowBottomSheetButtonTapped,
      properties: {
        "runs": _textController.text,
        "matchId": widget.matchData.id
      },
    );
  }

  /// Redirects user to relative asset investment page based on the [assetType].
  void _openAssetPage(AssetType assetType, int? amount) {
    switch (assetType) {
      case AssetType.gold:
        BaseUtil().openRechargeModalSheet(
          investmentType: InvestmentType.AUGGOLD99,
          amt: amount,
          isSkipMl: false,
          entryPoint: 'power-play',
        );
        break;
    }
  }

  /// Shows a popup for asset selection.
  Future<void> _onTapSelect() async {
    final scope = FocusScope.of(context);
    scope.focusedChild?.unfocus();

    final result = await showPopUp<AssetType>(context, (context) {
      return Positioned(
        bottom: 16,
        left: 20,
        child: InvestOptionContextMenu(
          currentAsset: _assetType.value,
          availableAssets: const [
            AssetType.gold,
          ],
        ),
      );
    });

    if (result != null) {
      _assetType.value = result;
    }

    scope.requestFocus(_predictionNode);
  }

  /// Validates the input value.
  String? _validateValue(String value, AssetType assetType) {
    if (value.isEmpty) {
      return 'Please enter prediction';
    }

    final runs = int.tryParse(value);

    if (runs == null) {
      return 'Invalid input';
    }

    if (assetType.isGold && runs <= 9) {
      return 'Please enter a prediction of more than 10 runs';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.pageHorizontalMargins,
          right: SizeConfig.pageHorizontalMargins,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            height: 2,
            width: 100,
            color: Colors.white,
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Text(
            "Make your Prediction",
            style: TextStyles.sourceSansSB.body1.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Text(
            "Enter a Prediction for this Match",
            style: TextStyles.sourceSans.body3.colour(Colors.white),
          ),

          SizedBox(
            height: SizeConfig.padding28,
          ),
          Container(
            // height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.3),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                    child: IplTeamsScoreWidget(
                      matchData: widget.matchData,
                    )),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Your Prediction
          Text(
            "Your Prediction",
            style: TextStyles.sourceSansSB.body0.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x80D9D9D9),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            keyboardType: TextInputType.number,
                            controller: _textController,
                            focusNode: _predictionNode,
                            autofocus: true,
                            style: TextStyles.sourceSansB.title5.copyWith(
                              height: 1.1,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 18,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: 'Enter your prediction',
                              hintStyle: TextStyles.sourceSansB.body1.copyWith(
                                height: .8,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xffD9D9D9).withOpacity(.5),
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(5),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Runs',
                            style: TextStyles.sourceSansSB.body3.copyWith(
                              color: const Color(0xff414145),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _showFormValidationError,
                  builder: (context, value, child) {
                    final text =
                        _validateValue(_textController.text, _assetType.value);
                    if (text != null && value) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          text,
                          style: TextStyles.sourceSans.body3.colour(Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          SizedBox(
            height: SizeConfig.padding40,
          ),

          Row(
            children: [
              ListenableBuilder(
                listenable: _assetType,
                builder: (context, child) => AssetSelectionButton(
                  assetType: _assetType.value,
                  onSelect: _onTapSelect,
                ),
              ),
              const SizedBox(
                width: 21,
              ),
              Expanded(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  onPressed: _onTapPredict,
                  child: Center(
                    child: Text(
                      'PREDICT NOW',
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
        ],
      ),
    );
  }
}

class AssetSelectionButton extends StatelessWidget {
  final VoidCallback onSelect;
  final AssetType assetType;

  const AssetSelectionButton({
    required this.onSelect,
    required this.assetType,
    super.key,
  });

  Widget _buildFooter(AssetType assetType) {
    return Row(
      children: [
        SvgPicture.asset(
          assetType.assetPath,
          height: 30,
          width: 30,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          assetType.label,
          style: TextStyles.sourceSansSB.body2.copyWith(
            height: 1.5,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Save In Asset',
                style: TextStyles.sourceSans.body3.colour(
                  UiConstants.kModalSheetMutedTextBackgroundColor,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Transform.rotate(
                angle: math.pi,
                child: SvgPicture.asset(
                  Assets.arrow,
                  height: 8,
                  color: UiConstants.kModalSheetMutedTextBackgroundColor,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          _buildFooter(assetType),
        ],
      ),
    );
  }
}

class InvestOptionContextMenu extends StatefulWidget {
  const InvestOptionContextMenu({
    required this.availableAssets,
    required this.currentAsset,
    super.key,
  });

  final List<AssetType> availableAssets;
  final AssetType currentAsset;

  @override
  State<InvestOptionContextMenu> createState() =>
      _InvestOptionContextMenuState();
}

class _InvestOptionContextMenuState extends State<InvestOptionContextMenu> {
  late final ValueNotifier<AssetType> _assetTypeNotifier;

  @override
  void initState() {
    super.initState();
    _assetTypeNotifier = ValueNotifier(widget.currentAsset);
  }

  /// Sets [assetType] as currently selected asset and pops the page with
  /// [assetType] as result.
  void _onSelected(AssetType assetType) {
    _assetTypeNotifier.value = assetType;
    Navigator.pop(context, _assetTypeNotifier.value);
  }

  Widget _buildFooter(AssetType assetType) {
    return Row(
      children: [
        SvgPicture.asset(
          assetType.assetPath,
          height: 30,
          width: 30,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          assetType.label,
          style: TextStyles.sourceSansSB.body2.copyWith(
            height: 1.5,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _assetTypeNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assets = widget.availableAssets;
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff3D3D3D),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          children: [
            IntrinsicWidth(
              child: ListenableBuilder(
                listenable: _assetTypeNotifier,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < assets.length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: i != assets.length - 1 ? 10 : 0,
                          ),
                          child: _AssetOptionRadio(
                            selectedAssetType: _assetTypeNotifier.value,
                            assetType: assets[i],
                            onSelected: _onSelected,
                          ),
                        ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(
                        thickness: .5,
                        color: Colors.white,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Row(
                    children: [
                      Text(
                        'Save In Asset',
                        style: TextStyles.sourceSans.body3.copyWith(
                          color:
                              UiConstants.kModalSheetMutedTextBackgroundColor,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SvgPicture.asset(
                        Assets.arrow,
                        height: 6,
                        color: UiConstants.kModalSheetMutedTextBackgroundColor,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                ListenableBuilder(
                  listenable: _assetTypeNotifier,
                  builder: (context, child) {
                    return _buildFooter(_assetTypeNotifier.value);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _AssetOptionRadio extends StatelessWidget {
  const _AssetOptionRadio({
    required this.assetType,
    required this.onSelected,
    required this.selectedAssetType,
  });

  final AssetType assetType;
  final AssetType selectedAssetType;
  final ValueChanged<AssetType> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = assetType == selectedAssetType;
    return InkWell(
      onTap: () => onSelected(assetType),
      child: Row(
        children: [
          _RadioButton(isSelected),
          const SizedBox(
            width: 8,
          ),
          SvgPicture.asset(
            assetType.assetPath,
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
            assetType.label,
            style: TextStyles.sourceSansSB.body2.copyWith(
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioButton extends StatelessWidget {
  const _RadioButton(this.isSelected);
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    const baseDecoration = BoxDecoration(
      shape: BoxShape.circle,
    );

    const backgroundColor = UiConstants.kBackgroundColor;

    final childContainer = Container(
      padding: const EdgeInsets.all(4.5),
      decoration: baseDecoration.copyWith(
        color: UiConstants.kTabBorderColor,
      ),
      child: Container(
        height: 5,
        width: 5,
        decoration: baseDecoration.copyWith(
          color: backgroundColor,
        ),
      ),
    );

    return Container(
      height: 27,
      width: 27,
      padding: const EdgeInsets.all(5),
      decoration: baseDecoration.copyWith(
        color: backgroundColor,
        border: Border.all(
          width: 1.4,
          color: UiConstants.kFAQDividerColor,
        ),
      ),
      child: isSelected ? childContainer : null,
    );
  }
}
