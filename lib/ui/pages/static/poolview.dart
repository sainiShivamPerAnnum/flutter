import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PoolView extends StatefulWidget {
  const PoolView({Key key}) : super(key: key);

  @override
  State<PoolView> createState() => _PoolViewState();
}

class _PoolViewState extends State<PoolView> {
  final _userService = locator<UserService>();
  @override
  void initState() {
    super.initState();
    AppState.isWebGameLInProgress = true;
  }

  @override
  dispose() {
    AppState.isWebGameLInProgress = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: WebView(
          initialUrl:
              "https://d2qfyj2eqvh06a.cloudfront.net/pool-club/index.html?user=${_userService.baseUser.uid}&name=${_userService.baseUser.username}",
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
