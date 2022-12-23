import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:velocit_merchant/Core/data/network/baseApiServices.dart';

import '../../../utils/utils.dart';
import '../app_excaptions.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final client = http.Client();
      final response =
      await client.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw  Utils.errorToast("System is busy, Please try after sometime.");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final client = http.Client();

      Response response = await client.post(Uri.parse(url), body: data, headers: {
        'Content-type':'application/json'
      }).timeout(
          Duration(seconds: 50));

      responseJson = returnResponse(response);
      print("Get SignUp" + responseJson.toString());

    } on SocketException {
      print("Not SignUp");

      throw  Utils.errorToast("System is busy, Please try after sometime.");

    }
    return responseJson;
  }
  @override
  Future getPutApiResponse(String url, data) async {
    dynamic responseJson;
    try {
      final client = http.Client();

      Response response = await client.put(Uri.parse(url), body: data).timeout(
          Duration(seconds: 10));

      responseJson = returnResponse(response);
      print("responseJson..........");
    } on SocketException {
      throw  Utils.errorToast("System is busy, Please try after sometime.");
    }
    return responseJson;
  }
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw  Utils.errorToast("System is busy, Please try after sometime.");
      case 500:
      case 404:
        throw  Utils.errorToast("System is busy, Please try after sometime.");

      default:
        throw  Utils.errorToast("System is busy, Please try after sometime.");
    }
  }




}

