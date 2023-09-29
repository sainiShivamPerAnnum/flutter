// import 'dart:async';
// import 'dart:ui';

// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/enums/screen_item_enum.dart';
// import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/ui/pages/rewards/instant_scratch_card/gt_instant_view.dart';
// import 'package:felloapp/ui/pages/static/app_widget.dart';
// import 'package:felloapp/util/locator.dart';
// import 'package:felloapp/util/show_case_key.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:showcaseview/showcaseview.dart';

// import '../../util/styles/size_config.dart';

// class SpotLightController {
//   SpotLightController._();

//   static final instance = SpotLightController._();
//   bool _isInitiated = false;
//   late Completer completer;

//   late BuildContext _currentContext;

//   BuildContext? saveViewContext;
//   BuildContext? playViewContext;
//   BuildContext? accountContext;
//   BuildContext get currentContext => _currentContext;

//   BehaviorSubject<List<UserFlow>> _stream =
//       BehaviorSubject.seeded([UserFlow.initial]);
//   bool isTourStarted = false;
//   set userFlow(UserFlow flow) {
//     if (_stream.isClosed) return;
//     if (!_isInitiated) return;
//     if (_stream.value.contains(flow)) return;
//     _stream.add([..._stream.value, flow]);
//   }

//   bool isSkipButtonClicked = false;
//   bool isQuickTour = false;
//   bool startShowCase = false;

//   void init() {
//     _isInitiated = true;

//     _stream = BehaviorSubject.seeded([UserFlow.initial]);
//     _stream.distinct().listen(_listener);
//   }

//   Future<void> _listener(List<UserFlow> flow) async {
//     unawaited(BaseUtil.openDialog(
//       isBarrierDismissible: false,
//       content: Container(),
//       barrierColor: Colors.transparent,
//       addToScreenStack: true,
//     ));
//     await Future.delayed(const Duration(seconds: 1));
//     unawaited(AppState.backButtonDispatcher!.didPopRoute());

//     isSkipButtonClicked = false;
//     switch (flow.last) {
//       case UserFlow.initial:
//         break;
//       case UserFlow.onSaveTab:
//         await startSaveFlow();
//         break;

//       case UserFlow.onAssetPageGold:
//       case UserFlow.onAssetPageFlo:
//         if (!isQuickTour) await startAssetViewFlow();
//         break;

//       case UserFlow.onAssetBuyPage:
//         if (!isQuickTour) await startGoldInputFlow();
//         break;
//       case UserFlow.onPlayTab:
//         await startPlayFlow();
//         break;
//       case UserFlow.onGamesModalSheet:
//         if (!isQuickTour) await startGameModalSheet();
//         break;
//       case UserFlow.onTambolaPage:
//         await startTambolaFlow();
//         break;

//       case UserFlow.onWinPage:
//         await startAccount();
//         break;
//       case UserFlow.floInputView:
//         if (!isQuickTour) await startFloInputView();
//         break;
//       default:
//         break;
//     }
//   }

//   set currentContext(BuildContext context) => _currentContext = context;
//   Future<void> startShowcase(List<GlobalKey> keys,
//       [BuildContext? context]) async {
//     completer = Completer();
//     isTourStarted = true;
//     ShowCaseWidget.of(context ?? currentContext).startShowCase(keys);
//     await completer.future;
//     isTourStarted = false;
//   }

//   Future<void> startSaveFlow({void Function()? onFinish}) async {
//     await startShowcase([
//       ShowCaseKeys.GoldAssetKey,
//       ShowCaseKeys.LendBoxAssetKey,
//     ], saveViewContext);
//     if (!isSkipButtonClicked)
//       await startShowcase([
//         ShowCaseKeys.PlayKey,
//       ]);
//   }

//   void dispose() {
//     _stream.close();
//   }

//   Future<void> startTambolaFlow({void Function()? onFinish}) async {
//     await startShowcase([
//       ShowCaseKeys.TambolaButton,
//     ]);
//   }

//   Future<void> startAssetViewFlow({void Function()? onFinish}) async {
//     await startShowcase([
//       ShowCaseKeys.assetPicture,
//       ShowCaseKeys.SaveButton,
//     ]);
//   }

//   Future<void> startPlayFlow({void Function()? onFinish}) async {
//     await startShowcase([
//       ShowCaseKeys.floCoinsKey,
//     ]);
//     if (!isSkipButtonClicked)
//       await startShowcase([
//         ShowCaseKeys.GamesKey,
//       ], playViewContext);
//     if (!isSkipButtonClicked)
//       await startShowcase([
//         ShowCaseKeys.AccountKey,
//       ]);
//   }

