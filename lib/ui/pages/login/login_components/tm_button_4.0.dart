// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';
// import 'package:flutter/material.dart';

// class AppPositiveBtn extends StatelessWidget {
//   const AppPositiveBtn({
//     Key key,
//     @required this.btnText,
//     @required this.onPressed,
//     @required this.width,
//   }) : super(key: key);
//   final String btnText;
//   final VoidCallback onPressed;
//   final double width;
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: SizeConfig.screenWidth * 0.1556,
//           width: width,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(
//               8.0, //SizeConfig.buttonBorderRadius,
//             ),
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xff12BC9D),
//                 Color(0xff249680),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: MaterialButton(
//             // padding: EdgeInsets.zero,
//             onPressed: onPressed,
//             child: Text(
//               btnText.toUpperCase(),
//               style: TextStyles.rajdhaniB.title5,
//             ),
//           ),
//         ),
//         Container(
//           height: SizeConfig.padding2,
//           width: width - SizeConfig.padding4,
//           margin: EdgeInsets.symmetric(
//             horizontal: SizeConfig.padding2,
//           ),
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: UiConstants.kTextColor,
//                 offset: Offset(0, SizeConfig.padding2),
//                 blurRadius: SizeConfig.padding4,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
