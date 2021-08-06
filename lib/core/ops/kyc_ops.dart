import 'dart:convert';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserKycDetail.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/location.dart';
import 'package:felloapp/util/kyc_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/**
 * To get KYC firebase document
 * baseProvider.kycDetail =
    await dbProvider.getUserKycDetails(baseProvider.myUser.uid);
 *
 * To UPDATE KYC firebase document
 * await dbProvider.updateUserKycDetails(
    baseProvider.myUser.uid, baseProvider.kycDetail);
 * */

class KYCModel extends ChangeNotifier {
  final Log log = new Log('KYCModel');
  Location location = Location();
  DBModel _dbModel = locator<DBModel>();
  BaseUtil baseProvider = locator<BaseUtil>();

  String _baseUri;
  String _apiKey;
  var headers;

  // bool isInit() => (_apiKey != null);

  //to check if the user kyc details are available or not
  bool isUserSetup() => (baseProvider.kycDetail != null &&
      baseProvider.kycDetail.merchantId != null &&
      baseProvider.kycDetail.userAccessToken != null);

  //  call always
  // - if user new - initialised a new object
  // - if existing user - just fetches the current data
  Future<bool> init() async {
    if (_dbModel == null || baseProvider == null) return false;
    KycUrls.init();
    //initialize user kyc obj
    baseProvider.kycDetail = baseProvider.kycDetail ??
        await _dbModel.getUserKycDetails(baseProvider.myUser.uid);
    if (!isUserSetup()) {
      bool setupFlag = await _setupUser();
      log.debug('New investor setup correctly: $setupFlag');
      return setupFlag;
    } else {
      return true;
    }
  }

  Future<bool> _setupUser() async {
    //initialize signzy api key
    Map<String, String> cMap = await _dbModel.getActiveSignzyApiKey();
    if (cMap == null || cMap['key'] == null) return false;

    _baseUri = (cMap['baseuri'] == null || cMap['baseuri'].isEmpty)
        ? KycUrls.defaultBaseUri
        : cMap['baseuri'];
    String _apiKey = cMap['key'];
    log.debug('Generated API Key: $_apiKey');

    var channelHeaders = {
      'Content-Type': 'application/json',
      'Authorization': _apiKey
    };

    String email = baseProvider.myUser.email ?? '';
    String phone = baseProvider.myUser.mobile;
    String name = baseProvider.myUser.name;
    String panNumber = baseProvider.userRegdPan;

    //create a new document for the investor details
    var onboardObj = await _createOnboardingObj(
        channelHeaders, panNumber, email, phone, name);
    if (onboardObj['flag']) {
      baseProvider.kycDetail =
          UserKycDetail.newUser(onboardObj['username'], onboardObj['password']);
      //now login the investor and get their id and token
      var loginObj = await _login(channelHeaders,
          baseProvider.kycDetail.username, baseProvider.kycDetail.password);
      if (loginObj['flag']) {
        //save all the details
        bool upFlag = await _dbModel.updateUserKycDetails(
            baseProvider.myUser.uid, baseProvider.kycDetail);
        log.debug('Kyc Details updated:: $upFlag');
        return true;
      } else {
        log.error('Failed to login investor');
        return false;
      }
    } else {
      log.error('Failed to create onboarding object for investor');
      return false;
    }
  }

  Future<Map<dynamic, dynamic>> _createOnboardingObj(
      Map<String, dynamic> rHeaders,
      String panNumber,
      String email,
      String phone,
      String name) async {
    bool res = false;
    String message = "Object Created Successfully";

    Map<dynamic, dynamic> body = {
      "email": email,
      "username": _generateUserName(panNumber),
      "phone": phone,
      "name": name
    };

    String jsonBody = json.encode(body);

    http.Response response = await http.post(
      Uri.https(KycUrls.defaultBaseUri, KycUrls.createOnboardingObject),
      body: jsonBody,
      headers: rHeaders,
    );

    if (response.statusCode == 200) {
      res = true;
      print("Success ${response.body}");
      var data = jsonDecode(response.body);
      var userName = data['createdObj']['username'];
      var password = data['createdObj']['id'];
      print(userName);

      return {'flag': true, 'username': userName, 'password': password};
    } else if (response.statusCode == 422) {
      message = "Username already exists please enter a new username";
      res = false;
      log.debug(response.body);
    } else {
      res = false;
      message = "Something went wrong";
      log.debug(response.body);
    }

    Map<dynamic, dynamic> result = {'flag': res, 'message': message};

    return result;
  }

