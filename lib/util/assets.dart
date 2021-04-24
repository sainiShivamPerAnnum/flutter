import 'package:felloapp/base_util.dart';

import 'constants.dart';

class Assets {
  static final String logoMaxSize = 'images/fello_logo.png';
  static final String referGraphic = 'images/transfer.png';
  static final String iciciGraphic = 'images/icici.png';
  static final String augmontGraphic = 'images/augmont.png';
  static final String augmontLogo = "images/augmont-logo.jpg";
  static final String sebiGraphic = 'images/sebi.png';
  static final String amfiGraphic = 'images/amfi.png';
  static final String prizesGraphic = 'images/prizes-small.png';
  static final String winnersGraphic = 'images/winners-small.png';
  static final String whatsappIcon = 'images/whatsapp.png';
  static final String strikeThroughGraphic = 'images/diagonal-strike.png';
  static final String onboardCollageGraphic =
      'images/onboard_collage-small.png';

  static final String dummyPanCard = 'images/PAN_card.png';
  static final String dummyPanCardShowNumber =
      'images/PAN_card_no_focussed.png';
  static final String dummyAadhaarCard = 'images/Aadhar_card.jpg';
  static final String dummyCancelledCheque = 'images/Cancelled_cheque.png';
  static final String kycUnavailableAsset = 'images/kyc_unavailable.png';

  static final List<String> onboardingSlide = [
    'images/save-small.png',
    'images/grow-small.png',
    'images/games-small.png',
    'images/safe-small.png',
  ];

  static final List<String> onboardingHeader = [
    'Save',
    'Grow',
    'Play',
    'Safe',
  ];
  static final List<String> teachFello = [
    'images/process/process-1.png',
    'images/process/process-2.png',
    'images/process/process-3.png',
  ];
  static final checkmarkLottie = 'images/checkmark.json';
  static final String aboutUsDesc =
      'Fello is a game based savings and investment platform for users to save, grow and earn higher returns than a traditional savings bank account. For every ₹100 saved and invested through Fello, users get amazing rewards and incentives. \n\n'
      'We (Manish & Shourya) are two finance folks who started Fello with the vision of helping people save money in a better way and learn about personal finance and investments with an added tinge of fun with games like never before. Now savings are no more boring, it is fun, safe and rewarding!\n\n'
      'We are an AMFI registered mutual fund distributor and all your money is invested directly into a relevant mutual fund. So the money saved is safe and secure with the security of a financial institution. \n\n'
      'If you have any queries, feel free to reach out to us and we would be happy to help you.';

  static final List<String> onboardingDesc = [
    '${Constants.APP_NAME} is a game based savings and investment platform. '
        'We make saving a lot more rewarding, and investing a lot more simple.',
    '${Constants.APP_NAME} compiles carefully selected funds that are highly liquid and '
        'have historically given higher returns than traditional banks.',
    'For every ₹${BaseUtil.INVESTMENT_AMOUNT_FOR_TICKET} invested through ${Constants.APP_NAME}, '
        'you receive a weekly Tambola ticket. Participate, win and boost your savings faster!',
    '${Constants.APP_NAME} follows SEBI regulated guidelines and invests directly into the instrument of your choice,'
        ' while giving you the freedom to withdraw at any point.',
  ];

  static final String guideText =
      '1. Users receive 1 weekly ticket for every ₹100 saved and invested.\n\n'
      '2. Each tambola ticket is valid for one week starting from Monday, till  Sunday. \n\n'
      '3. You receive new tambola tickets every Monday for your amount saved in your account.\n\n'
      '4. Every day 5 numbers will be drawn from a raffle totalling 35 numbers per week.  \n\n'
      '5. Users can win in 5 categories: corners, 1st, 2nd, or 3rd row, or a full house. '
      'A ticket wins a category if the ticket numbers match with any of the 35 numbers drawn.  \n\n'
      '6. If more than one user wins a category, then the prize money will be split equally amongst the winners.  \n\n'
      '7. *Combination of numbers across multiple tickets will not be considered.';

  static final List<String> faqHeaders = [
    'What is Fello?',
    'How much returns do I get by saving and investing through Fello listed assets?',
    'Do I need to transfer money to Fello’s bank accounts or UPI?',
    'Is Fello safe?',
    'How does Fello work?',
    'Will I lose my money while I am playing Tambola on Fello?',
    'Is there any holding period for the money invested in the funds?',
    'How will the rewards be distributed?',
    'How do I get more tambola tickets?',
    'Do I need to invest everytime to participate in the weekly Tambola?',
  ];

