import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

class ReferralPolicy extends StatefulWidget {
  @override
  State createState() => _ReferralPolicyState();
}

class _ReferralPolicyState extends State<ReferralPolicy> {
  String htmlString;

  @override
  void initState() {
    super.initState();
    readFileAsync();
  }

  Future<dynamic> readFileAsync() async {
    htmlString =  await rootBundle.loadString('resources/referral_policy.html');
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: BaseUtil.getAppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            physics: BouncingScrollPhysics(),
            child:
            Html(
              data: htmlString??'',
            ),
          )
        )
    );
  }

}