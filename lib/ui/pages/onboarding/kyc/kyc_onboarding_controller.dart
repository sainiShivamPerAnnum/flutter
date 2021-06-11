import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/signature.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/verify_kyc_webview.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class KycOnboardController extends StatefulWidget {
  @override
  State createState() => _KycOnboardControllerState();
}

class _KycOnboardControllerState extends State<KycOnboardController> {
  static BaseUtil baseProvider;
  File image;

  KYCModel kycModel = KYCModel();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseUtil.getAppBar(context),
      body: Container(
        child: Center(
          child: Column(
            children: [
              MyButton(
                  title: "Create Object",
                  onPressed: () async {
                    // var email = "finalTest@gmail.com";
                    // var username = "fello272sg";
                    // var phone = "9811111111";
                    // var name = "Fello";
                    //
                    // var result = await kycModel.createOnboardingObject(
                    //     email, username, phone, name);
                    //
                    // bool flag = result['flag'];
                    // print(flag);
                    // var message = result['message'];
                    //
                    // print(message);

                    // flag == true ? baseProvider.showPositiveAlert('Success',
                    //     '$message', context)
                    //     : baseProvider.showNegativeAlert('Failed',
                    //     'user already exists',
                    //     context);
                  }),

              MyButton(
                  title: "Siganture",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignatureScreen()),
                    );
                  }),
              MyButton(
                  title: "Profile",
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(child: Text("Update profile")),
                          content: Text("Choose image from"),
                          actions: [
                            new TextButton(
                              child: Text('Camera'),
                              onPressed: () async {
                                var image = await picker.getImage(
                                    source: ImageSource.camera);
                                var imagePath = image.path;

                                print(imagePath);

                                var result =
                                    await kycModel.updateProfile(imagePath);
                              },
                            ),
                            TextButton(
                              child: Text('Gallery'),
                              onPressed: () async {
                                final image = await picker.getImage(
                                    source: ImageSource.gallery);
                                var imagePath = image.path;

                                await kycModel.updateProfile(imagePath);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),

              MyButton(
                  title: "POI",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(child: Text("POD")),
                          content: Text("Choose image from"),
                          actions: [
                            new TextButton(
                              child: Text('Camera'),
                              onPressed: () async {
                                var image = await picker.getImage(
                                    source: ImageSource.camera);
                                var imagePath = image.path;

                                print(imagePath);

                                var result =
                                    await kycModel.executePOI(imagePath);

                                // var flag = result["flag"];
                                //
                                // if(flag)
                                //   {
                                //     print("success");
                                //     Navigator.pop(context);
                                //
                                //   }
                                // else
                                //   {
                                //     print("FAiled");
                                //
                                //  }
                              },
                            ),
                            TextButton(
                              child: Text('Gallery'),
                              onPressed: () async {
                                final image = await picker.getImage(
                                    source: ImageSource.gallery);
                                var imagePath = image.path;

                                await kycModel.executePOI(imagePath);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),

              MyButton(
                  title: "Cancelled Cheque",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(child: Text("POD")),
                          content: Text("Choose image from"),
                          actions: [
                            new TextButton(
                              child: Text('Camera'),
                              onPressed: () async {
                                var image = await picker.getImage(
                                    source: ImageSource.camera);
                                var imagePath = image.path;

                                print(imagePath);

                                var result =
                                    await kycModel.cancelledCheque(imagePath);
                              },
                            ),
                            TextButton(
                              child: Text('Gallery'),
                              onPressed: () async {
                                final image = await picker.getImage(
                                    source: ImageSource.gallery);
                                var imagePath = image.path;

                                await kycModel.cancelledCheque(imagePath);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),

              MyButton(
                  title: "Penny Transfer",
                  onPressed: () async {
                    var accountNumber = "50100344606311";
                    var ifscCode = "HDFC0000119";
                    var name = "Abhishek";

                    await kycModel.bankPennyTransfer(
                        accountNumber, ifscCode, name);
                  }),

              MyButton(
                  title: "PDF",
                  onPressed: () async {
                    await kycModel.generatePdf();
                  }),

              // MyButton(title: "Location", onPressed: () async
              // {
              //   kycModel.uploadLocation();
              //
              // }),
              //
              //
              // MyButton(
              //     title: "Video",
              //     onPressed: () async{
              //
              //       var image = await picker.getVideo(source: ImageSource.camera);
              //       var imagePath = image.path;
              //
              //       await kycModel.recordVideo(imagePath);
              //
              //
              //
              //
              //
              //     }),
              //
              // MyButton(
              //     title: "FATCA",
              //     onPressed: () async{
              //
              //
              //       // await kycModel.Fatca();
              //
              //
              //
              //
              //
              //     }),

              MyButton(
                  title: "Web View",
                  onPressed: () async {
                    var url =
                        "https://esign-preproduction.signzy.tech/nsdl-esign-customer2/5b2e4ddd84b5cd6c465019ed/token/8aBTTkfgtqiOZvUotD6GJ1yaalNTTmBAg04RTOzSsLSvGAbFAvC1l3mvjiCX1612553003805";

                    // if (await canLaunch(url)) {
                    //   await launch(url);
                    // } else {
                    //   throw 'Could not launch $url';
                    // }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KycWebview()),
                    );
                  }

                  // await kycModel.Fatca();

                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final Color colour;
  final String title;
  final Function onPressed;

  MyButton({this.colour, this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: UiConstants.primaryColor,
      textColor: Colors.white,
      child: Text(
        title,
      ),
    );
  }
}
