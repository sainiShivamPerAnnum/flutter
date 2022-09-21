import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class CarousalWidget extends StatefulWidget {
  final List<Widget> widgets;
  final double height;
  final double width;

  const CarousalWidget({Key key, this.widgets, this.height, this.width})
      : super(key: key);

  @override
  State<CarousalWidget> createState() => _CarousalWidgetState();
}

class _CarousalWidgetState extends State<CarousalWidget> {
  int _currentPos = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: widget.height,
          width: widget.width,
          child: PageView.builder(
            itemBuilder: ((context, index) => widget.widgets[index]),
            itemCount: widget.widgets.length,
            onPageChanged: (val) {
              setState(() {
                _currentPos = val;
              });
            },
          ),
        ),
        SizedBox(
          height: SizeConfig.padding20,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            widget.widgets.length,
            (index) => Container(
              width: SizeConfig.padding8,
              height: SizeConfig.padding8,
              margin: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _currentPos == index ? Colors.white : Colors.transparent,
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
              ),
            ),
          ),
        )
      ],
    );
  }
}
