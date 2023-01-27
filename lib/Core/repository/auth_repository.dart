import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';
import '../../Screens/Auth_Screens/OTP_Screen.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

import '../AppConstant/apiMapping.dart';

class AuthRepository {
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

  Future postApiUsingEmailRequest(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.getURI(apiEndPoint.auth_signIn_using_post);

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse(url)).timeout(Duration(seconds: 10));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

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
          StringConstant.isLogIn = true;
          prefs.setString('jwt_token', map['jwt_token'].toString());
        }
        // Prefs.instance.setToken(StringConstant.userId, id.toString());

        var loginId = await prefs.getString(StringConstant.testId);

        print("LoginId : .. " + loginId.toString());
        // StringConstant.isLogIn = true;
        Utils.successToast(id.toString());

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OrderDashboard()));
      } else {      Utils.errorToast("System is busy, Please try after sometime.");
      }
    } catch (e) {
      Utils.errorToast("System is busy, Please try after sometime.");
    }
    httpClient.close();
    return responseJson;
  }


/////////////////


  /// FINAL API FOR LOGIN USING EMAIL AND PASSWORD

  Future postApiUsingEmailPasswordRequest(
      Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.loginViaEmailPassword;

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(responseJson.toString(), 'Login Response:');

    if (jsonData['status'].toString() == 'OK') {
      prefs.setString(
          StringConstant.testId, jsonData['payload']['body']['id'].toString());
      // Prefs.instance.setToken(StringConstant.userId, id.toString());

      final preferences = await SharedPreferences.getInstance();
      preferences.setInt('isUserLoggedIn', 1);
      preferences.setString(
          'isUserId', jsonData['payload']['body']['id'].toString());
      preferences.setString(
          'usernameLogin', jsonData['payload']['body']['username'].toString());
      preferences.setString(
          'emailLogin', jsonData['payload']['body']['email'].toString());


      StringConstant.isLogIn = true;
      Utils.successToast('User login successfully');

      StringConstant.isUserNavigateFromDetailScreen =
          (prefs.getString('isUserNavigateFromDetailScreen')) ?? "";
      StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
      print("Cart Id From Login usinh Email " + StringConstant.UserCartID);
      print("StringConstant.isUserNavigateFromDetailScreen" +
          StringConstant.isUserNavigateFromDetailScreen);
      var userId = preferences.getString('isUserId');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OrderDashboard()));

    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR LOGIN USING MOBILE AND OTP

  Future postApiForMobileOTPRequest(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.loginViaMobileOTP;
    print(url);
    print(jsonMap['mobile']);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'Login Using Mobile OTP Response:');
    if (jsonData['status'].toString() == 'OK') {
      prefs.setString(
          StringConstant.setOtp, jsonData['payload']['otp'].toString());
      String mobile = jsonMap['mobile'].toString();
      Utils.successToast(jsonData['payload']['otp'].toString());

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OTPScreen(
            mobileNumber: mobile.toString(),
            OTP: jsonData['payload']['otp'].toString(),
            Uname: jsonData['payload']['username'].toString(),
            UID: jsonData['payload']['user_id'].toString(),
          )));
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR LOGIN USING EMAIL AND OTP

  Future postApiForEmailOTPRequest(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.loginViaEmailOTP;
    print(url);
    print(jsonMap['email']);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'Login Using Email OTP Response:');

    if (jsonData['status'].toString() == 'OK') {
      prefs.setString(
          StringConstant.setOtp, jsonData['payload']['otp'].toString());
      String mobile = jsonMap['email'].toString();
      Utils.successToast(jsonData['payload']['otp'].toString());
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OTPScreen(
            mobileNumber: mobile.toString(),
            OTP: jsonData['payload']['otp'].toString(),
            Uname: jsonData['payload']['username'].toString(),
            UID: jsonData['payload']['user_id'].toString(),
          )));
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR VALIDATING OTP

  Future postApiForValidateOTP(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.validateOTP;
    print(url);
    print(jsonMap);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'Validate OTP Response:');
    if(response.statusCode == 200){

      if (jsonData['status'].toString() == 'OK') {

        prefs.setString(
            StringConstant.testId, jsonData['payload']['id'].toString());
        // Prefs.instance.setToken(StringConstant.userId, id.toString());

        final preferences = await SharedPreferences.getInstance();
        preferences.setInt('isUserLoggedIn', 1);
        preferences.setString(
            'isUserId', jsonData['payload']['id'].toString());
        preferences.setString(
            'usernameLogin', jsonData['payload']['username'].toString());
        preferences.setString(
            'emailLogin', jsonData['payload']['email'].toString());


        StringConstant.isLogIn = true;
        Utils.successToast('User login successfully');



        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OrderDashboard()));

      } else {
        Utils.errorToast("Please enter valid details.");

        httpClient.close();
        return responseJson;
      }}else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
    /*   if (jsonData['status'].toString() == 'OK') {
      prefs.setString(
          StringConstant.testId, jsonData['payload']['id'].toString());
      // Prefs.instance.setToken(StringConstant.userId, id.toString());

      var loginId = await Prefs.instance.getToken(StringConstant.userId);
      final preferences = await SharedPreferences.getInstance();
      preferences.setInt('isUserLoggedIn', 1);
      preferences.setString('isUserId', jsonData['payload']['id'].toString());
      preferences.setString(
          'usernameLogin', jsonData['payload']['username'].toString());
      preferences.setString(
          'emailLogin', jsonData['payload']['email'].toString());

      print("LoginId : .. " + loginId.toString());

      StringConstant.isLogIn = true;
      Utils.successToast('User login successfully');

      StringConstant.isUserNavigateFromDetailScreen =
          (prefs.getString('isUserNavigateFromDetailScreen')) ?? "";
      StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
      print("Cart Id From OTP verify API  " + StringConstant.UserCartID);
      print("StringConstant.isUserNavigateFromDetailScreen" +
          StringConstant.isUserNavigateFromDetailScreen);

      if (StringConstant.isUserNavigateFromDetailScreen == 'Yes') {
        var cartUserId = prefs.getString('CartSpecificUserIdPref');
        var itemCode = prefs.getString('CartSpecificItem_codePref');
        var itemQuanity = prefs.getString('CartSpecificItemQuantityPref');

        Map data = {
          'user_id': jsonData['payload']['id'].toString(),
          'item_code': itemCode,
          'qty': itemQuanity
        };

        StringConstant.RandomUserLoginId =
            (prefs.getString('RandomUserId')) ?? '';
        print("Random ID : " + StringConstant.RandomUserLoginId);

        CartRepository().mergeCartList(StringConstant.RandomUserLoginId,
            jsonData['payload']['id'].toString(), data, context);
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => CartDetailsActivity()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }*/
  }


}
