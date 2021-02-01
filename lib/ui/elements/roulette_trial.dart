import 'package:flutter/material.dart';

class Roulette extends StatefulWidget {
  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3;
  ScrollController _scrollController4;
  ScrollController _scrollController5;

  @override
  void initState() {
    _scrollController1 = new ScrollController();
    _scrollController2 = new ScrollController();
    _scrollController3 = new ScrollController();
    _scrollController4 = new ScrollController();
    _scrollController5 = new ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveDown();
    });
    super.initState();
  }

  _moveDown() {
    _scrollController1.animateTo(_scrollController1.position.maxScrollExtent,
        curve: Curves.linear, duration: Duration(milliseconds: 1000));
    _scrollController2.animateTo(_scrollController1.position.maxScrollExtent,
        curve: Curves.linear, duration: Duration(milliseconds: 800));
    _scrollController3.animateTo(_scrollController1.position.maxScrollExtent,
        curve: Curves.linear, duration: Duration(milliseconds: 1200));
    _scrollController4.animateTo(_scrollController1.position.maxScrollExtent,
        curve: Curves.linear, duration: Duration(milliseconds: 1000));
    _scrollController5.animateTo(_scrollController1.position.maxScrollExtent,
        curve: Curves.linear, duration: Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          width: double.infinity,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(horizontal: 20),
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
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.4],
              colors: [Colors.blueGrey[500], Colors.blueGrey[400]],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Holes(
                scrollController: _scrollController1,
                getchild: (int i) {
                  return (i).toString();
                },
              ),
              Holes(
                scrollController: _scrollController2,
                getchild: (int i) {
                  return (i * 2).toString();
                },
              ),
              Holes(
                scrollController: _scrollController3,
                getchild: (int i) {
                  return (i * 3).toString();
                },
              ),
              Holes(
                scrollController: _scrollController4,
                getchild: (int i) {
                  return (i * 4).toString();
                },
              ),
              Holes(
                scrollController: _scrollController5,
                getchild: (int i) {
                  return (i * 5).toString();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Holes extends StatelessWidget {
  final ScrollController scrollController;
  final Function getchild;

  Holes({this.scrollController, this.getchild});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
      height: _width * 0.08,
      width: _width * 0.08,
      padding: EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        controller: scrollController,
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          return Text(
            getchild(i),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: _height * 0.025),
          );
        },
      ),
    );
  }
}
