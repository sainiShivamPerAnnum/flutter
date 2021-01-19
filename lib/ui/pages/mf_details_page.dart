import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/withdraw_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:fl_animated_linechart/common/pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MFDetailsPage extends StatefulWidget {
  @override
  _MFDetailsPageState createState() => _MFDetailsPageState();
}

class _MFDetailsPageState extends State<MFDetailsPage> {
  BaseUtil baseProvider;
  DBModel dbProvider;
  FcmHandler fcmProvider;
  int acctBalance = 0;

  _init() {
    if (fcmProvider != null && baseProvider != null) {
      fcmProvider.addIncomingMessageListener((valueMap) {
        if (valueMap['title'] != null && valueMap['body'] != null) {
          baseProvider.showPositiveAlert(
              valueMap['title'], valueMap['body'], context,
              seconds: 5);
        }
      }, 1);
      if (baseProvider.myUser.account_balance != null &&
          baseProvider.myUser.account_balance > 0)
        acctBalance = baseProvider.myUser.account_balance;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (fcmProvider != null) fcmProvider.addIncomingMessageListener(null, 1);
  }

  Map<DateTime, double> line1 = {
    DateTime.utc(2000, 12, 09): 5.0,
    DateTime.utc(2002, 02, 21): 10.0,
    DateTime.utc(2005, 04, 15): 15.0,
    DateTime.utc(2007, 12, 09): 18.0,
    DateTime.utc(2009, 02, 21): 22.0,
    DateTime.utc(2011, 04, 15): 15.0,
    DateTime.utc(2015, 12, 09): 27.0,
    DateTime.utc(2018, 02, 21): 32.0,
    DateTime.utc(2022, 04, 15): 25.0,
    DateTime.utc(2027, 12, 09): 40.0,
    DateTime.utc(2032, 02, 21): 35.0,
    DateTime.utc(2035, 04, 15): 45.0,
  };

  LineChart chart;

  int months = 1;
  double containerHeight = 10;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    fcmProvider = Provider.of<FcmHandler>(context);
    _init();
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    chart = AreaLineChart.fromDateTimeMaps(
      [line1],
      [UiConstants.primaryColor],
      ['C'],
      gradients: [
        Pair(UiConstants.primaryColor.withGreen(190), UiConstants.primaryColor)
      ],
    );
    return Scaffold(
      appBar: BaseUtil.getAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: _height * 0.02,
                            top: _height * 0.02,
                            bottom: _height * 0.02,
                          ),
                          width: _width * 0.2,
                          child: Image.asset(Assets.iciciGraphic,
                              fit: BoxFit.contain),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: FittedBox(
                          child: Text(
                            "ICICI Prudential Mutual Fund",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                        )),
                        SizedBox(
                          width: _height * 0.02,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: _height * 0.02, left: 20, right: 30),
                      child: Text(
                        'ICICI Prudential Liquid Mutual Fund is a'
                        ' popular fund that has consistently given an annual return of 6-7%.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: UiConstants.accentColor,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: _height * 0.02,
                      ),
                      height: _height * 0.3,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedLineChart(
                          chart,
                          key: UniqueKey(),
                        ), //Unique key to force animations
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: _height * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(5, 5),
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Table(
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.black.withOpacity(0.1),
                          ),
                          verticalInside: BorderSide(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                        children: [
                          TableRow(children: [
                            FundDetailsCell(
                              title: "Current Price",
                              data: "999",
                              info:
                                  "I am learning to build apps in Flutter. Now I have come to alert dialogs. I have done them before in Android and iOS, but how do I make an alert in Flutter?",
                            ),
                            FundDetailsCell(
                              title: "CAGR%",
                              data: "5.0",
                              info:
                                  "I am learning to build apps in Flutter. Now I have come to alert dialogs. I have done them before in Android and iOS, but how do I make an alert in Flutter?",
                            ),
                          ]),
                          TableRow(children: [
                            FundDetailsCell(
                              title: "Age",
                              data: "15",
                              info:
                                  "I am learning to build apps in Flutter. Now I have come to alert dialogs. I have done them before in Android and iOS, but how do I make an alert in Flutter?",
                            ),
                            FundDetailsCell(
                              title: "Yeild%",
                              data: "4.55",
                              info:
                                  "I am learning to build apps in Flutter. Now I have come to alert dialogs. I have done them before in Android and iOS, but how do I make an alert in Flutter?",
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("For More Details visit official Site"),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: _height * 0.02,
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(5, 5),
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "PROFIT CALCULATOR",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Investment Amount"),
                                    CalculatorCapsule(
                                      gradColors: [
                                        UiConstants.primaryColor.withGreen(190),
                                        UiConstants.primaryColor
                                      ],
                                      child: TextField(
                                        cursorColor: Colors.black,
                                        keyboardType: TextInputType.number,
                                        decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                left: 15,
                                                bottom: 11,
                                                top: 11,
                                                right: 15),
                                            hintText: "100"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Return Amount"),
                                    CalculatorCapsule(
                                      gradColors: [
                                        Colors.blueGrey,
                                        Colors.blueGrey[800],
                                      ],
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text("130"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Wrap(
                            spacing: 20,
                            children: [
                              Chip(
                                backgroundColor: UiConstants.chipColor,
                                label: Text("+100"),
                              ),
                              Chip(
                                backgroundColor: UiConstants.chipColor,
                                label: Text("+500"),
                              ),
                              Chip(
                                backgroundColor: UiConstants.chipColor,
                                label: Text("+1000"),
                              ),
                              Chip(
                                backgroundColor: UiConstants.chipColor,
                                label: Text("+5000"),
                              ),
                              Chip(
                                backgroundColor: UiConstants.chipColor,
                                label: Text("+10000"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Select No of Months: $months"),
                          Slider(
                            value: months.toDouble(),
                            onChanged: (val) {
                              setState(() {
                                months = val.toInt();
                              });
                            },
                            label: months.toString(),
                            max: 36,
                            min: 0,
                            divisions: 18,
                            activeColor: UiConstants.primaryColor,
                            inactiveColor:
                                UiConstants.primaryColor.withOpacity(0.2),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: _height * 0.02,
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(5, 5),
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "FAQs",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (ctx, i) {
                              return NewWidget();
                            },
                          )
                        ],
                      ),
                    ),
                    _buildBetaWithdrawButton(),
                  ],
                ),
              ),
            ),
          ),
          _buildBetaSaveButton(),
        ],
      ),
    );
  }

  Widget _buildBetaSaveButton() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        gradient: new LinearGradient(colors: [
          UiConstants.primaryColor,
          UiConstants.primaryColor.withBlue(190),
        ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
      ),
      child: new Material(
        child: MaterialButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DEPOSIT ',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
              // Text(
              //   'BETA',
              //   style: Theme.of(context).textTheme.button.copyWith(
              //         color: Colors.white,
              //         fontStyle: FontStyle.italic,
              //         fontSize: 10,
              //       ),
              // ),
            ],
          ),
          onPressed: () async {
            HapticFeedback.vibrate();
            Navigator.of(context).pushNamed('/deposit');
          },
          highlightColor: Colors.orange.withOpacity(0.5),
          splashColor: Colors.orange.withOpacity(0.5),
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }

