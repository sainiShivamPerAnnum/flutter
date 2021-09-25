import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';

class TnC extends StatefulWidget {
  @override
  State createState() => _TnCState();
}

class _TnCState extends State<TnC> {
  Log log = new Log('TnC');
  String htmlString;
  bool _downloadFailed = false;
  bool _isLoadComplete = false;

  @override
  void initState() {
    super.initState();
    downloadFileAsync();
  }

  Future<dynamic> downloadFileAsync() async {
    File downloadToFile;
    try {
      Directory appDirectory = await getApplicationDocumentsDirectory();
      downloadToFile = File('${appDirectory.path}/tnc.html');
    } catch (e) {
      log.error('Failed to get app directory instance');
      log.error(e.toString());
      _isLoadComplete = true;
      _downloadFailed = true;
      setState(() {});
      return;
    }
    try {
      await FirebaseStorage.instance
          .ref('PolicyFiles/fello_tnc.html')
          .writeToFile(downloadToFile);
    } catch (err) {
      log.error('Referral plauolicy Download failed');
      log.error(err.toString());
      _isLoadComplete = true;
      _downloadFailed = true;
      setState(() {});
      return;
    }

    try {
      htmlString = downloadToFile.readAsStringSync();
      //await rootBundle.loadString(downloadToFile.readAsStringSync());
    } catch (onerr) {
      log.error('Failed to load sync string from download file: $onerr');
      _isLoadComplete = true;
      _downloadFailed = true;
      setState(() {});
      return;
    }
    _isLoadComplete = true;
    setState(() {});
  }

  Future<dynamic> readFileAsync() async {
    // htmlString =  await rootBundle.loadString('resources/fello_tnc.html');
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: BaseUtil.getAppBar(context, "Terms & Conditions"),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (_isLoadComplete && !_downloadFailed)
                  ? Html(
                      data: htmlString ?? '',
                    )
                  : Container(),
              (_isLoadComplete && _downloadFailed)
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Failed to load the Terms of Service at the moment. Please try again later',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: UiConstants.accentColor),
                        ),
                      ),
                    )
                  : Container(),
              (!_isLoadComplete)
                  ? Center(
                      child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: SpinKitWave(
                            color: UiConstants.primaryColor,
                          )),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
