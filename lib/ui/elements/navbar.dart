import 'dart:core';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding28),
      child: Row(
        //Center buttons horizontally
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Inject a bunch of btn instances into our row
        children: buttonWidgets,
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
          ? Expanded(
              child: Stack(
                children: [
                  CustomPaint(
                    painter: SelectedItemBackdrop(),
                    size: Size(
                        data.title == 'Journey'
                            ? SizeConfig.screenWidth * 0.12
                            : data.title == 'Win'
                                ? SizeConfig.screenWidth * 0.1
                                : SizeConfig.screenWidth * 0.09,
                        SizeConfig.screenWidth * 0.06),
                  ),
                  BottomNavBarItemContent(
                    iconString: data.activeIconImage,
                    title: data.title,
                    isSelected: isSelected,
                    width: SizeConfig.screenWidth * 0.09,
                  ),
                ],
              ),
            )
          : Expanded(
              child: BottomNavBarItemContent(
                iconString: data.inactiveIconImage,
                title: data.title,
                isSelected: isSelected,
                width: SizeConfig.screenWidth * 0.09,
              ),
            ),
    );
  }
}

class BottomNavBarItemContent extends StatelessWidget {
  final String iconString;
  final String title;
  final bool isSelected;
  final double width;

  const BottomNavBarItemContent(
      {Key key, this.iconString, this.title, this.isSelected, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: SizeConfig.screenWidth * 0.09,
          width: width,
          child: SvgPicture.asset(
            iconString,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: SizeConfig.screenWidth * 0.01,
        ),
        Text(title,
            style: isSelected
                ? TextStyles.rajdhaniSB.colour(UiConstants.kTextColor)
                : TextStyles.rajdhaniSB.colour(UiConstants.kTextColor2))
      ],
    );
  }
}

class SelectedItemBackdrop extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width * 0.7258065, size.height);
    path_0.lineTo(size.width * 0.2580645, size.height);
    path_0.lineTo(0, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF55AF95).withOpacity(0),
          Color(0xFF55AF95),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(10, 10),
        radius: 25,
      ));
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
