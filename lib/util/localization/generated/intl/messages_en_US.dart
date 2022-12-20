// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_US';

  static String m0(version) => "Version ${version}";

  static String m1(prizeAmount) => "Win upto Rs.${prizeAmount}";

  static String m2(index) => "Milestone ${index}";

  static String m3(prizeAmount) =>
      "I\'ve won ₹\$${prizeAmount} as\nDigital Gold on Fello!";

  static String m4(servingSize) => "*Based on ${servingSize} fl. oz serving.";

  static String m5(quantity, formattedNumber) =>
      "${Intl.plural(quantity, one: 'One serving.', other: '${formattedNumber} servings in your system at one time.')}";

  static String m6(quantity, formattedNumber) =>
      "${Intl.plural(quantity, one: 'One serving per day.', other: '${formattedNumber} servings per day.')}";

  static String m7(goldAmount) => "${goldAmount} gm";

  static String m8(winningsAmout) => "₹ ${winningsAmout}";

  static String m9(cost) => "SKIP WITH ${cost} TOKENS";

  static String m10(ticketType) => "Win a ${ticketType} ticket";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "ObGenderLabel": MessageLookupByLibrary.simpleMessage("Gender"),
        "abBuyDigitalGold":
            MessageLookupByLibrary.simpleMessage("Buy Digital Gold"),
        "abCompleteYourProfile":
            MessageLookupByLibrary.simpleMessage("Complete your profile"),
        "abGamingName": MessageLookupByLibrary.simpleMessage("Pick a Username"),
        "abMyProfile": MessageLookupByLibrary.simpleMessage("My Profile"),
        "abNotifications": MessageLookupByLibrary.simpleMessage("Alerts"),
        "addBankInformationText":
            MessageLookupByLibrary.simpleMessage("Add Bank information"),
        "app_version": m0,
        "balanceText": MessageLookupByLibrary.simpleMessage("Balance"),
        "blogsSubTitle": MessageLookupByLibrary.simpleMessage(
            "Read about the world of games and finance"),
        "blogsTitle": MessageLookupByLibrary.simpleMessage("Fin-gyan"),
        "btnCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "btnComplete": MessageLookupByLibrary.simpleMessage("Complete"),
        "btnDownloadInvoice":
            MessageLookupByLibrary.simpleMessage("Download Invoice"),
        "btnEdit": MessageLookupByLibrary.simpleMessage("Edit"),
        "btnEnable": MessageLookupByLibrary.simpleMessage("Enable"),
        "btnGrantPermission":
            MessageLookupByLibrary.simpleMessage("Grant Permission"),
        "btnLetsGo": MessageLookupByLibrary.simpleMessage("Let\'s Go"),
        "btnLoading": MessageLookupByLibrary.simpleMessage("Loading"),
        "btnNo": MessageLookupByLibrary.simpleMessage("No"),
        "btnNotNow": MessageLookupByLibrary.simpleMessage("Not Now"),
        "btnNotifyMe": MessageLookupByLibrary.simpleMessage("NOTIFY ME"),
        "btnPlay": MessageLookupByLibrary.simpleMessage("PLAY"),
        "btnRetry": MessageLookupByLibrary.simpleMessage("Retry"),
        "btnSave": MessageLookupByLibrary.simpleMessage("Save"),
        "btnSaveNow": MessageLookupByLibrary.simpleMessage("Save Now"),
        "btnSeeAll": MessageLookupByLibrary.simpleMessage("See All"),
        "btnSignout": MessageLookupByLibrary.simpleMessage("SIGN OUT"),
        "btnSkipWithTokens":
            MessageLookupByLibrary.simpleMessage("SKIP WITH TOKENS"),
        "btnStartPlaying":
            MessageLookupByLibrary.simpleMessage("Start Playing"),
        "btnSumbit": MessageLookupByLibrary.simpleMessage("Submit"),
        "btnUpdate": MessageLookupByLibrary.simpleMessage("Update"),
        "btnWin": MessageLookupByLibrary.simpleMessage("WIN"),
        "btnYes": MessageLookupByLibrary.simpleMessage("Yes"),
        "buyGold":
            MessageLookupByLibrary.simpleMessage("Buy 24K pure Digital Gold"),
        "challenges": MessageLookupByLibrary.simpleMessage("Challenges"),
        "chooseYourAsset":
            MessageLookupByLibrary.simpleMessage("Choose your asset"),
        "completeKYCText": MessageLookupByLibrary.simpleMessage("Complete KYC"),
        "contestTitle": MessageLookupByLibrary.simpleMessage(
            "Take part in fun and exciting contests"),
        "couponApplied":
            MessageLookupByLibrary.simpleMessage(" coupon applied"),
        "currentTokens":
            MessageLookupByLibrary.simpleMessage("Current Tokens:"),
        "dAbtDigGold":
            MessageLookupByLibrary.simpleMessage("About Digital Gold"),
        "dPanNkyc": MessageLookupByLibrary.simpleMessage("PAN & KYC"),
        "dReferNEarn": MessageLookupByLibrary.simpleMessage("Refer and Earn"),
        "dTransactions": MessageLookupByLibrary.simpleMessage("Transactions"),
        "dhowitworks": MessageLookupByLibrary.simpleMessage("How it works?"),
        "digitalGoldText": MessageLookupByLibrary.simpleMessage("Digital Gold"),
        "earnOneToken": MessageLookupByLibrary.simpleMessage(
            "Earn 1 Token for every ₹1 you invest"),
        "enableSellGold": MessageLookupByLibrary.simpleMessage(
            "To enable selling gold, complete the following:"),
        "felloFloEarnTxt":
            MessageLookupByLibrary.simpleMessage("Enjoy stable returns of 10%"),
        "felloFloText": MessageLookupByLibrary.simpleMessage("Fello Flo"),
        "gameOfWeek": MessageLookupByLibrary.simpleMessage("Game of the week"),
        "gameRewardsAmount": m1,
        "gameWinUptoTitle": MessageLookupByLibrary.simpleMessage("Win upto "),
        "gamesSafetySubTitle": MessageLookupByLibrary.simpleMessage(
            "Fello games do not use any money from your savings or investments"),
        "gamesSafetyTitle": MessageLookupByLibrary.simpleMessage(
            "Games are played with Fello tokens"),
        "get1Token": MessageLookupByLibrary.simpleMessage(
            "Get 1 token for every Rupee saved"),
        "getGoldenTickets": MessageLookupByLibrary.simpleMessage(
            "Earn Golden Tickets for every referral"),
        "getHappyHourNotified": MessageLookupByLibrary.simpleMessage(
            "Get notified when the next happy hour is live"),
        "getStartedWithSIP": MessageLookupByLibrary.simpleMessage(
            "Get started with a weekly/ daily SIP"),
        "goldPurchased":
            MessageLookupByLibrary.simpleMessage("Gold Purchased:"),
        "goldSellReason": MessageLookupByLibrary.simpleMessage(
            "What makes you want to sell?"),
        "goldSellingCapacity": MessageLookupByLibrary.simpleMessage(
            "Upto ₹ 50,000 can be sold at one go."),
        "goldSold": MessageLookupByLibrary.simpleMessage("Gold Sold:"),
        "happyHourIsOver":
            MessageLookupByLibrary.simpleMessage("Happy Hour is over"),
        "happyHourNotificationSetPrimary": MessageLookupByLibrary.simpleMessage(
            "Your Happy hour notifications is set!"),
        "happyHourNotificationSetSecondary":
            MessageLookupByLibrary.simpleMessage(
                "We will notify you before the next happy hour starts"),
        "happyHoursEndingin":
            MessageLookupByLibrary.simpleMessage("Happy Hour ending in "),
        "howToParticipate":
            MessageLookupByLibrary.simpleMessage("How to participate"),
        "investSafelyInGoldText": MessageLookupByLibrary.simpleMessage(
            "Invest safely in Gold\nwith our Auto SIP to win tokens"),
        "jBanner1": MessageLookupByLibrary.simpleMessage("Hello World"),
        "jBanner2": MessageLookupByLibrary.simpleMessage(
            "Welcome to this Universe and win "),
        "jFailed":
            MessageLookupByLibrary.simpleMessage("Journey failed to load"),
        "jInvestAmountTitile":
            MessageLookupByLibrary.simpleMessage("Amount of Invest"),
        "jLevel": MessageLookupByLibrary.simpleMessage("Level "),
        "jLoadinglevels": MessageLookupByLibrary.simpleMessage(
            "Loading more levels for you,please wait"),
        "jMileStone": m2,
        "jMileStoneSKipSuccessTitle1": MessageLookupByLibrary.simpleMessage(
            "Milestone Skipped Successfully"),
        "jMileStoneSKipSuccessTitle2": MessageLookupByLibrary.simpleMessage(
            "Let\'s get to the next milestone"),
        "jSkipMileStone":
            MessageLookupByLibrary.simpleMessage("SKIP MILESTONE"),
        "jSkipMileStoneDesc": MessageLookupByLibrary.simpleMessage(
            "To skip this milestone and go one level ahead, save in any of the asset"),
        "jSkipMilestoneSecondary":
            MessageLookupByLibrary.simpleMessage("Skip Milestone?"),
        "jWon": MessageLookupByLibrary.simpleMessage("YOU WON"),
        "kycGrantPermissionText": MessageLookupByLibrary.simpleMessage(
            "Please grant camera access permission to continue"),
        "kycNameLabel":
            MessageLookupByLibrary.simpleMessage("Name as per your PAN Card"),
        "kycPanUpload":
            MessageLookupByLibrary.simpleMessage("Upload your PAN Card"),
        "kycTitle": MessageLookupByLibrary.simpleMessage("KYC DETAILS"),
        "kycUseCamera": MessageLookupByLibrary.simpleMessage("Use Camera"),
        "kycVerifyText": MessageLookupByLibrary.simpleMessage(
            "This is required to securely verify your identity."),
        "mileStoneCompleted": MessageLookupByLibrary.simpleMessage(
            "You have completed this milestone"),
        "minimumAmount":
            MessageLookupByLibrary.simpleMessage("Minimum sell amount is ₹ 10"),
        "missedHappyHour": MessageLookupByLibrary.simpleMessage(
            "Missed out on the happy hour offer?"),
        "moreGamesSubTitle": MessageLookupByLibrary.simpleMessage(
            "New games are added regularly. Keep checking out"),
        "moreGamesTitle":
            MessageLookupByLibrary.simpleMessage("Explore More Games"),
        "navBarJourney": MessageLookupByLibrary.simpleMessage("Journey"),
        "navBarPlay": MessageLookupByLibrary.simpleMessage("Play"),
        "navBarSave": MessageLookupByLibrary.simpleMessage("Save"),
        "navBarWin": MessageLookupByLibrary.simpleMessage("Win"),
        "navWMT": MessageLookupByLibrary.simpleMessage("Earn more tokens"),
        "needHelp": MessageLookupByLibrary.simpleMessage("Need more help?"),
        "noTransaction":
            MessageLookupByLibrary.simpleMessage("No transactions to show yet"),
        "obAgreeText": MessageLookupByLibrary.simpleMessage(
            "By continuing, you agree to our "),
        "obAppLock": MessageLookupByLibrary.simpleMessage("App Lock"),
        "obBankDetails":
            MessageLookupByLibrary.simpleMessage("Your Bank Account Details"),
        "obBlockedAb":
            MessageLookupByLibrary.simpleMessage("Account Information"),
        "obBlockedSubtitle1": MessageLookupByLibrary.simpleMessage(
            "Your Fello Account has been banned for activity that violates our policy"),
        "obBlockedTitle": MessageLookupByLibrary.simpleMessage(
            "Your Account Has Been blocked"),
        "obDateFieldVal":
            MessageLookupByLibrary.simpleMessage("Date field cannot be empty"),
        "obDidntGetOtp":
            MessageLookupByLibrary.simpleMessage("Didn\'t receive? "),
        "obDobLabel": MessageLookupByLibrary.simpleMessage("Date of Birth"),
        "obDone": MessageLookupByLibrary.simpleMessage("DONE"),
        "obEdit": MessageLookupByLibrary.simpleMessage("EDIT"),
        "obEmailHint":
            MessageLookupByLibrary.simpleMessage("Enter your email address"),
        "obEmailLabel": MessageLookupByLibrary.simpleMessage("Email Address"),
        "obEnterDetails": MessageLookupByLibrary.simpleMessage("Enter Details"),
        "obEnterDetailsTitle": MessageLookupByLibrary.simpleMessage(
            "You\'re one step away from 10% returns"),
        "obEnterMobile": MessageLookupByLibrary.simpleMessage(
            " Enter your 10 digit phone number"),
        "obEverInvestedLabel":
            MessageLookupByLibrary.simpleMessage("Ever saved or invested"),
        "obFinish": MessageLookupByLibrary.simpleMessage("FINISH"),
        "obGenderFemale": MessageLookupByLibrary.simpleMessage("Female"),
        "obGenderHint":
            MessageLookupByLibrary.simpleMessage("Select your gender"),
        "obGenderLabel": MessageLookupByLibrary.simpleMessage("Gender"),
        "obGenderMale": MessageLookupByLibrary.simpleMessage("Male"),
        "obGenderOthers":
            MessageLookupByLibrary.simpleMessage("Rather not say"),
        "obHelp": MessageLookupByLibrary.simpleMessage("Help"),
        "obInValidDate": MessageLookupByLibrary.simpleMessage("Invalid date"),
        "obIsOlder": MessageLookupByLibrary.simpleMessage(
            "By proceeding, you agree that you are 18 years and older."),
        "obJoinUsBottomTitle": MessageLookupByLibrary.simpleMessage(
            "Join over 5 Lakh users who save and win with us!"),
        "obKYCDetailsLabel":
            MessageLookupByLibrary.simpleMessage("Your KYC Details"),
        "obLoading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "obLoggingInWith":
            MessageLookupByLibrary.simpleMessage("Logging in with"),
        "obLoginHeading": MessageLookupByLibrary.simpleMessage("Login/Sign up"),
        "obMobileLabel": MessageLookupByLibrary.simpleMessage("Mobile Number"),
        "obNameAsPerPan": MessageLookupByLibrary.simpleMessage(
            "Please enter your name as per PAN"),
        "obNameHint": MessageLookupByLibrary.simpleMessage("Enter Full name"),
        "obNameLabel": MessageLookupByLibrary.simpleMessage("Name"),
        "obNameRules": MessageLookupByLibrary.simpleMessage(
            "At least 3 characters required"),
        "obNeedHelp": MessageLookupByLibrary.simpleMessage("Need Help?"),
        "obNext": MessageLookupByLibrary.simpleMessage("NEXT"),
        "obOtpLabel": MessageLookupByLibrary.simpleMessage("Verify OTP"),
        "obOtpRequest": MessageLookupByLibrary.simpleMessage(
            "Didn\'t get an OTP? Request in "),
        "obOtpTryExceed": MessageLookupByLibrary.simpleMessage(
            "OTP requests exceeded. Please try again in sometime or contact us."),
        "obResend": MessageLookupByLibrary.simpleMessage("RESEND"),
        "obTermsofService":
            MessageLookupByLibrary.simpleMessage("Terms of Service"),
        "obUpdateAvatar": MessageLookupByLibrary.simpleMessage("Update Avatar"),
        "obUsernameHint":
            MessageLookupByLibrary.simpleMessage("Enter a username"),
        "obUsernameLabel": MessageLookupByLibrary.simpleMessage("Username"),
        "obUsernameRule1": MessageLookupByLibrary.simpleMessage(
            "must be more than 4 and less than 20 letters"),
        "obUsernameRule2": MessageLookupByLibrary.simpleMessage(
            "only lowercase alphabets, numbers and dot(.) symbols allowed."),
        "obUsernameRule3": MessageLookupByLibrary.simpleMessage(
            "consecutive dot(.) are not allowed. example: abc..xyz is an invalid username"),
        "obUsernameRule4": MessageLookupByLibrary.simpleMessage(
            "dot(.) are not allowed at the beginning and at the end example: .abc , abcd. are invalid usernames "),
        "obUsernameRulesTitle":
            MessageLookupByLibrary.simpleMessage("Rules for a valid username"),
        "obValidEmail":
            MessageLookupByLibrary.simpleMessage("Please enter a valid email"),
        "offline": MessageLookupByLibrary.simpleMessage("Offline"),
        "onboardText1": MessageLookupByLibrary.simpleMessage(
            "Save or invest ₹100 and get 1 game ticket every Monday"),
        "onboardText2": MessageLookupByLibrary.simpleMessage(
            "Use the tickets to participate in exciting weekly games"),
        "onboardText3": MessageLookupByLibrary.simpleMessage(
            "Your money keeps growing with great returns while you play fun games and win prizes!"),
        "onboardTitle": MessageLookupByLibrary.simpleMessage(
            "Game based Savings \n & Investments🎉"),
        "onboradButton": MessageLookupByLibrary.simpleMessage("GET STARTED"),
        "orderSummary": MessageLookupByLibrary.simpleMessage("Order Summary"),
        "pkPanLabel": MessageLookupByLibrary.simpleMessage("PAN Number"),
        "pkStateHint":
            MessageLookupByLibrary.simpleMessage("Which state do you live in?"),
        "pkStateLabel": MessageLookupByLibrary.simpleMessage("State"),
        "playTrendingGames":
            MessageLookupByLibrary.simpleMessage("Trending Games"),
        "priceClaimTitle1": MessageLookupByLibrary.simpleMessage(
            "You\'ve won an Amazon Gift Voucher\n worth"),
        "priceClaimTitle2": m3,
        "priceClaimTitle3": MessageLookupByLibrary.simpleMessage(
            "You\'ve won Fello Rewards\n worth"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "purchaseRate": MessageLookupByLibrary.simpleMessage("Purchase Rate:"),
        "ranOutOfTokens": MessageLookupByLibrary.simpleMessage(
            "You ran out of Fello tokens, here are some ways to get back on the track:"),
        "received": MessageLookupByLibrary.simpleMessage("Received"),
        "refCodeHint": MessageLookupByLibrary.simpleMessage(
            "Enter your referral code here"),
        "refCodeOptional":
            MessageLookupByLibrary.simpleMessage("Referral Code (Optional)"),
        "refHIW": MessageLookupByLibrary.simpleMessage("How do you earn?"),
        "refHaveReferral":
            MessageLookupByLibrary.simpleMessage("Have a referral code?"),
        "refInvalid":
            MessageLookupByLibrary.simpleMessage("Invalid referral code"),
        "refPolicy": MessageLookupByLibrary.simpleMessage("Referral Policy"),
        "refPolicyFailed": MessageLookupByLibrary.simpleMessage(
            "Failed to load the Referral Policy at the moment. Please try again later"),
        "refShareLink": MessageLookupByLibrary.simpleMessage("Share Link"),
        "refStep2": MessageLookupByLibrary.simpleMessage(
            "Your friend makes their first saving of ₹ 100 on the app."),
        "refStep3": MessageLookupByLibrary.simpleMessage(
            "Both you and your friend receive ₹ 25 and 200 Fello tokens in your account."),
        "refUnAvailable": MessageLookupByLibrary.simpleMessage("Unavailable"),
        "refWhatsapp": MessageLookupByLibrary.simpleMessage("WhatsApp"),
        "referFriends":
            MessageLookupByLibrary.simpleMessage("Refer your friends"),
        "refstep1": MessageLookupByLibrary.simpleMessage(
            "Your friend installs Fello and signs up using your referral link or referral code."),
        "refsubtitle": MessageLookupByLibrary.simpleMessage(
            "Earn ₹ 25 and 200 Fello tokens for every referral and referrer of the month will get a brand new iphone 13"),
        "resultsPageFirstDisclaimer": m4,
        "resultsPageLethalDosageMessage": m5,
        "resultsPageSafeDosageMessage": m6,
        "resultsPageSafeDosageTitle":
            MessageLookupByLibrary.simpleMessage("Daily Safe Maximum"),
        "resultsPageSecondDisclaimer": MessageLookupByLibrary.simpleMessage(
            "*Applies to age 18 and over. This calculator does not replace professional medical advice."),
        "saveAutoSaveSubTitle": MessageLookupByLibrary.simpleMessage(
            "Set up Autosave & earn daily tokens "),
        "saveAutoSaveTitle":
            MessageLookupByLibrary.simpleMessage("Set up Autosave"),
        "saveBaseline": MessageLookupByLibrary.simpleMessage(
            "You get 1 token for every Rupee saved"),
        "saveGold24k": MessageLookupByLibrary.simpleMessage("24K"),
        "saveGoldBalanceValue": m7,
        "saveGoldBalancelabel":
            MessageLookupByLibrary.simpleMessage("Gold Balance:"),
        "saveGoldPure": MessageLookupByLibrary.simpleMessage("99.99% Pure"),
        "saveHistory": MessageLookupByLibrary.simpleMessage("History"),
        "saveMoney": MessageLookupByLibrary.simpleMessage("Save More Money"),
        "saveSecure": MessageLookupByLibrary.simpleMessage("100% secure"),
        "saveSellButton": MessageLookupByLibrary.simpleMessage("SELL"),
        "saveViewAll": MessageLookupByLibrary.simpleMessage("View All"),
        "saveWinningsLabel":
            MessageLookupByLibrary.simpleMessage("My Active Winnings"),
        "saveWinningsValue": m8,
        "secureFelloTitle":
            MessageLookupByLibrary.simpleMessage("Secure Fello"),
        "sellRate": MessageLookupByLibrary.simpleMessage("Sell Rate:"),
        "shareCardTitle": MessageLookupByLibrary.simpleMessage(
            "Play fun games and get a chance to\nwin rewards as Digital Gold!"),
        "signout": MessageLookupByLibrary.simpleMessage("Sign Out"),
        "skipWithtokenCost": m9,
        "sold": MessageLookupByLibrary.simpleMessage("Sold"),
        "splashNoInternet": MessageLookupByLibrary.simpleMessage(
            "No active internet connection"),
        "splashSecureText":
            MessageLookupByLibrary.simpleMessage("🔒 safe and secure"),
        "splashSlowConnection": MessageLookupByLibrary.simpleMessage(
            "Connection taking longer than usual"),
        "splashTagline":
            MessageLookupByLibrary.simpleMessage("Your savings and gaming app"),
        "startSaving": MessageLookupByLibrary.simpleMessage("Start Saving"),
        "tDrawTime":
            MessageLookupByLibrary.simpleMessage("Today’s draw at 6 PM "),
        "tGeneratedOn": MessageLookupByLibrary.simpleMessage("Generated on :"),
        "tLossSubtitle": MessageLookupByLibrary.simpleMessage(
            "None of your tickets matched this week"),
        "tLossSubtitle2": MessageLookupByLibrary.simpleMessage(
            "Get ready for next week tambola from now on."),
        "tLossTitle": MessageLookupByLibrary.simpleMessage("Tambola Results"),
        "tParWinTitle": MessageLookupByLibrary.simpleMessage("Tambola Results"),
        "tParWinsubtitle": MessageLookupByLibrary.simpleMessage(
            "Only users with minimun savings balance of ₹ 100 are eliglble for prizes"),
        "tProcessingSubtitle": MessageLookupByLibrary.simpleMessage(
            "We are processing your tickets to see if any of your tickets has won a category.."),
        "tProcessingTitle": MessageLookupByLibrary.simpleMessage("Prize Day"),
        "tWinSubtitle": MessageLookupByLibrary.simpleMessage(
            "Your tickets have been submitted\nfor processing"),
        "tWinSubtitle2": MessageLookupByLibrary.simpleMessage(
            "Your prizes will be credited tomorrow. Be sure to check out the leaderboard!"),
        "tWinTitle": MessageLookupByLibrary.simpleMessage("CONGRATULATIONS!"),
        "tambolaNew": MessageLookupByLibrary.simpleMessage("NEW"),
        "termsOfService":
            MessageLookupByLibrary.simpleMessage("Terms of Service"),
        "tokenDeductionOnTransaction": MessageLookupByLibrary.simpleMessage(
            "With every transaction, some\ntokens will be deducted."),
        "tokensRequired":
            MessageLookupByLibrary.simpleMessage("Tokens Required"),
        "totalSavings": MessageLookupByLibrary.simpleMessage("Total Savings"),
        "txnActiveCoupon":
            MessageLookupByLibrary.simpleMessage("Active Coupons"),
        "txnAmountTitle":
            MessageLookupByLibrary.simpleMessage("Transaction Amount"),
        "txnApply": MessageLookupByLibrary.simpleMessage("Apply"),
        "txnApplyCoupon":
            MessageLookupByLibrary.simpleMessage("Apply a Coupon"),
        "txnBankDetailsLabel":
            MessageLookupByLibrary.simpleMessage("Bank Account Details"),
        "txnDetailsTitle":
            MessageLookupByLibrary.simpleMessage("Transaction Details"),
        "txnEnterCode": MessageLookupByLibrary.simpleMessage(
            "Please enter a code to continue"),
        "txnEnterCoupon":
            MessageLookupByLibrary.simpleMessage("Enter a Coupon Code here"),
        "txnHappyHours": MessageLookupByLibrary.simpleMessage(
            "You have made a transaction during \nHappy Hours!"),
        "txnHistoryLabel":
            MessageLookupByLibrary.simpleMessage("Transaction History"),
        "txnInvalidCouponCode":
            MessageLookupByLibrary.simpleMessage("Invalid Coupon code"),
        "txnInvoiceFailed":
            MessageLookupByLibrary.simpleMessage("Invoice could not be loaded"),
        "txnTryAfterSomeTime":
            MessageLookupByLibrary.simpleMessage("Please try in some time"),
        "win1Crore": MessageLookupByLibrary.simpleMessage("Win ₹1 Crore!"),
        "winATicket": m10,
        "winIphoneBigText":
            MessageLookupByLibrary.simpleMessage("and win iPad Air"),
        "winIphoneSmallText":
            MessageLookupByLibrary.simpleMessage("Refer friends"),
        "winMoneyBigText":
            MessageLookupByLibrary.simpleMessage("₹ 1 Lakh every week"),
        "winMoneySmallText":
            MessageLookupByLibrary.simpleMessage("Play and win"),
        "winMyWinnings": MessageLookupByLibrary.simpleMessage("My Winnings"),
        "withdrawGoldBalance":
            MessageLookupByLibrary.simpleMessage("Withdrawable Gold Balance")
      };
}
