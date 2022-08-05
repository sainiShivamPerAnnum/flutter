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
      return NavbarButton(
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
        padding: EdgeInsets.only(top: SizeConfig.padding10),
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

class NavBarItemData {
  final String title;
  final String activeIconImage;
  final String inactiveIconImage;

  NavBarItemData(this.title, this.activeIconImage, this.inactiveIconImage);
}

class NavbarButton extends StatelessWidget {
  final NavBarItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const NavbarButton({this.data, this.isSelected, this.onTap, Key key})
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
          height: SizeConfig.screenHeight * 0.04,
          width: SizeConfig.screenHeight * 0.04,
          child: SvgPicture.asset(
            iconString,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(title,
            style: isSelected
                ? TextStyles.rajdhaniSB.colour(UiConstants.kTextColor)
                : TextStyles.rajdhaniSB.colour(UiConstants.kTextColor2))
      ],
    );
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
