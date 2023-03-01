//
//
// import 'package:flutter/material.dart';
//
// import '../data/responses/api_response.dart';
// import '../repository/qrcode_repository.dart';
//
// class QRCodeViewModel with ChangeNotifier {
//   final _myRepo = QRRepository();
//
//   ApiResponse<FindByFMCGCodeScannerModel> deliveryScan = ApiResponse.loading();
//
//   setDeliveryScannerList(ApiResponse<FindByFMCGCodeScannerModel> response) {
//     deliveryScan = response;
//     notifyListeners();
//   }
// Future<void> getDeliveryByScannerWithGet(String orderId, String qrId,BuildContext context) async {
//   setDeliveryScannerList(ApiResponse.loading());
//
//   _myRepo.getProductDeliveryScannerList(orderId,qrId,context).then((value) async {
//     // productSubCategory.data!.payload!.content! .addAll(value.payload!.content!);
//
//
//     setDeliveryScannerList(ApiResponse.completed(value));
//   }).onError((error, stackTrace) {
//     setDeliveryScannerList(ApiResponse.error(error.toString()));
//   });
// }}