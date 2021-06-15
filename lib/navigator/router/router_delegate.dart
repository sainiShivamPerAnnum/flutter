import 'package:felloapp/ui/dialogs/aboutus_dialog.dart';
import 'package:felloapp/ui/dialogs/game-poll-dialog.dart';
import 'package:felloapp/ui/dialogs/guide_dialog.dart';
import 'package:felloapp/ui/pages/hamburger/faq_page.dart';
import 'package:felloapp/ui/pages/hamburger/hamburger_screen.dart';
import 'package:felloapp/ui/pages/hamburger/tnc_page.dart';
import 'package:felloapp/ui/pages/launcher_screen.dart';
import 'package:felloapp/ui/pages/login/login_controller.dart';
import 'package:felloapp/ui/pages/onboarding/getstarted/get_started_page.dart';
import 'package:felloapp/ui/pages/root.dart';
import 'package:felloapp/ui/pages/tabs/finance/gold_details_page.dart';
import 'package:felloapp/ui/pages/tabs/finance/mf_details_page.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola-home.dart';
import 'package:felloapp/ui/pages/tabs/profile/edit_profile_page.dart';
import 'package:felloapp/ui/pages/tabs/profile/referrals_page.dart';
import 'package:felloapp/ui/pages/tabs/profile/transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../app_state.dart';
import 'ui_pages.dart';

class FelloRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final List<Page> _pages = [];

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppState appState;

  FelloRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(() {
      notifyListeners();
    });
  }

  List<MaterialPage> get pages => List.unmodifiable(_pages);

  int numPages() => _pages.length;

  @override
  PageConfiguration get currentConfiguration =>
      _pages.last.arguments as PageConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    // 1
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    // 2
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last);
    }
  }

  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last);
      print("Popped a page");
      notifyListeners();
      return Future.value(true);
    }
    notifyListeners();
    return Future.value(false);
  }

  void _removePage(MaterialPage page) {
    if (page != null) {
      _pages.remove(page);
    }
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child,
        key: Key(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    AppState.screenStack.add(ScreenItem.page);
    print("Added a page ${pageConfig.key}");
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  void addPage(PageConfiguration pageConfig) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage;

    if (shouldAddPage) {
      switch (pageConfig.uiPage) {
        case Pages.Splash:
          _addPageData(SplashScreen(), SplashPageConfig);
          break;
        case Pages.Login:
          _addPageData(LoginController(), LoginPageConfig);
          break;
        case Pages.Root:
          _addPageData(Root(), LoginPageConfig);
          break;
        case Pages.Onboard:
          _addPageData(GetStartedPage(), OnboardPageConfig);
          break;
        case Pages.EditProfile:
          _addPageData(EditProfile(), EditProfileConfig);
          break;
        case Pages.MfDetails:
          _addPageData(MFDetailsPage(), MfDetailsPageConfig);
          break;
        case Pages.AugDetails:
          _addPageData(AugmontDetailsPage(), EditProfileConfig);
          break;
        case Pages.Transaction:
          _addPageData(Transactions(), MfDetailsPageConfig);
          break;
        case Pages.Referral:
          _addPageData(ReferralsPage(), EditProfileConfig);
          break;
        case Pages.TambolaHome:
          _addPageData(TambolaHome(), EditProfileConfig);
          break;
        case Pages.Tnc:
          _addPageData(TnC(), TncPageConfig);
          break;
        case Pages.Faq:
          _addPageData(FAQPage(), FaqPageConfig);
          break;
        default:
          break;
      }
    }
  }

// 1
  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

// 2
  void setPath(List<MaterialPage> path) {
    _pages.clear();
    AppState.screenStack.clear();
    _pages.addAll(path);
    notifyListeners();
  }

// 3
  void replaceAll(PageConfiguration newRoute) {
    setNewRoutePath(newRoute);
  }

// 4
  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

// 5
  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

// 6
  void addAll(List<PageConfiguration> routes) {
    routes.forEach((route) {
      addPage(route);
    });
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      AppState.screenStack.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  void _setPageAction(PageAction action) {
    switch (action.page.uiPage) {
      case Pages.Splash:
        SplashPageConfig.currentPageAction = action;
        break;
      case Pages.Login:
        LoginPageConfig.currentPageAction = action;
        break;
      case Pages.Onboard:
        OnboardPageConfig.currentPageAction = action;
        break;
      case Pages.Root:
        RootPageConfig.currentPageAction = action;
        break;
      case Pages.EditProfile:
        EditProfileConfig.currentPageAction = action;
        break;
      case Pages.MfDetails:
        MfDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.AugDetails:
        AugDetailsPageConfig.currentPageAction = action;
        break;
      case Pages.Transaction:
        TransactionPageConfig.currentPageAction = action;
        break;
      case Pages.Referral:
        ReferralPageConfig.currentPageAction = action;
        break;
      case Pages.TambolaHome:
        TambolaHomePageConfig.currentPageAction = action;
        break;
      case Pages.Tnc:
        TncPageConfig.currentPageAction = action;
        break;
      case Pages.Faq:
        FaqPageConfig.currentPageAction = action;
        break;

      default:
        break;
    }
  }

  List<Page> buildPages() {
    switch (appState.currentAction.state) {
      // 3
      case PageState.none:
        break;
      case PageState.addPage:
        // 4
        _setPageAction(appState.currentAction);
        addPage(appState.currentAction.page);
        break;
      case PageState.pop:
        // 5
        pop();
        break;
      case PageState.replace:
        // 6
        _setPageAction(appState.currentAction);
        replace(appState.currentAction.page);
        break;
      case PageState.replaceAll:
        // 7
        _setPageAction(appState.currentAction);
        replaceAll(appState.currentAction.page);
        break;
      case PageState.addWidget:
        // 8
        _setPageAction(appState.currentAction);
        pushWidget(appState.currentAction.widget, appState.currentAction.page);
        break;
      case PageState.addAll:
        // 9
        addAll(appState.currentAction.pages);
        break;
    }
    // 10
    appState.resetCurrentAction();
    return List.of(_pages);
  }

  void parseRoute(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath(SplashPageConfig);
      return;
    } else {
      if (num.tryParse(uri.pathSegments[0]) != null) {
        appState.setCurrentTabIndex = num.tryParse(uri.pathSegments[0]);
      }
      for (int i = 0; i < uri.pathSegments.length; i++) {
        final segment = uri.pathSegments[i];
        if (segment.startsWith('d-', 0)) {
          dialogCheck(segment.split('-').last);
        } else {
          screenCheck(segment);
        }
      }
    }
    // for one segement [bottom]
  }

  void dialogCheck(String dialogKey) {
    Widget dialogWidget = null;
    bool barrierDismissable = true;
    switch (dialogKey) {
      case 'guide':
        dialogWidget = GuideDialog();
        break;
      case 'gamePoll':
        dialogWidget = GamePoll();
        break;
      case "aboutus":
        dialogWidget = AboutUsDialog();
        break;

      case "ham":
        dialogWidget = HamburgerMenu();
        barrierDismissable = false;
    }
    if (dialogWidget != null) {
      AppState.screenStack.add(ScreenItem.dialog);
      showDialog(
          context: navigatorKey.currentContext,
          barrierDismissible: barrierDismissable,
          builder: (ctx) {
            return WillPopScope(
                onWillPop: () {
                  //if (AppState.screenStack.last == ScreenItem.dialog) {
                  AppState.screenStack.removeLast();
                  //}
                  return Future.value(true);
                },
                child: dialogWidget);
          });
    }
  }

  void screenCheck(String screenKey) {
    PageConfiguration pageConfiguration = null;
    switch (screenKey) {
      case 'editProfile':
        pageConfiguration = EditProfileConfig;
        addPage(EditProfileConfig);
        break;
      case 'mfDetails':
        pageConfiguration = MfDetailsPageConfig;
        break;
      case 'augDetails':
        pageConfiguration = AugDetailsPageConfig;
        break;
      case 'tran':
        pageConfiguration = TransactionPageConfig;
        break;
      case 'referral':
        pageConfiguration = ReferralPageConfig;
        break;
      case 'tambolaHome':
        pageConfiguration = TambolaHomePageConfig;
        break;
      case 'tnc':
        pageConfiguration = TncPageConfig;
        break;
      case 'faq':
        pageConfiguration = FaqPageConfig;
        break;
    }
    if (pageConfiguration != null) {
      addPage(pageConfiguration);
    }
  }
}

