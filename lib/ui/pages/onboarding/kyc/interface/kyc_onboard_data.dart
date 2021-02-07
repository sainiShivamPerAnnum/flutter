import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:felloapp/core/model/UserKycDetail.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/location.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/fatcaforms.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/signature.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class KycOnboardData {
  static bool isLoading = false;
  ConfettiController _confeticontroller = new ConfettiController(
    duration: new Duration(seconds: 5),
  );
  File image;
  KYCModel kycModel = KYCModel();
  final picker = ImagePicker();
  Location location = Location();
  DBModel dbProvider = locator<DBModel>();
  BaseUtil baseProvider = locator<BaseUtil>();
  final _formKey = GlobalKey<FormState>();
  var imagef, imageb;
  TextEditingController _accNo = new TextEditingController();
  TextEditingController _ifsc = new TextEditingController();
  TextEditingController _accHoldName = new TextEditingController();
  TextEditingController _dob = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _fname = new TextEditingController();
  TextEditingController _pan = new TextEditingController();
  TextEditingController _uid = new TextEditingController();
  TextEditingController _pin = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  TextEditingController _district = new TextEditingController();

  //---------------------------------SHOW DIALOG BOX-----------------------------------------------------------//
  showStepDialog(BuildContext context, Widget title, Widget subtitle,
      List<Widget> actions) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (stepctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiConstants.padding),
            ),
            elevation: 0.0,
            title: title,
            content: subtitle,
            actions: actions,
          );
        });
  }

  //-----------------------SHOW UNDISMISSIBLE DIALOG BOX-------------------------------------------------------//
  showUDStepDialog(BuildContext context, Widget title, Widget subtitle,
      List<Widget> actions) {
    isLoading = true;
    showDialog(
        context: context,
        builder: (stepctx) {
          return WillPopScope(
            onWillPop: () async {
              if (isLoading) {
                return false;
              } else {
                return true;
              }
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiConstants.padding),
              ),
              elevation: 0.0,
              title: title,
              content: subtitle,
              actions: actions,
            ),
          );
        });
  }

//----------------------------SHOW UNDISMISSBLE LOADING DIALOG---------------------------------------------//
  showLoadingDialog(BuildContext context) {
    isLoading = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (loadingctx) {
          return WillPopScope(
            onWillPop: () async {
              if (isLoading) {
                return false;
              } else {
                return true;
              }
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiConstants.padding),
              ),
              elevation: 0.0,
              title: Text("Processing"),
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 12,
                  ),
                  Text("Please don't press back"),
                ],
              ),
            ),
          );
        });
  }

