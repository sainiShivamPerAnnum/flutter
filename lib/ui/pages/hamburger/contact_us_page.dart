import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../base_util.dart';
import '../../../main.dart';

class ContactUsPage extends StatefulWidget {
  ContactUsPage({Key key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  BaseUtil baseProvider;
  AppState appState;
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            // backButtonDispatcher.didPopRoute();
          },
        ),
        elevation: 1.0,
        backgroundColor: UiConstants.primaryColor,
        iconTheme: IconThemeData(
          color: UiConstants.accentColor, //change your color here
        ),
        title: Text('Contact Us',
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.largeTextSize)),
      ),
      body : Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset("images/contact_us.svg", height : SizeConfig.screenHeight*0.3,width : MediaQuery.of(context).size.width,alignment: Alignment.bottomRight,),
          ),
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ListTile(title: Text('Request a call', style : TextStyle(fontSize: SizeConfig.largeTextSize, color: UiConstants.textColor)),tileColor: Colors.transparent, trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {

              },),
              SizedBox(height : SizeConfig.blockSizeVertical*1.5),
              ListTile(title: Text('Email Us', style : TextStyle(fontSize: SizeConfig.largeTextSize, color: UiConstants.textColor)),tileColor: Colors.transparent, trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                HapticFeedback.vibrate();
                _launchEmail();
              },),
              SizedBox(height : SizeConfig.blockSizeVertical*1.5),
              ListTile(title: Text('Chat with Us', style : TextStyle(fontSize: SizeConfig.largeTextSize, color: UiConstants.textColor)),tileColor: Colors.transparent, trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                HapticFeedback.vibrate();
                appState.currentAction = PageAction(state: PageState.addPage, page: ChatSupportPageConfig);
              },),
              SizedBox(height : SizeConfig.blockSizeVertical*1.5),
              ListTile(title: Text('FAQs', style : TextStyle(fontSize: SizeConfig.largeTextSize, color: UiConstants.textColor)),tileColor: Colors.transparent, trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                HapticFeedback.vibrate();
                appState.currentAction = PageAction(state: PageState.addPage, page: FaqPageConfig);
              },),
            ],
          )
        ],
      )
    );
  }

  String _encodeQueryParametersForEmail(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _launchEmail() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'hello@fello.in'
    );
    launch(emailLaunchUri.toString());
  } 

}