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

  static final String guideText = '1. Users receive 1 ticket for every Rs.100 invested.\n\n'
      '2. Each tambola ticket is valid for one week starting from Monday through Sunday. \n\n'
      '3. You receive fresh tambola tickets every week for your current savings balance.\n\n'
      '4. Every day 5 numbers will be drawn from a raffle totalling 35 numbers per week.  \n\n'
      '5. Users can win corners, 1st, 2nd, 3rd rows or a full house if their ticket numbers match with any of the 35 numbers drawn.  \n\n'
      '6. If more than one user wins a category, then the prize money will be split equally amongst the winners.  \n\n'
      '7. *Combination of numbers across multiple tickets will not be considered.';

}