  static final List<String> faqAnswers = [
    'Fello is a game based savings and investment platform for users to save, invest and grow their money '
        'through SEBI/RBI regulated financial assets and earn more than their savings bank account returns. '
        'For every ₹100 invested through Fello, users get one tambola ticket using which they can participate '
        'in weekly Tambola draws and win amazing cash rewards and prizes.',
    'Fello aims at listing only those financial investment products which have the potential to give returns more'
        ' than your traditional savings bank account returns which lie between 3-4%. For example, we are planning '
        'to list our first asset as an ICICI prudential liquid fund which gives returns within the range of 6-7% '
        'per annum.',
    'Absolutely not! Fello never asks you to deposit money into our bank accounts or UPI addresses. All the money '
        'invested and saved through Fello will be directly transferred into respective fund bank accounts and UPI '
        'ID’s by you at the time of saving and investing. For example, if a user invests in an ICICI prudential mutual '
        'fund, then the user receives a UPI id of ICICI bank mutual fund to which he/she needs to transfer the money '
        'directly.',
    '100% my Fello friend! All the money invested and saved through Fello is directly invested into the respective '
        'financial asset without our intervention. So the money is absolutely safe and sound lying in the respective '
        'bank account of the relevant fund. Also, we want to take utmost care of all our Fello customers, so we have '
        'also made sure to have world class 256 bit encryption. Also, we are an ISO 27001 certified platform and '
        'will be a SEBI registered Mutual Fund Distributor.',
    'It’s very simple. Step 1: Save and invest in the mutual fund listed on the platform. Step 2: For every ₹100'
        ' invested on the platform, you get a tambola ticket. Step 3: Participate in the weekly Tambola and you get '
        'to win amazing rewards and cash prizes.Step 4: Continue holding your investment and savings for the next '
        'week to get more tamobla tickets or . The longer you save and hold, the more you earn, the more tambola tickets'
        ' you get and the more chances you get at winning the weekly tambola.',
    'Absolutely not! The money saved and invested in the mutual fund is always in the safe hands of the respective '
        'mutual fund and that will never be effected for playing tambola or other future games on the platform.'
        ' But on the other hand, the more you save and invest, the more chances you get to win the tambola! :D',
    'There is no holding period currently for the funds which are getting listed on Fello. The funds are liquid '
        'funds and can be withdrawn anytime as per your convenience and the money will be deposited back into your '
        'account instantly or t+1 days.',
    'We want our users to save and grow more. So all the cash rewards will be awarded in the form of mutual funds.'
        ' If the user wants to redeem them, then the mutual funds can be sold and the amount will be deposited into '
        'their bank accounts instantly or in t+1 days.',
    'I see that you want to win more! So to increase your chances of winning, you need to save and invest more in the'
        ' listed mutual fund. For every ₹100 invested you get 1 ticket, so if you invest and save ₹1000, you get '
        '10 tickets. Second, by referring it to your friends, the more you refer, the more tambola tickets you earn '
        'thus increasing the chances of you winning the draw!',
    'You don’t need to! If you invested on week 1 and if you are continuing to hold the investment for the coming week '
        'you get fresh tambola tickets equivalent to the amount invested. For example: If you have invested ₹1000 on '
        'week 1, you get 10 tickets. If you continue holding the ₹1000 for week 2, you get another 10 tickets and '
        'so on! Isn’t that amazing?! :D',
  ];

  static final List<String> mfFaqHeaders = [
    'What kind of fund is this?',
    'What does a liquid debt fund mean?',
    'What is required to save with this fund',
    'How does the transaction work?',
    'What is the minimum amount that I can deposit?',
    'How can I withdraw from this fund?',
    'How much time does it take to receive my money?',
  ];

  static final List<String> mfFaqAnswers = [
    'This is the ICICI Prudential Liquid Mutual Fund-Growth. This is a liquid debt mutual fund',
    'Liquid funds are categorised as low risk products from liquidity and interest rate risk perspective. This is because they hold very short term instruments where the chances of interest rate fluctuations are less. ',
    'To save in this fund, you simply need to follow the 3 step onboarding process, post which you\'re all set to deposit and withdraw. Please not that you need to be a KYC verified customer',
    'Transactions are very smooth. After onboarding, simply enter your UPI ID and the amount you wish to save and you will be able to complete the transaction on your UPI App, just like a normal UPI payment!',
    'The very first transaction that you make needs to be atleast ₹100. After this, you can save any amount you want, even ₹1!',
    'Withdrawals take simply 2 clicks. Click on withdrawal, confirm the amount you wish to withdraw and it will get immediately deposited to your added bank account',
    '90% of your funds are withdrawn within minutes. The remaining 10% will be available within the next day. So if you had saved ₹100 and wish to withdraw the entire amount, ₹90 gets withdrawn within 2 minutes, and the rest within the next day!',
  ];

  static final List<String> goldFaqHeaders = [
    'What kind of asset is this?',
    'Who is Augmont?',
    'What does digital gold mean?',
    'What is the purity of the Gold?',
    'How does the transaction work?',
    'What is the minimum amount that I need to buy?',
    'When can I sell my gold?',
    'Is there any risk involved?',
  ];

