import 'package:flutter/cupertino.dart';

import 'package:felloapp/navigator/app_state.dart';

const String SplashPath = '/splash';
const String LoginPath = '/login';
const String OnboardPath = '/onboard';
const String RootPath = '/approot';
const String UserProfileDetailsPath = '/userProfileDetails';
const String MfDetailsPath = '/mfDetails';
const String AugDetailsPath = '/augDetails';
const String TransactionPath = '/tran';
const String ReferralPath = '/referral';
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
// const String AugmontGoldBuyPath = '/augBuy';
const String AugmontGoldSellPath = '/augSell';
const String AugmontGoldDetailsPath = '/augDetails';
const String ReferralDetailsPath = '/referralDetails';
const String ReferralHistoryPath = '/referralHistory';
const String MyWinningsPath = '/myWinnings';
const String BlockedUserPath = '/blockeUser';
const String FreshdeskHelpPath = '/freshDeskHelp';
const String GoldenTicketViewPath = '/goldenTicketView';
const String GoldenTicketsViewPath = '/goldenTicketsView';
const String GoldenMilestonesViewPath = '/goldenMilestonesView';
const String GoldBalanceDetailsViewPath = '/goldBalanceDetailsView';

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
  // AugGoldBuy,
  AugGoldSell,
  AugGoldDetails,
  ReferralDetails,
  ReferralHistory,
  MyWinnings,
  BlockedUser,
  FreshDeskHelp,
  GoldenTicketView,
  GoldenTicketsView,
  GoldenMilestonesView,
  GoldBalanceDetailsView
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  final String name;

  PageAction currentPageAction;
  var returnValue;

  PageConfiguration({
    @required this.key,
    @required this.path,
    @required this.uiPage,
    @required this.name,
    this.currentPageAction,
  });

  @override
  String toString() {
    return 'PageConfiguration(key: $key, path: $path, uiPage: $uiPage, name: $name, currentPageAction: $currentPageAction, returnValue: $returnValue)';
  }
}

PageConfiguration SplashPageConfig = PageConfiguration(
  key: 'Splash',
  path: SplashPath,
  uiPage: Pages.Splash,
  name: 'Splash Screen',
);

PageConfiguration NotificationsConfig = PageConfiguration(
  key: 'Notifications',
  path: NotificationsPath,
  uiPage: Pages.Notifications,
  name: 'Notifications Screen',
);

PageConfiguration LoginPageConfig = PageConfiguration(
  key: 'Login',
  path: LoginPath,
  uiPage: Pages.Login,
  name: 'Login Screen',
);

PageConfiguration RootPageConfig = PageConfiguration(
  key: 'Root',
  path: RootPath,
  uiPage: Pages.Root,
  name: 'Root Screen',
);

PageConfiguration OnboardPageConfig = PageConfiguration(
  key: 'Onboard',
  path: OnboardPath,
  uiPage: Pages.Onboard,
  name: 'On Boarding Screen',
);

PageConfiguration UserProfileDetailsConfig = PageConfiguration(
  key: 'EditProfile',
  path: UserProfileDetailsPath,
  uiPage: Pages.UserProfileDetails,
  name: 'Edit Profile Screen',
);

PageConfiguration MfDetailsPageConfig = PageConfiguration(
  key: 'MfDetails',
  path: MfDetailsPath,
  uiPage: Pages.MfDetails,
  name: 'Mutual Fund Details Screen',
);

PageConfiguration AugDetailsPageConfig = PageConfiguration(
  key: 'AugDetails',
  path: AugDetailsPath,
  uiPage: Pages.AugDetails,
  name: 'Augmont Details Screen',
);

PageConfiguration TransactionPageConfig = PageConfiguration(
  key: 'Tran',
  path: TransactionPath,
  uiPage: Pages.Transaction,
  name: 'Transactions Screen',
);

PageConfiguration ReferralPageConfig = PageConfiguration(
  key: 'Referral',
  path: ReferralPath,
  uiPage: Pages.Referral,
  name: 'Referral Screen',
);

PageConfiguration FaqPageConfig = PageConfiguration(
  key: 'Faq',
  path: FaqPath,
  uiPage: Pages.Faq,
  name: 'FAQ Screen',
);