//------------------------------SHOW SUCCESS DIALOG-----------------------------------------------//
  showSuccessDialog(BuildContext context) {
    isLoading = false;
    showDialog(
        context: context,
        builder: (successctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiConstants.padding),
            ),
            elevation: 0.0,
            title: Text("Hurry"),
            content: Text("Step Completed"),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

//---------------------------ERROR DIALOG---------------------------------------------------------//
  showErrorDialog(BuildContext context, String message) {
    isLoading = false;
    showDialog(
        context: context,
        builder: (errorctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiConstants.padding),
            ),
            elevation: 0.0,
            title: Text("Snap!"),
            content: Text(message),
            actions: [
              FlatButton(
                child: Text("Retry"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  // ----------------------MARKS A PARTICULAR STEP AS ATTEMPTED -------------------------------------------------//
  _markStepAttempted(int step) async {
    baseProvider.kycDetail.isStepComplete[step] = -1;
    await dbProvider.updateUserKycDetails(
        baseProvider.myUser.uid, baseProvider.kycDetail);
  }

  // ------------------------MARKS A STEP COMPLETED-----------------------------------------------------------------//
  _markStepCompleted(int step) async {
    baseProvider.kycDetail.isStepComplete[step] = 1;
    if (step != 10) {
      baseProvider.kycDetail.isStepComplete[step + 1] = 2;
    }
    await dbProvider.updateUserKycDetails(
        baseProvider.myUser.uid, baseProvider.kycDetail);
  }

// ---------------------------------CREATE FORMS----------------------------------------------------------//
  Widget createForm(List<Widget> fields) {
    return Container(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Wrap(children: fields),
        ),
      ),
    );
  }

//----------------------------------CREATE EDITABLE FIELD FOR FORMS -----------------------------------//
  Widget createEditableField(
    TextEditingController controller,
    String title,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        InputField(
          child: TextFormField(
            decoration: InputDecoration(border: InputBorder.none),
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              if (value.isEmpty) {
                return 'Field Cannot be Empty';
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------CREATE FORM FIELDS FOR BANK DETAILS -----------------------------------------------//
  createBankFormFields() {
    return [
      Text("Account No"),
      InputField(
        child: TextFormField(
          decoration: inputFieldDecoration('Enter Your Account Number'),
          controller: _accNo,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value.isEmpty) {
              return 'Field Cannot be Empty';
            } else {
              return null;
            }
          },
        ),
      ),
      Text("IFSC Code"),
      InputField(
        child: TextFormField(
          decoration: inputFieldDecoration('Enter Your IFSC Code'),
          controller: _ifsc,
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            RegExp nameCheck = RegExp(r"^[A-z0-9]");
            if (value.isEmpty) {
              return 'Field Cannot be empty';
            } else if (nameCheck.hasMatch(value)) {
              return null;
            } else {
              return "Invalid IFSC";
            }
          },
        ),
      ),
      Text("Account Holder Name"),
      InputField(
        child: TextFormField(
          decoration: inputFieldDecoration('Enter Your Name'),
          controller: _accHoldName,
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value.isEmpty) {
              return 'Field Cannot be empty';
            } else {
              return null;
            }
          },
        ),
      ),
    ];
  }

  //--------------------------------------PAN VERIFCATION PROCESS CONTINUED--------------------------------//

  continuePanProcess(BuildContext context, String imagePath) async {
    Navigator.pop(context);
    showLoadingDialog(context);
    print(imagePath);
    var result = await kycModel.executePOI(imagePath);
    print(result);
    Navigator.pop(context);
    if (result["flag"]) {
      _dob.text = result["fields"]["dob"];
      _name.text = result["fields"]["name"];
      _fname.text = result["fields"]["fname"];
      _pan.text = result["fields"]["pan"];
      showStepDialog(
          context, Text("Confirm PAN Details"), createForm(createPANFields()), [
        FlatButton(
          child: Text("Confirm"),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              showLoadingDialog(context);
              var result = await kycModel.updatePOI(
                  _name.text, _fname.text, _pan.text, _dob.text);
              if (result["flag"]) {
                _markStepCompleted(0);
                Navigator.pop(context);
                showSuccessDialog(context);
              } else {
                showErrorDialog(context, result.toString());
              }
            }
          },
        ),
      ]);
    } else {
      showErrorDialog(context, result.toString());
    }
  }

  continueBankVerification(BuildContext context, String imagePath) async {
    Navigator.pop(context);
    showLoadingDialog(context);
    var result = await kycModel.cancelledCheque(imagePath);
    Navigator.pop(context);
    if (result["flag"] == true) {
      print(result["fields"]);
      _accNo.text = result["fields"]["accountno"];
      _accHoldName.text = result["fields"]["name"];
      _ifsc.text = result["fields"]["ifsc"];
      showStepDialog(
          context, Text("Penny Transfer"), createForm(createBankFormFields()), [
        FlatButton(
          child: Text("Cancle"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Ok"),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              showLoadingDialog(context);
              var result =
                  await kycModel.bankPennyTransfer(_accNo, _ifsc, _accHoldName);
              Navigator.pop(context);
              if (result["flag"] == true) {
                _markStepCompleted(2);
                showSuccessDialog(context);
              } else {
                showErrorDialog(context, result.toString());
              }
            }
          },
        ),
      ]);
    } else {
      showErrorDialog(context, result.toString());
    }
  }

  continueProfilePictureProcess(BuildContext context, String imagePath) async {
    Navigator.pop(context);
    showLoadingDialog(context);
    var result = await kycModel.updateProfile(imagePath);
    Navigator.pop(context);
    if (result["flag"] == true) {
      _markStepCompleted(6);
      showSuccessDialog(context);
    } else {
      showErrorDialog(context, result.toString());
    }
  }

  createPOAImageCards(BuildContext context, int face) {
    return GestureDetector(
      onTap: () {
        showStepDialog(
            context,
            Text(face == 0 ? "Front-Side Upload" : "Back-Side Upload"),
            Text("Choose image from"), [
          new FlatButton(
            child: Text('Camera'),
            onPressed: () async {
              _markStepAttempted(0);
              face == 0
                  ? imagef = await picker.getImage(source: ImageSource.camera)
                  : imageb = await picker.getImage(source: ImageSource.camera);
              // print(imagef.path);
              Navigator.pop(context);
              Navigator.pop(context);
              stepButtonAction(1, context);
              //print(result);
            },
          ),
          FlatButton(
            child: Text('Gallery'),
            onPressed: () async {
              _markStepAttempted(0);
              face == 0
                  ? imagef = await picker.getImage(source: ImageSource.gallery)
                  : imageb = await picker.getImage(source: ImageSource.gallery);
              // print(imagef.path);
              Navigator.pop(context);
              Navigator.pop(context);
              stepButtonAction(1, context);
            },
          ),
        ]);
      },
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: UiConstants.primaryColor),
          borderRadius: BorderRadius.circular(20),
          color: UiConstants.primaryColor.withOpacity(0.1),
        ),
        child: face == 0
            ? (imagef == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 50,
                        color: UiConstants.primaryColor,
                      ),
                      Text("Front Side of Address Proof"),
                    ],
                  )
                : Image.file(
                    File(imagef.path),
                    fit: BoxFit.cover,
                  ))
            : (imageb == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 50,
                        color: UiConstants.primaryColor,
                      ),
                      Text("Back Side of Address Proof"),
                    ],
                  )
                : Image.file(
                    File(imageb.path),
                    fit: BoxFit.cover,
                  )),
      ),
    );
  }

