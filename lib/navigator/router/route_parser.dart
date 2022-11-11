import 'package:flutter/material.dart';

import 'ui_pages.dart';

class FelloParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.isEmpty) {
      return SplashPageConfig;
    }

    final path = uri.pathSegments[0];

    switch (path) {
      case SplashPath:
        return SplashPageConfig;
      case LoginPath:
        return LoginPageConfig;
      case RootPath:
        return RootPageConfig;
      case OnboardPath:
        return OnboardPageConfig;
      case UserProfileDetailsPath:
        return UserProfileDetailsConfig;
      default:
        return SplashPageConfig;
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Splash:
        return const RouteInformation(location: SplashPath);
      case Pages.Login:
        return const RouteInformation(location: LoginPath);
      case Pages.Root:
        return const RouteInformation(location: RootPath);
      case Pages.Onboard:
        return const RouteInformation(location: OnboardPath);
      case Pages.UserProfileDetails:
        return const RouteInformation(location: UserProfileDetailsPath);
      default:
        return const RouteInformation(location: SplashPath);
    }
  }
}