PageConfiguration AugOnboardPageConfig = PageConfiguration(
  key: 'AugOnboard',
  path: AugOnboardingPath,
  uiPage: Pages.AugOnboard,
  name: 'Augmont Onboarding Screen',
);

PageConfiguration AugWithdrawalPageConfig = PageConfiguration(
  key: 'AugWithdrawal',
  path: AugWithdrawalPath,
  uiPage: Pages.AugWithdrawal,
  name: 'Augmont Withdrawl Screen',
);

PageConfiguration EditAugBankDetailsPageConfig = PageConfiguration(
  key: 'EditAugBankDetails',
  path: EditAugBankDetailsPath,
  uiPage: Pages.EditAugBankDetails,
  name: 'Edit Augmont Bank Details Screen',
);

PageConfiguration RefPolicyPageConfig = PageConfiguration(
  key: 'RefPolicy',
  path: ReferralPolicyPath,
  uiPage: Pages.RefPolicy,
  name: 'Referral Policy Screen',
);

PageConfiguration ChatSupportPageConfig = PageConfiguration(
  key: 'ChatSupport',
  path: ChatSupportPath,
  uiPage: Pages.ChatSupport,
  name: 'Chat Support Screen',
);

PageConfiguration UpdateRequiredConfig = PageConfiguration(
  key: 'UpdateRequired',
  path: UpdateRequiredPath,
  uiPage: Pages.UpdateRequired,
  name: 'Update Required Screen',
);

PageConfiguration ClaimUsernamePageConfig = PageConfiguration(
  key: 'ClaimUsername',
  path: ClaimUsernamePath,
  uiPage: Pages.ClaimUsername,
  name: 'Claim Username Screen',
);

PageConfiguration VerifyEmailPageConfig = PageConfiguration(
  key: 'VerifyEmail',
  path: VerifyEmailPath,
  uiPage: Pages.VerifyEmail,
  name: 'Verify Email Screen',
);

PageConfiguration SupportPageConfig = PageConfiguration(
  key: 'Support',
  path: SupportPath,
  uiPage: Pages.Support,
  name: 'Support Screen',
);

PageConfiguration WalkThroughConfig = PageConfiguration(
  key: 'WalkThrough',
  path: WalkThroughPath,
  uiPage: Pages.WalkThrough,
  name: 'Walk Thorugh Screen',
);

PageConfiguration YourFundsConfig = PageConfiguration(
  key: 'YourFunds',
  path: YourFundsPath,
  uiPage: Pages.YourFunds,
  name: 'Your Funds Screen',
);

PageConfiguration THomePageConfig = PageConfiguration(
  key: 'THome',
  path: THome,
  uiPage: Pages.THome,
  name: 'Tambolla Home Screen',
);

PageConfiguration TGamePageConfig = PageConfiguration(
  key: 'TGame',
  path: TGame,
  uiPage: Pages.TGame,
  name: 'Tambola Game Screen',
);

PageConfiguration TWeeklyResultPageConfig = PageConfiguration(
  key: 'TWeeklyResult',
  path: TWeeklyResult,
  uiPage: Pages.TWeeklyResult,
  name: 'Tambola Weekly Result Screen',
);

PageConfiguration TPickDrawPageConfig = PageConfiguration(
  key: 'TPickDraw',
  path: TPickDraw,
  uiPage: Pages.TPickDraw,
  name: 'Tambola Pick Draw Screen',
);

PageConfiguration TShowAllTicketsPageConfig = PageConfiguration(
  key: 'TShowAllTickets',
  path: TShowAllTickets,
  uiPage: Pages.TShowAllTickets,
  name: 'Tambola Show All Tickets',
);

PageConfiguration TWalkthroughPageConfig = PageConfiguration(
  key: 'TWalkthrough',
  path: TWalkthrough,
  uiPage: Pages.TWalkthrough,
  name: 'Tambola Walkthrough Screeb',
);

PageConfiguration TSummaryDetailsPageConfig = PageConfiguration(
  key: 'TSummaryDetails',
  path: TSummaryDetails,
  uiPage: Pages.TSummaryDetails,
  name: 'Tambola Summary Screen',
);

