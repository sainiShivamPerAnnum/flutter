import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/stac/lib/stac.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class SduiPage extends StatelessWidget {
  const SduiPage({
    required this.linkToParse,
    super.key,
  });
  final String linkToParse;

  @override
  Widget build(BuildContext context) {
    return Stac.fromNetwork(
      context: context,
      request: StacNetworkRequest(
        url: linkToParse,
        cBaseUrl: '',
        isS3Request: true,
      ),
      loadingWidget: (_) => const BaseScaffold(
        backgroundColor: UiConstants.bg,
        showBackgroundGrid: false,
        body: Center(
          child: FullScreenLoader(),
        ),
      ),
      errorWidget: (_, error) => const BaseScaffold(
        backgroundColor: UiConstants.bg,
        showBackgroundGrid: false,
        body: NewErrorPage(),
      ),
    );
  }
}
