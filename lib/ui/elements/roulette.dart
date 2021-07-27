import 'package:felloapp/ui/elements/daily_pick_text_slider.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';

class Roulette extends StatelessWidget {
  Roulette({this.dailyPickTextList, this.digits});

  final List<String> dailyPickTextList;
  final List<int> digits;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 4),
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blueGrey[400],
          boxShadow: [
            new BoxShadow(
              color: Colors.black26,
              offset: Offset.fromDirection(20, 7),
              blurRadius: 5.0,
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.4],
            colors: [Colors.blueGrey[500], Colors.blueGrey[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 3),
                child: DPTextSlider(
                  infoList: dailyPickTextList,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    digits.length,
                    (index) => Holes(
                      pick: digits[index],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class Holes extends StatefulWidget {
  final int pick;

  Holes({this.pick});

  @override
  _HolesState createState() => _HolesState();
}

class _HolesState extends State<Holes> {
  ScrollController _scrollController;

  @override
  void initState() {
    if (widget.pick != -1) {
      _scrollController = ScrollController();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveDown();
      });
    }
    super.initState();
  }

  _moveDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        curve: Curves.linear, duration: Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    if (widget.pick != -1) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List pickList = [
      widget.pick - 2,
      widget.pick + 4,
      widget.pick + 10,
      widget.pick - 14,
      widget.pick + 8,
      widget.pick
    ];
    return Container(
      height: SizeConfig.screenWidth * 0.1,
      width: SizeConfig.screenWidth * 0.1,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: widget.pick != -1
          ? ListWheelScrollView(
              itemExtent: SizeConfig.screenWidth * 0.1,
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              children: List.generate(
                  pickList.length,
                  (i) => Container(
                        height: SizeConfig.screenWidth * 0.1,
                        width: SizeConfig.screenWidth * 0.1,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "${pickList[i]}",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                              fontSize: SizeConfig.largeTextSize),
                        ),
                      )),
            )
          // ListView.builder(
          //     physics: NeverScrollableScrollPhysics(),
          //     itemCount: pickList.length,
          //
          //     shrinkWrap: true,
          //     itemBuilder: (ctx, i) {
          //       return Container(
          //         height: SizeConfig.screenWidth * 0.1,
          //         width: SizeConfig.screenWidth * 0.1,
          //         alignment: Alignment.center,
          //         padding: EdgeInsets.all(8),
          //         child: Text(
          //           "${pickList[i]}",
          //           style: TextStyle(
          //               fontWeight: FontWeight.w700,
          //               fontSize: SizeConfig.largeTextSize),
          //         ),
          //       );
          //     },
          //   )
          : Center(
              child: Text(
                "-",
                style: TextStyle(fontSize: SizeConfig.largeTextSize),
              ),
            ),
    );
  }
}
