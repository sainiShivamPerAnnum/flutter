import 'package:felloapp/util/assets.dart';

enum AssetType {
  flo(
    loadingLottie: Assets.floDepostLoadingLottie,
    successLottie: Assets.floDepositSuccessLottie,
    icon: Assets.felloFlo,
  ),

  aug(
    loadingLottie: Assets.goldDepostLoadingLottie,
    successLottie: Assets.goldDepostSuccessLottie,
    icon: Assets.digitalGoldBar,
  );

  const AssetType({
    required this.loadingLottie,
    required this.successLottie,
    required this.icon,
  });

  final String loadingLottie;
  final String successLottie;
  final String icon;
}
