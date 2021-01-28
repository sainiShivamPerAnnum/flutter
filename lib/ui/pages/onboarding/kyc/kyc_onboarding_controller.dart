import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/signature.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class KycOnboardController extends StatefulWidget {
  @override
  State createState() => _KycOnboardControllerState();
}

class _KycOnboardControllerState extends State<KycOnboardController> {

  static BaseUtil baseProvider;
  File image;



  KYCModel kycModel = KYCModel();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: BaseUtil.getAppBar(),

      body: Container(
        child: Center(
          child: Column(
            children: [
              MyButton(title: "Create Object", onPressed: () async
              {

                var result = await kycModel.createOnboardingObj();

                bool flag = result['flag'];
                print(flag);
                var message = result['message'];

                print(message);


                // flag == true ? baseProvider.showPositiveAlert('Success',
                //     '$message', context)
                //     : baseProvider.showNegativeAlert('Failed',
                //     'user already exists',
                //     context);

              }),



              MyButton(title: "Siganture", onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignatureScreen()),
                );


              }),
              MyButton(title: "Profile", onPressed: () {}),

              MyButton(
                  title: "POI",
                  onPressed: (){

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  AlertDialog(
                          title: Center(child: Text("POD")),
                          content: Text("Choose image from"),
                          actions: [

                            new FlatButton(
                              child: Text('Camera'),
                              onPressed: () async {
                                image = await ImagePicker.pickImage(source: ImageSource.camera);
                                var imagePath = image.path;

                                print(imagePath);

                               // var result =
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
                            FlatButton(
                              child: Text('Gallery'),
                              onPressed: () async {
                                image = await ImagePicker.pickImage(source: ImageSource.camera);
                                var imagePath = image.path;

                                await kycModel.executePOI(imagePath);



                              },
                            ),

                          ],
                        );
                      },
                    );





                  }),



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
