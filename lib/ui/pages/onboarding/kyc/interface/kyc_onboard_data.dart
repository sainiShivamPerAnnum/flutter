import 'dart:io';

import 'package:camera/camera.dart';
import 'package:confetti/confetti.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:felloapp/core/service/location.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/fatcaforms.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/interface/cam.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/signature.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scratcher/widgets.dart';

class KycOnboardData {
  int level;
  static Color titleColor = Color(0xff00587a);
  static bool isLoading = false;
  ConfettiController _confeticontroller = new ConfettiController(
    duration: new Duration(seconds: 5),
  );
  File image;
  final picker = ImagePicker();
  Location location = Location();
  DBModel dbProvider = locator<DBModel>();
  BaseUtil baseProvider = locator<BaseUtil>();
  KYCModel kycModel = locator<KYCModel>();
  final _formKey = GlobalKey<FormState>();
  var imagef, imageb;
  double _height, _width;
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
  showStepDialog(BuildContext context, String title, String caption,
      Widget subtitle, List<Widget> actions) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (stepctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiConstants.padding),
            ),
            elevation: 0.0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(title), Text(caption)],
            ),
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
            title: Text("Success"),
            content: Text("Details updated!"),
            actions: [
              TextButton(
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
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
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
      _fname.text = result["fields"]["fatherName"];
      _pan.text = result["fields"]["number"];
      showStepDialog(
          context,
          "Here are the details we extracted",
          'Kindly update if required and confirm',
          createForm(createPANFields()), [
        TextButton(
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
                showErrorDialog(
                    context,
                    result['message'] ??
                        'Something went wrong. Please try again');
              }
            }
          },
        ),
      ]);
    } else {
      showErrorDialog(context,
          result['message'] ?? 'Something went wrong. Please try again');
    }
  }

  continueBankVerification(BuildContext context, String imagePath) async {
    Navigator.pop(context);
    showLoadingDialog(context);
    var result = await kycModel.cancelledCheque(imagePath);
    Navigator.pop(context);
    if (result["flag"] == true) {
      print(result["fields"]);
      _accNo.text = result["fields"]['result']["accountNumber"];
      _accHoldName.text = result["fields"]['result']["name"];
      _ifsc.text = result["fields"]['result']["ifsc"];
      showStepDialog(
          context, "Penny Transfer", '', createForm(createBankFormFields()), [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text("Ok"),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              showLoadingDialog(context);
              var result = await kycModel.bankPennyTransfer(
                  _accNo.text, _ifsc.text, _accHoldName.text);
              Navigator.pop(context);
              if (result["flag"] == true) {
                _markStepCompleted(2);
                showSuccessDialog(context);
              } else {
                showErrorDialog(
                    context,
                    result['message'] ??
                        'Something went wrong. Please try again');
              }
            }
          },
        ),
      ]);
    } else {
      showErrorDialog(context,
          result['message'] ?? 'Something went wrong. Please try again');
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
      showErrorDialog(context,
          result['message'] ?? 'Something went wrong. Please try again');
    }
  }

  createPOAImageCards(BuildContext context, int face) {
    return GestureDetector(
      onTap: () {
        showStepDialog(
            context,
            face == 0 ? "Front-Side Upload" : "Back-Side Upload",
            '',
            Text("Choose image from"), [
          new TextButton(
            child: Text('Camera'),
            onPressed: () async {
              _markStepAttempted(1);
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
          TextButton(
            child: Text('Gallery'),
            onPressed: () async {
              _markStepAttempted(1);
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
                      Text("Front Side of Aadhaar"),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(imagef.path),
                      fit: BoxFit.cover,
                    ),
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
                      Text("Back Side of Aadhaar"),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(imageb.path),
                      fit: BoxFit.cover,
                    ),
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

  Future<bool> stepButtonAction(int step, BuildContext context) async {
    baseProvider.kycDetail =
        await dbProvider.getUserKycDetails(baseProvider.myUser.uid);
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    // -----------------------------CODE TO EXECUTE STEPS SEQUENTILY--------------------------------------------//
    if (step != 0 && baseProvider.kycDetail.isStepComplete[step - 1] != 1) {
      showStepDialog(
        context,
        "Error",
        "You missed a step in between",
        Text(""),
        [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    } else if (baseProvider.kycDetail.isStepComplete[step] == 1) {
      showStepDialog(
        context,
        "Oops",
        '',
        Text("You have already completed this process"),
        [
          TextButton(
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
        //   2,
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
            context, "PAN Card Upload", '', Text("Choose image from"), [
          new TextButton(
            child: Text('Camera'),
            onPressed: () async {
              _markStepAttempted(0);
              var image = await picker.getImage(source: ImageSource.camera);
              var imagePath = image.path;
              continuePanProcess(context, imagePath);
            },
          ),
          TextButton(
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
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          if (imagef == null || imageb == null) {
                            showErrorDialog(context,
                                "Both front and back images are required");
                          } else {
                            showLoadingDialog(context);
                            var result = await kycModel.coresPOA(
                                imagef.path, imageb.path);
                            print(result);
                            isLoading = false;
                            Navigator.pop(context);
                            Navigator.pop(context);
                            if (result["flag"] == true) {
                              _uid.text = result["fields"]["uid"].toString();
                              _pin.text = result["fields"]["splitAddress"]
                                      ["pincode"]
                                  .toString();
                              _address.text =
                                  result["fields"]["address"].toString();
                              _name.text = result["fields"]["name"].toString();
                              _dob.text = result["fields"]["dob"].toString();
                              _city.text = result["fields"]["splitAddress"]
                                      ["city"]
                                  .toString();
                              _state.text = result["fields"]["splitAddress"]
                                      ["state"]
                                  .toString();
                              _district.text = result["fields"]["splitAddress"]
                                      ["district"]
                                  .toString();
                              showStepDialog(context, "Confirm you Details", '',
                                  createForm(createADDFields()), [
                                TextButton(
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
                                      isLoading = false;
                                      Navigator.pop(context);
                                      if (result["flag"]) {
                                        _markStepCompleted(1);
                                        showSuccessDialog(context);
                                      } else {
                                        showErrorDialog(
                                            context,
                                            result['message'] ??
                                                'Something went wrong. Please try again');
                                      }
                                    }
                                  },
                                ),
                              ]);
                            } else {
                              showErrorDialog(
                                  context,
                                  result['message'] ??
                                      'Something went wrong. Please try again');
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
          "Cancelled Cheque",
          '',
          Text("Choose image from"),
          [
            new TextButton(
              child: Text('Camera'),
              onPressed: () async {
                _markStepAttempted(2);
                var image = await picker.getImage(source: ImageSource.camera);
                var imagePath = image.path;
                print(imagePath);
                continueBankVerification(context, imagePath);
              },
            ),
            TextButton(
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
        final result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignatureScreen()));
        print(result);
        if (result["flag"] == true) {
          _markStepCompleted(3);
          showSuccessDialog(context);
        } else {
          showErrorDialog(context,
              result['message'] ?? 'Something went wrong. Please try again');
        }
      }
      //------------------------------------------------------FATCA-------------------------------------------------//
      else if (step == 4) {
        print("FATCA");
        //await kycModel.Fatca();
        final result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => FatcaForms()));

        if (result["flag"] == true) {
          _markStepCompleted(4);
          showSuccessDialog(context);
        } else {
          showErrorDialog(context,
              result['message'] ?? 'Something went wrong. Please try again');
        }
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
          showErrorDialog(context,
              result['message'] ?? 'Something went wrong. Please try again');
        }
      }
      //--------------------------------------------------PROFILE PICTURE---------------------------------------------//
      else if (step == 6) {
        print("profile Picture");
        showStepDialog(
          context,
          "Update profile",
          '',
          Text("Choose image from"),
          [
            new TextButton(
              child: Text('Camera'),
              onPressed: () async {
                _markStepAttempted(6);
                var image = await picker.getImage(source: ImageSource.camera);
                var imagePath = image.path;
                continueProfilePictureProcess(context, imagePath);
              },
            ),
            TextButton(
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
        showLoadingDialog(context);
        print("Video Verification");
        var result = await kycModel.startVideo();
        if (result["flag"] == true) {
          isLoading = false;
          Navigator.pop(context);
          List<CameraDescription> cameras = [];
          try {
            WidgetsFlutterBinding.ensureInitialized();
            cameras = await availableCameras();
          } on CameraException catch (e) {
            logError(e.code, e.description);
          }
          var imagePath = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => MyCam(
                  cameras: cameras, randNum: result["object"][0]["randNumber"]),
            ),
          );
          // var result = await kycModel.recordVideo(imagePath);
          print("-----------------------------Data recieved: $imagePath");
        }
        // _markStepAttempted(7);
        showLoadingDialog(context);
        Navigator.pop(context);
        if (result["flag"] == true) {
          _markStepCompleted(7);
          showSuccessDialog(context);
        } else {
          showErrorDialog(context,
              result['message'] ?? 'Something went wrong. Please try again');
        }
      }
      //--------------------------------------------PDF REVIEW--------------------------------------------------------//
      else if (step == 8) {
        print("PDF Review");
        var ress = await kycModel.kycVerificationEngine();

        var data = await kycModel.generatePdf();

        if (data['flag']) {
          print("data is $data");
          //url to redirect to signzy otp verification
          var url = data['fields']['result']['url'].toString();
          print("url is $url");
          // var result = await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => KycWebview(
          //             url: url,
          //           )),
          // );
          var result = true;

          if (result) {
            _markStepCompleted(8);
            showSuccessDialog(context);
          } else {
            showErrorDialog(context, 'Something went wrong. Please try again');
          }
        } else {}
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
                            if (value > 70 && value < 90) {
                              _confeticontroller.play();
                            }
                          },
                          onThreshold: () =>
                              print("Threshold reached, you won!"),
                          child: Container(
                            height: _height * 0.3,
                            width: _height * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: Image.asset(
                                            "images/winners-small.png")),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Material(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                            BaseUtil.remoteConfig.getString(
                                                'kyc_completion_prize'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 30,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Material(
                                      child: Text(
                                        "Reward will be automatically credited to your account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: KycOnboardData.titleColor,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                )
                                // Image.network(
                                //   //TODO BaseUtil.remoteConfig.getString('kyc_completion_prize');
                                //   "https://babblesports.com/wp-content/uploads/2020/06/Untitled-design-7-1200x675.jpg",
                                //   fit: BoxFit.cover,
                                // ),
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
    return true;
  }

  static List<Map<String, String>> stageCardData = [
    {
      "title": "PAN Card",
      "subtitle": "This is required for your proof of Identity",
    },
    {
      "title": "Aadhaar Card",
      "subtitle": "This is required for your proof of address",
    },
    {
      "title": "Cancelled Cheque",
      "subtitle": "This is required to verify your bank details",
    },
    {
      "title": "Signature",
      "subtitle": "Provide a digital sign",
    },
    {
      "title": "Basic Details",
      "subtitle": "Fill out certain important details",
    },
    {
      "title": "Confirm Location",
      "subtitle":
          "This is required to verify that you are in the country at present",
    },
    {
      "title": "Profile Picture",
      "subtitle": "Provide your selfie/profile picture",
    },
    {
      "title": "Video Verification",
      "subtitle":
          "This is required to verify that you are completing your own KYC",
    },
    {
      "title": "Application Review",
      "subtitle": "Review and sign your final application",
    },
    {
      "title": "get your reward",
      "subtitle": "Hurray, you did a great job. this is your reward",
    },
  ];

  static getTitleStyle() {
    return TextStyle(
      color: titleColor,
      fontWeight: FontWeight.w700,
      fontSize: 22,
    );
  }

  static getSubtitleStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 18,
      height: 1.5,
    );
  }

  static getNotes(String note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: titleColor,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              note,
              style: KycOnboardData.getSubtitleStyle(),
            ),
          ),
        ],
      ),
    );
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');
}
