import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/logo/logo_container.dart';
import 'package:felloapp/ui/elements/texts/breathing_text_widget.dart';
import 'package:felloapp/ui/pages/splash/splash_vm.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';

//Flutter and dart imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LauncherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context, listen: true);
    S FT = S.of(context);
    return BaseView<LauncherViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.exit(),
      builder: (ctx, model, child) {
        return Scaffold(
            body: Stack(
          children: <Widget>[
            (model.logo != null)
                ? Center(
                    child: Container(
                      child: new Logo(
                        size: 160.0,
                        style: model.logoStyle,
                        img: model.logo,
                      ),
                    ),
                  )
                : Center(child: Text('Loading..')),
            Positioned(
              bottom: 0,
              child: Container(
                width: SizeConfig.screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: model.isSlowConnection,
                        child: connectivityStatus == ConnectivityStatus.Offline
                            ? Text('No active internet connection',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: SizeConfig.mediumTextSize))
                            : BreathingText(
                                alertText: FT.splashSlowConnection,
                                textStyle: TextStyles.body2,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
      },
    );
  }
}
