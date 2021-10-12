import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TambolaAppBar extends StatefulWidget {
  const TambolaAppBar({
    Key key,
  }) : super(key: key);

  @override
  State createState() => _TambolaAppBarState();
}

class _TambolaAppBarState extends State<TambolaAppBar> {
  bool _highlight = false;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {
    final lclDbModel = Provider.of<LocalDBModel>(context);
    if (!_isInit) {
      lclDbModel.showTambolaTutorial.then((flag) {
        _highlight = flag;
        _isInit = true;
        setState(() {});
      });
    }
    return Container(
      height: SizeConfig.screenWidth * 0.14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
            ),
            color: Colors.white,
          ),
          Image.asset(
            "images/fello-dark.png",
            height: kToolbarHeight * 0.6,
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              _highlight
                  ? Center(
                      child: SpinKitPulse(
                      size: 50,
                      color: Colors.white,
                    ))
                  : Container(),
              Center(
                  child: IconButton(
                onPressed: () {
                  AppState.delegate.appState.currentAction = PageAction(
                      state: PageState.addPage, page: TWalkthroughPageConfig);
                  lclDbModel.setShowTambolaTutorial = false;
                },
                icon: Icon(Icons.info),
                color: Colors.white,
              ))
            ],
          ),
        ],
      ),
    );
  }
}
