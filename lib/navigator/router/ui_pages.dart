import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter/cupertino.dart';

const String SplashPath = '/splash';
const String LoginPath = '/login';
const String OnboardPath = '/onboard';
const String RootPath = '/approot';
const String EditProfilePath = '/editProfile';
const String MfDetailsPath = '/mfDetails';
const String AugDetailsPath = '/augDetails';
const String TransactionPath = '/tran';
const String ReferralPath = '/referral';
const String TambolaHomePath = '/tambolaHome';
const String TncPath = '/tnc';
const String FaqPath = '/faq';
const String AugOnboardingPath = '/augOnboard';
const String AugWithdrawalPath = '/augWithdrawal';
const String EditAugBankDetailsPath = '/editAugBankDetails';

enum Pages {
  Splash,
  Login,
  Onboard,
  Root,
  EditProfile,
  MfDetails,
  AugDetails,
  Transaction,
  Referral,
  TambolaHome,
  Tnc,
  Faq,
  AugOnboard,
  AugWithdrawal,
  EditAugBankDetails
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction currentPageAction;
  PageConfiguration(
      {@required this.key,
      @required this.path,
      @required this.uiPage,
      this.currentPageAction});
}

PageConfiguration SplashPageConfig = PageConfiguration(
  key: 'Splash',
  path: SplashPath,
  uiPage: Pages.Splash,
);
PageConfiguration LoginPageConfig = PageConfiguration(
  key: 'Login',
  path: LoginPath,
  uiPage: Pages.Login,
);
PageConfiguration RootPageConfig = PageConfiguration(
  key: 'Root',
  path: RootPath,
  uiPage: Pages.Root,
);
PageConfiguration OnboardPageConfig = PageConfiguration(
  key: 'Onboard',
  path: OnboardPath,
  uiPage: Pages.Onboard,
);
PageConfiguration EditProfileConfig = PageConfiguration(
  key: 'EditProfile',
  path: EditProfilePath,
  uiPage: Pages.EditProfile,
);
PageConfiguration MfDetailsPageConfig = PageConfiguration(
  key: 'MfDetails',
  path: MfDetailsPath,
  uiPage: Pages.MfDetails,
);
PageConfiguration AugDetailsPageConfig = PageConfiguration(
  key: 'AugDetails',
  path: AugDetailsPath,
  uiPage: Pages.AugDetails,
);
PageConfiguration TransactionPageConfig = PageConfiguration(
  key: 'Tran',
  path: TransactionPath,
  uiPage: Pages.Transaction,
);
PageConfiguration ReferralPageConfig = PageConfiguration(
  key: 'Referral',
  path: ReferralPath,
  uiPage: Pages.Referral,
);
PageConfiguration TambolaHomePageConfig = PageConfiguration(
  key: 'TambolaHome',
  path: TambolaHomePath,
  uiPage: Pages.TambolaHome,
);
PageConfiguration TncPageConfig = PageConfiguration(
  key: 'Tnc',
  path: TncPath,
  uiPage: Pages.Tnc,
);
PageConfiguration FaqPageConfig = PageConfiguration(
  key: 'Faq',
  path: FaqPath,
  uiPage: Pages.Faq,
);

PageConfiguration AugOnboardPageConfig = PageConfiguration(
  key: 'AugOnboard',
  path: AugOnboardingPath,
  uiPage: Pages.AugOnboard,
);

PageConfiguration AugWithdrawalPageConfig = PageConfiguration(
  key: 'AugWithdrawal',
  path: AugWithdrawalPath,
  uiPage: Pages.AugWithdrawal,
);
PageConfiguration EditAugBankDetailsPageConfig = PageConfiguration(
  key: 'EditAugBankDetails',
  path: EditAugBankDetailsPath,
  uiPage: Pages.EditAugBankDetails,
);
