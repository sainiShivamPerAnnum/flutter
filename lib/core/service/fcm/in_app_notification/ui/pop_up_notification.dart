import 'package:felloapp/core/service/fcm/in_app_notification/in_app_notification_handler.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/action_resolver.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class PopupNotificationView extends StatelessWidget {
  const PopupNotificationView(
    this.notification, {
    super.key,
  });

  final PopupNotification notification;

  void _onTapImage() {
    _onClose();

    final action = notification.action;
    if (action != null) {
      ActionResolver.instance.resolve(action);
    }
  }

  void _onClose() {
    AppState.unblockNavigation();
    AppState.backButtonDispatcher!.didPopRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Stack(
              children: [
                InkWell(
                  onTap: _onTapImage,
                  child: Image.network(
                    notification.image,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: _onClose,
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: SizeConfig.padding24,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
