// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/ui/elements/tambola_board_view.dart';
// import 'package:flutter/material.dart';

// class TambolaCardsList extends StatelessWidget {
//   final List<TambolaBoardView> tambolaBoardView;

//   TambolaCardsList({this.tambolaBoardView});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BaseUtil.getAppBar(context, "My Tambola Cards"),
//       body: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20),
//         child: ListView.builder(
//             itemCount: tambolaBoardView.length,
//             itemBuilder: (ctx, i) {
//               return Container(
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 child: tambolaBoardView[i],
//               );
//             }),
//       ),
//     );
//   }
// }
