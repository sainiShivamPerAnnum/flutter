// import 'package:felloapp/core/enums/page_state_enum.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/navigator/router/ui_pages.dart';
// import 'package:felloapp/ui/architecture/base_vm.dart';
// import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_view.dart';

// class SellGoldBtnVM extends BaseModel {
//   sellButtonAction() async {
//     openSellPage();
//   }

//   openSellPage() {
//     AppState.delegate.appState.currentAction = PageAction(
//       state: PageState.addWidget,
//       page: AugWithdrawalPageConfig,
//       widget: AugmontGoldSellView(
//           passbookBalance: 0.0,
//           withdrawableGoldQnty: 0.0,
//           sellRate: 0.0,
//           onAmountConfirmed: (Map<String, double> amountDetails) {
//             //_onInitiateWithdrawal(amountDetails['withdrawal_quantity']);
//           },
//           bankHolderName: "ARAB", // _baseUtil.augmontDetail.bankHolderName,
//           bankAccNo: "1234", //_baseUtil.augmontDetail.bankAccNo,
//           bankIfsc: "12345" // _baseUtil.augmontDetail.ifsc,
//           ),
//     );
//   }
// }
