// import 'package:felloapp/ui/architecture/base_view.dart';
// import 'package:felloapp/ui/service_elements/user_coin_service/coin_balance_text.dart';
// import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
// import 'package:felloapp/ui/service_elements/user_service/user_name_text.dart';
// import 'package:felloapp/ui/widgets/appbars/fello_appbar_vm.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';

// import 'package:flutter/material.dart';

// class FelloAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final Text title;
//   final AppBar appBar;
//   final List<Widget> widgets;

//   const FelloAppBar({Key key, this.title, this.appBar, this.widgets})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BaseView<FelloAppBarVM>(
//       onModelReady: (model) {
//         model.getFlc();
//       },
//       builder: (context, model, child) => AppBar(
//         backgroundColor: ThemeData().scaffoldBackgroundColor,
//         leading: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: InkWell(
//             onTap: model.showDrawer,
//             child: ProfileImageSE(),
//           ),
//         ),
//         title: UserNameTextSE(),
//         actions: [
//           InkWell(
//             onTap: () => model.showTicketModal(context),
//             child: Container(
//               margin: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   color: UiConstants.primaryColor),
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: [
//                   model.isLoadingFlc
//                       ? CircularProgressIndicator(
//                           color: Colors.white,
//                         )
//                       : CoinBalanceTextSE(),
//                   SizedBox(width: 8),
//                   Icon(
//                     Icons.control_point_rounded,
//                     color: Colors.white,
//                     size: kToolbarHeight / 2.5,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           InkWell(
//             child: Icon(
//               Icons.notifications,
//               size: kToolbarHeight * 0.5,
//               color: Color(0xff4C4C4C),
//             ),
//             //icon: Icon(Icons.contact_support_outlined),
//             // iconSize: kToolbarHeight * 0.5,
//             onTap: model.openAlertsScreen,
//           ),
//           SizedBox(
//             width: SizeConfig.globalMargin,
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
// }
