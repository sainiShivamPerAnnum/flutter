import 'package:felloapp/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestKeys {
  //SignIn/SignUp keys
  static final Finder onBoardingScreen = find.byKey(Key('onboardingFab'));
  static final Finder mobileNoTextField = find.byKey(Key('mobileNoTextField'));
  static final Finder mobileNext = find.byKey(Key('LoginCTA'));
  static final Finder otpTextField = find.byKey(Key('otpTextField'));
  static final Finder termsAndConditions =
      find.byKey(Key('TermsAndConditions'));
  static final Finder helpTab = find.byKey(Key('helpTab'));
  static final Finder mobileInputScreenText =
      find.byKey(Key("mobileInputScreenText"));
  static final Finder otpResend = find.byKey(Key("OtpResend"));

  static final Finder messageFCM = find.byKey(Key("messageFCM"));

  static final Finder userNameTab = find.byKey(Key("userNameTab"));
  static final Finder refferalTab = find.byKey(Key("refferalTab"));
  static final Finder refferalCode = find.byKey(Key("refferalCode"));

  //static final Finder profile = find.byKey(Key(Constants.PROFILE));
  //profile_tap
  static final Finder profile = find.byKey(Key("userProfileEntry"));
//  static final Finder saveProfile = find.byKey(Key("savings"));
  static final Finder saveProfile = find.byKey(Key('play'));
  static final Finder signOut = find.byKey(Key("signOutButton"));
  static final Finder userProfilePrimaryScrollbar =
      find.byKey(Key("userProfilePrimaryScrollbar"));
  static final Finder confirm = find.byKey(Key('logoutConfirmationCTA'));
  static final Finder cancel = find.byKey(Key('logoutCancelCTA'));

  static final Finder dailyAppBonus = find.byKey(const Key('AppBonus'));

  static final Finder GTBackButton = find.byKey(Key('GTBackButton'));

  //Save Section
  // Key(Constants.ASSET_TYPE_AUGMONT)
  static final Finder saveGoldBanner =
      find.byKey(Key(Constants.ASSET_TYPE_AUGMONT));
  static final Finder saveFloBanner =
      find.byKey(Key(Constants.ASSET_TYPE_LENDBOX));

  static final Finder transactionSeeAll = find.byKey(Key('transactionSeeAll'));

  static final Finder saveButton = find.byKey(Key('saveButton'));

  static final Finder bankDetailsPending =
      find.byKey(Key('bankDetailsPending'));
  static final Finder kycPending = find.byKey(Key('kycPending'));
  static final Finder kycPendingSave = find.byKey(Key('kycPendingSave'));

  static final Finder saveGoldCustomButton = find.byKey(Key('digitalgold'));
  static final Finder saveFloCustomButton = find.byKey(Key('felloflo'));

  static final Finder bannerAugmontGold = find.byKey(Key('bannerAugmontGold'));
  static final Finder enterGoldBuyAmount =
      find.byKey(Key('enterGoldBuyAmount'));
  static final Finder couponKey = find.byKey(Key('couponKey'));
  static final Finder currentGoldPrice = find.byKey(Key('currentGoldPrice'));
  static final Finder goldInGms = find.byKey(Key('goldInGms'));

  //Need to add this correctly as multiple coupon codes available
  static final Finder couponEXTRA1 = find.byKey(Key('EXTRA1%'));
  static final Finder TEST10 = find.byKey(Key('TEST10'));

  static final Finder customCouponClick = find.byKey(Key('customCouponClick'));
  static final Finder customCouponEnter = find.byKey(Key('customCouponEnter'));
  static final Finder customCouponEnterApply =
      find.byKey(Key('customCouponEnterApply'));
  static final Finder save = find.byKey(Key('save'));

  static final Finder amountInput = find.byKey(Key('amountInput'));

  static final Finder profileAvatar = find.byKey(Key('userAvatarKey'));

  static final Finder sellButton = find.byKey(Key('sellButton')); //Gold sell
  static final Finder floWithdraw = find.byKey(Key('floWithdraw')); //Flo sell

  static final Finder saveNowNewUser =
      find.byKey(Key('saveNowNewUser')); //save now for new user screen
  static final Finder viewBreakdownCard =
      find.byKey(Key('viewBreakdownCard')); //View Breakdown on cards home

  static final Finder saveNowHomeScreen =
      find.byKey(Key('saveNowHomeScreen')); //home page save button for new user

  static final Finder saveNowButton = find.byKey(
      const Key('saveNowButton')); //home page save now button for invested user

  static final Finder felloBalance =
      find.byKey(Key('felloBalance')); //fello balance card

  static final Finder goldSavePlan =
      find.byKey(const Key('goldSavePlan')); //Select plan to save - Gold

  static final Finder flo8 = find.byKey(Key('UNI_FLEXI')); //Flo 8% program
  static final Finder flo10 = find.byKey(Key('UNI_FIXED_3')); //Flo 10% program
  static final Finder flo12 = find.byKey(Key('UNI_FIXED_6')); //Flo 12% program

  static final Finder goldBreakdownDetails =
      find.byKey(Key('goldBreakdownDetails')); //gold breakdown details

  static final Finder floBreakdownDetails =
      find.byKey(Key('floBreakdownDetails')); // flo breakdown details

  static final Finder tambolaTicketGold =
      find.byKey(Key('tambolaTicketGold')); //tambola ticket breakdown

  static final Finder portfolioCard = find.byKey(const Key('portfolioCard'));
  static final Finder goldPortfolioSave =
      find.byKey(const Key('goldPortfolioSave'));
  static final Finder floPortfolioSave =
      find.byKey(const Key('floPortfolioSave'));
  static final Finder saveinGoldButton =
      find.byKey(const Key('saveinGoldButton'));
  static final Finder saveinFloButton =
      find.byKey(const Key('saveinFloButton'));
  static final Finder floFlexiAsset = find.byKey(const Key('10%'));
  static final Finder floFixedAsset = find.byKey(const Key('12%'));

  static final Finder goBackAnywayButton =
      find.byKey(const Key('goBackAnywayButton')); //transaction cancel button

  static final Finder blockedScreenTermsAndConditions =
      find.byKey(const Key('blockedScreenTermsAndConditions')); //banned user
}
