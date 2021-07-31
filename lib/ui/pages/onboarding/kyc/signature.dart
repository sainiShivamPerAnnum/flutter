import 'dart:io';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  // final String status;
  // final String status_keword;

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  static bool loading = false;

  KYCModel kycModel = KYCModel();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final SignatureScreen pod = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: BaseUtil.getAppBar(context, null),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        // color: myColors.homeColor,
        child: ListView(
          children: [
            Signature(
              controller: _controller,
              height: size.height * .75,
              backgroundColor: Colors.white,
            ),
            BottomAppBar(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      var image = await _controller.toImage();
                      // var order = pod.order_id;

                      var data =
                          await image.toByteData(format: ImageByteFormat.png);
                      // var name = '$order+.png';
                      final tempFile = File(
                          "${(await getTemporaryDirectory()).path}signature.png");

                      final file = await tempFile.writeAsBytes(
                        data.buffer.asUint8List(
                            data.offsetInBytes, data.lengthInBytes),
                      );

                      var res = await kycModel.updateSignature(file.path);

                      // bool flag = res['flag'];

                      if (res['flag'] == true) {
                        setState(() {
                          loading = false;
                        });

                        Navigator.of(context).pop(res);
                      } else {
                        setState(() {
                          loading = false;
                        });

                        Navigator.of(context).pop(res);

                        print("error");
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