  Future<Map<dynamic, dynamic>> _login(
      Map<String, dynamic> rHeaders, var userName, var password) async {
    bool res = false;
    String message = "Success";
    KycUrls.userName = userName;
    Map<dynamic, dynamic> body = {"username": userName, "password": password};

    String jsonBody = json.encode(body);
    http.Response response = await http.post(
      Uri.https(KycUrls.defaultBaseUri, KycUrls.login),
      body: jsonBody,
      headers: rHeaders,
    );

    if (response.statusCode == 200) {
      res = true;
      print("Success ${response.body}");
      var data = jsonDecode(response.body);
      var token = data['id'];
      var merchantId = data['userId'];
      var createdTime = data['created'];
      var ttl = data['ttl'];

      baseProvider.kycDetail.merchantId = merchantId;
      baseProvider.kycDetail.userAccessToken = token;
      baseProvider.kycDetail.tokenTtl = ttl;
      baseProvider.kycDetail.tokenCreatedTime = createdTime;
    } else if (response.statusCode == 422) {
      message = "Username already exists please enter a new username";
      res = false;
      log.debug(response.body);
    } else {
      res = false;
      message = "Something went wrong";
      log.debug(response.body);
    }

    Map<dynamic, dynamic> result = {'flag': res, 'message': message};

    return result;
  }

  Future<Map<dynamic, dynamic>> ccImage(String imagePath) async {
    print(imagePath);
    var headers = {'Content-Type': 'application/json'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://persist.signzy.tech/api/files/upload'));
    request.fields.addAll({'ttl': '10 mins'});
    MediaType a = new MediaType('image', 'jpg');
    var multipartFile =
        http.MultipartFile.fromPath('file', imagePath, contentType: a);

    request.files.add(await multipartFile);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String rx = await response.stream.bytesToString();
      String imageUrl = jsonDecode(rx)['file']['directURL'];
      return {'flag': true, 'imageUrl': imageUrl};
    } else {
      print(response.reasonPhrase);
      return {'flag': false, 'imageUrl': null};
    }
  }

