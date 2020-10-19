import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/tambola_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TambolaView extends TambolaViewModel {
  Log log = new Log('TambolaView');
  DBModel _reqProvider;
  BaseUtil _baseProvider;
  @override
  void initState() {
    decodeBoard(sampleTambolaString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _reqProvider = Provider.of<DBModel>(context);
    _baseProvider = Provider.of<BaseUtil>(context);

    return Scaffold(
      body: _getBody(),
    );
  }

  Widget _buildGameBody() {
    int gridStateHeight = TambolaViewModel.boardHeight;
    int gridStateLength = TambolaViewModel.boardLength;
    return Column(children: <Widget>[
      AspectRatio(
          aspectRatio: 0.98,
          child: SizedBox.expand(
            child: Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridStateLength,
                ),
                itemBuilder: _buildGridItems,
                itemCount: gridStateLength * gridStateHeight,
              ),
            ),
          )),
    ]);
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateHeight = TambolaViewModel.boardHeight;
    int gridStateLength = TambolaViewModel.boardLength;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);

    return GestureDetector(
      onTap: () => gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          child: Center(
            child: _buildGridItem2(x, y),
          ),
        ),
      ),
    );
  }

  Widget _getItemContainer(int x, int y, int digit) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: this.gridOnTap && x == this.tappedX && y == this.tappedY
                  ? Colors.orange
                  : Colors.black,
              width: this.gridOnTap && x == this.tappedX && y == this.tappedY
                  ? 2.0
                  : 0.0),
          color: (x + y) % 2 == 0 ? Colors.blueGrey : Colors.grey,
        ),
        foregroundDecoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: x == 0 ? 2.0 : 0.0,
                    color: x == 0 ? Colors.orange : Colors.black),
                left: BorderSide(
                    width: y == 0 ? 2.0 : 0.0,
                    color: y == 0 ? Colors.orange : Colors.black),
                bottom: BorderSide(
                    width: x == 2 ? 2.0 : 0.0,
                    color: x == 2 || x == 5 || x == 8
                        ? Colors.orange
                        : Colors.black),
                right: BorderSide(
                    width: y == 8 ? 2.0 : 0.0,
                    color: y == 2 || y == 5 || y == 8
                        ? Colors.orange
                        : Colors.black))),
        child: Center(
          child: Text(digit == 0 ? '' : digit.toString()),
        ),
      ),
    );
  }

  Widget _buildGridItem2(int x, int y) {
    return _getItemContainer(x, y, tambolaBoard[x][y]);
  }

  _getBody() {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          // margin: EdgeInsets.only(top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGameBody(),
              _buildButton()
            ],
          ),
        ),
      ],
    );
  }

  _buildButton() {
    return Padding(
      padding: EdgeInsets.all(20.0),
        child:Material(
          child: MaterialButton(
            color: Colors.blueAccent,
            child: Text('Get Tickets',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            minWidth: double.infinity,
            height: 50,
            onPressed: () {
              _reqProvider.pushTicketRequest(_baseProvider.myUser, 1);
            },
          ),
          borderRadius: new BorderRadius.circular(80.0),
        )
    );
  }

  _body() {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          //bot stack
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                color: Colors.blueGrey,
              ),
              Container(
                color: Colors.white,
              )
            ],
          ),
        ),
        Container(
          //top stack
          margin: EdgeInsets.only(top: 35.0),
          child: Column(
            children: <Widget>[
              // Container(
              //   child: Text("Tambola"),
              //   margin: EdgeInsets.only(bottom: 30.0),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: <Widget>[
              //     GestureDetector(
              //         onTap: (){
              //           // MyDialog(context, "WARNING", "Permainan ini akan direset", Status.WARNING).build(() {
              //           //   resetGame();
              //           //   Navigator.pop(context);
              //           // }, cancel: (){
              //           //   Navigator.pop(context);
              //           // });
              //         },
              //         child: Container(
              //           padding: EdgeInsets.only(right: 20.0),
              //           color: Colors.orange,
              //           child: new Row(
              //             children: <Widget>[
              //               IconButton(
              //                 icon: Icon(Icons.add, color: Colors.white),
              //                 onPressed: resetGame,
              //               ),
              //               Text("NEW GAME", style: TextStyle(color: Colors.white))
              //             ],
              //           ),
              //         )
              //     ),
              //     Column(
              //       children: <Widget>[
              //         Text("Time Remaining", style: TextStyle(color: Colors.white),),
              //         Row(
              //           children: <Widget>[
              //             InkWell(
              //               onTap: (){
              //                 onStartStopPress();
              //               },
              //               child: new Icon(playButton ? Icons.pause : Icons.play_arrow, color: Colors.orange,),
              //             ),
              //             new Text(countDownText, style: TextStyle(color: Colors.white),)
              //           ],
              //         )
              //       ],
              //     )
              //   ],
              // ),
              _buildGameBody(),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                        "1",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        //panggil method insert
                        onTapInsertGrid(1);
                        //ToDO: buat method insert untuk pengerjaan manual
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "2",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        //panggil method insert
                        onTapInsertGrid(2);
                        //ToDO: buat method insert untuk pengerjaan manual
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "3",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        onTapInsertGrid(3);
                        //panggil method insert
                        //ToDO: buat method insert untuk pengerjaan manual
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "4",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        onTapInsertGrid(4);
                        //panggil method insert
                        //ToDO: buat method insert untuk pengerjaan manual
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "5",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        onTapInsertGrid(5);
                        //panggil method insert
                        //ToDO: buat method insert untuk pengerjaan manual
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "6",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        onTapInsertGrid(6);
                        //panggil method insert
                        //ToDO: buat method insert untuk pengerjaan manual
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "7",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        onTapInsertGrid(7);
                        //panggil method insert
                        //ToDO: buat method insert untuk pengerjaan manual
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "8",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        onTapInsertGrid(8);
                        //panggil method insert
                        //ToDO: buat method insert untuk pengerjaan manual
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "9",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        onTapInsertGrid(9);
                        //panggil method insert
                        //ToDO: buat method insert untuk pengerjaan manual
                      },
                    )
                  ],
                ),
              ),
              // Expanded(
              //     child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child: AspectRatio(
              //         aspectRatio: 6.0,
              //         child: GestureDetector(
              //             onTap: (){
              //               // MyDialog(context, "WARNING", "Apakah Anda mengaku selesai ?", Status.WARNING).build(() {
              //               //   Navigator.pop(context);
              //               //   setState(() {
              //               //     try_solving();
              //               //   });
              //               // }, cancel: (){
              //               //   Navigator.pop(context);
              //               // });
              //             },
              //             child: Container(
              //                 padding: EdgeInsets.all(20.0),
              //                 color: Colors.green,
              //                 child: new Center(
              //                   child: Text("SOLVE ME!", style: TextStyle(fontSize: 20, color: Colors.white)),
              //                 )
              //             )
              //         ),
              //       ),
              //     )
              // )
            ],
          ),
        )
      ],
    );
  }
}
