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
  final List<NavBarItemDataV2> items;

  const NavBar({this.items, this.itemTapped, this.currentIndex = 0});

  NavBarItemDataV2 get selectedItem =>
      currentIndex >= 0 && currentIndex < items.length
          ? items[currentIndex]
          : null;

  @override
  Widget build(BuildContext context) {
    //For each item in our list of data, create a NavBtn widget
    List<Widget> buttonWidgets = items.map((data) {
      //Create a button, and add the onTap listener
      return NavbarButtonV2(
          data: data,
          isSelected: data == selectedItem,
          onTap: () {
            //Get the index for the clicked data
            var index = items.indexOf(data);
            //Notify any listeners that we've been tapped, we rely on a parent widget to change our selectedIndex and redraw
            itemTapped(index);
          });
    }).toList();

    //Create a container with a row, and add our btn widgets into the row
    return Container(
      //Clip the row of widgets, to suppress any overflow errors that might occur during animation
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
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

class NavBarItemDataV2 {
  final String title;
  final String activeIconImage;
  final String inactiveIconImage;

  NavBarItemDataV2(this.title, this.activeIconImage, this.inactiveIconImage);
}

class NavbarButtonV2 extends StatelessWidget {
  final NavBarItemDataV2 data;
  final bool isSelected;
  final VoidCallback onTap;

  const NavbarButtonV2({this.data, this.isSelected, this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isSelected
          ? BottomNavBarItemContent(
              iconString: data.activeIconImage,
              title: data.title,
              isSelected: isSelected,
            )
          : BottomNavBarItemContent(
              iconString: data.inactiveIconImage,
              title: data.title,
              isSelected: isSelected,
            ),
    );
  }
}

class BottomNavBarItemContent extends StatelessWidget {
  final String iconString;
  final String title;
  final bool isSelected;

  const BottomNavBarItemContent(
      {Key key, this.iconString, this.title, this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          width: 30,
          child: SvgPicture.asset(
            iconString,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: TextStyles.rajdhaniSB.copyWith(
              color: isSelected
                  ? UiConstants.kTextColor
                  : UiConstants.kTextColor2),
        )
      ],
    );
  }
}

// Handle the transition between selected and de-deselected, by animating it's own width,
// and modifying the color/visibility of some child widgets
// class NavbarButton extends StatefulWidget {
//   final NavBarItemData data;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const NavbarButton(this.data, this.isSelected, {@required this.onTap});

//   @override
//   _NavbarButtonState createState() => _NavbarButtonState();
// }

// class _NavbarButtonState extends State<NavbarButton>
//     with SingleTickerProviderStateMixin {
//   AnimationController _iconAnimController;
//   bool _wasSelected;

//   @override
//   void initState() {
//     //Create a tween + controller which will drive the icon rotation
//     int duration = 700;
//     _iconAnimController = AnimationController(
//       duration: Duration(milliseconds: duration),
//       vsync: this,
//     );
//     Tween<double>(begin: 0, end: 1).animate(_iconAnimController)
//       //Listen for tween updates, and rebuild the widget tree on each tick
//       ..addListener(() {
//         setState(() {});
//       });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _iconAnimController.dispose();
//     super.dispose();
//   }

//   Widget _buildContent() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         //Rotate the icon using the current animation value
//         Rotation3d(
//           rotationY: 180 * _iconAnimController.value,
//           child: widget.isSelected
//               ? Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white, shape: BoxShape.circle),
//                   padding: EdgeInsets.all(SizeConfig.padding8),
//                   child: SvgPicture.asset(widget.data.iconImage,
//                       width: SizeConfig.screenWidth * 0.048,
//                       color: Colors.black),
//                 )
//               : SvgPicture.asset(
//                   widget.data.iconImage,
//                   width: SizeConfig.screenWidth * 0.077,
//                   color: Colors.grey,
//                 ),
//         ),
//         //Add some hz spacing
//         SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
//         //Label
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Text(
//             widget.data.title,
//             style: TextStyles.body2
//                 .colour(
//                   widget.isSelected ? Colors.white : Colors.grey,
//                 )
//                 .bold,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     _startAnimIfSelectedChanged(widget.isSelected);
//     //Create our main button, a Row, with an icon and some text
//     //Inject the data from our widget.data property
//     var content = _buildContent();

//     //Wrap btn in GestureDetector so we can listen to taps
//     return GestureDetector(
//       onTap: () => widget.onTap(),
//       //Wrap in a bit of extra padding to make it easier to tap
//       child: Container(
//         color: Colors.black,
//         margin: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
//         //Wrap in an animated container, so changes to width & color automatically animate into place
//         child: AnimatedContainer(
//           alignment: Alignment.centerLeft,

//           //Determine target width, selected item is wider
//           //width: //widget.isSelected
//           //?
//           //  widget.data.width,
//           //: SizeConfig.screenWidth * 0.132,
//           curve: Curves.easeOutCubic,
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           duration: Duration(milliseconds: 1400),
//           //Use BoxDecoration top create a rounded container
//           decoration: BoxDecoration(
//             border: Border.all(
//                 color: widget.isSelected ? Colors.white : Colors.black),
//             borderRadius: BorderRadius.all(
//               Radius.circular(100),
//             ),
//           ),
//           //Wrap the row in a ClippedView to suppress any overflow errors if we momentarily exceed the screen size
//           child: ClippedView(
//             child: content,
//           ),
//         ),
//       ),
//     );
//   }

//   void _startAnimIfSelectedChanged(bool isSelected) {
//     if (_wasSelected != widget.isSelected) {
//       //Go forward or reverse, depending on the isSelected state
//       widget.isSelected
//           ? _iconAnimController.forward()
//           : _iconAnimController.reverse();
//     }
//     _wasSelected = widget.isSelected;
//   }
// }

// //Takes a x,y or z rotation, in degrees, and rotates. Good for spins & 3d flip effects
// class Rotation3d extends StatelessWidget {
//   //Degrees to rads constant
//   static const double degrees2Radians = pi / 180;

//   final Widget child;
//   final double rotationX;
//   final double rotationY;
//   final double rotationZ;

//   const Rotation3d(
//       {Key key,
//       @required this.child,
//       this.rotationX = 0,
//       this.rotationY = 0,
//       this.rotationZ = 0})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Transform(
//         alignment: FractionalOffset.center,
//         transform: Matrix4.identity()
//           ..setEntry(3, 2, 0.001)
//           ..rotateX(rotationX * degrees2Radians)
//           ..rotateY(rotationY * degrees2Radians)
//           ..rotateZ(rotationZ * degrees2Radians),
//         child: child);
//   }
// }

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

// class NavBarItemData {
//   final String title;
//   final String iconImage;
//   final double width;

//   NavBarItemData(this.title, this.iconImage, this.width);
// }
