import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/finance/autosave/segmate_chip.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AutosaveFrequencyBar extends StatelessWidget {
  const AutosaveFrequencyBar({
    required this.model,
    super.key,
  });

  final AutosaveProcessViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kBackgroundColor3,
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        border: Border.all(
          color: UiConstants.kBorderColor.withOpacity(0.22),
          width: SizeConfig.border1,
        ),
      ),
      width: SizeConfig.screenWidth! * 0.7248,
      height: SizeConfig.screenWidth! * 0.0987,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate,
            left: model.selectedFrequency == FREQUENCY.daily
                ? 0
                : model.selectedFrequency == FREQUENCY.weekly
                    ? SizeConfig.screenWidth! * 0.24
                    : SizeConfig.screenWidth! * 0.48,
            child: AnimatedContainer(
              width: SizeConfig.screenWidth! * 0.24,
              height: SizeConfig.screenWidth! * 0.094,
              decoration: BoxDecoration(
                color: UiConstants.kAutopayAmountActiveTabColor,
                borderRadius: model.selectedFrequency == FREQUENCY.daily
                    ? BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.roundness5),
                        bottomLeft: Radius.circular(SizeConfig.roundness5),
                      )
                    : model.selectedFrequency == FREQUENCY.weekly
                        ? BorderRadius.zero
                        : BorderRadius.only(
                            topRight: Radius.circular(SizeConfig.roundness5),
                            bottomRight: Radius.circular(SizeConfig.roundness5),
                          ),
              ),
              duration: const Duration(milliseconds: 500),
            ),
          ),
          Row(
            children: [
              SegmentChips(
                frequency: FREQUENCY.daily,
                model: model,
              ),
              SegmentChips(
                frequency: FREQUENCY.weekly,
                model: model,
              ),
              SegmentChips(
                frequency: FREQUENCY.monthly,
                model: model,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
