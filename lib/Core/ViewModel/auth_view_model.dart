import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../repository/auth_repository.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();

  String _getOTP = '';

  String get getOTP => _getOTP;

  bool _loadingWithGet = false;

  bool get loadingWithGet => _loadingWithGet;

  bool _loadingWithPost = false;

  bool get loadingWithPost => _loadingWithPost;

  bool _loadingWithSignUpPost = false;

  bool get loadingWithSignUpPost => _loadingWithSignUpPost;


  setLoadingWithGet(bool value) {
    _loadingWithGet = value;

    notifyListeners();
  }
  setLoadingWithPost(bool value) {
    _loadingWithPost = value;

    notifyListeners();
  }
  setLoadingWithSignUpPost(bool value) {
    _loadingWithSignUpPost = value;

    notifyListeners();
  }

  // Future<void> loginApiWithGet( BuildContext context) async {
  //   setLoadingWithGet(true);
  //   _myRepo.loginApiWithGet().then((value) async {
  //     setLoadingWithGet(false);
  //     if (kDebugMode) {
  //       print("Login Api With Get: $value");
  //       print("Login Api With Get: ${value!["response"]["body"]["payload"]}");
  //     }
  //       _getOTP = value!["response"]["body"]["payload"].toString();
  //     print("Login Api With Get: $_getOTP");
  //
  //     Prefs.instance.setToken("otpKey", _getOTP);
  //       Utils.successToast(value!["response"]["body"]["payload"].toString());
  //
  //       // Navigator.of(context).push(
  //       //   MaterialPageRoute(
  //       //     builder: (context) => OTPScreen(),
  //       //   ),
  //       // );
  //
  //   }).onError((error, stackTrace) {
  //     setLoadingWithGet(false);
  //
  //     if (kDebugMode) {
  //       Utils.flushBarErrorMessage(error.toString(), context);
  //       print(error.toString());
  //     }
  //   });
  // }
  //
  // Future<void> loginApiWithPost(dynamic data, BuildContext context) async {
  //   setLoadingWithPost(true);
  //   _myRepo.loginApiWithPost(data).then((value) {
  //     setLoadingWithPost(false);
  //     if (kDebugMode) {
  //       print("Login Api With Post : $value");
  //     }
  //
  //
  //   }).onError((error, stackTrace) {
  //     setLoadingWithPost(false);
  //     if (kDebugMode) {
  //       Utils.flushBarErrorMessage(error.toString(), context);
  //
  //       print(error.toString());
  //     }
  //   });
  // }
  //
  //
  // Future<void> authSignInUsingPost(dynamic data, BuildContext context) async {
  //   setLoadingWithPost(true);
  //   _myRepo.authSignInUsingPost(data).then((value) {
  //     setLoadingWithPost(false);
  //     if (kDebugMode) {
  //       print("Sign In Api With Post : $value");
  //     }
  //
  //   }).onError((error, stackTrace) {
  //     setLoadingWithPost(false);
  //     if (kDebugMode) {
  //       Utils.flushBarErrorMessage(error.toString(), context);
  //
  //       print(error.toString());
  //     }
  //   });
  // }
  //
  // Future<void> authSignUpUsingPost(dynamic data, BuildContext context) async {
  //   setLoadingWithSignUpPost(true);
  //   _myRepo.authSignUpUsingPost(data).then((value) {
  //     setLoadingWithSignUpPost(false);
  //     if (kDebugMode) {
  //       print("Create an Account Api With Post : $value");
  //     }
  //
  //   }).onError((error, stackTrace) {
  //     setLoadingWithSignUpPost(false);
  //     if (kDebugMode) {
  //       Utils.flushBarErrorMessage(error.toString(), context);
  //
  //       print(error.toString());
  //     }
  //   });
  // }
}
