import 'package:felloapp/ui/pages/root.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:core';
import 'dart:math';

class NavBar extends StatelessWidget {
  final ValueChanged<int> itemTapped;
  final int currentIndex;
  final List<NavBarItemData> items;

  const NavBar({this.items, this.itemTapped, this.currentIndex = 0});

  NavBarItemData get selectedItem =>
      currentIndex >= 0 && currentIndex < items.length
          ? items[currentIndex]
          : null;

  @override
  Widget build(BuildContext context) {
    //For each item in our list of data, create a NavBtn widget
    List<Widget> buttonWidgets = items.map((data) {
      //Create a button, and add the onTap listener
      return NavbarButton(data, data == selectedItem, data.showFocus,
          onTap: () {
        //Get the index for the clicked data
        var index = items.indexOf(data);
        //Notify any listeners that we've been tapped, we rely on a parent widget to change our selectedIndex and redraw
        itemTapped(index);
      });
    }).toList();

    //Create a container with a row, and add our btn widgets into the row
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.bottomNavBarColor,
        //Add some drop-shadow to our navbar, use 2 for a slightly nicer effect
        // boxShadow: [
        //   BoxShadow(blurRadius: 16, color: Colors.black12),
        //   BoxShadow(blurRadius: 24, color: Colors.black12),
        // ],
      ),
      alignment: Alignment.center,
      height: 80,
      //Clip the row of widgets, to suppress any overflow errors that might occur during animation
      child: SizedBox(
        child: Row(
          //Center buttons horizontally
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // Inject a bunch of btn instances into our row
          children: buttonWidgets,
        ),
      ),
    );
  }
}

// Handle the transition between selected and de-deselected, by animating it's own width,
// and modifying the color/visibility of some child widgets
class NavbarButton extends StatefulWidget {
  final NavBarItemData data;
  final bool isSelected;
  final bool isFocus;
  final VoidCallback onTap;

  const NavbarButton(this.data, this.isSelected, this.isFocus,
      {@required this.onTap});

  @override
  _NavbarButtonState createState() => _NavbarButtonState();
}

class _NavbarButtonState extends State<NavbarButton>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimController;
  bool _wasSelected;
  double _animScale = 1;

  @override
  void initState() {
    //Create a tween + controller which will drive the icon rotation
    int duration = (350 / _animScale).round();
    _iconAnimController = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this,
    );
    Tween<double>(begin: 0, end: 1).animate(_iconAnimController)
      //Listen for tween updates, and rebuild the widget tree on each tick
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _iconAnimController.dispose();
    super.dispose();
  }

  Widget _buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //Rotate the icon using the current animation value
        Rotation3d(
            rotationY: 180 * _iconAnimController.value,
            child: SvgPicture.asset(
              widget.data.iconImage,
              height: 24,
              color: widget.isSelected ? Colors.white : Color(0xffcccccc),
            )),
        //Add some hz spacing
        SizedBox(width: 12),
        //Label
        Text(
          widget.data.title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Montserrat",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _startAnimIfSelectedChanged(widget.isSelected);
    //Create our main button, a Row, with an icon and some text
    //Inject the data from our widget.data property
    var content = (widget.isFocus)
        ? Stack(children: [
            Center(
                child: SpinKitPulse(
              color: UiConstants.primaryColor,
            )),
            _buildContent()
          ])
        : _buildContent();

    //Wrap btn in GestureDetector so we can listen to taps
    return GestureDetector(
      onTap: () => widget.onTap(),
      //Wrap in a bit of extra padding to make it easier to tap
      child: Container(
        color: UiConstants.bottomNavBarColor,
        padding: EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
        //Wrap in an animated container, so changes to width & color automatically animate into place
        child: AnimatedContainer(
          alignment: Alignment.center,
          //Determine target width, selected item is wider
          width: widget.isSelected ? widget.data.width : 56,
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(12),
          duration: Duration(milliseconds: (700 / _animScale).round()),
          //Use BoxDecoration top create a rounded container
          decoration: BoxDecoration(
            color: widget.isSelected
                ? UiConstants.primaryColor
                : UiConstants.bottomNavBarColor,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          //Wrap the row in a ClippedView to suppress any overflow errors if we momentarily exceed the screen size
          child: ClippedView(
            child: content,
          ),
        ),
      ),
    );
  }

  void _startAnimIfSelectedChanged(bool isSelected) {
    if (_wasSelected != widget.isSelected) {
      //Go forward or reverse, depending on the isSelected state
      widget.isSelected
          ? _iconAnimController.forward()
          : _iconAnimController.reverse();
    }
    _wasSelected = widget.isSelected;
  }
}

//Takes a x,y or z rotation, in degrees, and rotates. Good for spins & 3d flip effects
class Rotation3d extends StatelessWidget {
  //Degrees to rads constant
  static const double degrees2Radians = pi / 180;

  final Widget child;
  final double rotationX;
  final double rotationY;
  final double rotationZ;

  const Rotation3d(
      {Key key,
      @required this.child,
      this.rotationX = 0,
      this.rotationY = 0,
      this.rotationZ = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(rotationX * degrees2Radians)
          ..rotateY(rotationY * degrees2Radians)
          ..rotateZ(rotationZ * degrees2Radians),
        child: child);
  }
}

//Hides the overflow of a child, preventing the Flutter framework from throwing errors
class ClippedView extends StatelessWidget {
  final Widget child;
  final Axis clipDirection;

  const ClippedView({Key key, this.child, this.clipDirection = Axis.horizontal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: clipDirection,
      child: child,
    );
  }
}

class NavBarItemData {
  final String title;
  final IconData icon;
  final String iconImage;
  final double width;
  bool showFocus;

  NavBarItemData(
      this.title, this.icon, this.width, this.iconImage, this.showFocus);
}
