import 'package:felloapp/ui/pages/finance/autosave/autosave_process/autosave_process_vm.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
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
        model.selectedFrequency = frequency;
      },
      child: Container(
        width: SizeConfig.screenWidth! * 0.24,
        alignment: Alignment.center,
        child: Text(
          frequency.name,
          style: TextStyles.body3.bold.colour(
            getColor(),
          ),
        ),
      ),
    );
  }

  Color getColor() =>
      frequency == model.selectedFrequency ? Colors.white : Colors.grey;
}
