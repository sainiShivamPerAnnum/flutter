import 'package:felloapp/base_util.dart';

import 'constants.dart';

class Assets{
  static final String logoMaxSize = 'images/fello_logo.png';
  static final String referGraphic = 'images/transfer.png';
  static final String iciciGraphic = 'images/icici.png';
  static final String sebiGraphic = 'images/sebi.png';
  static final String amfiGraphic = 'images/amfi.png';
  static final String prizesGraphic = 'images/prizes-small.png';
  static final String winnersGraphic = 'images/winners-small.png';
  static final String whatsappIcon = 'images/whatsapp.png';
  static final String strikeThroughGraphic = 'images/diagonal-strike.png';

  static final List<String> onboardingSlide = [
    'images/save-small.png',
    'images/grow-small.png',
    'images/games-small.png',
    'images/safe-small.png',
  ];

  static final List<String> onboardingHeader=[
    'Save',
    'Grow',
    'Play',
    'Safe',
  ];

  static final String aboutUsDesc = 'Fello is a gamified savings and investment platform for users to save, grow and earn higher returns than a traditional savings bank account. For every Rs.100 saved and invested through Fello, users get amazing rewards and incentives. \n\n'
      'We (Manish & Shourya) are two finance folks who started Fello with the vision of helping people save money in a better way and learn about personal finance and investments with an added tinge of fun with games like never before. Now savings are no more boring, it is fun, safe and rewarding!\n\n'
      'We are an AMFI registered mutual fund distributor and all your money is invested directly into a relevant mutual fund. So the money saved is safe and secure with the security of a financial institution. \n\n'
      'If you have any queries, feel free to reach out to us and we would be happy to help you.';

  static final List<String> onboardingDesc = [
    '${Constants.APP_NAME} is a gamified savings and investment platform. '
        'We make saving a lot more rewarding, and investing a lot more simple.',
    '${Constants.APP_NAME} compiles carefully selected funds that are highly liquid and '
        'have historically given higher returns than traditional banks.',
    'For every ₹${BaseUtil.INVESTMENT_AMOUNT_FOR_TICKET} invested through ${Constants.APP_NAME}, '
        'you receive a weekly Tambola ticket. Participate, win and boost your savings faster!',
    '${Constants.APP_NAME} follows SEBI regulated guidelines and invests directly into the instrument of your choice,'
        ' while giving you the freedom to withdraw at any point.',
  ];

  static final String guideText = '1. Users receive 1 weekly ticket for every ₹100 saved and invested.\n\n'
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
    'Fello is a gamified savings and investment platform for users to save, invest and grow their money '
        'through SEBI/RBI regulated financial assets and earn more than their savings bank account returns. '
        'For every Rs.100 invested through Fello, users get one tambola ticket using which they can participate '
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
    'It’s very simple. Step 1: Save and invest in the mutual fund listed on the platform. Step 2: For every Rs.100'
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
        ' listed mutual fund. For every Rs.100 invested you get 1 ticket, so if you invest and save Rs.1000, you get '
        '10 tickets. Second, by referring it to your friends, the more you refer, the more tambola tickets you earn '
        'thus increasing the chances of you winning the draw!',
    'You don’t need to! If you invested on week 1 and if you are continuing to hold the investment for the coming week '
        'you get fresh tambola tickets equivalent to the amount invested. For example: If you have invested Rs.1000 on '
        'week 1, you get 10 tickets. If you continue holding the Rs.5000 for week 2, you get another 10 tickets and '
        'so on! Isn’t that amazing?! :D',
  ];

}