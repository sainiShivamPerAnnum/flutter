import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  String _panError;
  String _amountError;
  String _upiAddress;
  String _amtError;
  bool _hasInvested = false;
  bool _isProcessing = false;
  String transactionMsg = null;

  // used for defining amount and UPI address of merchant where
  // payment is to be received.
  TextEditingController _upiAddressController = TextEditingController();
  TextEditingController _panController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  // used for showing list of UPI apps installed in current device
  Future<List<ApplicationMeta>> _appsFuture;

  @override
  void initState() {
    super.initState();

    // we have declared amount as 999 (i.e. Rs.999).
    _amountController.text = (100).toString();

    // we have used sample UPI address (will be used to receive amount)
    _upiAddress = BaseUtil.remoteConfig.getString('deposit_upi_address');
    _upiAddress = (_upiAddress==null||_upiAddress.isEmpty)?'9986643444@okbizaxis':_upiAddress;
    _upiAddressController.text = _upiAddress;

    // used for getting list of UPI apps installed in current device
    _appsFuture = UpiPay.getInstalledUpiApplications();
  }

  @override
  void dispose() {
    // dispose text field controllers after use.
    _upiAddressController.dispose();
    _panController.dispose();
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

    final panErr = _validatePANnumber(_panController.text);
    if(panErr != null) {
      setState(() {
        _panError = panErr;
      });
      return;
    }
    setState(() {
      _panError = null;
    });

    final amtErr = _validateAmount(_amountController.text, _hasInvested);
    if(amtErr != null) {
      setState(() {
        _amountError = amtErr;
      });
      return;
    }
    setState(() {
      _amountError = null;
    });

    final String _note = 'FelloDeposit-user'+ baseProvider.myUser.mobile + 'pan' + _panController.text;

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    // this function will initiate UPI transaction.
    final response = await UpiPay.initiateTransaction(
      amount: _amountController.text,
      app: app.upiApplication,
      receiverName: 'Fello',
      receiverUpiAddress: _upiAddress,
      transactionRef: transactionRef,
      merchantCode: '7372',
      transactionNote: _note
    );

    print('Printing UPI transaction response');
    print(response.rawResponse);
    _isProcessing = true;
    setState(() {});

    String sucFlag = 'NA';
    if(response.status == UpiTransactionStatus.success) sucFlag = 'SUCCESS';
    else if(response.status == UpiTransactionStatus.failure) sucFlag = 'FAILURE';
    else if(response.status == UpiTransactionStatus.submitted) sucFlag = 'SUBMITTED';

    dbProvider.addFundDeposit(baseProvider.myUser.uid,
        _amountController.text, response.rawResponse, sucFlag).then((value) {
      if(value) {
        baseProvider.myUser.pan = _panController.text;
        dbProvider.updateUser(baseProvider.myUser).then((value) {
          transactionMsg = 'Transaction details successfully saved. Your account and ticket balance will soon be updated!';
          _isProcessing = false;
          setState(() {});
        });
      }else{
        transactionMsg = 'Failed to save the transaction details. '
            ' We would request you to kindly send us a screenshot of the UPI transaction.'
            ' We will contact you to confirm the transaction.';
        _isProcessing = false;
        setState(() {});
      }
    });
  }

  _initFields() {
    if(baseProvider != null) {
      if(baseProvider.myUser != null && baseProvider.myUser.pan != null && baseProvider.myUser.pan.isNotEmpty) {
        _panController.text = baseProvider.myUser.pan;
        _hasInvested = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);

    return new Scaffold(
        appBar: BaseUtil.getAppBar(),
        body: _buildUpiLayout()
    );
  }

  Widget _buildUpiLayout() {
    _initFields();
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
                            offset: Offset.fromDirection(20, 5),
                            blurRadius: 1.0,
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
                            Text('Deposit with Fello and we will seamlessly invest your amount and forward all relevant confirmations',
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
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('Receiving UPI address: $_upiAddress',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey
                  ),
                ),
              ),
              (!_isProcessing && transactionMsg != null && transactionMsg.isNotEmpty)?Padding(
                padding: EdgeInsets.all(10),
                child: Text(transactionMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: UiConstants.primaryColor
                  ),
                ),
              ):Container(),
              (_isProcessing)?Padding(
                  padding: EdgeInsets.all(30),
                  child: SpinKitWave(
                    color: UiConstants.primaryColor,
                  )
              ):Container(),
              (_isProcessing)?Padding(
                  padding: EdgeInsets.all(30),
                  child: Text('Please do not close this window',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: UiConstants.accentColor
                    ),
                  ),
              ):Container(),
              (!_isProcessing)?Container(
                margin: EdgeInsets.only(top: 32),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _panController,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '',
                          labelText: 'Your PAN number',
                        ),
                      ),
                    ),
                  ],
                ),
              ):Container(),
              if (_panError != null)
                Container(
                  margin: EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _panError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              (!_isProcessing)?Container(
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
              ):Container(),
              if (_amountError != null)
                Container(
                  margin: EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _amountError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              (!_isProcessing)?Container(
                margin: EdgeInsets.only(top: 68, bottom: 32),
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
              ):Container()
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

String _validatePANnumber(String value) {
  if(value == null || value.isEmpty) {
    return 'Please enter a valid PAN number';
  }
  RegExp regex = new RegExp('[A-Z]{5}[0-9]{4}[A-Z]{1}');
  if(!regex.hasMatch(value) || value.length != 10) return 'Please enter a valid PAN number';

  return null;
}

String _validateAmount(String value, bool hasInvested) {
  if(value == null || value.isEmpty) {
    return 'Please enter a valid amount';
  }
  try{
    double amount = double.parse(value);
    if(!hasInvested && amount < 100) return 'A minimum investment of ₹100 is required for the first investment';
    if(hasInvested && amount < 1) return 'Please enter value more than ₹1';
    else if(amount > 1500) return 'We are currently only accepting deposits below ₹1500';
    else return null;
  }catch(e) {
    return 'Please enter a valid amount';
  }
}
