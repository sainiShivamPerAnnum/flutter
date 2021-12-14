import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter/cupertino.dart';

const String SplashPath = '/splash';
const String LoginPath = '/login';
const String OnboardPath = '/onboard';
const String RootPath = '/approot';
const String UserProfileDetailsPath = '/userProfileDetails';
const String MfDetailsPath = '/mfDetails';
const String AugDetailsPath = '/augDetails';
const String TransactionPath = '/tran';
const String ReferralPath = '/referral';
const String TncPath = '/tnc';
const String FaqPath = '/faq';
const String AugOnboardingPath = '/augOnboard';
const String AugWithdrawalPath = '/augWithdrawal';
const String EditAugBankDetailsPath = '/editAugBankDetails';
const String ReferralPolicyPath = '/refPolicy';
const String ChatSupportPath = '/chatSupport';
const String ClaimUsernamePath = '/claimUsername';
const String VerifyEmailPath = '/verifyEmail';
const String SupportPath = '/support';
const String UpdateRequiredPath = '/updateRequired';
const String WalkThroughPath = '/walkThrough';
const String WalkThroughCompletedPath = '/walkThroughCompleted';
const String YourFundsPath = '/yourFunds';
const String NotificationsPath = '/notifications';
const String THome = '/tHome';
const String TGame = '/tGame';
const String TWalkthrough = 'tWalkthrough';
const String TShowAllTickets = 'tShowAllTickets';
const String TPickDraw = 'tPickDraw';
const String TWeeklyResult = 'tWeeklyResult';
const String TSummaryDetails = 'tSummaryDetails';
const String CricketHomePath = 'cricketHome';
const String CricketGamePath = 'cricketGame';
const String TransactionsHistoryPath = 'transHistory';
const String KycDetailsPath = 'kycDetails';
const String BankDetailsPath = 'bankDetails';
const String AugmontGoldBuyPath = '/augBuy';
const String AugmontGoldSellPath = '/augSell';
const String AugmontGoldDetailsPath = '/augDetails';
const String ReferralDetailsPath = '/referralDetails';
const String ReferralHistoryPath = '/referralHistory';
const String MyWinningsPath = '/myWinnings';
const String blockedUserPath = '/blockeUser';

