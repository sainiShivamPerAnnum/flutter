import 'package:felloapp/util/app_state.dart';
import 'package:flutter/cupertino.dart';

const String SplashPath = '/launcher';
const String RootPath = '/approot';
const String OnboardPath = '/onboarding';
const String LoginPath = '/login';
const String EditProfilePath = '/editProf';

enum Pages { Splash, Root, Onboard, Login, EditProfile }

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
  currentPageAction: null,
);
PageConfiguration RootPageConfig = PageConfiguration(
  key: 'Root',
  path: RootPath,
  uiPage: Pages.Root,
  currentPageAction: null,
);
PageConfiguration OnboardPageConfig = PageConfiguration(
  key: 'Onboard',
  path: OnboardPath,
  uiPage: Pages.Onboard,
  currentPageAction: null,
);
PageConfiguration LoginPageConfig = PageConfiguration(
  key: 'Login',
  path: LoginPath,
  uiPage: Pages.Login,
  currentPageAction: null,
);
PageConfiguration EditProfilePageConfig = PageConfiguration(
  key: 'EditProf',
  path: EditProfilePath,
  uiPage: Pages.EditProfile,
  currentPageAction: null,
);