// Push screen with data
// pushWidget(Details(int.parse(uri.pathSegments[1])), DetailsPageConfig);


 //  else if (uri.pathSegments.length == 1) {
    //   final path = uri.pathSegments[0];
    //   switch (path) {
    //     case 'splash':
    //       replaceAll(SplashPageConfig);
    //       showDialog(
    //           context: navigatorKey.currentContext,
    //           builder: (ctx) => GuideDialog());
    //       break;
    //     case 'login':
    //       replaceAll(LoginPageConfig);
    //       break;
    //     case 'onboard':
    //       replaceAll(OnboardPageConfig);
    //       break;
    //     case 'root':
    //       replaceAll(RootPageConfig);
    //       break;
    //     case 'editProfile':
    //       setPath([
    //         _createPage(Root(), RootPageConfig),
    //         _createPage(EditProfile(), EditProfileConfig),
    //       ]);
    //       break;
    //     case 'mfDetails':
    //       setPath([
    //         _createPage(Root(), RootPageConfig),
    //         _createPage(MFDetailsPage(), EditProfileConfig),
    //       ]);
    //       break;
    //     case 'augDetails':
    //       setPath([
    //         _createPage(Root(), RootPageConfig),
    //         _createPage(AugmontDetailsPage(), EditProfileConfig),
    //       ]);
    //       break;
    //     case 'tran':
    //       setPath([
    //         _createPage(Root(), RootPageConfig),
    //         _createPage(Transactions(), EditProfileConfig),
    //       ]);
    //       break;
    //     case 'referral':
    //       setPath([
    //         _createPage(Root(), RootPageConfig),
    //         _createPage(ReferralsPage(), EditProfileConfig),
    //       ]);
    //       break;
    //     case 'tambolaHome':
    //       setPath([
    //         _createPage(Root(), RootPageConfig),
    //         _createPage(TambolaHome(), EditProfileConfig),
    //       ]);
    //       break;
    //     case 'tnc':
    //       setPath([
    //         _createPage(Root(), RootPageConfig),
    //         _createPage(TnC(), TncPageConfig),
    //       ]);
    //       break;
    //     case 'faq':
    //       setPath([
    //         _createPage(Root(), RootPageConfig),
    //         _createPage(FAQPage(), FaqPageConfig),
    //       ]);
    //       break;
    //   }
    // }