//---------------------------------CREATE FIELDS FOR PAN CONFIRMATION DIALOG-------------------------//
  createPANFields() {
    return [
      createEditableField(_dob, "Date of birth"),
      createEditableField(_name, "Name"),
      createEditableField(_fname, "Father's Name"),
      createEditableField(_pan, "PAN"),
    ];
  }

//---------------------------------CREATE FIELDS FOR ADDRESS CONFIRMATION DIALOG-------------------------//
  createADDFields() {
    return [
      createEditableField(_dob, "Date of birth"),
      createEditableField(_name, "Name"),
      createEditableField(_uid, "UID"),
      createEditableField(_pin, "PinCode"),
      createEditableField(_address, "Address"),
      createEditableField(_city, "City"),
      createEditableField(_district, "District"),
      createEditableField(_state, "State"),
    ];
  }

  stepButtonAction(int step, BuildContext context) async {
    baseProvider.kycDetail =
        await dbProvider.getUserKycDetails(baseProvider.myUser.uid);
    // -----------------------------CODE TO EXECUTE STEPS SEQUENTILY--------------------------------------------//
    // if (step != 0 && baseProvider.kycDetail.isStepComplete[step - 1] == 0) {
    //   showStepDialog(
    //     context,
    //     Text("Oops!"),
    //     Text("You missed a step in between"),
    //     [
    //       FlatButton(
    //         child: Text("OK"),
    //         onPressed: () => Navigator.pop(context),
    //       ),
    //     ],
    //   );
    // } else
    // --------------------------------------------------------------------------------------------------------//

    if (baseProvider.kycDetail.isStepComplete[step] == 1) {
      showStepDialog(
        context,
        Text("Oops"),
        Text("You have already completed this process"),
        [
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    } else {
      if (step == 0) {
        // -------------- TO RESET ALL THE STEP VALUES --------------------------------//
        // showStepDialog(
        //   context,
        //   Center(child: Text("Hold on!")),
        //   Text("We are fetching details for your record."),
        //   null,
        // );
        // baseProvider.kycDetail.isStepComplete = [
        //   0,
        //   0,
        //   0,
        //   0,
        //   0,
        //   0,
        //   0,
        //   0,
        //   0,
        //   0,
        // ];
        // await dbProvider.updateUserKycDetails(
        //     baseProvider.myUser.uid, baseProvider.kycDetail);
        // Navigator.pop(context);
        // ---------------------------------------------------------------------------//
        showStepDialog(
            context, Text("PAN Card Upload"), Text("Choose image from"), [
          new FlatButton(
            child: Text('Camera'),
            onPressed: () async {
              _markStepAttempted(0);
              var image = await picker.getImage(source: ImageSource.camera);
              var imagePath = image.path;
              continuePanProcess(context, imagePath);
            },
          ),
          FlatButton(
            child: Text('Gallery'),
            onPressed: () async {
              _markStepAttempted(0);
              final image = await picker.getImage(source: ImageSource.gallery);
              var imagePath = image.path;
              continuePanProcess(context, imagePath);
            },
          ),
        ]);
        //--------------------------------------ADDRESS VERIFICATION-------------------------------------------------//
      } else if (step == 1) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(UiConstants.padding),
                  ),
                  content: Wrap(
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      createPOAImageCards(context, 0),
                      createPOAImageCards(context, 1),
                    ],
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancle")),
                    FlatButton(
                        onPressed: () async {
                          if (imagef == null || imageb == null) {
                            showErrorDialog(context, "You missed any field!");
                          } else {
                            showLoadingDialog(context);
                            var result = await kycModel.coresPOA(
                                imagef.path, imageb.path);
                            print(result);
                            isLoading = false;
                            Navigator.pop(context);
                            Navigator.pop(context);
                            if (result["flag"] == true) {
                              _uid.text = result["fields"]["uid"];
                              _pin.text = result["fields"]["pincode"];
                              _address.text = result["fields"]["address"];
                              _name.text = result["fields"]["name"];
                              _dob.text = result["fields"]["dob"];
                              _city.text = result["fields"]["city"];
                              _state.text = result["fields"]["state"];
                              _district.text = result["fields"]["district"];
                              showStepDialog(
                                  context,
                                  Text("Confirm you Details"),
                                  createForm(createADDFields()), [
                                FlatButton(
                                  child: Text("Confirm"),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      showLoadingDialog(context);
                                      var result = await kycModel.updatePOA(
                                          _name.text,
                                          _uid.text,
                                          _address.text,
                                          _city.text,
                                          _state.text,
                                          _district.text,
                                          _pin.text,
                                          _dob.text);
                                      if (result["flag"]) {
                                        _markStepCompleted(0);
                                        Navigator.pop(context);
                                        showSuccessDialog(context);
                                      } else {
                                        showErrorDialog(
                                            context, result.toString());
                                      }
                                    }
                                  },
                                ),
                              ]);
                            } else {
                              showErrorDialog(context, result.toString());
                            }
                          }
                        },
                        child: Text("Ok")),
                  ],
                ));
      }
      //-----------------------------------------CANCELLED CHEQUE-------------------------------------------------//
      else if (step == 2) {
        print("Cancelled Cheque");
        showStepDialog(
          context,
          Center(child: Text("Cancelled Cheque")),
          Text("Choose image from"),
          [
            new FlatButton(
              child: Text('Camera'),
              onPressed: () async {
                _markStepAttempted(2);
                var image = await picker.getImage(source: ImageSource.camera);
                var imagePath = image.path;
                print(imagePath);
                continueBankVerification(context, imagePath);
              },
            ),
            FlatButton(
              child: Text('Gallery'),
              onPressed: () async {
                _markStepAttempted(2);

                final image =
                    await picker.getImage(source: ImageSource.gallery);
                var imagePath = image.path;
                continueBankVerification(context, imagePath);
              },
            ),
          ],
        );
      }
      //-------------------------------------------------------SIGNATURE--------------------------------------------//
      else if (step == 3) {
        print("Signature");
        _markStepAttempted(3);
        final result = Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignatureScreen()));
      }
      //------------------------------------------------------FATCA-------------------------------------------------//
      else if (step == 4) {
        print("FATCA");
        //await kycModel.Fatca();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FatcaForms()));
      }
      //-------------------------------------------LOCATION----------------------------------------------------------//
      else if (step == 5) {
        print("Location");
        _markStepAttempted(5);
        var result = await kycModel.uploadLocation();
        print(result);
        if (result["flag"] == true) {
          _markStepCompleted(5);
          showSuccessDialog(context);
        } else {
          showErrorDialog(context, result.toString());
        }
      }
      //--------------------------------------------------PROFILE PICTURE---------------------------------------------//
      else if (step == 6) {
        print("profile Picture");
        showStepDialog(
          context,
          Center(child: Text("Update profile")),
          Text("Choose image from"),
          [
            new FlatButton(
              child: Text('Camera'),
              onPressed: () async {
                _markStepAttempted(6);
                var image = await picker.getImage(source: ImageSource.camera);
                var imagePath = image.path;
                continueProfilePictureProcess(context, imagePath);
              },
            ),
            FlatButton(
              child: Text('Gallery'),
              onPressed: () async {
                final image =
                    await picker.getImage(source: ImageSource.gallery);
                var imagePath = image.path;
                continueProfilePictureProcess(context, imagePath);
              },
            ),
          ],
        );
      }
      //-----------------------------------------------------------VIDEO VERIFICATION-----------------------------------//
      else if (step == 7) {
        print("Video Verification");
        var image = await picker.getVideo(source: ImageSource.camera);
        _markStepAttempted(7);
        var imagePath = image.path;
        showLoadingDialog(context);
        var result = await kycModel.recordVideo(imagePath);
        Navigator.pop(context);
        if (result["flag"] == true) {
          _markStepCompleted(7);
          showSuccessDialog(context);
        } else {
          showErrorDialog(context, result.toString());
        }
      }
      //--------------------------------------------PDF REVIEW--------------------------------------------------------//
      else if (step == 8) {
        print("PDF Review");
        await kycModel.generatePdf();
      }
      //--------------------------------------COMPLETION REWARD----------------------------------------------------------//
      else if (step == 9) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300,
                width: 300,
                padding: EdgeInsets.all(40),
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Scratcher(
                          brushSize: 30,
                          threshold: 50,
                          image: Image.asset(
                            "images/scratch-card.png",
                            fit: BoxFit.cover,
                          ),
                          onChange: (value) {
                            print("Scratch progress: $value%");
                            if (value > 90) {
                              _confeticontroller.play();
                            }
                          },
                          onThreshold: () =>
                              print("Threshold reached, you won!"),
                          child: Container(
                            // height: 170,
                            // width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "https://babblesports.com/wp-content/uploads/2020/06/Untitled-design-7-1200x675.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: ConfettiWidget(
                        blastDirectionality: BlastDirectionality.explosive,
                        confettiController: _confeticontroller,
                        particleDrag: 0.05,
                        emissionFrequency: 0.05,
                        numberOfParticles: 25,
                        gravity: 0.05,
                        shouldLoop: false,
                        colors: [
                          UiConstants.primaryColor,
                          Colors.grey,
                          Colors.yellow,
                          Colors.blue,
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
      }
    }
  }

  static List<Map<String, String>> stageCardData = [
    {
      "title": "Upload Your PAN Card",
      "subtitle": "We'll use this as your proof of Identity",
    },
    {
      "title": "Upload your UID Card/Driving Liscence",
      "subtitle": "We'll verify your address using this",
    },
    {
      "title": "Upload a Cancelled Cheque",
      "subtitle": "THis is a an important step",
    },
    {
      "title": "Make your Signature",
      "subtitle": "We need a digital sign of yours",
    },
    {
      "title": "FATCA",
      "subtitle": "Fill in these minor information",
    },
    {
      "title": "Location",
      "subtitle": "Your location is needed",
    },
    {
      "title": "Profile Picture",
      "subtitle": "Please upload a profile picture",
    },
    {
      "title": "Video Verification",
      "subtitle": "Okay, won't trouble you after this",
    },
    {
      "title": "Application Review",
      "subtitle": "Review all the details and confirm by signing it",
    },
    {
      "title": "get your reward",
      "subtitle": "Hurray, you did a great job. this is your reward",
    },
  ];
}
