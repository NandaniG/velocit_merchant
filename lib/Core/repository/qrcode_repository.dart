

import 'package:flutter/material.dart';

import '../../Screens/orders_Dashboard.dart';
import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class QRRepository{
  BaseApiServices _apiServices = NetworkApiServices();

 getProductDeliveryScannerList(
    String orderId,  String QrCode, BuildContext context) async {

    Map<String, String> fmcgData = {
      'qr_code': QrCode.toString(),
    };

    print("getProductBy Query" + fmcgData.toString());

    var url = '/order/$orderId/validator';
    String queryString = Uri(queryParameters: fmcgData).query;

    var requestUrl = ApiMapping.BaseAPI + url + '?' + queryString;
    print("getProductBy requestUrl" + requestUrl.toString());

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("Order Scan Response: " + response.toString());
      print("Order Scan status : "+response['status'].toString());
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString(
      //     'ScannedProductIDPref', response['payload']['id'].toString());
      if(response['status']== 'OK'){
        Utils.successToast("Scan successfully", );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OrderDashboard()));
       }else{
        print("NOT_FOUND....");
        // Navigator.pop(context);
        Utils.flushBarErrorMessage("Please scan proper content", context);

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => ProductDetailsActivity(
        //       id: response['payload']['id'],
        //     ),
        //   ),
        // );
      }

      return response;
    } catch (e) {
      throw e;
    }
  }

}

