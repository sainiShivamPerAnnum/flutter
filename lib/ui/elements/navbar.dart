import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      return NavbarButton(data, data == selectedItem, onTap: () {
        //Get the index for the clicked data
        var index = items.indexOf(data);
        //Notify any listeners that we've been tapped, we rely on a parent widget to change our selectedIndex and redraw
        itemTapped(index);
      });
    }).toList();

    //Create a container with a row, and add our btn widgets into the row
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
      ),

      // margin:
      //  (Platform.isIOS)
      //     ? EdgeInsets.only(
      //         left: SizeConfig.blockSizeHorizontal * 5,
      //         right: SizeConfig.blockSizeHorizontal * 5,
      //         bottom: MediaQuery.of(context).padding.bottom * 0.15)
      //     : EdgeInsets.symmetric(
      //         horizontal: SizeConfig.blockSizeHorizontal * 5),
      //Clip the row of widgets, to suppress any overflow errors that might occur during animation
      child: Row(
        //Center buttons horizontally
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // Inject a bunch of btn instances into our row
        children: buttonWidgets,
      ),
    );
  }
}

// Handle the transition between selected and de-deselected, by animating it's own width,
// and modifying the color/visibility of some child widgets
class NavbarButton extends StatefulWidget {
  final NavBarItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const NavbarButton(this.data, this.isSelected, {@required this.onTap});

  @override
  _NavbarButtonState createState() => _NavbarButtonState();
}

class _NavbarButtonState extends State<NavbarButton>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimController;
  bool _wasSelected;

  @override
  void initState() {
    //Create a tween + controller which will drive the icon rotation
    int duration = 700;
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //Rotate the icon using the current animation value
        Rotation3d(
          rotationY: 180 * _iconAnimController.value,
          child: widget.isSelected
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  padding: EdgeInsets.all(SizeConfig.padding8),
                  child: SvgPicture.asset(widget.data.iconImage,
                      height: SizeConfig.screenWidth * 0.048,
                      color: UiConstants.primaryColor),
                )
              : SvgPicture.asset(
                  widget.data.iconImage,
                  height: SizeConfig.screenWidth * 0.077,
                  color: Color(0xffC2EDE4),
                ),
        ),
        //Add some hz spacing
        SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
        //Label
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.data.title,
            style: TextStyles.body2.colour(Colors.white).bold,
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
    var content = _buildContent();

    //Wrap btn in GestureDetector so we can listen to taps
    return GestureDetector(
      onTap: () => widget.onTap(),
      //Wrap in a bit of extra padding to make it easier to tap
      child: Container(
        color: UiConstants.primaryColor,
        margin: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
        //Wrap in an animated container, so changes to width & color automatically animate into place
        child: AnimatedContainer(
          alignment: Alignment.centerLeft,

          //Determine target width, selected item is wider
          width: widget.isSelected ? widget.data.width : 64,
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 12),
          duration: Duration(milliseconds: 1400),
          //Use BoxDecoration top create a rounded container
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.isSelected
                    ? Colors.white
                    : UiConstants.primaryColor),
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
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

  NavBarItemData(this.title, this.icon, this.iconImage, this.width);
}
