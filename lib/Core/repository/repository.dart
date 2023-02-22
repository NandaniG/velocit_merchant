import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

import '../AppConstant/apiMapping.dart';

class Repository {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> loginApiWithGet() async {
    var url = ApiMapping.getURI(apiEndPoint.signIn_authenticate_get);

    try {
      dynamic resposnse = await _apiServices.getGetApiResponse(url);
      return resposnse;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> loginApiWithPost(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.signIn_authenticateWithUID_post);

    try {
      dynamic resposnse = await _apiServices.getPostApiResponse(url, data);
      return resposnse;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> authSignInUsingPost(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.auth_signIn_using_post);

    try {
      dynamic resposnse = await _apiServices.getPostApiResponse(url, data);
      return resposnse;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> authSignUpUsingPost(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.auth_signUp_using_post);
    print(url.toString());

    try {
      dynamic resposnse = await _apiServices.getPostApiResponse(url, data);
      return resposnse;
    } catch (e) {
      throw e;
    }
  }

  Future postApiRequest(Map jsonMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt_token') ?? '';
    // dynamic responseJson;
    var url = ApiMapping.ConstructURI(StringConstant.apiMerchantBasket_findby_merchant);
print(url);
    dynamic responseJson = await _apiServices.getGetApiResponseWithBody(url, jsonMap);
    
    String rawJson = responseJson.toString();
    print(responseJson.toString());
    return responseJson;
  }


  Future getApiRequest(Map jsonMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt_token') ?? '';
    dynamic responseJson;
    var url = ApiMapping.ConstructURI(StringConstant.apiMerchantBasket_findby_merchant);

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = 
  await httpClient.getUrl(Uri.parse(url)).timeout(Duration(seconds: 10));
    request.headers.set('content-type', 'application/json');
    // request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    // request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();
    String rawJson = responseJson.toString();
    print(responseJson.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);
    String id = map['id'].toString();
    int merchantId = map['principal_id'] ?? -1; 
    try {
      if (response.statusCode == 200) {
        print(responseJson.toString());
        String userId = id.toString();
        print("UserId from Api" + userId);
        // prefs.setString(StringConstant.userId, userId);
        prefs.setString(StringConstant.testId, userId);
        if (merchantId != -1) {
          prefs.setInt('merchant_id', merchantId);
          prefs.setBool('isLogin', true);
          prefs.setString('jwt_token', map['jwt_token'].toString());
        }
        // Prefs.instance.setToken(StringConstant.userId, id.toString());

        var loginId = await prefs.getString(StringConstant.testId);

        print("LoginId : .. " + loginId.toString());
        // StringConstant.isLogIn = true;
        // Utils.successToast(id.toString());

        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => OrderDashboard()));
      } else {      Utils.errorToast("System is busy, Please try after sometime.");
      }
    } catch (e) {
      Utils.errorToast("System is busy, Please try after sometime.");
    }
    httpClient.close();
    return responseJson;
  }
}
