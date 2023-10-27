import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/ui/pages/finance/autosave/amount_chips.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:flutter/material.dart';

class AutosaveSuggestionChipsRow extends StatelessWidget {
  const AutosaveSuggestionChipsRow({
    required this.model,
    required this.frequency,
    super.key,
  });

  final AutosaveProcessViewModel model;
  final FREQUENCY frequency;

  @override
  Widget build(BuildContext context) {
    List<AmountChipsModel> chipsData = model.getChips(frequency);
    print(chipsData.map((e) => e.toString()).toList());
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          model.getChipsLength(),
          (index) => AmountChips(
            isSelected: ((model.selectedAssetOption == 1 &&
                    int.tryParse(model.floAmountFieldController!.text) ==
                        chipsData[index].value) ||
                (model.selectedAssetOption == 2 &&
                    int.tryParse(model.goldAmountFieldController!.text) ==
                        chipsData[index].value)),
            amount: chipsData[index].value,
            onTap: () {
              FocusScope.of(context).unfocus();
              model.onChipTapped(chipsData[index].value!, index);
            },
            isBestSeller: chipsData[index].best,
          ),
        ));
  }
}
