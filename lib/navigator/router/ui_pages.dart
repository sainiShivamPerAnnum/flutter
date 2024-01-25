// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:felloapp/navigator/app_state.dart';

const String SplashPath = '/splash';
const String LoginPath = '/login';
const String AssetPreferencePath = '/assetPref';
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
const String YourFundsPath = '/yourFunds';
const String NotificationsPath = '/notifications';
const String THome = '/tHome';
const String TGame = '/tGame';
const String TWalkthrough = 'tWalkthrough';
const String TShowAllTickets = 'tShowAllTickets';
const String TPickDraw = 'tPickDraw';
const String TWeeklyResult = 'tWeeklyResult';
const String TSummaryDetails = 'tSummaryDetails';
const String TransactionsHistoryPath = 'transHistory';
const String KycDetailsPath = 'kycDetails';
const String BankDetailsPath = 'bankDetails';
const String AugmontGoldSellPath = '/augSell';
const String AugmontGoldDetailsPath = '/augDetails';
const String FloPremiumDetailsPath = '/floDetailsView';
const String ReferralDetailsPath = '/referralDetails';
const String ReferralHistoryPath = '/referralHistory';
const String MyWinningsPath = '/myWinnings';
const String BlockedUserPath = '/blockeUser';
const String FreshdeskHelpPath = '/freshDeskHelp';
const String ScratchCardViewPath = '/scratchCardView';
const String ScratchCardsViewPath = '/scratchCardsView';
const String GoldenMilestonesViewPath = '/goldenMilestonesView';
const String TopSaverViewPath = '/topSaverView';
const String AllParticipantsViewPath = '/allParticipantsView';
const String PoolViewPath = "/poolView";
const String WebHomeViewPath = "/webHomeView";
const String WebGameViewPath = "/webGameView";
const String AutosaveOnboardingViewPath = '/autosaveOnboardingView';
const String AutosaveProcessViewPath = '/autosaveProcessView';
const String AutosaveUpdateViewPath = '/autosaveUpdateView';
const String AutosaveDetailsViewPath = '/autosaveDetailsView';
const String AutosaveTransactionsViewPath = '/autosaveTransactionsViewPath';
const String NewGameHomeViewPath = '/newGameHome';
const String NewWebHomeViewPath = '/newWebHomeView';
const String TopPlayerLeaderboard = '/topPlayerLeaderboard';
const String JourneyViewPath = '/journeyViewPath';
const String OnBoardingPath = '/onBoardingPath';
const String CompleteProfilePath = '/CompleteProfileView';
const String BlogPostWebViewPath = '/blogPostWebView';
const String CampaignViewPath = '/campaignViewPath';
const String SaveAssetViewPath = '/saveAssetViewPath';
const String SellConfirmationViewPath = '/sellConfirmationViewPath';
const String ViewAllBlogsViewPath = '/viewAllBlogsViewPath';
const String AllParticipantsWinnersTopReferersPath =
    "/allParticipantsWinnersTopReferersPath";
const String RedeemSucessfulScreenPath = "/RedeemSucessfulScreenPath";
const String SharePriceScreenPath = "/SharePriceScreenPath";
const String AllTambolaTicketsPath = "/AllTambolaTicketsPath";
const String UserUPIDetailsViewPath = "/userUpiDetailsViewPath";
const String InfoStoriesViewPath = "/inforStoriesViewPath";
const String WebViewScreenPath = "/webViewScreenPath";
const String SettingsScreenPath = '/settingsScreenPath';
const String TExistingUserViewPath = '/texistingUserPath';
const String TNewUserViewPath = '/tnewUserViewPath';
const String TransactionDetailsPath = '/transactionDetailsPage';
const String AssetViewPath = '/assetViewSection';
const String LastWeekOverviewPath = '/lastWeekOverview';
const String AccountsPath = "/accountsViewPath";
const String PlayViewPath = "/playViewPath";

