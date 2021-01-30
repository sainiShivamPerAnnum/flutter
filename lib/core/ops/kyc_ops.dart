import 'dart:convert';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/kyc_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  DBModel _dbModel = locator<DBModel>();
  final String defaultBaseUri =
      'https://multi-channel-preproduction.signzy.tech';
  String _baseUri;
  String _apiKey;
  var headers;

  Future<bool> init() async {
    if (_dbModel == null) return false;
    Map<String, String> cMap = await _dbModel.getActiveSignzyApiKey();
    if (cMap == null) return false;

    _baseUri = (cMap['baseuri'] == null || cMap['baseuri'].isEmpty)
        ? defaultBaseUri
        : cMap['baseuri'];
    _apiKey = cMap['key'];
    headers = {
      'Content-Type': 'application/json',
      'Authorization': KycUrls.auth
    };
    return true;
  }

  bool isInit() => (_apiKey != null);

  Future<Map<dynamic, dynamic>> createOnboardingObj() async {
    bool res = false;
    String message = "Object Created Successfully";


    headers = {
      'Content-Type': 'application/json',
      'Authorization': KycUrls.auth
    };

    Map<dynamic, dynamic> body = {
      "email": "abhisheksoni@gmail.com",
      "username": "fello2223.",
      "phone": "9983392727",
      "name": "Abhishek"
    };

    String jsonBody = json.encode(body);

    http.Response response = await http.post(
      KycUrls.createOnboardingObject,
      body: jsonBody,
      headers: headers,
    );

    if (response.statusCode == 200) {
      res = true;
      print("Suucess ${response.body}");
      var data = jsonDecode(response.body);
      var userName = data['createdObj']['username'];
      var password = data['createdObj']['id'];
      print(userName);

      await login(userName, password);
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

  Future<Map<dynamic, dynamic>> login(var userName, var password) async {
    bool res = false;
    String message = "Success";

    KycUrls.userName = userName;

    Map<dynamic, dynamic> body = {"username": userName, "password": password};

    String jsonBody = json.encode(body);

    http.Response response = await http.post(
      KycUrls.login,
      body: jsonBody,
      headers: headers,
    );

    if (response.statusCode == 200) {
      res = true;
      print("Suucess ${response.body}");
      var data = jsonDecode(response.body);
      var token = data['id'];
      var merchantId = data['userId'];

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      await sharedPreferences.setString("authToken", token);
      await sharedPreferences.setString("merchantId", merchantId);
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

  Future<Map<dynamic, dynamic>> convertImages(var image) async
  {
    print("inside convertImage");
    bool result = false;
    var imageUrl;

    await getId();

    var request =
        http.MultipartRequest('POST', Uri.parse(KycUrls.convertImages));

    var convertedImage = await http.MultipartFile.fromPath('file', image);

    request.files.add(convertedImage);

    var response = await request.send();

    if (response.statusCode == 201 || response.statusCode == 200) {
      result = true;
      print(response.statusCode);
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      // print("response srrint $responseString");
      imageUrl = jsonDecode(responseString)['file']['directURL'];
      print(imageUrl);
    } else {
      print("Something went wrong");
      print(response.statusCode);
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      print(responseString);
    }
    Map<dynamic, dynamic> data = {'flag': result, 'imageUrl': imageUrl};

    return Future.value(data);
  }

  Future<Map<dynamic, dynamic>> executePOI(var image) async
  {
    var flag = false;
    var message = "Uploaded Successfully";

    var tokens = await getId();

    var auth = tokens['authToken'];
    var merchentId = tokens["merchantId"];
    print(merchentId);
    print("Auth Token = $auth");

    var data = await convertImages(image);
    var imageUrl = data['imageUrl'];
    print(imageUrl);

    var headers = {
      'Authorization': '$auth',
      'Content-Type': 'application/json'
    };

    var request = http.Request(
        'POST',
        Uri.parse(
            'https://multi-channel-preproduction.signzy.tech/api/onboardings/execute'));
    request.body = '''{
    "merchantId": "$merchentId",
    "inputData":
      { 
     "service": "identity",
     "type": "individualPan",
     "task": "autoRecognition",  
     "data": {
     "images": ["${imageUrl}"],            
     "toVerifyData": {},            
     "searchParam": {},  
     "proofType": "identity"   
          } 
       }  
     }''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)
    {
      flag = true;
      print(await response.stream.bytesToString());
    }
    else if (response.statusCode == 400)
      {
        flag = false;
        message = "Image link expired please select a new Image";

      }
    else {
      flag = false;
      message = "Something went wrong";
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
    }
    Map<dynamic,dynamic> results =
        {
          "flag" : flag,
          "message" : message

        };
    return results;
  }

  //  Future<Map<dynamic,dynamic>> executePOI(var image)async
  // {
  //    var tokens = await getId();
  //
  //    var auth = tokens['authToken'];
  //    var merchentId = tokens["merchantId"];
  //    print(merchentId);
  //    print("Auth Token = $auth");
  //
  //    var data = await convertImages(image);
  //    var imageUrl = data['imageUrl'];
  //    print(imageUrl);
  //
  //    var headers = {
  //      'Authorization': '$auth',
  //      'Content-Type': 'application/json'
  //    };
  //    var request = http.Request('POST', Uri.parse('https://multi-channel-preproduction.signzy.tech/api/onboardings/execute'));
  //    request.body = '''    {\n        "merchantId": "$merchentId",\n        "inputData": {\n            "service": "identity",\n            "type": "individualPan",\n            "task": "autoRecognition",\n            "data": {\n                "images": ["https://5.imimg.com/data5/XZ/BJ/RJ/SELLER-92944351/pancard-500x500-500x500.jpg"],            \n                "toVerifyData": {},\n                "searchParam": {},\n                "proofType": "identity"\n            }\n        }\n    }''';
  //    request.headers.addAll(headers);
  //
  //    http.StreamedResponse response = await request.send();
  //
  //    if (response.statusCode == 200) {
  //      print(await response.stream.bytesToString());
  //    }
  //    else {
  //      print(await response.stream.bytesToString());
  //      print(response.reasonPhrase);
  //    }
  //
  //
  //  }

  Future<bool> POI(var image) async {
    var imageURL = await convertImages(image);

    var data = await getId();

    var auth = data['authToken'];
    var merchentId = data["merchantId"];
    print(merchentId);
    print("Auth Token = $auth");

    bool result = false;

    print("INside multipart file");

    final headers = {
      // 'Content-Type': 'application/json',
      'Authorization': '$auth'
    };
    Map<dynamic, dynamic> inputData = {
      "service": "identity",
      "type": "individualPan",
      "task": "autoRecognition",
      "data": {
        "images": [imageURL],
        "toVerifyData": {},
        "searchParam": {},
        "proofType": "identity"
      }
    };

    var request = http.MultipartRequest('POST', Uri.parse(KycUrls.execute));

    request.headers.addAll(headers);
    request.fields['merchantId'] = '$merchentId';
    request.fields['inputData'] = '$inputData';

    var response = await request.send();

    if (response.statusCode == 201 || response.statusCode == 200) {
      result = true;
      // print("Success");
      // whatsapp.sendMessage(order);
      print(response.statusCode);
    } else {
      print("Something went wrong");
      print(response.statusCode);
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
    }

    return Future.value(result);

    //Get the response from the server
  }

  Future<bool> updateSignature(var image) async {
    var flag = false;
    var message = "Signature Uploaded Successfully";
    var data = await convertImages(image);

    var signatureUrl = data['imageUrl'];
    print("Signature url is $signatureUrl");

    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    var headers = {
      'Authorization': "$authToken",
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.updateSignature));
    request.body =
        '''{\n   "merchantId":"$merchantID",\n   "save":"formData",\n   "type":"signature",\n   "data":{\n      "type":"signature",\n      "signatureImageUrl":"$signatureUrl",\n      "consent":"true"\n   }\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      flag = true;

      print(await response.stream.bytesToString());
    } else {
      flag = false;
      print(response.reasonPhrase);
    }

    // Map<dynamic,dynamic> result =
    //   {
    //     'flag' : flag,
    //     'message' : message
    //
    //   };

    return flag;
  }


  Future<Map<dynamic, dynamic>> bankPennyTransfer() async
  {
    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool res = false;
    String message = "Bank Verified Successfully";


    var headers = {
      'Authorization': '$authToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(KycUrls.execute));
    request.body = '''{ 
      "merchantId": "$merchantID",\n  
      "inputData": {     
         "service": "nonRoc",       
          "type": "bankaccountverifications",  
           "task": "bankTransfer",
           "data": {
           "images": [],      
           "toVerifyData": {}, 
           "searchParam": {    
           "beneficiaryAccount": "50100344606311",
           "beneficiaryIFSC": "HDFC0000119",
           "beneficiaryName":"Abhishek Soni"
                     }
                   }
                 }
            }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)
    {

      print(await response.stream.bytesToString());
    }
    else if(response.statusCode == 400)
    {

      print(response.reasonPhrase);
    }

    Map<dynamic, dynamic> result =
    {
      'flag': res,
      'message': message
    };

    return result;
  }



  Future<Map<dynamic, dynamic>> cancelledCheque(var image) async
  {
    var tokens = await getId();
    var data = await convertImages(image);

    var imageUrl = data['imageUrl'];
    print("imge is $imageUrl");


    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool res = false;
    String message = "Bank Verified Successfully";


    var headers = {
      'Authorization': '$authToken',
      // 'Content-Type': 'application/json'
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
                }}''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)
    {

      print(await response.stream.bytesToString());
    }
    else if(response.statusCode == 400)
    {

      print(response.reasonPhrase);
    }

    Map<dynamic, dynamic> result =
    {
      'flag': res,
      'message': message
    };

    return result;
  }



  Future<Map<dynamic, dynamic>> generatePdf() async
  {
    var tokens = await getId();

    var merchantID = tokens['merchantId'];
    var authToken = tokens['authToken'];

    bool res = false;
    String message = "Bank Verified Successfully";



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

    if (response.statusCode == 200)
    {
      print(await response.stream.bytesToString());
    }
    else {
      print(await response.stream.bytesToString());

      print(response.statusCode);
    }

    Map<dynamic, dynamic> result = {'flag': res, 'message': message};

    return result;
  }






  Future<Map<dynamic, dynamic>> getId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var authToken = await sharedPreferences.getString("authToken");
    var merchantId = await sharedPreferences.getString("merchantId");

    print("auth Tojken = $authToken merid = $merchantId");

    Map<dynamic, dynamic> data = {
      "authToken": authToken,
      "merchantId": merchantId
    };

    return Future.value(data);
  }


}
