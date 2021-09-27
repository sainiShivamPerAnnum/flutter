//Project Imports
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/Buttons/large_button.dart';
import 'package:felloapp/ui/elements/custom-art/circles_with_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/size_config.dart';

//Dart and Flutter Imports
import 'dart:async';
import 'package:flutter/material.dart';

//Pub Imports
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class GetStartedPage extends StatefulWidget {
  @override
  State createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  List<bool> isVisible = List<bool>.filled(4, false);
  AppState appState;
  static const Duration animDuration = Duration(milliseconds: 190);

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackground(),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.05),
                child: Text(
                  'Game based Savings \n & Investments🎉',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: SizeConfig.largeTextSize * 1.1),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Container(
                    child: StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(12.0),
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 2,
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildTile(index);
                  },
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.fit(_fitSize(index)),
                )),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.05),
                child: _buildBtn(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned(
      child: CircleWithImage(Assets.logoMaxSize),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
  }

  Widget _buildBtn() {
    return AnimatedContainer(
      duration: animDuration,
      width: (isVisible[3]) ? SizeConfig.screenWidth - 50 : 0,
      child: new LargeButton(
        child: Text(
          'GET STARTED',
          style:
              Theme.of(context).textTheme.button.copyWith(color: Colors.white),
        ),
        onTap: () {
          Haptic.vibrate();
          appState.currentAction =
              PageAction(state: PageState.replaceAll, page: LoginPageConfig);
        },
      ),
    );
  }

  Widget _buildTile(int index) {
    switch (index) {
      case 0:
        {
          return AnimatedContainer(
              height: (isVisible[0]) ? SizeConfig.screenHeight * 0.15 : 0,
              duration: animDuration,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      Assets.getStartedDesc[0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.mediumTextSize),
                    ),
                  )));
        }
      case 1:
        {
          return AnimatedContainer(
            height: (isVisible[0]) ? SizeConfig.screenHeight * 0.15 : 0,
            duration: animDuration,
            child: Image(
              image: AssetImage('images/gs01.png'),
              fit: BoxFit.contain,
            ),
          );
        }
      case 3:
        {
          return AnimatedContainer(
            height: (isVisible[1]) ? SizeConfig.screenHeight * 0.15 : 0,
            duration: animDuration,
            child: Image(
              image: AssetImage('images/gs02.png'),
              fit: BoxFit.contain,
            ),
          );
        }
      case 4:
        {
          return AnimatedContainer(
              height: (isVisible[1]) ? SizeConfig.screenHeight * 0.15 : 0,
              duration: animDuration,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      Assets.getStartedDesc[1],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.mediumTextSize),
                    ),
                  )));
        }
      case 6:
        {
          return AnimatedContainer(
            height: (isVisible[2]) ? SizeConfig.screenHeight * 0.15 : 0,
            duration: animDuration,
            child: Image(
              image: AssetImage('images/gs03.png'),
              fit: BoxFit.contain,
            ),
          );
        }
      case 7:
        {
          return AnimatedContainer(
              height: (isVisible[2]) ? SizeConfig.screenHeight * 0.06 : 0,
              duration: animDuration,
              child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Text(
                      Assets.getStartedDesc[2],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.mediumTextSize),
                    ),
                  )));
        }
      default:
        return SizedBox(
          height: SizeConfig.screenHeight * 0.03,
        );
    }
  }

  int _fitSize(int index) {
    return (index == 2 || index == 5 || index == 6 || index == 7) ? 2 : 1;
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 400), () {
      setState(() {
        isVisible[0] = true;
      });
    });
    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        isVisible[1] = true;
      });
    });
    Timer(const Duration(milliseconds: 1200), () {
      setState(() {
        isVisible[2] = true;
      });
    });
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        isVisible[3] = true;
      });
    });
  }
}