  Widget _buildBetaWithdrawButton() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: MediaQuery.of(context).size.height * 0.02,
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: new LinearGradient(
          colors: [
            Colors.blueGrey,
            Colors.blueGrey[800],
          ],
          begin: Alignment(0.5, -1.0),
          end: Alignment(0.5, 1.0),
        ),
        // boxShadow: [
        //   new BoxShadow(
        //     color: Colors.black12,
        //     offset: Offset.fromDirection(20, 7),
        //     blurRadius: 3.0,
        //   )
        // ],
      ),
      child: new Material(
        child: MaterialButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WITHDRAW ',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
              // Text(
              //   'BETA',
              //   style: Theme.of(context).textTheme.button.copyWith(
              //         color: Colors.white,
              //         fontStyle: FontStyle.italic,
              //         fontSize: 10,
              //       ),
              // ),
            ],
          ),
          onPressed: () async {
            HapticFeedback.vibrate();
            showDialog(
                context: context,
                builder: (BuildContext context) => WithdrawDialog(
                      balance: baseProvider.myUser.account_balance,
                      withdrawAction: (String wAmount, String recUpiAddress) {
                        Navigator.of(context).pop();
                        baseProvider.showPositiveAlert(
                            'Withdrawal Request Added',
                            'Your withdrawal amount shall be credited shortly',
                            context);
                        dbProvider
                            .addFundWithdrawal(
                                baseProvider.myUser.uid, wAmount, recUpiAddress)
                            .then((value) {});
                      },
                    ));
          },
          highlightColor: Colors.orange.withOpacity(0.5),
          splashColor: Colors.orange.withOpacity(0.5),
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }
}

class NewWidget extends StatefulWidget {
  @override
  _NewWidgetState createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  bool open = false;
  void toggleContainerHeight() {
    if (!open) {
      setState(() {
        open = true;
      });
    } else {
      setState(() {
        open = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("What is ICICI Prudential Mutual Funds?"),
            Spacer(),
            IconButton(
              onPressed: toggleContainerHeight,
              icon: Icon(
                !open ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              ),
            ),
          ],
        ),
        AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 500),
          height: open ? MediaQuery.of(context).size.height * 0.05 : 0,
          padding: EdgeInsets.only(
            right: 30,
          ),
          width: double.infinity,
          child: Text(
              "Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem Lorem Ipsuem "),
        ),
      ],
    );
  }
}

class CalculatorCapsule extends StatelessWidget {
  final List<Color> gradColors;
  final Widget child;

  CalculatorCapsule({
    @required this.gradColors,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              ),
              gradient: new LinearGradient(
                colors: gradColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Center(
              child: Text(
                "₹",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class FundDetailsCell extends StatelessWidget {
  final String title, data, info;

  FundDetailsCell({
    @required this.data,
    @required this.title,
    @required this.info,
  });

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      height: 75,
      width: _width * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 20,
            ),
            child: Row(
              children: [
                Text(
                  "$title ",
                ),
                GestureDetector(
                  child: Icon(
                    Icons.info_outline,
                    size: 15,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        title: new Text(title),
                        content: Text(info),
                        actions: <Widget>[
                          new FlatButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop(); // dismisses only the dialog and returns nothing
                            },
                            child: new Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(data,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: Colors.black54,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
