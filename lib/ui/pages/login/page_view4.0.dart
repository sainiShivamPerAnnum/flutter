import 'package:felloapp/ui/pages/login/choose_avatat.dart';
import 'package:felloapp/ui/pages/login/dob_4.0.dart';
import 'package:felloapp/ui/pages/login/email_4.0.dart';
import 'package:felloapp/ui/pages/login/login_4.0.dart';
import 'package:felloapp/ui/pages/login/name_4.0.dart';
import 'package:felloapp/ui/pages/login/otp_4.0.dart';
import 'package:felloapp/ui/pages/login/user_4.0.dart';
import 'package:flutter/material.dart';

class PageView4 extends StatefulWidget {
  PageView4({Key key}) : super(key: key);

  @override
  State<PageView4> createState() => _PageView4State();
}

class _PageView4State extends State<PageView4> {
  final _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        SignUp4(),
        OTP4(),
        User4(),
        ChooseAvatar4(),
        Name4(),
        Email4(),
        DOB4(),
      ],
    );
  }
}
