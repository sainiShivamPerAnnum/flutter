import 'package:felloapp/core/service/payments/base_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UPIAppsBottomSheet extends StatelessWidget {
  final BaseTransactionService? txnServiceInstance;

  const UPIAppsBottomSheet({Key? key, this.txnServiceInstance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      height: SizeConfig.screenWidth! * 0.5,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness12),
            topRight: Radius.circular(SizeConfig.roundness12)),
      ),
      child: Padding(
          padding: EdgeInsets.all(SizeConfig.padding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    right: SizeConfig.pageHorizontalMargins / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      txnServiceInstance!.appMetaList.length > 0
                          ? locale.txnSelectUPI
                          : locale.txnNoUPI,
                      style: TextStyles.title5.bold,
                    ),
                    GestureDetector(
                      onTap: () {
                        AppState.backButtonDispatcher!.didPopRoute();
                      },
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              txnServiceInstance!.appMetaList.length <= 0
                  ? Container(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.noTickets,
                              height: SizeConfig.screenWidth! * 0.16),
                          SizedBox(height: SizeConfig.padding12),
                          Text(locale.txnCouldNotFindUPI,
                              style: TextStyles.body1.colour(Colors.grey)),
                        ],
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: txnServiceInstance!.appMetaList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              txnServiceInstance!.upiApplication =
                                  txnServiceInstance!
                                      .appMetaList[index].upiApplication;
                              txnServiceInstance!.selectedUpiApplicationName =
                                  txnServiceInstance!.appMetaList[index]
                                      .upiApplication.appName;
                              AppState.backButtonDispatcher!.didPopRoute();
                              txnServiceInstance!.processUpiTransaction();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: txnServiceInstance!
                                              .appMetaList[index]
                                              .iconImage(40)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        txnServiceInstance!.appMetaList[index]
                                            .upiApplication.appName,
                                        style: TextStyles.body4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                      ),
                    ),
            ],
          )),
    );
  }
}

// class SubsUPIAppsBottomSheet extends StatelessWidget {
//   final SubService? subscriptionService;

//   const SubsUPIAppsBottomSheet({Key? key, this.subscriptionService})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     S locale = S.of(context);
//     return Container(
//       padding: EdgeInsets.all(SizeConfig.padding20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(
//                 left: SizeConfig.pageHorizontalMargins,
//                 right: SizeConfig.pageHorizontalMargins / 2),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   subscriptionService!.appMetaList.length > 0
//                       ? locale.txnSelectUPI
//                       : locale.txnNoUPI,
//                   style: TextStyles.title5.bold.colour(Colors.white),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     AppState.backButtonDispatcher!.didPopRoute();
//                   },
//                   child: Icon(
//                     Icons.close,
//                     color: Colors.white,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           subscriptionService!.appMetaList.length <= 0
//               ? Container(
//                   width: SizeConfig.screenWidth,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(Assets.noTickets,
//                           height: SizeConfig.screenWidth! * 0.16),
//                       SizedBox(height: SizeConfig.padding12),
//                       Text(locale.txnCouldNotFindUPI,
//                           style: TextStyles.body1.colour(Colors.grey)),
//                     ],
//                   ),
//                 )
//               : GridView.builder(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   itemCount: subscriptionService!.appMetaList.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         subscriptionService!.upiApplication =
//                             subscriptionService!
//                                 .appMetaList[index].upiApplication;
//                         subscriptionService!.selectedUpiApplicationName =
//                             subscriptionService!.appMetaList[index]
//                                 .upiApplication.androidPackageName;
//                         debugPrint(
//                             subscriptionService!.selectedUpiApplicationName!);
//                         AppState.backButtonDispatcher!.didPopRoute();

//                         AppState.delegate!.appState.currentAction = PageAction(
//                           page: AutosaveProcessViewPageConfig,
//                           state: PageState.addPage,
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Container(
//                           child: Center(
//                             child: Column(
//                               children: [
//                                 ClipRRect(
//                                     borderRadius: BorderRadius.circular(5),
//                                     child: subscriptionService!
//                                         .appMetaList[index]
//                                         .iconImage(40)),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Text(
//                                   subscriptionService!.appMetaList[index]
//                                       .upiApplication.appName,
//                                   style: TextStyles.body4.colour(Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
