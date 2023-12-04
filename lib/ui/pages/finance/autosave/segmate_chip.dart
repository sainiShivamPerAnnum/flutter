import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SegmentChips extends StatelessWidget {
  final FREQUENCY frequency;
  final AutosaveProcessViewModel model;

  const SegmentChips({required this.frequency, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Haptic.vibrate();
        FocusScope.of(context).unfocus();
        model.selectedFrequency = frequency;
      },
      child: Container(
        width: SizeConfig.screenWidth! * 0.24,
        decoration: BoxDecoration(
            color: model.selectedFrequency != frequency
                ? UiConstants.kBackgroundColor3
                : Colors.transparent,
            borderRadius: frequency == FREQUENCY.daily
                ? BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness5),
                    bottomLeft: Radius.circular(SizeConfig.roundness5),
                  )
                : frequency == FREQUENCY.monthly
                    ? BorderRadius.only(
                        topRight: Radius.circular(SizeConfig.roundness5),
                        bottomRight: Radius.circular(SizeConfig.roundness5),
                      )
                    : BorderRadius.zero),
        alignment: Alignment.center,
        child: Text(
          frequency.name.toCamelCase(),
          style: TextStyles.body3.bold.colour(
            getColor(),
          ),
        ),
      ),
    );
  }

  Color getColor() =>
      frequency == model.selectedFrequency ? Colors.black : Colors.grey;
}

extension Cases on String? {
  String toCamelCase() {
    if (this == null) {
      return "";
    } else {
      return (this!.split('').first.toUpperCase() +
          this!.split('').toList().sublist(1).join('').toLowerCase());
    }
  }
}
