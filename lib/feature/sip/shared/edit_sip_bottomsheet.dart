import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/shared/interest_calculator.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditSipBottomSheet extends StatefulWidget {
  const EditSipBottomSheet({
    required this.state,
    required this.index,
    required this.allowEdit,
    required this.frequency,
    required this.amount,
    required this.assetType,
    required this.model,
    super.key,
  });
  final AutosaveState state;
  final int index;
  final bool allowEdit;
  final num amount;
  final String frequency;
  final SIPAssetTypes assetType;
  final SipCubit model;
  @override
  State<EditSipBottomSheet> createState() => _EditSipBottomSheetState();
}

class _EditSipBottomSheetState extends State<EditSipBottomSheet> {
  bool _isLoading = false;
  final locale = locator<S>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.padding24,
        right: SizeConfig.padding24,
      ),
      child: _isLoading
          ? SizedBox(
              height: SizeConfig.padding100,
              child: const Center(
                  child: CupertinoActivityIndicator(
                color: UiConstants.kTextColor,
              )))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: SizeConfig.padding14,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            UiConstants.kProfileBorderColor.withOpacity(0.4)),
                    height: 5,
                    width: 94,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding22,
                ),
                Text(
                  locale.editSipOptions,
                  style: TextStyles.sourceSansSB.body1
                      .colour(UiConstants.kTextColor),
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                Divider(
                  thickness: 1,
                  color: UiConstants.kProfileBorderColor.withOpacity(0.2),
                ),
                if (widget.allowEdit)
                  InkWell(
                    onTap: () async {
                      _analyticsService.track(
                          eventName: AnalyticsEvents.editSipOption,
                          properties: {
                            "Option Selected": "Edit SIP",
                          });
                      return widget.model.editSip(widget.amount,
                          widget.frequency, widget.index, widget.assetType);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                        Row(
                          children: [
                            const AppImage(Assets.editIcon),
                            SizedBox(
                              width: SizeConfig.padding12,
                            ),
                            Text(
                              locale.editSipbtn,
                              style: TextStyles.sourceSansSB.body2
                                  .colour(Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                      ],
                    ),
                  ),
                if (widget.allowEdit)
                  Divider(
                    thickness: 1,
                    color: UiConstants.kProfileBorderColor.withOpacity(0.2),
                  ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    _analyticsService.track(
                        eventName: AnalyticsEvents.editSipOption,
                        properties: {
                          "Option Selected": widget.state.isPaused
                              ? "Resume SIP"
                              : "Pause SIP",
                        });
                    widget.state.isPaused
                        ? await widget.model.resume(widget.index)
                        : await widget.model.pause(widget.index);
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: Column(children: [
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Row(
                      children: [
                        const AppImage(Assets.pauseIcon),
                        SizedBox(
                          width: SizeConfig.padding12,
                        ),
                        Text(
                          widget.state.isPaused
                              ? locale.resumeSipbtn
                              : locale.pauseSipbtn,
                          style: TextStyles.sourceSansSB.body2
                              .colour(Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                  ]),
                ),
                Divider(
                  thickness: 1,
                  color: UiConstants.kProfileBorderColor.withOpacity(0.2),
                ),
                if (widget.allowEdit)
                  Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.padding6,
                      top: SizeConfig.padding22,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: SizeConfig.padding4,
                          width: SizeConfig.padding4,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: UiConstants.teal3),
                        ),
                        SizedBox(
                          width: SizeConfig.padding6,
                        ),
                        Text(
                            locale.sipReturn(SipCalculation.getReturn(
                              formAmount: widget.amount.toInt(),
                              currentAsset: widget.assetType,
                              interestOnly: true,
                              frequency: widget.frequency,
                            )),
                            style: TextStyles.sourceSansSB.body3.colour(
                                UiConstants
                                    .kModalSheetMutedTextBackgroundColor))
                      ],
                    ),
                  ),
                SizedBox(
                  height: SizeConfig.padding28,
                )
              ],
            ),
    );
  }
}
