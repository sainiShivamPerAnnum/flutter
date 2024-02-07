// import 'package:felloapp/ui/elements/page_views/height_adaptive_pageview.dart';
// import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
// import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_setup_components/chips.dart';
// import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_setup_components/combos.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:flutter/material.dart';

// class ChipsAndCombos extends StatelessWidget {
//   const ChipsAndCombos({
//     required this.model,
//     super.key,
//   });

//   final AutosaveProcessViewModel model;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: const Duration(seconds: 1),
//       child: model.selectedAssetOption == 0
//           ? Container(
//               margin: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
//               child: HeightAdaptivePageView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 controller: model.comboController,
//                 children: [
//                   AutosaveComboGrid(model: model, frequency: FREQUENCY.daily),
//                   AutosaveComboGrid(model: model, frequency: FREQUENCY.weekly),
//                   AutosaveComboGrid(model: model, frequency: FREQUENCY.monthly),
//                 ],
//               ),
//             )
//           : SizedBox(
//               width: SizeConfig.screenWidth,
//               height: SizeConfig.padding70,
//               child: PageView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 controller: model.chipsController,
//                 children: [
//                   AutosaveSuggestionChipsRow(
//                       model: model, frequency: FREQUENCY.daily),
//                   AutosaveSuggestionChipsRow(
//                       model: model, frequency: FREQUENCY.weekly),
//                   AutosaveSuggestionChipsRow(
//                       model: model, frequency: FREQUENCY.monthly),
//                 ],
//               ),
//             ),
//     );
//   }
// }
