import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';

import '../../Routes/Routes.dart';
import '../../Screens/Auth_Screens/forgot_password.dart';
import '../../Screens/Auth_Screens/sign_in.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/userModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  // Future postApiUsingEmailRequest(Map jsonMap, BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   dynamic responseJson;
  //   var url = ApiMapping.getURI(apiEndPoint.auth_signIn_using_post);
  //
  //   HttpClient httpClient = new HttpClient();
  //   HttpClientRequest request =
  //   await httpClient.postUrl(Uri.parse(url)).timeout(Duration(seconds: 10));
  //   request.headers.set('content-type', 'application/json');
  //   request.add(utf8.encode(json.encode(jsonMap)));
  //
  //   HttpClientResponse response = await request.close();
  //   // todo - you should check the response.statusCode
  //   responseJson = await response.transform(utf8.decoder).join();
  //   String rawJson = responseJson.toString();
  //   print(responseJson.toString());
  //
  //   Map<String, dynamic> map = jsonDecode(rawJson);
  //   String id = map['id'].toString();
  //   int merchantId = map['principal_id'] ?? -1;
  //
  //   print("UserId from Api" + map['id'].toString());
  //   try {
  //     if (response.statusCode == 200) {
  //       print(responseJson.toString());
  //       String userId = id.toString();
  //       print("UserId ..." + userId);
  //       // prefs.setString(StringConstant.userId, userId);
  //       prefs.setString(StringConstant.testId, userId);
  //       if (merchantId != -1) {
  //         prefs.setInt('merchant_id', merchantId);
  //         prefs.setBool('isLogin', true);
  //         StringConstant.isLogIn = true;
  //         prefs.setString('jwt_token', map['jwt_token'].toString());
  //       }
  //       // Prefs.instance.setToken(StringConstant.userId, id.toString());
  //
  //       var loginId = await prefs.getString(StringConstant.testId);
  //
  //       print("LoginId : .. " + loginId.toString());
  //       // StringConstant.isLogIn = true;
  //       Utils.successToast(id.toString());
  //
  //       // Navigator.of(context).pushReplacement(
  //       //     MaterialPageRoute(builder: (context) => OrderDashboard()));
  //
  //     } else {      Utils.errorToast("System is busy, Please try after sometime.");
  //     }
  //   } catch (e) {
  //     Utils.errorToast("System is busy, Please try after sometime.");
  //   }
  //   httpClient.close();
  //   return responseJson;
  // }

  /// FINAL API FOR LOGIN USING EMAIL AND PASSWORD

  Future postApiUsingEmailPasswordRequest(
      Map jsonMap,String fcmToken, BuildContext context) async {
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
      //api for passing fcm token
      passFCMToken(jsonData['payload']['body']['id'].toString(), fcmToken);
      AuthRepository()
          .getUserDetailsById(jsonData['payload']['body']['id'].toString());
      prefs.setString(
          StringConstant.testId, jsonData['payload']['body']['id'].toString());
      // Prefs.instance.setToken(StringConstant.userId, id.toString());

      var loginId = await Prefs.instance.getToken(StringConstant.userId);
      final preferences = await SharedPreferences.getInstance();
      preferences.setInt('isUserLoggedIn', 1);
      preferences.setString(
          'isUserId', jsonData['payload']['body']['id'].toString());
      preferences.setString(
          'usernameLogin', jsonData['payload']['body']['username'].toString());
      preferences.setString(
          'emailLogin', jsonData['payload']['body']['email'].toString());

      int merchantId = jsonData['payload']['body']['principal_id'] ?? -1;
print("merchantId ${merchantId}");
      if (merchantId != -1) {
        prefs.setInt('merchant_id', merchantId);
        prefs.setBool('isLogin', true);
        StringConstant.isLogIn = true;
        prefs.setString('jwt_token', jsonData['payload']['body']['jwt_token'].toString());
      }
      print("LoginId : .. " + loginId.toString());

      StringConstant.isLogIn = true;
      Utils.successToast('User login successfully');

      StringConstant.isUserNavigateFromDetailScreen =
          (prefs.getString('isUserNavigateFromDetailScreen')) ?? "";
      StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
      print("Cart Id From Login usinh Email " + StringConstant.UserCartID);
      print("StringConstant.isUserNavigateFromDetailScreen" +
          StringConstant.isUserNavigateFromDetailScreen.toString());
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

  Future postApiForMobileOTPRequest(
      Map jsonMap, bool isForgotPass, BuildContext context) async {
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
      prefs.setString('userIdFromOtp',jsonData['payload']['user_id'].toString());
      prefs.setString('userNameFromOtp',jsonData['payload']['username'].toString());
      String mobile = jsonMap['email'].toString();
      Utils.successToast(jsonData['payload']['otp'].toString());

      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => OTPScreen(
      //           mobileNumber: mobile.toString(),
      //           OTP: jsonData['payload']['otp'].toString(),
      //           Uname: jsonData['payload']['username'].toString(),
      //           UID: jsonData['payload']['user_id'].toString(),
      //           isForgotPass: isForgotPass,
      //         )));
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR LOGIN USING EMAIL AND OTP

  Future postApiForEmailOTPRequest(
      Map jsonMap, bool isForgotPass,String fcmToken, BuildContext context) async {
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
      //api for passing fcm token
      passFCMToken(jsonData['payload']['id'].toString(), fcmToken);

      prefs.setString(
          StringConstant.setOtp, jsonData['payload']['otp'].toString());
      prefs.setString('userIdFromOtp',jsonData['payload']['user_id'].toString());
      prefs.setString('userNameFromOtp',jsonData['payload']['username'].toString());
      String mobile = jsonMap['email'].toString();
      Utils.successToast(jsonData['payload']['otp'].toString());
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => OTPScreen(
      //           mobileNumber: mobile.toString(),
      //           OTP: jsonData['payload']['otp'].toString(),
      //           Uname: jsonData['payload']['username'].toString(),
      //           UID: jsonData['payload']['user_id'].toString(),
      //           isForgotPass: isForgotPass,
      //         )));
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR VALIDATING OTP

  Future postApiForValidateOTP(
      Map jsonMap, bool isForgotPass, BuildContext context) async {
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
    if (response.statusCode == 200) {
      if (jsonData['status'].toString() == 'OK') {
        AuthRepository()
            .getUserDetailsById(jsonData['payload']['id'].toString());

        prefs.setString(
            StringConstant.testId, jsonData['payload']['id'].toString());
        // Prefs.instance.setToken(StringConstant.userId, id.toString());

        final preferences = await SharedPreferences.getInstance();
        preferences.setInt('isUserLoggedIn', 1);
        preferences.setString('isUserId', jsonData['payload']['id'].toString());
        preferences.setString(
            'usernameLogin', jsonData['payload']['username'].toString());
        preferences.setString(
            'emailLogin', jsonData['payload']['email'].toString());


        StringConstant.isLogIn = true;
        Utils.successToast('User login successfully');

        StringConstant.isUserNavigateFromDetailScreen =
            (prefs.getString('isUserNavigateFromDetailScreen')) ?? "";
        StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
        print("Cart Id From Login usinh Email " + StringConstant.UserCartID);
        print("StringConstant.isUserNavigateFromDetailScreen" +
            StringConstant.isUserNavigateFromDetailScreen);
        var userId = preferences.getString('isUserId');


        Navigator.of(context)
            .pushReplacementNamed(RoutesName.dashboardRoute)
            .then((value) {});
      } else {
        Utils.errorToast("Please enter valid details.");

        httpClient.close();
        return responseJson;
      }
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

//get user details
  Future<UserModel> getUserDetailsById(String id) async {
    var url = ApiMapping.getURI(apiEndPoint.user_get);
    print("user specific ID : " + url + id.toString());
    final prefs = await SharedPreferences.getInstance();

    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print("user Specific Id : " + response.toString());
      print("user Specific email : " + response['payload']['email']);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
          'userProfileNamePrefs', response['payload']['username'].toString());
      await prefs.setString(
          'userProfileEmailPrefs', response['payload']['email'].toString());
      await prefs.setString(
          'userProfileMobilePrefs', response['payload']['mobile'].toString());

      return response = UserModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

//   Future getUserDetailsById(String id) async {
//     var url = ApiMapping.getURI(apiEndPoint.user_get);
//     print("user specific ID : " + url + id.toString());
//     final prefs = await SharedPreferences.getInstance();
//
//     try {
//       dynamic response = await _apiServices.getGetApiResponse(url + id);
//       print("user Specific Id : " + response.toString());
//       // print("user Specific email : " + response['payload']['email']);
//       //
//       // final prefs = await SharedPreferences.getInstance();
//       //
//       // await prefs.setString(
//       //     'userProfileNamePrefs', response['payload']['username'].toString());
//       // await prefs.setString(
//       //     'userProfileEmailPrefs', response['payload']['email'].toString());
//       // await prefs.setString(
//       //     'userProfileMobilePrefs', response['payload']['mobile'].toString());
//
//       return response ;
//     } catch (e) {
//       throw e;
//     }
//   }

  //Forgot password
  Future forgotPassRequest(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic responseJson;
    var url = ApiMapping.BaseAPI + ApiMapping.forgotPasswordGenOtp;
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
        responseJson.toString(), 'Forgot Password Response:');

    if (jsonData['status'].toString() == 'OK') {
      String mobile = jsonMap['cred'].toString();

      String result = jsonData['payload'].toString().replaceAll("'", "");
      String result1 = result.toString().replaceAll("{", "");
      String result2 = result1.toString().replaceAll("}", "");
      String OTP = result2.toString().replaceAll("newOtp:", "");
      print(mobile);
      print(OTP);
      // var jsonOtp = json.decode(result3);

      Utils.successToast(OTP.toString());
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ForgotPassOTP(
            mobileNumber: mobile.toString(),
            OTP: OTP.toString(),
          )));
    } else {
      Utils.errorToast("Please enter valid details.");
      httpClient.close();
      return responseJson;
    }
  }

//Reset Password
  Future resetPassRequest(
      Map jsonMap, bool isFromForgotPass, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic responseJson;
    var url = ApiMapping.BaseAPI + ApiMapping.resetPassword;
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

    if (jsonData['status'].toString() == 'OK') {
      StringConstant.prettyPrintJson(
          responseJson.toString(), 'Reset Password Response:');
      if (isFromForgotPass == true) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SignIn_Screen()));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDashboard(),
            ),
                (route) => false);
      }
    } else {
      Utils.errorToast("Please enter valid details.");
      httpClient.close();
      return responseJson;
    }
  }

  //update profile image
  Future updateProfileImageApi(dynamic data, String userId) async {
    // var url = ApiMapping.getURI(apiEndPoint.put_carts);
    final prefs = await SharedPreferences.getInstance();

    print("userId ID" + userId.toString());
    print("userId ID" + data.toString());

    var url = '/user/$userId/changeimage';

    var requestUrl = ApiMapping.BaseAPI + url;
    print(requestUrl.toString());

    String body = json.encode(data);
    print("updateProfileImageApi jsonMap" + body.toString());

    try {
      dynamic reply;
      http.Response response = await http.put(Uri.parse(requestUrl),
          body: body, headers: {'content-type': 'application/json'});
      print("response Put Address" + response.body.toString());
      var jsonData = json.decode(response.body);
      print("response post jsonData" + jsonData['status'].toString());

      // Utils.successToast(response.body.toString());
      return reply;

      return response;
    } catch (e) {
      throw e;
    }


}
  ///firebase fcm token
  Future passFCMToken(String userId, String fcmToken) async {
    Map<String, String> queryParams = {
      'fcm_token': fcmToken,
    };
    var url = ApiMapping.BaseAPI + '/user/$userId/setfcmtoken';
    String queryString = Uri(queryParameters: queryParams).query;

    var requestUrl = '$url?$queryString';
    print(requestUrl.toString());
    print("response url : " + requestUrl.toString());

    try {
      dynamic reply;
      http.Response response = await http.put(Uri.parse(requestUrl),
          headers: {'content-type': 'application/json'});
      print("response passFCMToken : " + response.body.toString());
      var jsonData = json.decode(response.body);
      print("response  passFCMToken status : " + jsonData['status'].toString());

      // Utils.successToast(response.body.toString());
      return reply;

      return response;
    } catch (e) {
      throw e;
    }
  }}