enum Pages {
  Splash,
  Login,
  Onboard,
  Root,
  UserProfileDetails,
  MfDetails,
  AugDetails,
  Transaction,
  Referral,
  Tnc,
  Faq,
  AugOnboard,
  UpdateRequired,
  AugWithdrawal,
  EditAugBankDetails,
  RefPolicy,
  ChatSupport,
  ClaimUsername,
  VerifyEmail,
  Support,
  WalkThrough,
  WalkThroughCompleted,
  YourFunds,
  THome,
  TGame,
  TWeeklyResult,
  TWalkthrough,
  TPickDraw,
  TShowAllTickets,
  TSummaryDetails,
  Notifications,
  CricketHome,
  CricketGame,
  TxnHistory,
  KycDetails,
  BankDetails,
  AugGoldBuy,
  AugGoldSell,
  AugGoldDetails,
  ReferralDetails,
  ReferralHistory,
  MyWinnings,
  blockedUser
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction currentPageAction;
  var returnValue;

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

PageConfiguration NotificationsConfig = PageConfiguration(
  key: 'Notifications',
  path: NotificationsPath,
  uiPage: Pages.Notifications,
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
PageConfiguration UserProfileDetailsConfig = PageConfiguration(
  key: 'EditProfile',
  path: UserProfileDetailsPath,
  uiPage: Pages.UserProfileDetails,
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

PageConfiguration RefPolicyPageConfig = PageConfiguration(
  key: 'RefPolicy',
  path: ReferralPolicyPath,
  uiPage: Pages.RefPolicy,
);
PageConfiguration ChatSupportPageConfig = PageConfiguration(
  key: 'ChatSupport',
  path: ChatSupportPath,
  uiPage: Pages.ChatSupport,
);
PageConfiguration UpdateRequiredConfig = PageConfiguration(
  key: 'UpdateRequired',
  path: UpdateRequiredPath,
  uiPage: Pages.UpdateRequired,
);
PageConfiguration ClaimUsernamePageConfig = PageConfiguration(
  key: 'ClaimUsername',
  path: ClaimUsernamePath,
  uiPage: Pages.ClaimUsername,
);
PageConfiguration VerifyEmailPageConfig = PageConfiguration(
  key: 'VerifyEmail',
  path: VerifyEmailPath,
  uiPage: Pages.VerifyEmail,
);
PageConfiguration SupportPageConfig = PageConfiguration(
  key: 'Support',
  path: SupportPath,
  uiPage: Pages.Support,
);
PageConfiguration WalkThroughConfig = PageConfiguration(
  key: 'WalkThrough',
  path: WalkThroughPath,
  uiPage: Pages.WalkThrough,
);
PageConfiguration YourFundsConfig = PageConfiguration(
  key: 'YourFunds',
  path: YourFundsPath,
  uiPage: Pages.YourFunds,
);

PageConfiguration THomePageConfig = PageConfiguration(
  key: 'THome',
  path: THome,
  uiPage: Pages.THome,
);
PageConfiguration TGamePageConfig = PageConfiguration(
  key: 'TGame',
  path: TGame,
  uiPage: Pages.TGame,
);
PageConfiguration TWeeklyResultPageConfig = PageConfiguration(
  key: 'TWeeklyResult',
  path: TWeeklyResult,
  uiPage: Pages.TWeeklyResult,
);
PageConfiguration TPickDrawPageConfig = PageConfiguration(
  key: 'TPickDraw',
  path: TPickDraw,
  uiPage: Pages.TPickDraw,
);
PageConfiguration TShowAllTicketsPageConfig = PageConfiguration(
  key: 'TShowAllTickets',
  path: TShowAllTickets,
  uiPage: Pages.TShowAllTickets,
);
PageConfiguration TWalkthroughPageConfig = PageConfiguration(
  key: 'TWalkthrough',
  path: TWalkthrough,
  uiPage: Pages.TWalkthrough,
);

PageConfiguration TSummaryDetailsPageConfig = PageConfiguration(
  key: 'TSummaryDetails',
  path: TSummaryDetails,
  uiPage: Pages.TSummaryDetails,
);

PageConfiguration CricketHomePageConfig = PageConfiguration(
  key: 'CricketHome',
  path: CricketHomePath,
  uiPage: Pages.CricketHome,
);

PageConfiguration CricketGamePageConfig = PageConfiguration(
  key: 'CricketGame',
  path: CricketGamePath,
  uiPage: Pages.CricketGame,
);

PageConfiguration TransactionsHistoryPageConfig = PageConfiguration(
  key: 'TxnHistory',
  path: TransactionsHistoryPath,
  uiPage: Pages.TxnHistory,
);
PageConfiguration KycDetailsPageConfig = PageConfiguration(
  key: 'KycDetails',
  path: KycDetailsPath,
  uiPage: Pages.KycDetails,
);

PageConfiguration BankDetailsPageConfig = PageConfiguration(
  key: 'BankDetails',
  path: BankDetailsPath,
  uiPage: Pages.BankDetails,
);

PageConfiguration AugmontGoldBuyPageConfig = PageConfiguration(
  key: 'augGoldBuy',
  path: AugmontGoldBuyPath,
  uiPage: Pages.AugGoldBuy,
);
PageConfiguration AugmontGoldSellPageConfig = PageConfiguration(
  key: 'augGoldSell',
  path: AugmontGoldSellPath,
  uiPage: Pages.AugGoldSell,
);

PageConfiguration AugmontGoldDetailsPageConfig = PageConfiguration(
  key: 'augGoldDetails',
  path: AugmontGoldDetailsPath,
  uiPage: Pages.AugGoldDetails,
);

PageConfiguration ReferralDetailsPageConfig = PageConfiguration(
  key: 'referDetails',
  path: ReferralDetailsPath,
  uiPage: Pages.ReferralDetails,
);
PageConfiguration ReferralHistoryPageConfig = PageConfiguration(
  key: 'referHistory',
  path: ReferralHistoryPath,
  uiPage: Pages.ReferralHistory,
);

PageConfiguration MyWinnigsPageConfig = PageConfiguration(
  key: 'myWinnings',
  path: MyWinningsPath,
  uiPage: Pages.MyWinnings,
);
PageConfiguration BlockedUserPageConfig = PageConfiguration(
  key: 'blockedUser',
  path: blockedUserPath,
  uiPage: Pages.blockedUser,
);
