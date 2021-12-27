// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/enums/connectivity_status_enum.dart';
// import 'package:felloapp/core/enums/view_state_enum.dart';
// import 'package:felloapp/ui/architecture/base_view.dart';
// import 'package:felloapp/ui/widgets/buttons/sell_gold_button/sellGoldBtn_vm.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';

// class SellGoldBtn extends StatelessWidget {
//   final Widget activeButtonUI;
//   final Widget loadingButtonUI;
//   final Widget disabledButtonUI;
//   SellGoldBtn(
//       {this.loadingButtonUI, this.activeButtonUI, this.disabledButtonUI});
//   @override
//   Widget build(BuildContext context) {
//     ConnectivityStatus connectivityStatus =
//         Provider.of<ConnectivityStatus>(context);
//     return BaseView<SellGoldBtnVM>(
//       builder: (ctx, model, child) {
//         if (connectivityStatus == ConnectivityStatus.Offline)
//           return disabledButtonUI != null
//               ? disabledButtonUI
//               : ElevatedButton(
//                   onPressed: () => BaseUtil.showNoInternetAlert(),
//                   style: ElevatedButton.styleFrom(primary: Colors.grey),
//                   child: Opacity(
//                     opacity: 0.7,
//                     child: Text("Offline"),
//                   ),
//                 );
//         else {
//           return activeButtonUI != null
//               ? InkWell(
//                   onTap: model.sellButtonAction,
//                   child: model.state == ViewState.Busy
//                       ? loadingButtonUI
//                       : activeButtonUI)
//               : ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.grey[300],
//                   ),
//                   onPressed: model.sellButtonAction,
//                   child: model.state == ViewState.Busy
//                       ? SpinKitThreeBounce(
//                           size: SizeConfig.mediumTextSize,
//                           color: Colors.black,
//                         )
//                       : Text(
//                           'WITHDRAW',
//                           style: TextStyles.body2.bold
//                               .colour(UiConstants.primaryColor),
//                         ),
//                 );
//         }
//       },
//     );
//   }
// }
