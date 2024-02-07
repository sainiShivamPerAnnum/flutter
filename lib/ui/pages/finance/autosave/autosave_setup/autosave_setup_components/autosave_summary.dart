// import 'package:felloapp/core/service/notifier_services/user_service.dart';
// import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
// import 'package:felloapp/util/assets.dart';
// import 'package:felloapp/util/constants.dart';
// import 'package:felloapp/util/extensions/string_extension.dart';
// import 'package:felloapp/util/locator.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:flutter/material.dart';

// class AutosaveSummary extends StatelessWidget {
//   const AutosaveSummary({
//     required this.model,
//     super.key,
//     this.showTopDivider = true,
//     this.showTitle = true,
//   });

//   final AutosaveProcessViewModel model;
//   final bool showTopDivider, showTitle;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (showTopDivider)
//           Divider(
//             height: SizeConfig.padding12,
//             color: Colors.white24,
//           ),
//         if (showTitle)
//           Column(
//             children: [
//               Text("Autosave Summary", style: TextStyles.rajdhaniSB.title3),
//               SizedBox(height: SizeConfig.padding16),
//             ],
//           ),
//         if (model.goldAmountFieldController!.text.isNotEmpty &&
//             int.tryParse(model.goldAmountFieldController!.text) != 0)
//           ListTile(
//             leading: Image.asset(
//               Assets.digitalGoldBar,
//               width: SizeConfig.padding44,
//             ),
//             title: Text(
//               "Digital Gold",
//               style: TextStyles.sourceSans.body1,
//             ),
//             trailing: Text(
//               "₹${model.goldAmountFieldController!.text}",
//               style: TextStyles.sourceSansB.body1,
//             ),
//           ),
//         if (model.floAmountFieldController!.text.isNotEmpty &&
//             int.tryParse(model.floAmountFieldController!.text) != 0)
//           ListTile(
//             leading: Image.asset(
//               Assets.felloFlo,
//               width: SizeConfig.padding44,
//             ),
//             title: Text(
//               "Fello Flo ${locator<UserService>().userSegments.contains(Constants.US_FLO_OLD) ? '10%' : '8%'}",
//               style: TextStyles.sourceSans.body1,
//             ),
//             trailing: Text(
//               "₹${model.floAmountFieldController!.text}",
//               style: TextStyles.sourceSansB.body1,
//             ),
//           ),
//         const Divider(
//           color: Colors.white24,
//         ),
//         ListTile(
//           // leading: SvgPicture.asset(
//           //   Assets.floGold,
//           //   width: SizeConfig.padding44,
//           // ),
//           title: Text(
//             "Total Amount",
//             style: TextStyles.sourceSans.body1,
//           ),
//           trailing: Text(
//             "₹${model.totalInvestingAmount}/${model.selectedFrequency.rename()}",
//             style: TextStyles.sourceSansB.body1,
//           ),
//         ),
//       ],
//     );
//   }
// }