const String YoutubePlayerViewPath = "/youtubePlayerViewPath";
const String EarnMoreReturnsViewPath = "/earnMoreReturnsViewPath";
//POWER PLAY PATHS
const String PowerPlayPath = '/powerPlayPath';
const String PowerPlayLeaderBoardPath = '/powerPlayLeaderBoardPath';
const String PowerPlayHowItWorksPath = '/powerPlayHowItWorksPath';
const String FppCompletedMatchDetailsPath = "fppCompletedMatchDetailsPath";
const String PowerPlayFTUXPath = '/powerPlayFTUXPath';
const String PowerPlaySeasonLeaderboardPath = "powerplaySeasonLeaderboardPath";
const String LendboxBuyViewPath = "/LendboxBuyViewPath";
const String AssetSelectionViewPath = "/assetSelectionViewPath";
const String QuizWebViewPath = "/quizWebViewPath";
const String BalloonLottieScreenPath = "/bolloonLottieScreenPath";
const String MaturityWithdrawalSuccessViewPath =
    "/maturityWithdrawalSuccessViewPath";
const String FelloBadgeHomePath = "/felloBadgeHomePath";
const String StoriesPath = "/storiesPath";

//GoldPro
const String GoldProDetailsPath = "/goldProDetailsPath";
const String GoldProBuyViewPath = "/goldProBuyPath";
const String GoldProSellViewPath = "/goldProSellView";
const String GoldProTxnsViewPath = "/goldProTxnsView";
const String GoldProTxnsDetailsViewPath = "goldProTxnsDetailsView";

//Tickets
const String TicketsIntroViewPath = "/ticketsIntroViewPath";
const String TicketsTutorialViewPath = "/ticketsTutorialViewPath";

const String SipPageViewPath = "/sip";

enum Pages {
  Splash,
  Login,
  AssetPreference,
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
  YourFunds,
  THome,
  TNewUser,
  TExistingUser,
  TGame,
  TWeeklyResult,
  AssetViewSection,
  TWalkthrough,
  TPickDraw,
  TShowAllTickets,
  TSummaryDetails,
  Notifications,
  TxnHistory,
  KycDetails,
  BankDetails,
  AugGoldSell,
  AugGoldDetails,
  FloPremiumDetails,
  ReferralDetails,
  ReferralHistory,
  MyWinnings,
  BlockedUser,
  FreshDeskHelp,
  ScratchCardView,
  ScratchCardsView,
  GoldenMilestonesView,
  TopSaverView,
  AllParticipantsView,
  PoolView,
  WebHomeView,
  WebGameView,
  AutosaveOnboardingView,
  AutosaveProcessView,
  AutosaveDetailsView,
  AutosaveTransactionsView,
  AutosaveUpdateView,
  NewWebHomeView,
  TopPlayerLeaderboard,
  JourneyView,
  OnBoardingView,
  CompleteProfileView,
  BlogPostWebView,
  CampaignView,
  SaveAssetView,
  SellConfirmationView,
  ViewAllBlogsView,
  AllParticipantsWinnersTopReferrersView,
  RedeemSuccessfulScreenView,
  SharePriceScreenView,
  AllTambolaTicketsView,
  UserUpiDetailsView,
  InfoStoriesView,
  WebView,
  SettingsView,
  TransactionDetailsPage,
  LastWeekOverview,
  AccountsView,
  PlayView,
  YoutubePlayerView,
  EarnMoreReturnsView,
  //POWER PLAY
  PowerPlayHome,
  PowerPlayLeaderBoard,
  PowerPlayHowItWorks,
  FppCompletedMatchDetails,
  PowerPlayFTUX,
  PowerPlaySeasonLeaderboard,
  LendboxBuyView,
  AssetSelectionView,
  QuizWebView,
  BalloonLottieScreen,
  MaturityWithdrawalSuccessView,
  FelloBadgeHome,
  //GOLDPRO
  GoldProDetailsView,
  GoldProBuyView,
  GoldProSellView,
  GoldProTxnsView,
  GoldProTxnsDetailsView,
  //TICKETS
  TicketsIntroViewPath,
  TicketsTutorialViewPath,
  Sip,
  Stories,
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  final String? name;
  PageAction? currentPageAction;

