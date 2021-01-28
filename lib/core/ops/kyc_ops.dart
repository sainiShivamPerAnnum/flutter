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
  final String defaultBaseUri = 'https://multi-channel-preproduction.signzy.tech';
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

  Future<Map<dynamic, dynamic>> createOnboardingObj() async
  {
    bool res = false;
    String message = "Object Created Successfully";

    String url = "https://multi-channel-preproduction.signzy.tech/api/channels/6007e4edf3be1f1190757519/onboardings";

    headers = {
      'Content-Type': 'application/json',
      'Authorization': KycUrls.auth
    };

    Map<dynamic,dynamic> body =
          {
            "email" : "abc@gmail.com",
            "username" : "soni2222.",
            "phone" : "9811111111",
            "name" : "Abhishek"
          };

    String jsonBody = json.encode(body);

    http.Response response = await http.post(
      KycUrls.createOnboardingObject,
      body: jsonBody,
      headers: headers,
    );

    if(response.statusCode == 200)
      {
        res = true;
        print("Suucess ${response.body}");
        var data = jsonDecode(response.body);
        var userName = data['createdObj']['username'];
        var password = data['createdObj']['id'];
        print(userName);

        await login(userName, password);


      }
    else if(response.statusCode == 422)
      {
        message = "Username already exists please enter a new username";
        res = false;
        log.debug(response.body);
      }

    else
      {
        res = false;
        message = "Something went wrong";
        log.debug(response.body);

      }

    Map<dynamic,dynamic> result =

    {
      'flag' : res,
      'message' : message

    };


    return result;
  }

  Future<Map<dynamic,dynamic>>login(var userName, var password)async
  {
    bool res = false;
    String message = "Success";

    KycUrls.userName = userName;


    Map<dynamic,dynamic> body =
    {
      "username": userName,
      "password": password
    };

    String jsonBody = json.encode(body);

    http.Response response = await http.post(
      KycUrls.login,
      body: jsonBody,
      headers: headers,
    );

    if(response.statusCode == 200)
    {
      res = true;
      print("Suucess ${response.body}");
      var data = jsonDecode(response.body);
      var token = data['id'];
      var merchantId = data['userId'];



      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      await sharedPreferences.setString("authToken", token);
      await sharedPreferences.setString("merchantId", merchantId);


    }
    else if(response.statusCode == 422)
    {
      message = "Username already exists please enter a new username";
      res = false;
      log.debug(response.body);
    }

    else
    {
      res = false;
      message = "Something went wrong";
      log.debug(response.body);

    }

    Map<dynamic,dynamic> result =

    {
      'flag' : res,
      'message' : message

    };


    return result;
  }




  Future<Map<dynamic,dynamic>> convertImages(var image) async
  {
    print("inside convertImage");
    bool result = false;
    var imageUrl;

    // await getId();

    var request = http.MultipartRequest('POST',Uri.parse(KycUrls.convertImages));

    var convertedImage = await http.MultipartFile.fromPath(
        'file', image);

    request.files.add(convertedImage);

    var response = await request.send();

    if (response.statusCode == 201 || response.statusCode == 200)
    {
      result = true;
      print(response.statusCode);
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      // print("response srrint $responseString");
      imageUrl = jsonDecode(responseString)['file']['directURL'];
      print(imageUrl);

    }
    else
    {
      print("Something went wrong");
      print(response.statusCode);
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      print(responseString);
    }
    Map<dynamic,dynamic> data  =
    {
      'flag' : result,
      'imageUrl' : imageUrl

    };

    return Future.value(data);

  }



  Future<Map<dynamic,dynamic>> executePOI(var image)async
  {
    print("inside execute poi");

    bool res = false;
    String message = "PAN Card Added Successfully";

    var imageURL = await convertImages(image);

    var data = await getId();

    var auth = data['authToken'];
    var merchentId = data["merchantId"];


    headers = {
      'Authorization': "$auth"
    };

    Map<dynamic,dynamic> body =
    {
      "merchantId": "$merchentId",
      "inputData": {
        "service": "identity",
        "type": "individualPan",
        "task": "autoRecognition",
        "data": {
          "images": [imageURL],
          "toVerifyData": {},
          "searchParam": {},
          "proofType": "identity"
        }
      }
    };

    String jsonBody = json.encode(body);

    http.Response response = await http.post(
      KycUrls.executePOI,
      body: jsonBody,
      headers: headers,
    );

    if(response.statusCode == 200)
    {
      res = true;
      print("Suucess ${response.body}");
      var data = jsonDecode(response.body);
      print(data);

    }
    else if(response.statusCode == 422)
    {
      message = "";
      res = false;
      log.debug(response.body);
    }

    else
    {
      res = false;
      message = "Something went wrong";
      log.debug(response.body);

    }

    Map<dynamic,dynamic> result =

    {
      'flag' : res,
      'message' : message

    };


    return result;

  }



  Future<Map<dynamic,dynamic>>getId() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var authToken = await sharedPreferences.getString("authToken");
    var merchantId = await sharedPreferences.getString("merchantId");

    print("auth Tojken = $authToken merid = $merchantId");

    Map<dynamic,dynamic> data =
        {
          "authToken" : authToken,
          "merchantId" : merchantId
        };


    return Future.value(data);



  }

}