  Future<Map<dynamic, dynamic>> convertImages(String imagePath) async {
    print("inside convertImage");
    bool result = false;
    var imageUrl;
    final headers = {
      'Content-Type': 'application/json',
    };

    List<String> fs = imagePath.split('.');
    String fileType = fs[fs.length - 1];
    if (fileType != 'jpg' && fileType != 'jpeg' && fileType != 'png') {
      return {
        'flag': false,
        'imageUrl': null,
        'message': 'Please upload a jpg or png image'
      };
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://persist.signzy.tech/api/files/upload'));
    request.fields.addAll({'ttl': '10 mins'});
    MediaType mt = new MediaType('image', fileType);
    var multipartFile =
        http.MultipartFile.fromPath('file', imagePath, contentType: mt);

    request.files.add(await multipartFile);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201 || response.statusCode == 200) {
      result = true;
      print(response.statusCode);
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      imageUrl = jsonDecode(responseString)['file']['directURL'];

      return {'flag': result, 'imageUrl': imageUrl};
    } else {
      print("Something went wrong");
      print(response.statusCode);
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);

      return {
        'flag': false,
        'imageUrl': null,
        'message': 'Failed to upload the image. Please try again in a while'
      };
    }
  }

  Future<Map<dynamic, dynamic>> executePOI(String imagePath) async {
    var fields;
    var flag = false;
    var message = "Uploaded Successfully";

    var tokens = await getId();
    var auth = tokens['authToken'];
    var merchentId = tokens["merchantId"];
    print(merchentId);
    print("Auth Token = $auth");

    var data = await convertImages(imagePath);
    if (!data['flag']) {
      return {
        "flag": false,
        "message":
            data['message'] ?? 'Operation failed. Please try again in sometime'
      };
    }
    var imageUrl = data['imageUrl'];
    print("image in poi $imageUrl");

    var headers = {
      'Authorization': '$auth',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{
    "merchantId": "$merchentId",
    "inputData":
      { 
     "service": "identity",
     "type": "individualPan",
     "task": "autoRecognition",  
     "data": {
     "images": ["$imageUrl"],            
     "toVerifyData": {},            
     "searchParam": {},  
     "proofType": "identity"   
          } 
       }  
     }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      var fd = jsonDecode(responseString)['object'];
      if (fd != null) fields = fd['result'];
      print(fields);
    } else if (response.statusCode == 400) {
      flag = false;
      message = "Image link expired please select a new Image";
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
    } else {
      flag = false;
      message = "Something went wrong";
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
    }
    Map<dynamic, dynamic> results = {
      "flag": flag,
      "message": message,
      "fields": fields
    };
    return results;
  }

  Future<Map<dynamic, dynamic>> coresPOA(var frontimage, var backImage) async {
    var fields;
    var flag = false;
    var message = "Uploaded Successfully";

    var tokens = await getId();

    var auth = tokens['authToken'];
    var merchentId = tokens["merchantId"];
    print(merchentId);
    print("Auth Token = $auth");

    var dataf = await convertImages(frontimage);
    var datab = await convertImages(backImage);
    var imageUrlf = dataf['imageUrl'];
    var imageUrlb = datab['imageUrl'];

    print(imageUrlf);

    var headers = {
      'Authorization': '$auth',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{
    "merchantId": "$merchentId",
    "inputData": {
      "service": "identity",
      "type": "aadhaar",
      "task": "autoRecognition",
         "data": {
             "images": ["$imageUrlf","$imageUrlb"],
             "toVerifyData": {},
             "searchParam": {},
             "proofType": "corrAddress"
             }
            }
           }''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      var fd = jsonDecode(responseString)['object'];
      if (fd != null) fields = fd['result'];

      await POA(imageUrlf, imageUrlb);
    } else if (response.statusCode == 400) {
      flag = false;
      message = "Image link expired please select a new Image";
    } else {
      flag = false;
      message = "Something went wrong";
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
    }
    Map<dynamic, dynamic> results = {
      "flag": flag,
      "message": message,
      "fields": fields
    };
    return results;
  }

  Future<Map<dynamic, dynamic>> POA(var frontimage, var backImage) async {
    var fields;
    var flag = false;
    var message = "Uploaded Successfully";

    var tokens = await getId();

    var auth = tokens['authToken'];
    var merchentId = tokens["merchantId"];

    // var dataf = await convertImages(frontimage);
    // var datab = await convertImages(backImage);
    // var imageUrlf = dataf['imageUrl'];
    // var imageUrlb = datab['imageUrl'];

    var headers = {
      'Authorization': '$auth',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{
    "merchantId": "$merchentId",
    "inputData": {
      "service": "identity",
      "type": "aadhaar",
      "task": "autoRecognition",
         "data": {
             "images": ["$frontimage","$backImage"],
             "toVerifyData": {},
             "searchParam": {},
             "proofType": "address"
             }
            }
           }''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      var fd = jsonDecode(responseString)['object'];
      if (fd != null) fields = fd['result'];
    } else if (response.statusCode == 400) {
      flag = false;
      message = "Image link expired please select a new Image";
    } else {
      flag = false;
      message = "Something went wrong";
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
    }
    Map<dynamic, dynamic> results = {
      "flag": flag,
      "message": message,
      "fields": fields
    };
    return results;
  }

  Future<Map<dynamic, dynamic>> startVideo() async {
    var tokens = await getId();
    var object;

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool flag = false;
    String message = "Video Verified Successfully";

    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{
    "merchantId":"$merchantID",
    "inputData":{
    "service":"video",
    "type":"video",
    "task":"start",
    "data":{}  
     }
     }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      object = jsonDecode(responseString)['object'];
      print('${object[0]['randNumber']}');
    } else if (response.statusCode == 401) {
      flag = false;
      message = "Invalid credentials";

      print(response.reasonPhrase);
    } else {
      message = "something went wrong please try again later";
    }

    Map<dynamic, dynamic> result = {
      'flag': flag,
      'message': message,
      //this object contains the transactionId and randNumber
      'object': object
    };

    return result;
  }

  Future<Map<dynamic, dynamic>> recordVideo(var video) async {
    var flag = false;
    var message = "Video Uploaded Successfully";

    var tokens = await getId();

    var auth = tokens['authToken'];
    var merchentId = tokens["merchantId"];
    print(merchentId);
    print("Auth Token = $auth");

    var data = await convertImages(video);
    var videoUrl = data['imageUrl'];
    print(videoUrl);

    var getData = await startVideo();

    var object = getData['object'];

    var transactionId = object[0]['transactionId'];
    print(transactionId);

    var headers = {
      'Authorization': '$auth',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{
    "merchantId":"$merchentId",
    "inputData":{ 
    "service":"video",
    "type":"video",
    "task":"verify",
    "data":{  
      "video":"$videoUrl",
      "transactionId":"$transactionId",
      "matchImage":"",
      "seconds":["00:00:02","00:00:04","00:00:06","00:00:08"],    
      
      "type":"video"    
        }
        }
        }''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
      print(await response.stream.bytesToString());
    } else if (response.statusCode == 400) {
      flag = false;
      message = "Video link expired please upload a new video";
    } else {
      flag = false;
      message = "Something went wrong";
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
    }
    Map<dynamic, dynamic> results = {"flag": flag, "message": message};
    return results;
  }

  Future<Map<dynamic, dynamic>> updateSignature(String imagePath) async {
    var flag = false;
    var message = "Signature Uploaded Successfully";
    var data = await convertImages(imagePath);
    if (!data['flag']) {
      return {
        "flag": false,
        "message":
            data['message'] ?? 'Operation failed. Please try again in sometime'
      };
    }
    ;

    var signatureUrl = data['imageUrl'];
    print("Signature url is $signatureUrl");

    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    var headers = {
      'Authorization': "$authToken",
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.update));
    request.body = '''{ 
        "merchantId":"$merchantID",
        "save":"formData",
        "type":"signature",
        "data":{ 
            "type":"signature",
            "signatureImageUrl":"$signatureUrl",
            "consent":"true"  
             }   
          }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
    } else if (response.statusCode == 422) {
      flag = false;
    } else {
      flag = false;
      message = "Something went wrong please try again later";
      print(response.reasonPhrase);
    }

    Map<dynamic, dynamic> result = {'flag': flag, 'message': message};

    return result;
  }

  Future<Map<dynamic, dynamic>> updateProfile(String imagePath) async {
    var flag = false;
    var message = "Profile Uploaded Successfully";
    var data = await convertImages(imagePath);
    if (!data['flag']) {
      return {
        "flag": false,
        "message":
            data['message'] ?? 'Operation failed. Please try again in sometime'
      };
    }
    ;

    var profileUrl = data['imageUrl'];
    print("Signature url is $profileUrl");

    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    var headers = {
      'Authorization': "$authToken",
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.update));
    request.body = '''{
          "merchantId":"$merchantID",
          "save":"formData",
          "type":"userPhoto",
          "data":{    
            "photoUrl":"$profileUrl"  
             }
            }''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;

      print(await response.stream.bytesToString());
    } else if (response.statusCode == 422) {
      flag = false;
      message = "Invalid Image please try again by selecting new image";
    } else {
      flag = false;
      message = "something went wrong";
      print(response.reasonPhrase);
    }

    Map<dynamic, dynamic> result = {'flag': flag, 'message': message};

    return Future.value(result);
  }

  Future<Map<dynamic, dynamic>> bankPennyTransfer(
      var beneficiaryAccount, beneficiaryIFSC, beneficiaryName) async {
    var fields;
    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool flag = false;
    String message = "Bank Verified Successfully";

    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{ 
      "merchantId": "$merchantID", 
      "inputData": {     
         "service": "nonRoc",       
          "type": "bankaccountverifications",  
           "task": "bankTransfer",
           "data": {
           "images": [],      
           "toVerifyData": {}, 
           "searchParam": {    
           "beneficiaryAccount": "$beneficiaryAccount",
           "beneficiaryIFSC": "$beneficiaryIFSC",
           "beneficiaryName":"$beneficiaryName"
                     }
                   }
                 }
            }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;

      // print(await response.stream.bytesToString());
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      fields = jsonDecode(responseString)['object'];
    } else if (response.statusCode == 400) {
      flag = false;

      print(response.reasonPhrase);
    } else {
      flag = false;
      message = "Something went wrong please try again later";
    }

    Map<dynamic, dynamic> result = {
      'flag': flag,
      'message': message,
      "fields": fields
    };

    return result;
  }

  Future<Map<dynamic, dynamic>> cancelledCheque(String imagePath) async {
    var fields;
    var tokens = await getId();
    var data = await convertImages(imagePath);
    if (!data['flag']) {
      return {
        "flag": false,
        "message":
            data['message'] ?? 'Operation failed. Please try again in sometime'
      };
    }

    var imageUrl = data['imageUrl'];
    print("image is $imageUrl");

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool flag = false;
    String message = "Bank Verified Successfully";
    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.execute));

    request.body = '''{
    "merchantId": "$merchantID",
    "inputData": {
      "service": "identity",
      "type": "cheque",
      "task": "autoRecognition",
      "data": {
      "images": ["$imageUrl"],
      "toVerifyData": {},
      "searchParam": {},
       "proofType": "cheque"
       }
       }
       }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      fields = jsonDecode(responseString)['object'];
      // print(await response.stream.bytesToString());
    } else if (response.statusCode == 400) {
      print(await response.stream.bytesToString());

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      flag = false;
      message = "Please enter a correct image format";

      print(response.reasonPhrase);
    } else if (response.statusCode == 400) {
      print(await response.stream.bytesToString());

      flag = false;
      message = "Please enter a correct image format";
    } else {
      print(await response.stream.bytesToString());

      print(response.reasonPhrase);
      message = "Something went wrong";
    }
    Map<dynamic, dynamic> result = {
      'flag': flag,
      'message': message,
      'fields': fields
    };

    return Future.value(result);
  }

  Future<Map<dynamic, dynamic>> Fatca(
      var pep, var rpep, var residentForTaxInIndia, var relatedPerson) async {
    print(
        "in dfatca pep $pep rpep $rpep $residentForTaxInIndia , $relatedPerson");
    var flag = false;
    var message = "Updated successfully";

    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    var headers = {
      'Authorization': "$authToken",
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.update));

    request.body = '''{
    "merchantId":"$merchantID",
    "save":"formData",
    "type":"fatca",
     "data":{
     "type":"fatca",
     "fatcaData":{
     "pep":"$pep",
     "rpep":"$rpep",
     "residentForTaxInIndia":"$residentForTaxInIndia",
     "relatedPerson":"$relatedPerson",
     "addressType":"...",
     "countryCodeJurisdictionResidence":"...",
     "countryJurisdictionResidence":"...",
     "taxIdentificationNumber":"...",
     "placeOfBirth":"...",
     "countryCodeOfBirth":"...",
     "countryOfBirth":"",
     "addressCity":"...",
     "addressDistrict":"...",
     "addressStateCode":"...",
     "addressState":"... ...",
      "addressCountryCode":"...",
      "addressCountry":"",    
       "addressPincode": "",  
       "address":"",  
       "relatedPersonType":"", 
       "relatedPersonKycNumber":"",
       "relatedPersonKycNumberExists":"...",
       "relatedPersonTitle":"....",
        "relatedPersonIdentityProof":{
        "name":"",
        "fatherName":"",
        "dob":"",
        "number":""
         },
                 "relatedPersonName":"",
                 
                 "relatedPersonIdentityProofType":"..."
                 }
                    }
                    }''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;

      print(await response.stream.bytesToString());
    } else if (response.statusCode == 422) {
      flag = false;
      message = "RelatedPerson must be one of [YES, NO]";
      print(await response.stream.bytesToString());
    } else {
      flag = false;
      message = "something went wrong";
      print(await response.stream.bytesToString());
    }

    Map<dynamic, dynamic> result = {'flag': flag, 'message': message};

    return Future.value(result);
  }

  Future<Map<dynamic, dynamic>> fatcaForms(
      //parameters for FATCA
      var pep,
      var rpep,
      var residentForTaxInIndia,
      var relatedPerson,
      //parameters for FORMS
      var gender,
      var maritalStatus,
      var nomineeRelationShip,
      var fatherTitle,
      var panNumber,
      var motherTitle,
      var residentialStatus,
      var occupationDescription,
      var occupationCode,
      var kycAccountCode,
      var kycAccountDescription,
      var communicationAddressCode,
      var communicationAddressType,
      var permanentAddressCode,
      var permanentAddressType,
      var citizenshipCountryCode,
      var citizenshipCountry,
      var applicationStatusCode,
      var applicationStatusDescription,
      var mobileNumber,
      var countryCode,
      var emailId,
      var fatherName,
      var motherName) async {
    var flag = false;
    var message = "Updated successfully";

    var res = await Fatca(pep, rpep, residentForTaxInIndia, relatedPerson);

    if (res['flag']) {
      flag = true;
      await Forms(
          gender,
          maritalStatus,
          nomineeRelationShip,
          fatherTitle,
          panNumber,
          motherTitle,
          residentialStatus,
          occupationDescription,
          occupationCode,
          kycAccountCode,
          kycAccountDescription,
          communicationAddressCode,
          communicationAddressType,
          permanentAddressCode,
          permanentAddressType,
          citizenshipCountryCode,
          citizenshipCountry,
          applicationStatusCode,
          applicationStatusDescription,
          mobileNumber,
          countryCode,
          emailId,
          fatherName,
          motherName);
    } else {
      message = "Something went wrong";

      print("inside else");
      print(res['message']);
    }

    Map<dynamic, dynamic> result = {'flag': flag, 'message': message};

    return Future.value(result);
  }

  Future<Map<dynamic, dynamic>> uploadLocation() async {
    await location.getCurrentLocation();

    var latitude = location.latitude;
    var longitude = location.longitude;

    print("lat is $latitude long is $longitude");

    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool flag = false;
    String message = "Updated Successfully";

    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.update));
    request.body = '''{
    "merchantId": "$merchantID",
    "save": "formData",
    "type": "userForensics",
    "data": {
    "type": "usersData",
    "userData": {
    "identity": {
     "geoLocationData": {
     "userLat": $latitude,
     "userLong": $longitude
     }        
     },
     "documents": {
     "geoLocationData": {},
     "browserData": {
      "signzyPlatformUsed": "Mobile",
      "userLat": $latitude,
      "userLong": $longitude
      }
      }
      }
      }
      }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;

      // print(await response.stream.bytesToString());
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
    } else if (response.statusCode == 400) {
      // print(await response.stream.bytesToString());

      flag = false;

      print(response.reasonPhrase);
    } else {
      // print(await response.stream.bytesToString());

      flag = false;
      message = "Something went wrong please try again later";
    }

    Map<dynamic, dynamic> result = {
      'flag': flag,
      'message': message,
    };

    return result;
  }

  Future<Map<dynamic, dynamic>> Forms(
    var gender,
    var maritalStatus,
    var nomineeRelationShip,
    var fatherTitle,
    var panNumber,
    var motherTitle,
    var residentialStatus,
    var occupationDescription,
    var occupationCode,
    var kycAccountCode,
    var kycAccountDescription,
    var communicationAddressCode,
    var communicationAddressType,
    var permanentAddressCode,
    var permanentAddressType,
    var citizenshipCountryCode,
    var citizenshipCountry,
    var applicationStatusCode,
    var applicationStatusDescription,
    var mobileNumber,
    var countryCode,
    var emailId,
    var fatherName,
    var motherName,
    // var annualIncome,
  ) async {
    print("inside for,ms");
    var flag = false;
    var message = "Updated successfully";

    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    var headers = {
      'Authorization': "$authToken",
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.update));
    request.body = '''{
    "merchantId": "$merchantID",
    "save": "formData",
    "type": "kycdata",
    "data": {
    "type": "kycdata",
    "kycData": {
    "gender": "$gender",
    "maritalStatus": "$maritalStatus",
    "nomineeRelationShip": "$nomineeRelationShip",
    "fatherTitle": "Mr.",
    "maidenTitle": "",
    "maidenName": ".......",
    "panNumber": "$panNumber",
    "aadhaarNumber": "",
    "motherTitle": "Mrs.",
    "residentialStatus": "$residentialStatus",
    "occupationDescription": "$occupationDescription",
    "occupationCode": "$occupationCode",
    "kycAccountCode": "$kycAccountCode",
    "kycAccountDescription": "$kycAccountDescription",
    "communicationAddressCode": "$communicationAddressCode",
    "communicationAddressType": "$communicationAddressType",
    "permanentAddressCode": "$permanentAddressCode",
    "permanentAddressType": "$permanentAddressType",
    "citizenshipCountryCode": "101",
    "citizenshipCountry": "India",
    "applicationStatusCode": "$applicationStatusCode",
    "applicationStatusDescription": "$applicationStatusDescription",
    "mobileNumber": "$mobileNumber",
    "countryCode": 91,
    "emailId": "$emailId",
    "fatherName": "$fatherName",
    "motherName": "$motherName",
    "placeOfBirth": "... placeOfBirth ..",
    "annualIncome": ""
    }
      }
       }''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;

      print(await response.stream.bytesToString());
    } else if (response.statusCode == 422) {
      flag = false;
      message = "Please fill the required fields";
      print(await response.stream.bytesToString());
    } else {
      flag = false;
      message = "something went wrong";
      print("IN forms");
      print(await response.stream.bytesToString());
    }

    Map<dynamic, dynamic> result = {'flag': flag, 'message': message};

    return Future.value(result);
  }

  // to update AAdhar Card
  Future<Map<dynamic, dynamic>> updatePOI(
      var name, var fatherName, var panNumber, var dob) async {
    //DOB should be in day/month/year
    var flag = false;
    var message = "Updated Successfully";

    var tokens = await getId();

    var auth = tokens['authToken'];
    var merchentId = tokens["merchantId"];
    print(merchentId);

    var headers = {
      'Authorization': '$auth',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(KycUrls.update));
    request.body = '''{
      "merchantId": "$merchentId", 
      "save": "formData",
      "type": "identityProof",
      "data": {
            "type": "individualPan",
            "name": "$name",
            "fatherName": "$fatherName",
            "number": "$panNumber",
            "dob": "$dob"
            }
           }''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
      print(await response.stream.bytesToString());
    } else if (response.statusCode == 422) {
      flag = false;
      message = "Please fill all the fields";
    } else {
      flag = false;
      message = "Something went wrong";
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
    }
    Map<dynamic, dynamic> results = {"flag": flag, "message": message};
    return results;
  }

  Future<Map<dynamic, dynamic>> updatePOA(var name, var uid, var address,
      var city, var state, var district, var pincode, var dob) async {
    //DOB should be in day/month/year
    print(
        "name: $name-----uid: $uid-----address: $address----city: $city-----state: $state---district: $district-----pincode: $pincode----dob: $dob");
    var flag = false;
    var message = "Updated Successfully";

    var tokens = await getId();

    var auth = tokens['authToken'];
    var merchantId = tokens["merchantId"];

    var headers = {
      'Authorization': '$auth',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(KycUrls.update));
    request.body = '''{
    "merchantId": "$merchantId",
    "save": "formData",
    "type": "addressProof",
    "data": {
         "type": "aadhaar",
         "name": "$name",
         "uid": "$uid",
         "address": "$address.",
          "city": "$city",
          "state": "$state",
          "district": "$district",
          "pincode": "$pincode",
          "dob": "$dob"
  
          }}''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("success");
      flag = true;
      print(await response.stream.bytesToString());
      await updateCorPOA(auth, merchantId, name, uid, address, city, state,
          district, pincode, dob);
    } else if (response.statusCode == 422) {
      print(await response.stream.bytesToString());

      flag = false;
      message = "Please fill all the fields";
    } else {
      flag = false;
      message = "Something went wrong";
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
    }
    Map<dynamic, dynamic> results = {"flag": flag, "message": message};
    return results;
  }

  Future<Map<dynamic, dynamic>> updateCorPOA(
      var auth,
      var merchantId,
      var name,
      var uid,
      var address,
      var city,
      var state,
      var district,
      var pincode,
      var dob) async {
    //DOB should be in day/month/year
    print(
        "name: $name-----uid: $uid-----address: $address----city: $city-----state: $state---district: $district-----pincode: $pincode----dob: $dob");
    var flag = false;
    var message = "Updated Successfully";

    var tokens = await getId();

    var auth = tokens['authToken'];
    var merchantId = tokens["merchantId"];
    print(merchantId);

    var headers = {
      'Authorization': '$auth',
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(KycUrls.update));
    request.body = '''{
    "merchantId": "$merchantId",
     "save": "formData",
     "type": "corrAddressProof",
         "data": {
         "type": "aadhaar",
         "name": "$name",
         "uid": "$uid",
         "address": "$address.",
          "city": "$city",
          "state": "$state",
          "district": "$district",
          "pincode": "$pincode",
          "dob": "$dob"
  
          }}''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("success");
      flag = true;
      print(await response.stream.bytesToString());
    } else if (response.statusCode == 422) {
      print(await response.stream.bytesToString());

      flag = false;
      message = "Please fill all the fields";
    } else {
      flag = false;
      message = "Something went wrong";
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
    }
    Map<dynamic, dynamic> results = {"flag": flag, "message": message};
    return results;
  }

  Future<Map<dynamic, dynamic>> generatePdf() async {
    var fields;
    var tokens = await getId();
    var url;

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool res = false;
    String message = "Pdf generated";

    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{
    "merchantId":"$merchantID",  
     "inputData":{  
         "service":"esign",  
            "type":"",
               "task":"createPdf",
                 "data":{ 
                     }
                       }
                       }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      res = true;
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      // print(responseString);
      var inputFile =
          jsonDecode(responseString)['object']['result']['combinedPdf'];
      var result = await generateAadharEsignPdf(inputFile);
      if (result['flag']) {
        fields = result['fields'];
        // print('url is $url');
      }
    } else {
      message = "Something went wrong";
      res = false;
      print(await response.stream.bytesToString());

      // print(response.statusCode);
    }

    Map<dynamic, dynamic> result = {
      'flag': res,
      'message': message,
      'fields': fields,
      'url': url
    };

    return result;
  }

  // this is the final step It will return a url that will redirect to aadhar authentication web site
  Future<Map<dynamic, dynamic>> generateAadharEsignPdf(var url) async {
    var fields;
    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool res = false;
    String message = "";

    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{
    "merchantId":"$merchantID",
     "inputData":{
     "service": "esign",
     "type": "",
     "task": "createEsignUrl",
     "data": {
      "inputFile": "$url",
       "signatureType": "aadhaaresign",
      "redirectUrl": ""
       }
       }
       }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      res = true;

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      fields = jsonDecode(responseString)['object'];
    } else if (response.statusCode == 400) {
      res = false;
      message = "This is not a valid PDF File";
    } else {
      message = "Something went wrong";

      res = false;
      print(await response.stream.bytesToString());

      print(response.statusCode);
    }

    Map<dynamic, dynamic> result = {
      'flag': res,
      'message': message,
      'fields': fields
    };

    return result;
  }

  // this function returns a esignedFile
  // Future<Map<dynamic, dynamic>> saveAadharEsignPdf() async {
  //   var fields;
  //   var tokens = await getId();
  //
  //   var merchantID = tokens['merchantId'];
  //   var authToken = tokens['authToken'];
  //
  //   bool res = false;
  //   String message = "";
  //
  //   var headers = {
  //     'Authorization': '$authToken',
  //     'Content-Type': 'application/json'
  //   };
  //   var request = http.Request('POST', Uri.parse(KycUrls.execute));
  //   request.body = '''{
  //   "merchantId":"$merchantID",
  //   "inputData":{
  //   "service": "esign",
  //   "type": "",
  //   "task": "getEsignData",
  //   "data":{
  //
  //           }
  //        }
  //     }
  //   ''';
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     res = true;
  //
  //     var responseData = await response.stream.toBytes();
  //     var responseString = String.fromCharCodes(responseData);
  //     fields = jsonDecode(responseString)['object']['result']['esignedFile'];
  //     print("signed pdf is $fields");
  //   } else if (response.statusCode == 400) {
  //     res = false;
  //     message = "PDF Not generated";
  //   } else {
  //     message = "Something went wrong";
  //
  //     res = false;
  //     print(await response.stream.bytesToString());
  //
  //     print(response.statusCode);
  //   }
  //
  //   Map<dynamic, dynamic> result = {
  //     'flag': res,
  //     'message': message,
  //     'fields': fields
  //   };
  //
  //   return result;
  // }
  //
  // // the above function returns a signed pdf url that url we need to pass and save it
  // Future<Map<dynamic, dynamic>> saveSignedPdf(var signedPdfUrl) async {
  //   var tokens = await getId();
  //
  //   var merchantID = tokens['merchantId'];
  //   var authToken = tokens['authToken'];
  //
  //   bool flag = false;
  //   String message = "Updated Successfully";
  //
  //   var headers = {
  //     'Authorization': '$authToken',
  //     'Content-Type': 'application/json'
  //   };
  //   var request = http.Request('POST', Uri.parse(KycUrls.update));
  //   request.body = '''{
  //   "merchantId": "$merchantID",
  //   "save": "esign",
  //   "data": {
  //   "signedPdf": "$signedPdfUrl"}
  //   }''';
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     flag = true;
  //
  //   } else if (response.statusCode == 422) {
  //     flag = false;
  //     message = "SignedPdf is not allowed to be empty";
  //
  //     print(response.reasonPhrase);
  //   } else {
  //     flag = false;
  //     message = "Something went wrong please try again later";
  //   }
  //
  //   Map<dynamic, dynamic> result = {
  //     'flag': flag,
  //     'message': message,
  //   };
  //
  //   return result;
  // }
  //
  //
  // // Final Step to complete the KYC verify Via KYC Verification Engine
  // Future<Map<dynamic, dynamic>> kycVerificationEngine() async
  // {
  //
  //   var tokens = await getId();
  //   var fields;
  //   var merchantID = tokens['merchantId'];
  //   var authToken = tokens['authToken'];
  //
  //   bool flag = false;
  //   String message = "Updated Successfully";
  //
  //   var headers = {
  //     'Authorization': '$authToken',
  //     'Content-Type': 'application/json'
  //   };
  //   var request = http.Request('POST', Uri.parse(KycUrls.execute));
  //   request.body = '''{
  //   "merchantId": "$merchantID",
  //   "inputData": {
  //   "service": "verificationEngine",
  //   "merchantId": "$merchantID"
  //   }
  //   }''';
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200)
  //   {
  //     flag = true;
  //     var responseData = await response.stream.toBytes();
  //     var responseString = String.fromCharCodes(responseData);
  //     fields = jsonDecode(responseString)['object'];
  //
  //
  //   } else if (response.statusCode == 422) {
  //     flag = false;
  //     message = "SignedPdf is not allowed to be empty";
  //
  //     print(response.reasonPhrase);
  //   } else {
  //     flag = false;
  //     message = "Something went wrong please try again later";
  //   }
  //
  //   Map<dynamic, dynamic> result = {
  //     'flag': flag,
  //     'message': message,
  //     'fields' : fields
  //   };
  //
  //   return result;
  // }

  // this function is used to fetch the merchant id and Authentication token

  Future<Map<dynamic, dynamic>> saveAadharEsignPdf() async {
    var fields;
    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool res = false;
    String message = "";

    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{
    "merchantId":"$merchantID",
    "inputData":{
    "service": "esign",
    "type": "",
    "task": "getEsignData",
    "data":{
    
            }  
         }
      }
    ''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      res = true;

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      fields = jsonDecode(responseString)['object']['result']['esignedFile'];
      print("signed pdf is $fields");
    } else if (response.statusCode == 400) {
      res = false;
      message = "PDF Not generated";
    } else {
      message = "Something went wrong";

      res = false;
      print(await response.stream.bytesToString());

      print(response.statusCode);
    }

    Map<dynamic, dynamic> result = {
      'flag': res,
      'message': message,
      'fields': fields
    };

    return result;
  }

  // the above function returns a signed pdf url that url we need to pass and save it
  Future<Map<dynamic, dynamic>> saveSignedPdf(var signedPdfUrl) async {
    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool flag = false;
    String message = "Updated Successfully";

    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.update));
    request.body = '''{
    "merchantId": "$merchantID",
    "save": "esign",
    "data": {
    "signedPdf": "$signedPdfUrl"}
    }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
    } else if (response.statusCode == 422) {
      flag = false;
      message = "SignedPdf is not allowed to be empty";

      print(response.reasonPhrase);
    } else {
      flag = false;
      message = "Something went wrong please try again later";
    }

    Map<dynamic, dynamic> result = {
      'flag': flag,
      'message': message,
    };

    return result;
  }

// Final Step to complete the KYC verify Via KYC Verification Engine
  Future<Map<dynamic, dynamic>> kycVerificationEngine() async {
    var tokens = await getId();
    var fields;
    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool flag = false;
    String message = "Updated Successfully";

    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{
    "merchantId": "$merchantID",
    "inputData": {
    "service": "verificationEngine",
    "merchantId": "$merchantID"
    }
    }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      fields = jsonDecode(responseString)['object'];
    } else if (response.statusCode == 422) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      flag = false;
      message = "SignedPdf is not allowed to be empty";

      print(response.reasonPhrase);
    } else {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      flag = false;
      message = "Something went wrong please try again later";
    }

    Map<dynamic, dynamic> result = {
      'flag': flag,
      'message': message,
      'fields': fields
    };

    return result;
  }

  Future<Map<dynamic, dynamic>> getId() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //
    // var authToken = await sharedPreferences.getString("authToken");
    // var merchantId = await sharedPreferences.getString("merchantId");
    if (baseProvider == null || _dbModel == null) return null;

    if (baseProvider.kycDetail == null) {
      baseProvider.kycDetail =
          await _dbModel.getUserKycDetails(baseProvider.myUser.uid);
    }

    if (!isUserSetup()) return null;

    String authToken = baseProvider.kycDetail.userAccessToken;
    String merchantId = baseProvider.kycDetail.merchantId;

    print("auth Token = $authToken merid = $merchantId");

    Map<dynamic, dynamic> data = {
      "authToken": authToken,
      "merchantId": merchantId
    };

    return Future.value(data);
  }

  String _generateUserName(String panNumber) {
    String p = (panNumber ?? 'ABCDE1234E').toLowerCase();
    var rnd = new Random();
    int u = rnd.nextInt(10);
    return 'felloj${u.toString()}_$p';
  }
}
