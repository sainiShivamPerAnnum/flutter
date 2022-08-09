import 'package:flutter/material.dart';

class UiConstants {
  UiConstants._();

  static final Color primaryColor = const Color(0xff34C3A7);
  static final Color primaryLight = const Color(0xffCBECED);
  static final Color tertiarySolid = const Color(0xffFF9E0B);
  static final Color tertiaryLight = const Color(0xffFFF5E5);
  static final Color scaffoldColor = const Color(0xffF1F6FF);
  static final Color felloBlue = const Color(0xff26A6F4);
  static final Color autosaveColor = const Color(0xff6b7AA1);
  static final Color gameCardColor = const Color(0xff39393C);

  static final Color accentColor = const Color(0xff333333);
  static final Color darkPrimaryColor = const Color.fromARGB(255, 58, 120, 255);
  static final Color secondaryColor = const Color.fromARGB(255, 241, 227, 243);
  // static final Color chipColor = const Color.fromARGB(255, 241, 227, 243);
  static final Color chipColor = Colors.grey[200];
  static final Color positiveAlertColor = Colors.blueAccent[400];
  static final Color negativeAlertColor = Colors.blueGrey;
//  static final Color secondaryColor = Colors.greenAccent;
  static final Color spinnerColor = Colors.grey[400];
  static final Color spinnerColor2 = Colors.grey[200];

  static final Color backgroundColor = Color(0xfff1f1f1);
  static final Color bottomNavBarColor = Colors.white;
  static final Color titleTextColor = Colors.white;
  static final Color textColor = Colors.black87;

  static const MaterialColor kPrimaryColor = MaterialColor(
    0xff2EB19F,
    const <int, Color>{
      50: const Color(0xff2EB19F),
      100: const Color(0xff2EB19F),
      200: const Color(0xff2EB19F),
      300: const Color(0xff2EB19F),
      400: const Color(0xff2EB19F),
      500: const Color(0xff2EB19F),
      600: const Color(0xff2EB19F),
      700: const Color(0xff2EB19F),
      800: const Color(0xff2EB19F),
      900: const Color(0xff2EB19F),
    },
  );

  /// New UI Colors
  static const Color kTextColor = const Color(0xFFFFFFFF);
  static const Color kTextColor2 = const Color(0xFF919193);
  static const Color kYellowTextColor = const Color(0xFFFEF5DC);

  static const Color kBackgroundColor = const Color(0xFF232326);
  static const Color kSecondaryBackgroundColor = const Color(0xFF39393C);
  static const Color kTabBorderColor = const Color(0xFF62E3C4);
  static const Color kDividerColor = const Color(0xFF9EA1A1);
  static const Color kBackgroundDividerColor = const Color(0xFF23272B);
  static const Color kFirstRankPillerColor = const Color(0xFFF2B826);
  static const Color kSecondRankPillerColor = const Color(0xF5371EE);
  static const Color kThirdRankPillerColor = const Color(0xFF34C3A7);
  static Color kUserRankBackgroundColor = Color(0xFF000000).withOpacity(0.3);
  static const Color kWinnerPlayerPrimaryColor = const Color(0xFFFFD979);
  static const Color kWinnerPlayerLightPrimaryColor = const Color(0xFFFEF5DC);
  static const Color kOtherPlayerPrimaryColor = const Color(0xFFFFFFFF);
  static const Color kLastUpdatedTextColor = const Color(0xFF919193);
  static const Color kTextFieldTextColor = const Color(0xFFBDBDBE);
  static const Color kProfileBorderOutterColor = const Color(0xFF737373);
  static const Color kProfileBorderColor = const Color(0xFFD9D9D9);
  static const Color kTextFieldColor = const Color(0xFF161617);
  static const Color kSwitchColor = const Color(0xFF19191A);
  static const Color kAutopayAmountActiveTabColor = const Color(0xFFF5F2ED);
  static const Color kAutopayAmountDeactiveTabColor = const Color(0xFF39393C);
  static const Color kBorderColor = const Color(0xFFDADADA);
  static const Color kLeaderBoardBackgroundColor = const Color(0xFF39393C);
  static const Color kSnackBarBgColor = const Color(0xFFF4EDD9);
  static const Color kSnackBarNegativeContentColor = const Color(0xFFE35833);
  static const Color kSnackBarPositiveContentColor = const Color(0xFF01656B);
  static const Color kSnackBarNoInternetContentColor = const Color(0xFFEFAF4E);
  static const Color kSaveDigitalGoldCardBg = const Color(0xFF495DB2);
  static const Color kSaveStableFelloCardBg = const Color(0xFF01656B);
  static const Color kBlogTitleColor = const Color(0xFF93B5FE);

  static const Color kFAQsAnswerColor = const Color(0xFFA9C6D6);

  static const Color kFAQDividerColor = const Color(0xFF627F8E);

  static const Color kSliverAppBarBackgroundColor = Color(0xff495DB2);
  static const Color kDarkBoxColor = const Color(0xFF3B3B3B);
  // Recharge Modal Sheet
  static const Color kRechargeModalSheetAmountSectionBackgroundColor =
      const Color(0xFF49494C);

  static const Color kpurpleTicketColor = const Color(0xFFCEC5FF);

  // Autosave
  static const Color kAutosaveBalanceColor = const Color(0xFFEFECD1);

  static LinearGradient kTextFieldGradient1 = LinearGradient(
    colors: [Color(0xff111111), Colors.transparent],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.4],
    tileMode: TileMode.clamp,
  );

  static LinearGradient kTextFieldGradient2 = LinearGradient(
    colors: [Color(0xff111111), UiConstants.kTextFieldColor.withOpacity(0.7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.4],
    tileMode: TileMode.clamp,
  );

  static LinearGradient kButtonGradient = LinearGradient(
      colors: [
        Color(0xFF08D2AD),
        Color(0xFF43544F),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.clamp);

  static LinearGradient kCampaignBannerBackgrondGradient = LinearGradient(
    colors: [Color(0xff141316), UiConstants.kBackgroundColor.withOpacity(0.2)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: [0, 0.7],
    tileMode: TileMode.clamp,
  );

  static LinearGradient kTrophyBackground = LinearGradient(
    colors: [Color(0xffFFE9B1), Color(0xffFFE9B1).withOpacity(0.0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0, 0.8],
    tileMode: TileMode.clamp,
  );
}
