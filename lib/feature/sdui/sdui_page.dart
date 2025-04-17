import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/stac/lib/stac.dart';
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
      request: StacNetworkRequest(url: linkToParse, cBaseUrl: ''),
      loadingWidget: (_) => const Center(
        child: FullScreenLoader(),
      ),
      errorWidget: (_, error) => const NewErrorPage(),
    );
  }
}
