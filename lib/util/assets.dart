import 'package:felloapp/base_util.dart';

import 'constants.dart';

class Assets{
  static final String logoMaxSize = 'images/fello_logo.png';
  static final String referGraphic = 'images/transfer.png';
  static final String iciciGraphic = 'images/icici.png';
  static final String sebiGraphic = 'images/sebi.png';
  static final String amfiGraphic = 'images/amfi.png';
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

}