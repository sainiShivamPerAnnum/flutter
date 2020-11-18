import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upi_pay/upi_pay.dart';

class UpiPayment extends StatefulWidget {
  @override
  _UpiPaymentState createState() => _UpiPaymentState();
}

class _UpiPaymentState extends State<UpiPayment> {
  // used for storing errors.
  BaseUtil baseProvider;
  DBModel dbProvider;
  String _upiAddrError;

  // used for defining amount and UPI address of merchant where
  // payment is to be received.
  TextEditingController _upiAddressController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  // used for showing list of UPI apps installed in current device
  Future<List<ApplicationMeta>> _appsFuture;

  @override
  void initState() {
    super.initState();

    // we have declared amount as 999 (i.e. Rs.999).
    _amountController.text = (1).toString();

    // we have used sample UPI address (will be used to receive amount)
    _upiAddressController.text = '998643444@okbizaxis';

    // used for getting list of UPI apps installed in current device
    _appsFuture = UpiPay.getInstalledUpiApplications();
  }

  @override
  void dispose() {
    // dispose text field controllers after use.
    _upiAddressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // this will open correspondence UPI Payment gateway app on which user has tapped.
  Future<void> _openUPIGateway(ApplicationMeta app) async {
    final err = _validateUpiAddress(_upiAddressController.text);
    if (err != null) {
      setState(() {
        _upiAddrError = err;
      });
      return;
    }
    setState(() {
      _upiAddrError = null;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    // this function will initiate UPI transaction.
    final a = await UpiPay.initiateTransaction(
      amount: _amountController.text,
      app: app.upiApplication,
      receiverName: 'Fello',
      receiverUpiAddress: _upiAddressController.text,
      transactionRef: transactionRef,
      merchantCode: '7372',
    );

    print(a);
  }

  // @override
  // Widget build(BuildContext context) {
  //   baseProvider = Provider.of<BaseUtil>(context);
  //   dbProvider = Provider.of<DBModel>(context);
  //   return Stack(
  //     children: [
  //       Container(
  //         height: 200,
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topRight,
  //             end: Alignment.bottomLeft,
  //             stops: [0.1, 0.6],
  //             colors: [
  //               UiConstants.primaryColor.withGreen(190),
  //               UiConstants.primaryColor,
  //             ],
  //           ),
  //           borderRadius: BorderRadius.only(
  //             bottomLeft: Radius.elliptical(
  //                 MediaQuery.of(context).size.width * 0.50, 18),
  //             bottomRight: Radius.elliptical(
  //                 MediaQuery.of(context).size.width * 0.50, 18),
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         top: 30,
  //         left: 5,
  //         child: IconButton(
  //           color: Colors.white,
  //           icon: Icon(Icons.settings),
  //           onPressed: () {
  //
  //           },
  //         ),
  //       ),
  //       Positioned(
  //         top: 30,
  //         right: 5,
  //         child: IconButton(
  //           color: Colors.white,
  //           icon: Icon(Icons.help_outline),
  //           onPressed: () {
  //             //Navigator.of(context).pushNamed(Settings.id);
  //           },
  //         ),
  //       ),
  //       Align(
  //           alignment: Alignment.topCenter,
  //           child: Padding(
  //             padding: EdgeInsets.only(top: 70),
  //             child: Column(
  //               children: [
  //                 Text(
  //                   '₹1,040',
  //                   style: TextStyle(
  //                       fontSize: 50,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white
  //                   ),
  //
  //                 ),
  //                 Text(
  //                   'saved',
  //                   style: TextStyle(
  //                       fontSize: 18,
  //                       color: Colors.white
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //       ),
  //       Padding(
  //           padding: EdgeInsets.only(top: 160),
  //           child: _buildUpiLayout()
  //       ),
  //       Align(
  //         alignment: Alignment.bottomCenter,
  //         child: _buildButton()
  //       )
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);

    return new Scaffold(
        appBar: BaseUtil.getAppBar(),
        body: _buildUpiLayout()
    );
  }

  Widget _buildUpiLayout() {
    return SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.black12,
                            offset: Offset.fromDirection(20, 7),
                            blurRadius: 3.0,
                            spreadRadius: 0.1
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [0.1, 0.4],
                        colors: [Colors.white, Colors.white],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Beta Deposit Dashboard',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: UiConstants.primaryColor,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Deposit with Fello and we will seamlessly invest your amount and forward all relevant receipts',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    height: 1.2,
                                    color: UiConstants.accentColor,
                                    fontWeight: FontWeight.w300
                                )
                            )
                          ]),
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _upiAddressController,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'address@upi',
                          labelText: 'Receiving UPI Address',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_upiAddrError != null)
                Container(
                  margin: EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _upiAddrError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Container(
                margin: EdgeInsets.only(top: 32),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        readOnly: false,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Amount',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 78, bottom: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Deposit using your installed UPI apps',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    FutureBuilder<List<ApplicationMeta>>(
                      future: _appsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container();
                        }

                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.6,
                          physics: NeverScrollableScrollPhysics(),
                          children: snapshot.data
                              .map((i) => Material(
                            key: ObjectKey(i.upiApplication),
                            color: Colors.grey[200],
                            child: InkWell(
                              onTap: () => _openUPIGateway(i),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.memory(
                                    i.icon,
                                    width: 64,
                                    height: 64,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 4),
                                    child: Text(
                                      i.upiApplication.getAppName(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
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
              dbProvider.pushTicketRequest(baseProvider.myUser, 1);
            },
          ),
          borderRadius: new BorderRadius.circular(80.0),
        )
    );
  }
}

String _validateUpiAddress(String value) {
  if (value.isEmpty) {
    return 'UPI Address is required.';
  }

  if (!UpiPay.checkIfUpiAddressIsValid(value)) {
    return 'UPI Address is invalid.';
  }

  return null;
}
