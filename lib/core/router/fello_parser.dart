import 'package:felloapp/core/router/pages.dart';
import 'package:flutter/material.dart';

class FelloParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    // 1
    final uri = Uri.parse(routeInformation.location);
    // 2
    if (uri.pathSegments.isEmpty) {
      return SplashPageConfig;
    }

    // 3
    final path = uri.pathSegments[0];
    // 4
    switch (path) {
      case SplashPath:
        return SplashPageConfig;
      case LoginPath:
        return LoginPageConfig;
      case OnboardPath:
        return OnboardPageConfig;
      case RootPath:
        return RootPageConfig;
      case LoginPath:
        return LoginPageConfig;
      case EditProfilePath:
        return EditProfilePageConfig;
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
      case Pages.Onboard:
        return const RouteInformation(location: OnboardPath);
      case Pages.Root:
        return const RouteInformation(location: RootPath);
      case Pages.EditProfile:
        return const RouteInformation(
          location: EditProfilePath,
        );
      default:
        return const RouteInformation(location: SplashPath);
    }
  }
}