//   Future<void> showTourDialog() async {
//     startShowCase = true;
//     await BaseUtil.openDialog(
//       addToScreenStack: true,
//       isBarrierDismissible: false,
//       content: StartTourDialog(),
//     );
//   }

//   Future<void> startGoldInputFlow() async {
//     await startShowcase([
//       ShowCaseKeys.goldInputKey,
//       ShowCaseKeys.currentGoldRates,
//       ShowCaseKeys.couponKey,
//       ShowCaseKeys.saveNowGold
//     ]);
//   }

//   Future<void> startAccount() async {
//     await startShowcase([
//       ShowCaseKeys.ScratchCardKey,
//       ShowCaseKeys.CurrentWinnings,
//     ]);
//     if (!isSkipButtonClicked) {
//       BaseUtil.openDialog(
//           isBarrierDismissible: false,
//           addToScreenStack: true,
//           barrierColor: Colors.black.withOpacity(0.5),
//           content: Center(child: CircularProgressIndicator.adaptive()));

//       if (await locator<ScratchCardService>().fetchAndVerifyScratchCardByID()) {
//         await locator<ScratchCardService>()
//             .showInstantScratchCardView(source: GTSOURCE.newuser);
//       }
//       AppState.backButtonDispatcher!.didPopRoute();
//       await startShowcase([ShowCaseKeys.SaveKey]);
//     }
//   }

//   bool isSpotLightDismissed = false;

//   Future<void> dismissSpotLight() async {
//     if (isTourStarted) {
//       isSpotLightDismissed = true;
//       isSkipButtonClicked = true;
//       ShowCaseWidget.of(currentContext).dismiss();
//       ShowCaseWidget.of(saveViewContext!).dismiss();
//       ShowCaseWidget.of(playViewContext!).dismiss();
//     }
//   }

//   Future<void> startGameModalSheet() async {
//     await startShowcase([
//       ShowCaseKeys.GameRewardsKey,
//       ShowCaseKeys.PlayGameKey,
//     ]);
//   }

//   void startQuickTour() async {
//     if (AppState.screenStack.last != ScreenItem.dialog &&
//         AppState.screenStack.last != ScreenItem.modalsheet) {
//       AppState.delegate!.parseRoute(Uri.parse('save'));
//       SpotLightController.instance.isQuickTour = true;
//       SpotLightController.instance.init();

//       SpotLightController.instance.userFlow = UserFlow.onSaveTab;
//     }
//   }

//   Future<void> startFloInputView() async {
//     await startShowcase([
//       ShowCaseKeys.floAmountKey,
//       ShowCaseKeys.floKYCKey,
//     ]);
//   }
// }

// class StartTourDialog extends StatelessWidget {
//   const StartTourDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
//       ),
//       elevation: 0.0,
//       backgroundColor: Colors.black.withOpacity(0.5),
//       insetPadding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
//           child: Container(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: SizeConfig.padding16,
//                 ),
//                 SvgPicture.asset(
//                   'assets/svg/tour_svg.svg',
//                   height: SizeConfig.screenHeight! * 0.5,
//                 ),
//                 SizedBox(
//                   height: SizeConfig.padding10,
//                 ),
//                 Text(
//                   'Welcome to Fello!',
//                   style: TextStyles.sourceSansSB.title5,
//                 ),
//                 SizedBox(
//                   height: SizeConfig.padding16,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: SizeConfig.pageHorizontalMargins),
//                   child: Text(
//                     'Start your Fello journey by taking a tour of the app. Get a reward after the tour!',
//                     style:
//                         TextStyles.sourceSans.body2.colour(Color(0xffBDBDBE)),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.padding12,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: SizeConfig.padding16,
//                     vertical: SizeConfig.padding16,
//                   ),
//                   child: AppPositiveBtn(
//                     btnText: 'Start Tour',
//                     onPressed: () {
//                       AppState.backButtonDispatcher!.didPopRoute();
//                       SpotLightController.instance.init();

//                       SpotLightController.instance.userFlow =
//                           UserFlow.onSaveTab;
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.padding12,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// enum UserFlow {
//   initial,
//   onSaveTab,
//   onAssetPageGold,
//   onAssetPageFlo,
//   onAssetBuyPage,
//   onTransactionPage,
//   cameAfterTransaction,
//   onPlayTab,
//   onGamesModalSheet,
//   cameFromPlayingGame,
//   onTambolaPage,
//   onWinPage,
//   floInputView
// }
