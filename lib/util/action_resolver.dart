import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/action.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:share_plus/share_plus.dart';

class ActionResolver {
  const ActionResolver._();
  static const instance = ActionResolver._();

  Future<void> resolve(Action action) async {
    final payload = action.payload;
    switch (action.type) {
      case ActionType.DEEP_LINK:
      case ActionType.LAUNCH_WEBVIEW:
        final url = payload['url'];
        if (url == null) {
          break;
        }
        AppState.delegate!.parseRoute(
          Uri.parse(url),
        );
        break;

      case ActionType.LAUNCH_EXTERNAL_APPLICATION:
        final url = payload['url'];
        if (url == null) {
          break;
        }
        await BaseUtil.launchUrl(url);
        break;

      case ActionType.SHARE:
        final content = payload['content'];
        if (content == null) {
          break;
        }
        await Share.share(content);
        break;

      default:
    }
  }
}
