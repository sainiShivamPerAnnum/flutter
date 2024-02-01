// import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CenterTextField extends StatefulWidget {
//   const CenterTextField({
//     required this.amountFieldController,
//     required this.onChanged,
//     required this.model,
//     super.key,
//   });

//   final TextEditingController amountFieldController;
//   final Function onChanged;
//   final AutosaveProcessViewModel model;

//   @override
//   State<CenterTextField> createState() => _CenterTextFieldState();
// }

// class _CenterTextFieldState extends State<CenterTextField> {
//   double? _fieldWidth;
//   bool readOnly = true;

//   double? get fieldWidth => _fieldWidth;

//   set fieldWidth(double? value) {
//     setState(() {
//       _fieldWidth = value;
//     });
//   }

//   enableField() {
//     if (readOnly) {
//       setState(() {
//         readOnly = false;
//       });
//     }
//   }

//   @override
//   initState() {
//     super.initState();
//     updateFieldWidth();
//     widget.amountFieldController.addListener(() {
//       updateFieldWidth();
//     });
//   }

//   updateFieldWidth() {
//     if (widget.amountFieldController.text.isEmpty) {
//       fieldWidth = SizeConfig.padding20;
//     } else {
//       fieldWidth = ((SizeConfig.screenWidth! * 0.07) *
//           widget.amountFieldController.text.length.toDouble());
//     }
//   }

//   @override
//   void dispose() {
//     widget.amountFieldController.removeListener(updateFieldWidth);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         enableField();
//         FocusScope.of(context).requestFocus();
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: SizeConfig.padding24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: SizeConfig.screenWidth! * 0.784,
//               margin: EdgeInsets.only(
//                 top: SizeConfig.padding24,
//               ),
//               decoration: BoxDecoration(
//                 color: UiConstants.kTextFieldColor,
//                 borderRadius: BorderRadius.circular(SizeConfig.roundness5),
//                 border: Border.all(
//                   color: UiConstants.kTextColor.withOpacity(0.1),
//                   width: SizeConfig.border1,
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "₹",
//                     style: TextStyles.rajdhaniB
//                         .size(SizeConfig.screenWidth! * 0.1067),
//                   ),
//                   Container(
//                     // color: Colors.red,
//                     width: fieldWidth,
//                     child: TextField(
//                       onTap: enableField,
//                       showCursor: true,
//                       maxLength: 5,
//                       autofocus: true,
//                       controller: widget.amountFieldController,
//                       keyboardType: TextInputType.number,
//                       readOnly: readOnly,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                       ],
//                       style: TextStyles.rajdhaniB
//                           .size(SizeConfig.screenWidth! * 0.1067),
//                       decoration: const InputDecoration(
//                         counterText: "",
//                         focusedBorder: InputBorder.none,
//                         border: InputBorder.none,
//                         enabledBorder: InputBorder.none,
//                         // isCollapse: true,
//                         isDense: true,
//                       ),
//                       onChanged: (val) {
//                         widget.onChanged(val);
//                         widget.model.updateMinMaxCapString(val);
//                         updateFieldWidth();
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: SizeConfig.padding4,
//                 horizontal: SizeConfig.pageHorizontalMargins,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     widget.model.minMaxCapString ?? '',
//                     style: TextStyles.body3.colour(Colors.red),
//                   ),
//                   Text(
//                     getMinMaxRange(),
//                     style: TextStyles.sourceSans.body3
//                         .colour(UiConstants.kTextColor2),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   String getMinMaxRange() {
//     switch (widget.model.selectedFrequency) {
//       case FREQUENCY.daily:
//         return widget.model.selectedAssetOption == 1
//             ? "(₹${widget.model.dailyMaxMinInfo.min.LENDBOXP2P} - ₹${widget.model.dailyMaxMinInfo.max.LENDBOXP2P})"
//             : "(₹${widget.model.dailyMaxMinInfo.min.AUGGOLD99} - ₹${widget.model.dailyMaxMinInfo.max.AUGGOLD99})";
//       case FREQUENCY.weekly:
//         return widget.model.selectedAssetOption == 1
//             ? "(₹${widget.model.weeklyMaxMinInfo.min.LENDBOXP2P} - ₹${widget.model.weeklyMaxMinInfo.max.LENDBOXP2P})"
//             : "(₹${widget.model.weeklyMaxMinInfo.min.AUGGOLD99} - ₹${widget.model.weeklyMaxMinInfo.max.AUGGOLD99})";
//       case FREQUENCY.monthly:
//         return widget.model.selectedAssetOption == 1
//             ? "(₹${widget.model.monthlyMaxMinInfo.min.LENDBOXP2P} - ₹${widget.model.monthlyMaxMinInfo.max.LENDBOXP2P})"
//             : "(₹${widget.model.monthlyMaxMinInfo.min.AUGGOLD99} - ₹${widget.model.monthlyMaxMinInfo.max.AUGGOLD99})";
//     }
//   }
// }