PageConfiguration CricketHomePageConfig = PageConfiguration(
  key: 'CricketHome',
  path: CricketHomePath,
  uiPage: Pages.CricketHome,
  name: 'Cricket Home Screen',
);

PageConfiguration CricketGamePageConfig = PageConfiguration(
  key: 'CricketGame',
  path: CricketGamePath,
  uiPage: Pages.CricketGame,
  name: 'Cricket Game Screen',
);

PageConfiguration TransactionsHistoryPageConfig = PageConfiguration(
  key: 'TxnHistory',
  path: TransactionsHistoryPath,
  uiPage: Pages.TxnHistory,
  name: 'Transactions History Screen',
);

PageConfiguration KycDetailsPageConfig = PageConfiguration(
  key: 'KycDetails',
  path: KycDetailsPath,
  uiPage: Pages.KycDetails,
  name: 'KYC Details Screen',
);

PageConfiguration BankDetailsPageConfig = PageConfiguration(
  key: 'BankDetails',
  path: BankDetailsPath,
  uiPage: Pages.BankDetails,
  name: 'Bank Details Screen',
);

// PageConfiguration AugmontGoldBuyPageConfig = PageConfiguration(
//   key: 'augGoldBuy',
//   path: AugmontGoldBuyPath,
//   uiPage: Pages.AugGoldBuy,
//   name: 'Gold Buy Screen',
// );

PageConfiguration AugmontGoldSellPageConfig = PageConfiguration(
  key: 'augGoldSell',
  path: AugmontGoldSellPath,
  uiPage: Pages.AugGoldSell,
  name: 'Gold Sell Screen',
);

PageConfiguration AugmontGoldDetailsPageConfig = PageConfiguration(
  key: 'augGoldDetails',
  path: AugmontGoldDetailsPath,
  uiPage: Pages.AugGoldDetails,
  name: 'About Digital Gold Screen',
);

PageConfiguration ReferralDetailsPageConfig = PageConfiguration(
  key: 'referDetails',
  path: ReferralDetailsPath,
  uiPage: Pages.ReferralDetails,
  name: 'Referral Details Screen',
);

PageConfiguration ReferralHistoryPageConfig = PageConfiguration(
  key: 'referHistory',
  path: ReferralHistoryPath,
  uiPage: Pages.ReferralHistory,
  name: 'Refer History Screen',
);

PageConfiguration MyWinnigsPageConfig = PageConfiguration(
  key: 'myWinnings',
  path: MyWinningsPath,
  uiPage: Pages.MyWinnings,
  name: 'My Winnings Screen',
);

PageConfiguration BlockedUserPageConfig = PageConfiguration(
    key: 'blockedUser',
    path: BlockedUserPath,
    uiPage: Pages.BlockedUser,
    name: 'Blocked User Page');

PageConfiguration FreshDeskHelpPageConfig = PageConfiguration(
    key: 'freshDeskHelp',
    path: FreshdeskHelpPath,
    uiPage: Pages.FreshDeskHelp,
    name: 'FreshDesk Help');

PageConfiguration GoldenTicketViewPageConfig = PageConfiguration(
    key: 'GoldenTicketView',
    path: GoldenTicketViewPath,
    uiPage: Pages.GoldenTicketView,
    name: 'Golden Ticket Highlighted');

PageConfiguration GoldenTicketsViewPageConfig = PageConfiguration(
    key: 'GoldenTicketsView',
    path: GoldenTicketsViewPath,
    uiPage: Pages.GoldenTicketsView,
    name: 'Golden Tickets Screen');

PageConfiguration GoldenMilestonesViewPageConfig = PageConfiguration(
  key: 'GoldenMilestonesView',
  path: GoldenMilestonesViewPath,
  uiPage: Pages.GoldenMilestonesView,
  name: 'Milestones screen',
);

PageConfiguration GoldBalanceDetailsViewPageConfig = PageConfiguration(
  key: 'GoldBalanceDetailsView',
  path: GoldBalanceDetailsViewPath,
  uiPage: Pages.GoldBalanceDetailsView,
  name: 'Gold Balance Details Screen',
);
