import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PoolView extends StatefulWidget {
  const PoolView({Key key}) : super(key: key);

  @override
  State<PoolView> createState() => _PoolViewState();
}

class _PoolViewState extends State<PoolView> {
  @override
  void initState() {
    super.initState();
    AppState.circGameInProgress = true;
  }

  @override
  dispose() {
    AppState.circGameInProgress = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: WebView(
          initialUrl:
              "https://fello-pool.surge.sh?user=w7H9jWJKECOGsqI1H3BjNav7dm13",
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