  static final List<String> goldFaqAnswers = [
    'This is digital gold. It brings the power of buying gold with the ease of online access.  On completing a deposit, you receive the required grams of digital gold at the purchased gold rate',
    'Augmont Goldtech Private Limited is a consumer retail Goldtech company - India’s largest and completely integrated gold company-from refining to retailing.',
    'Your gold is stored as an investment with Augmont Goldtech. For all purposes, it is as great as physical ownership and can be sold at any given time as well.',
    'Augmont offers verified 24 carats 999 Gold.',
    'Simply register by providing a few very simple details. After registration, you can purchase any amount of gold through any preferred payment method.',
    'You can make a minimum purchase of as low as ₹10',
    'Gold can be sold at any given time at the selling rate during the time. Your sell amount is usually deposited to your bank account within a maximum of 2 business working days.',
    'The gold purchase and sell rates are subject to gold price fluctuation. Historically, gold is accepted to be an extremely strong asset and has given good long term returns.'
  ];

  static final List<String> onboardDialogDesc = [
    'Welcome to Fello! We have added 5 game tickets to your account to get you started.',
    'Save your money in diverse and stable funds. We have onboarded ICICI Prudential Liquid Fund as our first partner.',
    'For every ₹100 you save, you receive a game ticket that refreshes every week. Our first listed game is Tambola! '
  ];

  static final String transactionProcess =
      'Presently, your funds are manually deposited to your linked mutual fund '
      'account along with an email confirmation. \n\nSoon, all deposits and withdrawals placed on Fello will be'
      ' processed directly by your mutual fund of choice. ';

  static final List<String> showCaseDesc = [
    'Welcome to Fello!\n'
        'We have added a number of tickets in your account to get you started',
    'Everyday, 5 numbers are randomly picked from Monday to Sunday. Click the box to see this week\'s numbers',
    'You receive fresh Tambola tickets every Monday. The ticket numbers are automatically crossed based on the daily picks',
    'If any of your tickets match one of the 5 categories, you receive an instant cash prize in your account!'
  ];

  static final List<String> bottomSheetDesc = [
    'Save more, Win more!',
    '₹100 saved = 1 ticket',
    '1 referral = 10 tickets and ₹25',
    'We are currently in Beta',
  ];

  static final List<String> mfTableDetailsInfo = [
    "The compound annual growth rate(CAGR) is the mean annual growth rate of an investment over a specified period of time longer than one year",
    "Net asset value(NAV) is the value of per share of a mutual fund or an exchange-traded fund on a specified date or time",
    "The number of years completed since the inception of the scheme",
    "Assets under management is the total market value of assets that an investment company manages on behalf of the investors",
  ];

  static final String integratedICICIUnavailable =
      "Mutual Fund deposits are currently being tested within a small cohort. \n\n It will soon be available for everyone. Stay tuned! 😎";

  static final String augmontUnavailable =
      "We are slowly moving towards a fully automated system of deposits and withdrawals. " +
          "Currently, we have started integrated transactions with only a small set of users.\n\n Please use manual deposits in the meanwhile!";

  static final String infoWhyPan =
      'Your PAN Card is required by ICICI to set up your investment folio';
  static final String infoWherePan =
      'Your PAN Number is a 10 character ID that can be found on your PAN Card';
  static final String infoWhatUPI =
      'UPI is a banking system for money transfers on payment apps. Your UPI ID is your unique address that identifies you on UPI';
  static final String infoWhereUPI =
      'Your UPI ID will be present in the profile section or payment settings section of the UPI app that you use. Typical UPI ID will be of the format \'username@bankname\'';
  static final String infoWhatKYC =
      '\'Know Your Customer\' is process where we verify your identity by requesting you to submit certain documents. This verification is a one time process across all services';
  static final String infoWhyKYC =
      'RBI has made KYC mandatory to verify the identity of all customers who carry out financial transactions. This process unlocks all equity and mutual funds for you to invest in!';
  static final String infoAugmontTxnHow = 'Simply enter the desired amount you wish to purchase and you will be redirected to a payment gateway where you can complete the payment. \n\nThe expected grams of gold and the tickets shall automatically get credited once the transaction is completed!';
  static final String infoAugmontTime = 'Making a gold purchase is immediate and the gold and tickets get automatically credited once the payment is complete.\n\n Selling your gold is also processed within a few clicks and the amount gets reflected in your bank account within 2 business working days.';

  static const List<String> POLL_NEXT_GAME_LIST = [
    'Financial Quiz',
    'Single player arcade',
    'Single/multi player card game',
    'Multi player board game',
    'Multi player arcade game',
  ];
}
