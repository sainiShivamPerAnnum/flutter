import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/Parallax-card/card_renderer.dart';
import 'package:felloapp/ui/elements/Parallax-card/data_model.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'rotation_3d.dart';

class GameCardList extends StatefulWidget {
  final List<Game> games;
  final Function onGameChange;

  const GameCardList({Key key, this.games, @required this.onGameChange})
      : super(key: key);

  @override
  GameCardListState createState() => GameCardListState();
}

class GameCardListState extends State<GameCardList>
    with SingleTickerProviderStateMixin {
  final double _maxRotation = 20;
  AppState appState;
  BaseUtil baseProvider;
  LocalDBModel _localDBModel;

  PageController _pageController;

  double _cardWidth = SizeConfig.screenWidth * 0.9;
  double _cardHeight = SizeConfig.screenWidth * 0.9;
  double _normalizedOffset = 0;
  double _prevScrollX = 0;
  bool _isScrolling = false;
  //int _focusedIndex = 0;

  AnimationController _tweenController;
  Tween<double> _tween;
  Animation<double> _tweenAnim;
  List<Function> gameRoutes;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    _localDBModel = Provider.of<LocalDBModel>(context, listen: false);
    gameRoutes = [
      () => baseProvider.openTambolaHome(),
      () {
        Haptic.vibrate();
        AppState.delegate.parseRoute(Uri.parse("d-gamePoll"));
      },
    ];

    //Calculate the viewPort fraction for this aspect ratio, since PageController does not accept pixel based size values
    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);

    //Create our main list
    Widget listContent = Container(
      //Wrap list in a container to control height and padding
      height: _cardHeight,
      //Use a ListView.builder, calls buildItemRenderer() lazily, whenever it need to display a listItem
      child: PageView.builder(
        //Use bounce-style scroll physics, feels better with this demo
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        itemCount: widget.games.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => _buildItemRenderer(i),
      ),
    );

    //Wrap our list content in a Listener to detect PointerUp events, and a NotificationListener to detect ScrollStart and ScrollUpdate
    //We have to use both, because NotificationListener does not inform us when the user has lifted their finger.
    //We can not use GestureDetector like we normally would, ListView suppresses it while scrolling.
    return Listener(
      onPointerUp: _handlePointerUp,
      child: NotificationListener(
        onNotification: _handleScrollNotifications,
        child: listContent,
      ),
    );
  }

  //Create a renderer for each list item
  Widget _buildItemRenderer(int itemIndex) {
    return GestureDetector(
      onTap: gameRoutes[itemIndex],
      child: Container(
        //Vertically pad all the non-selected items, to make them smaller. AnimatedPadding widget handles the animation.
        child: Rotation3d(
          rotationY: _normalizedOffset * _maxRotation,
          //Create the actual content renderer for our list
          child: TravelCardRenderer(
            //Pass in the offset, renderer can update it's own view from there
            _normalizedOffset,
            //Pass in Game path for the image asset links
            game: widget.games[itemIndex % widget.games.length],
            cardWidth: _cardWidth,
            cardHeight: _cardHeight,
          ),
        ),
      ),
    );
  }

  //Check the notifications bubbling up from the ListView, use them to update our currentOffset and isScrolling state
  bool _handleScrollNotifications(Notification notification) {
    //Scroll Update, add to our current offset, but clamp to -1 and 1
    if (notification is ScrollUpdateNotification) {
      if (_isScrolling) {
        double dx = notification.metrics.pixels - _prevScrollX;
        double scrollFactor = .01;
        double newOffset = (_normalizedOffset + dx * scrollFactor);
        _setOffset(newOffset.clamp(-1.0, 1.0));
      }
      _prevScrollX = notification.metrics.pixels;
      //Calculate the index closest to middle
      //_focusedIndex = (_prevScrollX / (_itemWidth + _listItemPadding)).round();
      widget.onGameChange(widget.games
          .elementAt(_pageController.page.round() % widget.games.length));
    }
    //Scroll Start
    else if (notification is ScrollStartNotification) {
      _isScrolling = true;
      _prevScrollX = notification.metrics.pixels;
      if (_tween != null) {
        _tweenController.stop();
      }
    }
    return true;
  }

  //If the user has released a pointer, and is currently scrolling, we'll assume they're done scrolling and tween our offset to zero.
  //This is a bit of a hack, we can't be sure this event actually came from the same finger that was scrolling, but should work most of the time.
  void _handlePointerUp(PointerUpEvent event) {
    if (_isScrolling) {
      _isScrolling = false;
      _startOffsetTweenToZero();
    }
  }

  //Helper function, any time we change the offset, we want to rebuild the widget tree, so all the renderers get the new value.
  void _setOffset(double value) {
    setState(() {
      _normalizedOffset = value;
    });
  }

  //Tweens our offset from the current value, to 0
  void _startOffsetTweenToZero() {
    //The first time this runs, setup our controller, tween and animation. All 3 are required to control an active animation.
    int tweenTime = 1000;
    if (_tweenController == null) {
      //Create Controller, which starts/stops the tween, and rebuilds this widget while it's running
      _tweenController = AnimationController(
          vsync: this, duration: Duration(milliseconds: tweenTime));
      //Create Tween, which defines our begin + end values
      _tween = Tween<double>(begin: -1, end: 0);
      //Create Animation, which allows us to access the current tween value and the onUpdate() callback.
      _tweenAnim = _tween.animate(new CurvedAnimation(
          parent: _tweenController, curve: Curves.elasticOut))
        //Set our offset each time the tween fires, triggering a rebuild
        ..addListener(() {
          _setOffset(_tweenAnim.value);
        });
    }
    //Restart the tweenController and inject a new start value into the tween
    _tween.begin = _normalizedOffset;
    _tweenController.reset();
    _tween.end = 0;
    _tweenController.forward();
  }
}