  PageConfiguration({
    required this.key,
    required this.path,
    required this.uiPage,
    this.name,
    this.currentPageAction,
  });

  @override
  String toString() {
    return 'PageConfiguration(key: $key, path: $path, uiPage: $uiPage, name: $name, currentPageAction: $currentPageAction)';
  }
}

PageConfiguration SplashPageConfig = PageConfiguration(
  key: 'Splash',
  path: SplashPath,
  uiPage: Pages.Splash,
  name: 'Splash Screen',
);
PageConfiguration AssetViewPageConfig = PageConfiguration(
    key: 'AssetView',
    path: AssetViewPath,
    uiPage: Pages.AssetViewSection,
    name: 'AssetViewScreen');

PageConfiguration TransactionDetailsPageConfig = PageConfiguration(
    key: 'TransactionDetailsPage',
    path: TransactionDetailsPath,
    uiPage: Pages.TransactionDetailsPage,
    name: 'TransactionDetails Screen');

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

PageConfiguration AssetPrefPageConfig = PageConfiguration(
  key: 'AssetPref',
  path: AssetPreferencePath,
  uiPage: Pages.AssetPreference,
  name: 'Asset Preference Screen',
);

PageConfiguration RootPageConfig = PageConfiguration(
  key: 'Root',
  path: RootPath,
  uiPage: Pages.Root,
  name: 'Root',
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

PageConfiguration TambolaExistingUser = PageConfiguration(
    key: 'TexistingUser',
    path: TExistingUserViewPath,
    uiPage: Pages.TExistingUser,
    name: 'TexistingUser Screen');

PageConfiguration TambolaNewUser = PageConfiguration(
    key: 'TNewUser',
    path: TNewUserViewPath,
    uiPage: Pages.TNewUser,
    name: 'TNewUser Screen');

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

PageConfiguration FloPremiumDetailsPageConfig = PageConfiguration(
  key: 'lendboxDetails',
  path: FloPremiumDetailsPath,
  uiPage: Pages.FloPremiumDetails,
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

PageConfiguration MyWinningsPageConfig = PageConfiguration(
  key: 'myWinnings',
  path: MyWinningsPath,
  uiPage: Pages.MyWinnings,
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

PageConfiguration ScratchCardViewPageConfig = PageConfiguration(
    key: 'ScratchCardView',
    path: ScratchCardViewPath,
    uiPage: Pages.ScratchCardView,
    name: 'Scratch Card Highlighted');

PageConfiguration ScratchCardsViewPageConfig = PageConfiguration(
    key: 'ScratchCardsView',
    path: ScratchCardsViewPath,
    uiPage: Pages.ScratchCardsView,
    name: 'Golden Tickets Screen');

PageConfiguration GoldenMilestonesViewPageConfig = PageConfiguration(
  key: 'GoldenMilestonesView',
  path: GoldenMilestonesViewPath,
  uiPage: Pages.GoldenMilestonesView,
  name: 'Milestones screen',
);

PageConfiguration TopSaverViewPageConfig = PageConfiguration(
  key: 'TopSaverView',
  path: TopSaverViewPath,
  uiPage: Pages.TopSaverView,
  name: 'TopSaverView screen',
);

PageConfiguration AllParticipantsViewPageConfig = PageConfiguration(
  key: 'AllParticipantsView',
  path: AllParticipantsViewPath,
  uiPage: Pages.AllParticipantsView,
  name: 'AllParticipantsView screen',
);

PageConfiguration WebHomeViewPageConfig = PageConfiguration(
  key: 'WebHomeView',
  path: WebHomeViewPath,
  uiPage: Pages.WebHomeView,
);
PageConfiguration WebGameViewPageConfig = PageConfiguration(
  key: 'WebGameView',
  path: WebGameViewPath,
  uiPage: Pages.WebGameView,
);
PageConfiguration PoolViewPageConfig = PageConfiguration(
  key: 'PoolView',
  path: PoolViewPath,
  uiPage: Pages.PoolView,
  name: 'Pool View Screen',
);

PageConfiguration AutosaveOnboardingViewPageConfig = PageConfiguration(
  key: 'AutosaveOnboardingView',
  path: AutosaveOnboardingViewPath,
  uiPage: Pages.AutosaveOnboardingView,
  name: 'Autosave Onboarding Screen',
);

PageConfiguration AutosaveProcessViewPageConfig = PageConfiguration(
  key: 'AutosaveProcessView',
  path: AutosaveProcessViewPath,
  uiPage: Pages.AutosaveProcessView,
);

PageConfiguration AutosaveUpdateViewPageConfig = PageConfiguration(
  key: 'AutosaveUpdateView',
  path: AutosaveProcessViewPath,
  uiPage: Pages.AutosaveUpdateView,
);

PageConfiguration AutosaveDetailsViewPageConfig = PageConfiguration(
  key: 'AutosaveDetailsView',
  path: AutosaveDetailsViewPath,
  uiPage: Pages.AutosaveDetailsView,
);

PageConfiguration AutosaveTransactionsViewPageConfig = PageConfiguration(
    key: 'AutosaveTransactionsView',
    path: AutosaveTransactionsViewPath,
    uiPage: Pages.AutosaveTransactionsView,
    name: "Autosave transaction Screen");

PageConfiguration NewWebHomeViewPageConfig = PageConfiguration(
  key: 'NewWebHomeView',
  path: NewWebHomeViewPath,
  uiPage: Pages.NewWebHomeView,
  name: "New Web Home Screen",
);

PageConfiguration TopPlayerLeaderboardPageConfig = PageConfiguration(
  key: 'TopPlayerLeaderboard',
  path: TopPlayerLeaderboard,
  uiPage: Pages.TopPlayerLeaderboard,
);
PageConfiguration JourneyViewPageConfig = PageConfiguration(
    key: 'JourneyView',
    path: JourneyViewPath,
    uiPage: Pages.JourneyView,
    name: "Journey Screen");

PageConfiguration OnBoardingViewPageConfig = PageConfiguration(
  key: 'OnBoardingView',
  path: OnBoardingPath,
  uiPage: Pages.OnBoardingView,
);
PageConfiguration CompleteProfileViewPageConfig = PageConfiguration(
    key: 'CompleteProfileView',
    path: CompleteProfilePath,
    uiPage: Pages.CompleteProfileView,
    name: "Level2 Screen");

PageConfiguration BlogPostWebViewConfig = PageConfiguration(
    key: 'BlogPostWeb',
    path: BlogPostWebViewPath,
    uiPage: Pages.BlogPostWebView,
    name: "Journey Screen");

PageConfiguration CampaignViewPageConfig = PageConfiguration(
  key: 'CampaignView',
  path: CampaignViewPath,
  uiPage: Pages.CampaignView,
  name: "Campaign View Screen",
);

PageConfiguration SaveAssetsViewConfig = PageConfiguration(
  key: 'SaveAssetsView',
  path: SaveAssetViewPath,
  uiPage: Pages.SaveAssetView,
);

PageConfiguration SellConfirmationViewConfig = PageConfiguration(
  key: 'SellConfirmationView',
  path: SellConfirmationViewPath,
  uiPage: Pages.SellConfirmationView,
  name: "Sell Confirmation View",
);

PageConfiguration ViewAllBlogsViewConfig = PageConfiguration(
  key: 'SellConfirmationView',
  path: ViewAllBlogsViewPath,
  uiPage: Pages.ViewAllBlogsView,
  name: "View All Blogs View",
);

PageConfiguration AllParticipantsWinnersTopReferrersConfig = PageConfiguration(
  key: 'AllParticipantsWinnersTopReferersView',
  path: AllParticipantsWinnersTopReferersPath,
  uiPage: Pages.AllParticipantsWinnersTopReferrersView,
);

PageConfiguration RedeemSuccessfulScreenPageConfig = PageConfiguration(
  key: 'RedeemSucessfulScreenView',
  path: RedeemSucessfulScreenPath,
  uiPage: Pages.RedeemSuccessfulScreenView,
  name: "Redeem Sucessfull View",
);

PageConfiguration SharePriceScreenPageConfig = PageConfiguration(
  key: 'SharePriceScreenView',
  path: SharePriceScreenPath,
  uiPage: Pages.SharePriceScreenView,
  name: "Reward sharing screen",
);

PageConfiguration AllTambolaTicketsPageConfig = PageConfiguration(
  key: 'AllTambolaTickets',
  path: AllTambolaTicketsPath,
  uiPage: Pages.AllTambolaTicketsView,
);
PageConfiguration UserUpiDetailsViewPageConfig = PageConfiguration(
    key: 'UserUpiDetailsView',
    path: UserUPIDetailsViewPath,
    uiPage: Pages.UserUpiDetailsView,
    name: "User Upi details Screen");

PageConfiguration InfoStoriesViewPageConfig = PageConfiguration(
    key: 'InfoStoresView',
    path: InfoStoriesViewPath,
    uiPage: Pages.InfoStoriesView,
    name: "Info Stories details Screen");

PageConfiguration WebViewPageConfig = PageConfiguration(
    key: 'WebView',
    path: WebViewScreenPath,
    uiPage: Pages.WebView,
    name: "Web browser Screen");

PageConfiguration SettingsViewPageConfig = PageConfiguration(
    key: 'SettingsView',
    path: SettingsScreenPath,
    uiPage: Pages.SettingsView,
    name: "Settings Screen");

//POWER PLAY
PageConfiguration PowerPlayHomeConfig = PageConfiguration(
    key: 'PowerPlayPath',
    path: PowerPlayPath,
    uiPage: Pages.PowerPlayHome,
    name: "PowerPlay Home Screen");

PageConfiguration PowerPlayLeaderBoardConfig = PageConfiguration(
    key: 'PowerPlayLeaderBoardPath',
    path: PowerPlayLeaderBoardPath,
    uiPage: Pages.PowerPlayLeaderBoard,
    name: "PowerPlay LeaderBoard Screen");

PageConfiguration PowerPlayHowItWorksConfig = PageConfiguration(
    key: 'PowerPlayHowItWorksPath',
    path: PowerPlayHowItWorksPath,
    uiPage: Pages.PowerPlayHowItWorks,
    name: "PowerPlay HowItWorks Screen");

PageConfiguration FppCompletedMatchDetailsConfig = PageConfiguration(
    key: 'FppCompletedMatchDetailsPath',
    path: FppCompletedMatchDetailsPath,
    uiPage: Pages.FppCompletedMatchDetails,
    name: "PowerPlay Completed Match Details Screen");

PageConfiguration PowerPlayFTUXPageConfig = PageConfiguration(
    key: 'powerPlayFTUXPath',
    path: PowerPlayFTUXPath,
    uiPage: Pages.PowerPlayFTUX,
    name: "PowerPlay Welcome Screen");

PageConfiguration PowerPlaySeasonLeaderboardDetailsConfig = PageConfiguration(
    key: 'PowerPlaySeasonLeaderboardDetailsPath',
    path: PowerPlaySeasonLeaderboardPath,
    uiPage: Pages.PowerPlaySeasonLeaderboard,
    name: "PowerPlay Season Leaderboard Screen");

PageConfiguration LastWeekOverviewConfig = PageConfiguration(
    key: 'LastWeekOverviewPath',
    path: LastWeekOverviewPath,
    uiPage: Pages.LastWeekOverview,
    name: "Last Week Overview Screen");

PageConfiguration AccountsViewConfig = PageConfiguration(
    key: 'AccountsViewPath',
    path: AccountsPath,
    uiPage: Pages.AccountsView,
    name: "Accounts View Screen");

PageConfiguration PlayViewConfig = PageConfiguration(
    key: 'PlayViewConfig',
    path: PlayViewPath,
    uiPage: Pages.PlayView,
    name: "Play View Screen");

PageConfiguration YoutubePlayerViewConfig = PageConfiguration(
    key: 'YoutubePlayerPath',
    path: YoutubePlayerViewPath,
    uiPage: Pages.YoutubePlayerView,
    name: "Youtube Player View Screen");

PageConfiguration EarnMoreReturnsViewPageConfig = PageConfiguration(
    key: 'EarnMoreReturnsViewPath',
    path: EarnMoreReturnsViewPath,
    uiPage: Pages.EarnMoreReturnsView,
    name: "Earn more rewards view screen");

PageConfiguration LendboxBuyViewConfig = PageConfiguration(
    key: 'LendboxBuyViewPath',
    path: LendboxBuyViewPath,
    uiPage: Pages.LendboxBuyView,
    name: "Lendbox Buy View Screen");

PageConfiguration AssetSelectionViewConfig = PageConfiguration(
    key: 'AssetSelectionViewPath',
    path: AssetSelectionViewPath,
    uiPage: Pages.AssetSelectionView,
    name: "Asset Selection View Screen");

PageConfiguration QuizWebViewConfig = PageConfiguration(
    key: 'QuizWebViewPath',
    path: QuizWebViewPath,
    uiPage: Pages.QuizWebView,
    name: "Quiz Web View Screen");

PageConfiguration BalloonLottieScreenViewConfig = PageConfiguration(
    key: 'BalloonLottieScreenViewPath',
    path: BalloonLottieScreenPath,
    uiPage: Pages.BalloonLottieScreen,
    name: "Balloon Lottie Screen View Screen");

PageConfiguration GoldProDetailsViewPageConfig = PageConfiguration(
    key: 'GoldProDetailsViewPath',
    path: GoldProDetailsPath,
    uiPage: Pages.GoldProDetailsView,
    name: "Gold X Details View Screen");

PageConfiguration GoldProBuyViewPageConfig = PageConfiguration(
    key: 'GoldProBuyViewPath',
    path: GoldProBuyViewPath,
    uiPage: Pages.GoldProBuyView,
    name: "Gold X Buy View Screen");

PageConfiguration GoldProSellViewPageConfig = PageConfiguration(
    key: 'GoldProSellViewPath',
    path: GoldProSellViewPath,
    uiPage: Pages.GoldProSellView,
    name: "Gold X Sell View Screen");

PageConfiguration GoldProTxnsViewPageConfig = PageConfiguration(
    key: 'GoldProTxnsViewPath',
    path: GoldProTxnsViewPath,
    uiPage: Pages.GoldProTxnsView,
    name: "Gold X Txns View Screen");

PageConfiguration GoldProTxnsDetailsViewPageConfig = PageConfiguration(
    key: 'GoldProTxnsDetailsViewPath',
    path: GoldProTxnsDetailsViewPath,
    uiPage: Pages.GoldProTxnsDetailsView,
    name: "Gold X Txns Details View Screen");

PageConfiguration TicketsIntroViewPageConfig = PageConfiguration(
    key: 'TicketsIntroViewPath',
    path: TicketsIntroViewPath,
    uiPage: Pages.TicketsIntroViewPath,
    name: "Tickets Intro View Screen");

PageConfiguration TicketsTutorialViewPageConfig = PageConfiguration(
    key: 'TicketsTutorialViewPath',
    path: TicketsTutorialViewPath,
    uiPage: Pages.TicketsTutorialViewPath,
    name: "Tickets Tutorial View Screen");
PageConfiguration MaturityWithdrawalSuccessViewPageConfig = PageConfiguration(
    key: 'MaturityWithdrawalSuccessViewPath',
    path: MaturityWithdrawalSuccessViewPath,
    uiPage: Pages.MaturityWithdrawalSuccessView,
    name: "Maturity Withdrawal Success View Screen");

PageConfiguration FelloBadgeHomeViewPageConfig = PageConfiguration(
    key: 'FelloBadgeHomeViewPath',
    path: FelloBadgeHomePath,
    uiPage: Pages.FelloBadgeHome,
    name: "Fello Badge Home View Screen");

PageConfiguration SipPageConfig = PageConfiguration(
  key: 'Sip',
  path: SipPageViewPath,
  uiPage: Pages.Sip,
  name: 'Login Screen',
);
PageConfiguration StoriesPageConfig = PageConfiguration(
  key: 'StoriesViewPath',
  path: StoriesPath,
  uiPage: Pages.Stories,
  name: "New user stories",
);
