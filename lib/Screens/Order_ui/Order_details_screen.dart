import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:barcode_finder/barcode_finder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Core/repository/qrcode_repository.dart';
import 'package:velocit_merchant/Core/repository/repository.dart';
import 'package:velocit_merchant/Screens/Order_ui/Return_order_screen.dart';
import 'package:velocit_merchant/Services/HomeModel.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/proceedButtons.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Core/AppConstant/apiMapping.dart';
import '../../Core/ViewModel/qrCode_view_model.dart';
import '../../Routes/Routes.dart';
import '../../Services/Provider/Home_Provider.dart';
import '../../utils/GlobalWidgets/appBar.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import '../../utils/StringUtils.dart';
import '../../utils/features/scannerWithGallery.dart';
import '../orders_Dashboard.dart';
import 'Cancel_order_screen.dart';
import 'Order_delivery_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  final Map order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  bool singleSelectOptions = false;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );
  final controller = BarcodeFinderController();

  String selectedTypeOfOrders = 'Change Status';
  var dropDownForAcceptedProducts = [
    'Packed',
    'Ready For\n Self PickUp',
    'Shipped',
    'Delivered',
    'Reject'
  ];
  var data;
  bool orderStatus = false;
  var orderStatusName = '';
  bool showSpinner = false ;
  HomeProvider homeProvider = HomeProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bottomButtonVisibility();
    getColorCodeStatus(widget.order);
  }

  DateFormat formate = DateFormat('dd MMM yyyy hh:mm aaa');
  DateTime date = DateTime.parse(DateTime.now().toString());

  // var earliest_delivery_date = formate.format(date);

  var address =
      'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021';
  var statusData = '';

  Color colorsStatus = ThemeApp.appColor;

  // var orderStatus = false;

  getColorCodeStatus(Map order) {
    if (order["status_code"] == 1000) {
      //
      colorsStatus = ThemeApp.whiteColor;
      statusData = 'Completed';
    } else if (order["status_code"] == 900) {
      //canceled
      colorsStatus = ThemeApp.redColor;
      statusData = 'Contains Cancelled Product(s)';
    } else if (order["status_code"] == 500) {
      //Acceptance pending
      colorsStatus = ThemeApp.megentaColor;
      statusData = 'Acceptance Pending';
    } else if (order["status_code"] == 600) {
      //Packing pending
      colorsStatus = Colors.yellow;
      statusData = 'Packing Pending';
    } else if (order["status_code"] == 700) {
      //shipping pending
      colorsStatus = ThemeApp.appColor;
      statusData = 'Shipping Pending';
    } else if (order["status_code"] == 800) {
      //delivery pending
      colorsStatus = ThemeApp.greenappcolor;
      statusData = 'Delivery Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        setState(() {});
        Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute)
            .then((value) => setState(() {}));

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: /* PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: appBar_backWidget(
              context,
              appTitle(context, "Basket ID - ${widget.order["id"]}"),
              const SizedBox()),
        ),*/

            AppBar(
          shadowColor: ThemeApp.appBackgroundColor,

          centerTitle: false,
          // elevation: 0,
          backgroundColor: ThemeApp.appBackgroundColor,
          flexibleSpace: Container(
            height: height * .08,
            width: width,
            decoration: const BoxDecoration(
              color: ThemeApp.appBackgroundColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
          ),
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute)
                  .then((value) => setState(() {}));
            },
            child: Transform.scale(
              scale: 0.7,
              child: Image.asset(
                'assets/appImages/backArrow.png',
                color: ThemeApp.primaryNavyBlackColor,
                // height: height*.001,
              ),
            ),
          ),

          // leadingWidth: width * .06,
          title: Text(
            "Basket ID - ${!StringConstant.isLogIn ? '1212' : widget.order["id"]}",
            style: const TextStyle(
                color: ThemeApp.blackColor,
                fontSize: 16,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400),
          ),
          // Row
        ),
        // bottomNavigationBar: singleSelectOptions
        //     ? Container(
        //         height: 0,
        //       )
        //     : SafeArea(
        //         child: Container(
        //         height: 45,
        //         child: Row(
        //           children: [
        //             Expanded(
        //               child: InkWell(
        //                 onTap: () {
        //                   setState(() {});
        //                 },
        //                 child: Container(
        //                     padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
        //                     decoration: BoxDecoration(
        //                       borderRadius: const BorderRadius.all(
        //                         Radius.circular(100),
        //                       ),
        //                       border: Border.all(color: ThemeApp.tealButtonColor),
        //                       color: ThemeApp.tealButtonColor,
        //                     ),
        //                     child: Center(
        //                       child: TextFieldUtils().usingPassTextFields(
        //                           'Accept', ThemeApp.whiteColor, context),
        //                     )),
        //               ),
        //             ),
        //             Expanded(
        //               child: Container(
        //                   padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
        //                   decoration: BoxDecoration(
        //                     borderRadius: const BorderRadius.all(
        //                       Radius.circular(100),
        //                     ),
        //                     border: Border.all(color: ThemeApp.tealButtonColor),
        //                     color: ThemeApp.buttonShade2,
        //                   ),
        //                   child: Center(
        //                     child: TextFieldUtils().usingPassTextFields(
        //                         'Reject', ThemeApp.tealButtonColor, context),
        //                   )),
        //             )
        //           ],
        //         ),
        //       )),
        body: SafeArea(
            child: ModalProgressHUD(
              inAsyncCall:showSpinner,
              child:ChangeNotifierProvider<HomeProvider>.value(
                value: homeProvider,
                child: Container(
                    color: ThemeApp.appBackgroundColor,
                    width: width,
                    child: !StringConstant.isLogIn
                        ? unAuthorizedUser()
                        : authorizedUser()),
              ),
            )),
      ),
    );
  }

  Widget unAuthorizedUser() {
    return ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                /* stepperWidget(),  SizedBox(
                      height: height * .02,
                    ),*/
                Row(
                  children: [
                    Text(
                      'Current Status : ',
                      style: TextStyle(
                          color: ThemeApp.primaryNavyBlackColor,
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400),
                    ),
                    Text(statusData,
                        style: TextStyle(
                            color: colorsStatus,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  // height: height * 0.5,
                  width: width,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: ThemeApp.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFieldUtils().dynamicText(
                              StringUtils.deliveryDetails,
                              context,
                              TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: width * .02,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              // border: Border.all(
                              //     color: ThemeApp.packedButtonColor),
                              color: ThemeApp.whiteColor,
                            ),
                            child: TextFieldUtils().dynamicText(
                                StringConstant.selectedTypeOfAddress,
                                context,
                                TextStyle(
                                    color: ThemeApp.lightFontColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldUtils().dynamicText(
                          "John Dawid",
                          context,
                          TextStyle(
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          // provider.orderCheckOutDetails[0]
                          //     ["orderCheckOutDeliveryAddress"],
                          "305, Wing C, Vyankatesh Grafitee, Near Siddhivinayak temple, Manjari Mundhwa road, Keshv Nagar, pune -412307",
                          softWrap: true,
                          style: TextStyle(
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/appImages/callIcon.svg',
                            color: ThemeApp.appColor,
                            semanticsLabel: 'Acme Logo',
                            theme: SvgTheme(
                              currentColor: ThemeApp.appColor,
                            ),
                            // height: height * .025,
                          ),
                          TextFieldUtils().dynamicText(
                              " +91 9856785555",
                              context,
                              TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Container(
                    // height: height * 0.6,
                    width: width,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: const BoxDecoration(
                      color: ThemeApp.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldUtils().dynamicText(
                            StringUtils.orderSummary,
                            context,
                            TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(
                          height: height * .02,
                        ),
                        orderSummary(),
                      ],
                    )),
                SizedBox(
                  height: height * .02,
                ),
                priceDetails(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ]);
  }

  Widget authorizedUser() {
    return ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                /* stepperWidget(),  SizedBox(
                      height: height * .02,
                    ),*/
                Row(
                  children: [
                    Text(
                      'Current Status : ',
                      style: TextStyle(
                          color: ThemeApp.primaryNavyBlackColor,
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400),
                    ),
                    Text(statusData,
                        style: TextStyle(
                            color: colorsStatus,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Container(
                      // height: height * 0.5,
                      width: width,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: ThemeApp.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFieldUtils().dynamicText(
                                  StringUtils.deliveryDetails,
                                  context,
                                  TextStyle(
                                      color: ThemeApp.primaryNavyBlackColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: width * .02,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 8, 18, 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  // border: Border.all(
                                  //     color: ThemeApp.packedButtonColor),
                                  color: ThemeApp.whiteColor,
                                ),
                                child: TextFieldUtils().dynamicText(
                                    StringConstant.selectedTypeOfAddress,
                                    context,
                                    TextStyle(
                                        color: ThemeApp.lightFontColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldUtils().dynamicText(
                              widget.order["customer_name"] ?? "",
                              context,
                              TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              // provider.orderCheckOutDetails[0]
                              //     ["orderCheckOutDeliveryAddress"],
                              // '${widget.order["delivery_address_line1"]},${widget.order["delivery_address_line2"]},${widget.order["delivery_address_city"]},${widget.order["delivery_address_pincode"]},${widget.order["delivery_address_state"]}',

                              // widget.order["delivery_address_line1"]??""+widget.order["delivery_address_line2"]??""+widget.order["delivery_address_city"]??""+widget.order["delivery_address_pincode"]??""+widget.order["delivery_address_state"]??"",
                              '${widget.order["delivery_address_line1"]??""},${widget.order["delivery_address_line2"]??""},${widget.order["delivery_address_city"]??""},${widget.order["delivery_address_pincode"]??""},${widget.order["delivery_address_state"]??""}',
                              softWrap: true,
                              style: TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/appImages/callIcon.svg',
                                color: ThemeApp.appColor,
                                semanticsLabel: 'Acme Logo',
                                theme: SvgTheme(
                                  currentColor: ThemeApp.appColor,
                                ),
                                // height: height * .025,
                              ),
                              TextFieldUtils().dynamicText(
                                  " +91 ${widget.order['customer_contact']}",
                                  context,
                                  TextStyle(
                                      color: ThemeApp.primaryNavyBlackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
         // Container(
         //              alignment: Alignment.centerRight,
         //              child: SvgPicture.asset(
         //                // 'assets/appImages/canceledIcon.svg',
         //                'assets/appImages/Cancelled.svg',
         //                color: ThemeApp.redColor,
         //                theme: SvgTheme(
         //                    // currentColor: ThemeApp.appColor,
         //                    ),
         //                // height: height * .025,
         //              ),
         //            ),
                  ],
                ),
                SizedBox(
                  height: height * .02,
                ),
                Container(
                    // height: height * 0.6,
                    width: width,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: const BoxDecoration(
                      color: ThemeApp.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldUtils().dynamicText(
                            StringUtils.orderSummary,
                            context,
                            TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(
                          height: height * .02,
                        ),
                        orderSummary(),
                      ],
                    )),
                SizedBox(
                  height: height * .02,
                ),
                priceDetails(),
                SizedBox(
                  height: 20,
                ),
                // ,
                // proceedButton(
                //     "Complete Order", ThemeApp.tealButtonColor, context,
                //     () {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => OrderDeliveryScreen(),
                //     ),
                //   );
                // }),
                // allOrderCheckButtons(),
                allBottomButtons(),
                // allOrderStatusButton(),
                /*   singleSelectOptions == false
                    ? Container()
                    : isOrderCanceled == false
                        ? SafeArea(
                            child: Container(
                            height: 45,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        for (int i = 0;
                                            i < widget.order['orders'].length;
                                            i++) {
                                          if (widget.order['orders'][i]
                                                  ["is_accepted"] ==
                                              false) {
                                            data = Provider.of<HomeProvider>(
                                                    context,
                                                    listen: false)
                                                .loadJsonForChangeStatus(
                                                    510,
                                                    widget.order['orders'][i]
                                                        ['merchant_id'],
                                                    widget.order['orders'][i]
                                                        ['order_id'],
                                                    context);
                                          }

                                          if (widget.order['orders'][i]
                                                      ["is_accepted"] ==
                                                  true &&
                                              widget.order['orders'][i]
                                                      ["is_packed"] ==
                                                  false) {
                                            data = Provider.of<HomeProvider>(
                                                    context,
                                                    listen: false)
                                                .loadJsonForChangeStatus(
                                                    610,
                                                    widget.order['orders'][i]
                                                        ['merchant_id'],
                                                    widget.order['orders'][i]
                                                        ['order_id'],
                                                    context);
                                          }

                                          if (widget.order['orders'][i]
                                                      ["is_accepted"] ==
                                                  true &&
                                              widget.order['orders'][i]
                                                      ["is_packed"] ==
                                                  true &&
                                              widget.order['orders'][i]
                                                      ["is_shipped"] ==
                                                  false) {
                                            data = Provider.of<HomeProvider>(
                                                    context,
                                                    listen: false)
                                                .loadJsonForChangeStatus(
                                                    710,
                                                    widget.order['orders'][i]
                                                        ['merchant_id'],
                                                    widget.order['orders'][i]
                                                        ['order_id'],
                                                    context);
                                          }

                                          if (widget.order['orders'][i]
                                                      ["is_accepted"] ==
                                                  true &&
                                              widget.order['orders'][i]
                                                      ["is_packed"] ==
                                                  true &&
                                              widget.order['orders'][i]
                                                      ["is_shipped"] ==
                                                  true &&
                                              widget.order['orders'][i]
                                                      ["is_delivered"] ==
                                                  false) {
                                            data = Provider.of<HomeProvider>(
                                                    context,
                                                    listen: false)
                                                .loadJsonForChangeStatus(
                                                    810,
                                                    widget.order['orders'][i]
                                                        ['merchant_id'],
                                                    widget.order['orders'][i]
                                                        ['order_id'],
                                                    context);
                                          }
                                        }
                                      });
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 9.0, 0, 9.0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                          border: Border.all(
                                              color: ThemeApp.tealButtonColor),
                                          color: ThemeApp.tealButtonColor,
                                        ),
                                        child: Center(
                                          child: TextFieldUtils()
                                              .usingPassTextFields(
                                                  orderStatusName,
                                                  ThemeApp.whiteColor,
                                                  context),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReturnOrderActivity(
                                                    values: widget.order,
                                                    isSingleOrderReject: false,
                                                  )));
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 9.0, 0, 9.0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                          border: Border.all(
                                              color: ThemeApp.tealButtonColor),
                                          color: ThemeApp.buttonShade2,
                                        ),
                                        child: Center(
                                          child: TextFieldUtils()
                                              .usingPassTextFields(
                                                  'Reject Orders',
                                                  ThemeApp.tealButtonColor,
                                                  context),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ))
                        : SizedBox(),*/
                SizedBox(
                  height: height * .01,
                ),
              ],
            ),
          ),
        ]);
  }

  bool isOrderCanceled = false;

  Widget orderSummary() {
    return StringConstant.isLogIn
        ? ListView.builder(
            shrinkWrap: true,
            // separatorBuilder: (BuildContext context, int index) =>
            // const Divider(thickness: 2, color: ThemeApp.primaryNavyBlackColor),
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.order['orders'].length,
            itemBuilder: (BuildContext context, int index) {
              Map orderDetails = widget.order['orders'][index];

              DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
              DateTime date = DateTime.parse(
                  (orderDetails['delivery_date'] ?? DateTime.now().toString()));
              var delivery_date = format.format(date);
              // for (int i = 0; i < widget.order['orders'].length; i++) {
              //   print(
              //       "widget.order['orders']['current_status_code']${widget.order['orders'][i]['current_status_code']}");
              //     if (widget.order['orders'][i]['current_status_code'] == 2000) {
              //       orderStatus = true;
              //       subOrderStatus = 'Refund Proceed ';
              //       colorsSubOrderStatus = ThemeApp.tealButtonColor;
              //       isOrderCanceled = true;
              //     } else if (widget.order['orders'][i]['current_status_code'] ==
              //         810) {
              //       subOrderStatus = 'Delivered';
              //       colorsSubOrderStatus = ThemeApp.deliveredOrderColor;
              //     } else if (widget.order['orders'][i]['current_status_code'] ==
              //         850) {
              //       subOrderStatus = 'Refund Proceed ';
              //       colorsSubOrderStatus = ThemeApp.tealButtonColor;
              //     }
              //   }

              if (orderDetails["is_accepted"] == false &&
                  orderDetails['current_status_code'] != 2000) {
                orderStatus = true;
                orderStatusName = 'Accept all Orders';
              } else if (orderDetails["is_accepted"] == true &&
                  orderDetails["is_packed"] == false) {
                orderStatus = true;
                orderStatusName = 'All Orders Packed';
              } else if (orderDetails["is_accepted"] == true &&
                  orderDetails["is_packed"] == true &&
                  orderDetails["is_shipped"] == false) {
                orderStatus = true;
                orderStatusName = 'All Orders Shipped';
              } else if (orderDetails["is_accepted"] == true &&
                  orderDetails["is_packed"] == true &&
                  orderDetails["is_shipped"] == true &&
                  orderDetails["is_delivered"] == false) {
                orderStatus = true;
                orderStatusName = 'All Orders Delivered';
              }

              if (orderStatus) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => setState(() {
                          singleSelectOptions = true;
                        }));
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // height: height * 0.15,
                    width: width,
                    decoration: BoxDecoration(
                      color: ThemeApp.whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.network(
                                    // width: double.infinity,
                                    // snapshot.data![index].serviceImage,
                                    // 'assets/images/androidImage.jpg',
                                    orderDetails['image_url'] ?? '',
                                    errorBuilder:
                                        ((context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/images/androidImage.jpg');
                                    }),
                                    fit: BoxFit.fill,
                                    // width: width*.18,
                                    height: 85,
                                    width: 85,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextFieldUtils().dynamicText(
                                                'Order ID : ${orderDetails['order_id']}',
                                                context,
                                                TextStyle(
                                                    color: ThemeApp
                                                        .primaryNavyBlackColor,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            cancelDeliveredStatus(orderDetails),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFieldUtils().dynamicText(
                                            // 'POCO M3 Pro 5G(Yellow, 32GB)',
                                            '${orderDetails['short_name']}',
                                            context,
                                            TextStyle(
                                                color: ThemeApp
                                                    .primaryNavyBlackColor,
                                                fontSize: 13,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w400)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFieldUtils().dynamicText(
                                            'Quantity : ${orderDetails['item_qty']}',
                                            context,
                                            TextStyle(
                                                color: ThemeApp
                                                    .primaryNavyBlackColor,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextFieldUtils().dynamicText(
                                "Delivery date : " + delivery_date,
                                context,
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.subIconColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          orderStatusButtons(orderDetails),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            thickness: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            })
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // height: height * 0.15,
                width: width,
                decoration: BoxDecoration(
                  color: ThemeApp.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image.asset(
                                'assets/images/androidImage.jpg',
                                // width: width*.18,
                                height: 85,
                                width: 85,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFieldUtils().dynamicText(
                                        'POCO M3 Pro 5G(Yellow, 32GB)',
                                        context,
                                        TextStyle(
                                            color:
                                                ThemeApp.primaryNavyBlackColor,
                                            fontSize: 13,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextFieldUtils().dynamicText(
                                            'Quantity : 1',
                                            context,
                                            TextStyle(
                                                color: ThemeApp
                                                    .primaryNavyBlackColor,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w700)),
                                        InkWell(
                                            onTap: (() {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60.0),
                                                  ),
                                                  builder: (context) {
                                                    return Stack(
                                                      alignment: Alignment
                                                          .center, // <---------

                                                      children: [
                                                        Container(
                                                          width: width,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 30.0),
                                                          child:
                                                              bottomSheetForOtp(
                                                                  {}),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    const Icon(
                                                                  Icons.close,
                                                                  size: 30,
                                                                  color: ThemeApp
                                                                      .whiteColor,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }),
                                            child: Container(
                                                // height: 45,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: ThemeApp
                                                            .dropDownBorderColor)),
                                                child: Row(
                                                  children: [
                                                    Text(selectedTypeOfOrders,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    Icon(
                                                      Icons.arrow_drop_down,
                                                      color:
                                                          ThemeApp.subIconColor,
                                                    )
                                                  ],
                                                )))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: TextFieldUtils().dynamicText(
                            "Delivery date : " +
                                formate.format(date).toString(),
                            context,
                            TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.subIconColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  var subOrderStatus = '';
  Color colorsSubOrderStatus = ThemeApp.appColor;

  Widget cancelDeliveredStatus(Map orderDetails) {
    if (orderDetails["current_status_code"] == 2000) {
      return TextFieldUtils().dynamicText(
          'Initiate Refund',
          context,
          TextStyle(
              color: ThemeApp.tealButtonColor,
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w700));
    } else if (orderDetails["current_status_code"] == 810) {
      colorsSubOrderStatus = ThemeApp.tealButtonColor;
      return TextFieldUtils().dynamicText(
          'Delivered',
          context,
          TextStyle(
              color: ThemeApp.deliveredOrderColor,
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w700));
    }
    return Container();
  }

  bool isAnyOrderRejected = false;

  Widget orderStatusButtons(Map orderDetails) {
    if (orderDetails["current_status_code"] == 2000) {
      return Text('');
    } else {
      if (orderDetails["is_accepted"] == false) {
        // executing if is_accepted is false
        // print("step 1");
        return Container(
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {    showSpinner =true;
                      singleSelectOptions = true;
                      orderDetails['is_order_placed'] = true;



                      // putApiForChangeStatus( 510,
                      //     orderDetails['merchant_id'],
                      //     orderDetails['order_id'],
                      //     context);
                    });
                    Provider.of<HomeProvider>(context, listen: false)
                             .loadJsonForChangeStatus(
                             510,
                             orderDetails['merchant_id'],
                             orderDetails['order_id'],
                             context);
                    Timer(
                        const Duration(seconds: 2),
                            () {
                              setState(() {
                                showSpinner =false;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  const OrderDashboard()
                                  ));
                            });

                    print("Repository().showSpinner"+showSpinner.toString());
               // Provider.of<HomeProvider>(context, listen: false)
               //          .loadJsonForChangeStatus(
               //          510,
               //          orderDetails['merchant_id'],
               //          orderDetails['order_id'],
               //          context);

                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(color: ThemeApp.tealButtonColor),
                        color: ThemeApp.tealButtonColor,
                      ),
                      child: Center(
                        child: TextFieldUtils().usingPassTextFields(
                            'Accept', ThemeApp.whiteColor, context),
                      )),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      singleSelectOptions = true;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ReturnOrderActivity(
                                basket: widget.order,
                                order: orderDetails,
                                isSingleOrderReject: true,
                              )));
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(color: ThemeApp.tealButtonColor),
                        color: ThemeApp.buttonShade2,
                      ),
                      child: Center(
                        child: TextFieldUtils().usingPassTextFields(
                            'Reject', ThemeApp.tealButtonColor, context),
                      )),
                ),
              )
            ],
          ),
        );
      } else if ((orderDetails["is_accepted"] == true) &&
          (orderDetails["is_packed"] == false)) {
        // executing if is_accepted is true and is_packed is false
        // print("step 2");
        return Container(
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showSpinner =true;
                      singleSelectOptions = true;
                      orderDetails['is_order_placed'] = true;

                    });    data = Provider.of<HomeProvider>(context, listen: false)
                        .loadJsonForChangeStatus(
                        610,
                        orderDetails['merchant_id'],
                        orderDetails['order_id'],
                        context);
                    Timer(
                        const Duration(seconds: 2),
                            () {
                          setState(() {
                            showSpinner =false;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  const OrderDashboard()
                              ));
                        });

                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(color: ThemeApp.tealButtonColor),
                        color: ThemeApp.tealButtonColor,
                      ),
                      child: Center(
                        child: TextFieldUtils().usingPassTextFields(
                            'Packed', ThemeApp.whiteColor, context),
                      )),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      singleSelectOptions = true;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ReturnOrderActivity(
                            basket: widget.order,
                            order: orderDetails,
                                isSingleOrderReject: true,
                              )));
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(color: ThemeApp.tealButtonColor),
                        color: ThemeApp.buttonShade2,
                      ),
                      child: Center(
                        child: TextFieldUtils().usingPassTextFields(
                            'Reject', ThemeApp.tealButtonColor, context),
                      )),
                ),
              )
            ],
          ),
        );
      } else if ((orderDetails["is_accepted"] == true) &&
          (orderDetails["is_packed"] == true) &&
          (orderDetails["is_shipped"] == false)) {
        // print("step 3");
        return Container(
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {showSpinner =true;
                      singleSelectOptions = true;

                    }); orderDetails['is_order_placed'] = true;
                    data = Provider.of<HomeProvider>(context, listen: false)
                        .loadJsonForChangeStatus(
                        710,
                        orderDetails['merchant_id'],
                        orderDetails['order_id'],
                        context);
                    Timer(
                        const Duration(seconds: 2),
                            () {
                          setState(() {
                            showSpinner =false;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  const OrderDashboard()
                              ));
                        });
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(color: ThemeApp.tealButtonColor),
                        color: ThemeApp.tealButtonColor,
                      ),
                      child: Center(
                        child: TextFieldUtils().usingPassTextFields(
                            'Shipped', ThemeApp.whiteColor, context),
                      )),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      singleSelectOptions = true;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ReturnOrderActivity(
                            basket: widget.order,
                            order: orderDetails,                                isSingleOrderReject: true,
                              )));
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(color: ThemeApp.tealButtonColor),
                        color: ThemeApp.buttonShade2,
                      ),
                      child: Center(
                        child: TextFieldUtils().usingPassTextFields(
                            'Reject', ThemeApp.tealButtonColor, context),
                      )),
                ),
              )
            ],
          ),
        );
      } else if ((orderDetails["is_accepted"] == true) &&
          (orderDetails["is_packed"] == true) &&
          (orderDetails["is_shipped"] == true) &&
          (orderDetails["is_delivered"] == false)) {
        // print("step 4");
        return Container(
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    // setState(() {
                    //   singleSelectOptions = true;
                    //   orderDetails['is_order_placed'] =
                    //       true;
                    //   data = Provider.of<HomeProvider>(
                    //           context,
                    //           listen: false)
                    //       .loadJsonForChangeStatus(
                    //           810,
                    //           widget.order['id'],
                    //           orderDetails['order_id'],
                    //           context);
                    // });
                    //QR code

                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        builder: (context) {
                          return Stack(
                            alignment: Alignment.center, // <---------

                            children: [
                              Container(
                                  width: width,
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: ScannerWidget(
                                      state: controller.state,
                                      merchant_id: orderDetails['merchant_id'],
                                      orderId: orderDetails['order_id'])),
                              Positioned(
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.close,
                                        size: 30,
                                        color: ThemeApp.whiteColor,
                                      )),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(color: ThemeApp.tealButtonColor),
                        color: ThemeApp.tealButtonColor,
                      ),
                      child: Center(
                        child: TextFieldUtils().usingPassTextFields(
                            'Order Code', ThemeApp.whiteColor, context),
                      )),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      singleSelectOptions = true;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ReturnOrderActivity(
                            basket: widget.order,
                            order: orderDetails,                                isSingleOrderReject: true,
                              )));
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(color: ThemeApp.tealButtonColor),
                        color: ThemeApp.buttonShade2,
                      ),
                      child: Center(
                        child: TextFieldUtils().usingPassTextFields(
                            'Reject', ThemeApp.tealButtonColor, context),
                      )),
                ),
              )
            ],
          ),
        );
      } else {
        print("else............");
        return Text('');
      }
    }

    return Container();
  }

  int cntIsAccept = 0;
  int cntIsPacked = 0;
  int cntIsShipped = 0;
  int cntIsCanceled = 0;

  bottomButtonVisibility() {
    for (int i = 0; i < widget.order['orders'].length; i++) {
      if (widget.order['orders'][i]['is_accepted']) {
        cntIsAccept = cntIsAccept + 1;
      }

      if (widget.order['orders'][i]['is_packed']) {
        cntIsPacked = cntIsPacked + 1;
      }
      if (widget.order['orders'][i]['is_shipped']) {
        cntIsShipped = cntIsShipped + 1;
      }
      if (widget.order['orders'][i]['current_status_code'] == 2000) {
        cntIsCanceled = cntIsCanceled + 1;
      }
    }
    // allBottomButtons();

    print('cntIsAccept ' + cntIsAccept.toString());
    print('cntIsPacked ' + cntIsPacked.toString());
    print('cntIsShipped ' + cntIsShipped.toString());
    print('cntIsCanceled ' + cntIsCanceled.toString());
  }

  Widget allBottomButtons() {
    if (cntIsCanceled == widget.order['orders'].length) {
      return Container();
    } else if ((cntIsAccept == widget.order['orders'].length) &&
        (cntIsPacked == widget.order['orders'].length) &&
        (cntIsShipped == 0)) {
      return SafeArea(
          child: Container(
        height: 45,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    for (int i = 0; i < widget.order['orders'].length; i++) {
                      if (widget.order['orders'][i]["is_accepted"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                510,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }

                      if (widget.order['orders'][i]["is_accepted"] == true &&
                          widget.order['orders'][i]["is_packed"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                610,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }

                      if (widget.order['orders'][i]["is_accepted"] == true &&
                          widget.order['orders'][i]["is_packed"] == true &&
                          widget.order['orders'][i]["is_shipped"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                710,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }

                      if (widget.order['orders'][i]["is_accepted"] == true &&
                          widget.order['orders'][i]["is_packed"] == true &&
                          widget.order['orders'][i]["is_shipped"] == true &&
                          widget.order['orders'][i]["is_delivered"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                810,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }
                    }
                  });
                },
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      border: Border.all(color: ThemeApp.tealButtonColor),
                      color: ThemeApp.tealButtonColor,
                    ),
                    child: Center(
                      child: TextFieldUtils().usingPassTextFields(
                          'All Orders Shipped', ThemeApp.whiteColor, context),
                    )),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ReturnOrderActivity(
                        basket: widget.order,
                        order: widget.order['orders'][0],                            isSingleOrderReject: false,
                          )));
                },
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      border: Border.all(color: ThemeApp.tealButtonColor),
                      color: ThemeApp.buttonShade2,
                    ),
                    child: Center(
                      child: TextFieldUtils().usingPassTextFields(
                          'Reject Orders', ThemeApp.tealButtonColor, context),
                    )),
              ),
            )
          ],
        ),
      ));
    } else if ((cntIsAccept == widget.order['orders'].length) &&
        (cntIsPacked == 0)) {
      return SafeArea(
          child: Container(
        height: 45,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    for (int i = 0; i < widget.order['orders'].length; i++) {
                      if (widget.order['orders'][i]["is_accepted"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                510,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }

                      if (widget.order['orders'][i]["is_accepted"] == true &&
                          widget.order['orders'][i]["is_packed"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                610,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }

                      if (widget.order['orders'][i]["is_accepted"] == true &&
                          widget.order['orders'][i]["is_packed"] == true &&
                          widget.order['orders'][i]["is_shipped"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                710,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }

                      if (widget.order['orders'][i]["is_accepted"] == true &&
                          widget.order['orders'][i]["is_packed"] == true &&
                          widget.order['orders'][i]["is_shipped"] == true &&
                          widget.order['orders'][i]["is_delivered"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                810,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }
                    }
                  });
                },
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      border: Border.all(color: ThemeApp.tealButtonColor),
                      color: ThemeApp.tealButtonColor,
                    ),
                    child: Center(
                      child: TextFieldUtils().usingPassTextFields(
                          'All Orders Packed', ThemeApp.whiteColor, context),
                    )),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ReturnOrderActivity(
                        basket: widget.order,
                        order: widget.order['orders'][0],
                        isSingleOrderReject: false,
                          )));
                },
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      border: Border.all(color: ThemeApp.tealButtonColor),
                      color: ThemeApp.buttonShade2,
                    ),
                    child: Center(
                      child: TextFieldUtils().usingPassTextFields(
                          'Reject Orders', ThemeApp.tealButtonColor, context),
                    )),
              ),
            )
          ],
        ),
      ));
    } else if ((cntIsAccept == widget.order['orders'].length) &&
        (cntIsPacked == 0)) {
      return Container();
    } else if (cntIsAccept == 0 && cntIsPacked == 0 && cntIsShipped == 0) {
      return SafeArea(
          child: Container(
        height: 45,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    for (int i = 0; i < widget.order['orders'].length; i++) {
                      if (widget.order['orders'][i]["is_accepted"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                510,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }

                      if (widget.order['orders'][i]["is_accepted"] == true &&
                          widget.order['orders'][i]["is_packed"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                610,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }

                      if (widget.order['orders'][i]["is_accepted"] == true &&
                          widget.order['orders'][i]["is_packed"] == true &&
                          widget.order['orders'][i]["is_shipped"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                710,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }

                      if (widget.order['orders'][i]["is_accepted"] == true &&
                          widget.order['orders'][i]["is_packed"] == true &&
                          widget.order['orders'][i]["is_shipped"] == true &&
                          widget.order['orders'][i]["is_delivered"] == false) {
                        data = Provider.of<HomeProvider>(context, listen: false)
                            .loadJsonForChangeStatus(
                                810,
                                widget.order['orders'][i]['merchant_id'],
                                widget.order['orders'][i]['order_id'],
                                context);
                      }
                    }
                  });
                },
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      border: Border.all(color: ThemeApp.tealButtonColor),
                      color: ThemeApp.tealButtonColor,
                    ),
                    child: Center(
                      child: TextFieldUtils().usingPassTextFields(
                          'Accept All Orders', ThemeApp.whiteColor, context),
                    )),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ReturnOrderActivity(
                        basket: widget.order,
                        order: widget.order['orders'][0],
                        isSingleOrderReject: false,
                          )));
                },
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      border: Border.all(color: ThemeApp.tealButtonColor),
                      color: ThemeApp.buttonShade2,
                    ),
                    child: Center(
                      child: TextFieldUtils().usingPassTextFields(
                          'Reject Orders', ThemeApp.tealButtonColor, context),
                    )),
              ),
            )
          ],
        ),
      ));
    }

    return Container();
  }

  Widget prices() {
    return StringConstant.isLogIn
        ? Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFieldUtils().dynamicText(
                    "${indianRupeesFormat.format(widget.order['total_mrp'])}",
                    context,
                    TextStyle(
                      color: ThemeApp.primaryNavyBlackColor,
                      fontSize: height * .023,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    )),
                SizedBox(
                  width: width * .02,
                ),
                TextFieldUtils().dynamicText(
                    indianRupeesFormat.format(int.parse("45215")),
                    context,
                    TextStyle(
                      fontSize: height * .023,
                      color: ThemeApp.primaryNavyBlackColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 1.5,
                    )),
                SizedBox(
                  width: width * .01,
                ),
                TextFieldUtils().dynamicText(
                    "25% OFF",
                    context,
                    TextStyle(
                      fontSize: height * .02,
                      color: ThemeApp.primaryNavyBlackColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          )
        : Container();
  }

  Widget priceDetails() {
    return StringConstant.isLogIn
        ? Container(
            // height: height * 0.25,
            width: width,
            decoration: const BoxDecoration(
              color: ThemeApp.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price Details',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.primaryNavyBlackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      // TextFieldUtils().homePageTitlesTextFields(
                      //     "Price (${payload.ordersForPurchase!.length.toString()} items)",
                      //     context),
                      Text(indianRupeesFormat.format(widget.order['total_mrp']),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      // TextFieldUtils().homePageTitlesTextFields(
                      //     indianRupeesFormat
                      //         .format(double.parse(payload.totalMrp.toString())),
                      //     context)
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      Text(
                          "- ${indianRupeesFormat.format(double.parse(widget.order['total_discount'].toString()))}",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      /*   TextFieldUtils()
                        .homePageTitlesTextFields("Discount", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        "- ${indianRupeesFormat.format(double.parse(payload.totalDiscountAmount.toString()))}",
                        context),*/
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery charges',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      Text(
                          indianRupeesFormat.format(double.parse(widget
                              .order['total_delivery_charges']
                              .toString())),
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: height * .019,
                              fontWeight: FontWeight.w400)),
                      /* TextFieldUtils()
                        .homePageTitlesTextFields("Delivery charges", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(double.parse(
                            payload.totalDeliveryCharges.toString())),
                        context),*/
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: width,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: ThemeApp.separatedLineColor,
                          width: 0.5,
                        ),
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Container(
                    // width: width,
                    // decoration: const BoxDecoration(
                    //   color: ThemeApp.whiteColor,
                    //   borderRadius: BorderRadius.only(
                    //       bottomRight: Radius.circular(10),
                    //       bottomLeft: Radius.circular(10)),
                    // ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        Text(
                            "${indianRupeesFormat.format(widget.order['total_payable'] ?? 0)} ",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.appColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        /* TextFieldUtils().titleTextFields("Total Amount", context),
                      TextFieldUtils().titleTextFields(
                          "${indianRupeesFormat.format(payload.totalPayable)} ",
                          context),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            // height: height * 0.25,
            width: width,
            decoration: const BoxDecoration(
              color: ThemeApp.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price Details',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.primaryNavyBlackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      // TextFieldUtils().homePageTitlesTextFields(
                      //     "Price (${payload.ordersForPurchase!.length.toString()} items)",
                      //     context),
                      Text('300',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      // TextFieldUtils().homePageTitlesTextFields(
                      //     indianRupeesFormat
                      //         .format(double.parse(payload.totalMrp.toString())),
                      //     context)
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      Text("- 20",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      /*   TextFieldUtils()
                        .homePageTitlesTextFields("Discount", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        "- ${indianRupeesFormat.format(double.parse(payload.totalDiscountAmount.toString()))}",
                        context),*/
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery charges',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      Text('20',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.lightFontColor,
                              fontSize: height * .019,
                              fontWeight: FontWeight.w400)),
                      /* TextFieldUtils()
                        .homePageTitlesTextFields("Delivery charges", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(double.parse(
                            payload.totalDeliveryCharges.toString())),
                        context),*/
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: width,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: ThemeApp.separatedLineColor,
                          width: 0.5,
                        ),
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Container(
                    // width: width,
                    // decoration: const BoxDecoration(
                    //   color: ThemeApp.whiteColor,
                    //   borderRadius: BorderRadius.only(
                    //       bottomRight: Radius.circular(10),
                    //       bottomLeft: Radius.circular(10)),
                    // ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        Text("300",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.appColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        /* TextFieldUtils().titleTextFields("Total Amount", context),
                      TextFieldUtils().titleTextFields(
                          "${indianRupeesFormat.format(payload.totalPayable)} ",
                          context),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget bottomSheetForOtp(Map orderDetails) {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
          decoration: const BoxDecoration(
              color: ThemeApp.whiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: ThemeApp.lightBorderColor)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      StringConstant.isLogIn
                          ? setState(() {
                              selectedTypeOfOrders = "Accepted";
                              // value.statusCode = 510;
                              data = Provider.of<HomeProvider>(context,
                                      listen: false)
                                  .loadJsonForChangeStatus(
                                      510,
                                      orderDetails['merchant_id'],
                                      orderDetails['order_id'],
                                      context);
                              Navigator.pop(context);
                            })
                          : setState(() {
                              selectedTypeOfOrders = "Accepted";
                              Navigator.pop(context);
                            });
                    },
                    child: TextFieldUtils().dynamicText(
                        'Accepted',
                        context,
                        const TextStyle(
                            color: ThemeApp.activeOrderColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: height * .04,
                  ),
                  InkWell(
                    onTap: () {
                      StringConstant.isLogIn
                          ? setState(() {
                              selectedTypeOfOrders = "Acceptance Rejected";
                              // value.statusCode = 510;
                              data = Provider.of<HomeProvider>(context,
                                      listen: false)
                                  .loadJsonForChangeStatus(
                                      550,
                                      orderDetails['merchant_id'],
                                      orderDetails['order_id'],
                                      context);
                              Navigator.pop(context);
                            })
                          : setState(() {
                              selectedTypeOfOrders = "Acceptance Rejected";
                              Navigator.pop(context);
                            });
                    },
                    child: TextFieldUtils().dynamicText(
                        'Acceptance Rejected',
                        context,
                        const TextStyle(
                            color: ThemeApp.redColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: height * .04,
                  ),
                  InkWell(
                    onTap: () {
                      StringConstant.isLogIn
                          ? setState(() {
                              selectedTypeOfOrders = "Packed";

                              data = Provider.of<HomeProvider>(context,
                                      listen: false)
                                  .loadJsonForChangeStatus(
                                      610,
                                      orderDetails['merchant_id'],
                                      orderDetails['order_id'],
                                      context);
                              Navigator.pop(context);
                            })
                          : setState(() {
                              selectedTypeOfOrders = "Packed";
                              Navigator.pop(context);
                            });
                    },
                    child: TextFieldUtils().dynamicText(
                        'Packed',
                        context,
                        const TextStyle(
                            color: ThemeApp.packedButtonColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: height * .04,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                  "Enter Delivery OTP Shared With Customer"),
                              content: Container(
                                height: 40,
                                // color: Colors.blue,
                                margin: EdgeInsets.only(top: 10),
                                child: Material(
                                  color: Colors.transparent,
                                  child: OTPTextField(
                                    controller: OtpFieldController(),
                                    length: 5,
                                    width: 50,
                                    fieldWidth: 40,
                                    style: TextStyle(fontSize: 17),
                                    textFieldAlignment:
                                        MainAxisAlignment.spaceAround,
                                    otpFieldStyle: OtpFieldStyle(
                                        backgroundColor: Colors.white),
                                    fieldStyle: FieldStyle.box,
                                    onCompleted: (pin) {
                                      print("Completed: " + pin);
                                    },
                                  ),
                                ),
                              ),
                              actions: [
                                Container(
                                  // margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: ThemeApp.appColor,
                                      borderRadius: BorderRadius.circular(0)),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Verify OTP",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }));

                      StringConstant.isLogIn
                          ? setState(() {
                              data = Provider.of<HomeProvider>(context,
                                      listen: false)
                                  .loadJsonForChangeStatus(
                                      710,
                                      orderDetails['merchant_id'],
                                      orderDetails['order_id'],
                                      context);
                              selectedTypeOfOrders = "Shipped";
                            })
                          : setState(() {
                              selectedTypeOfOrders = "Shipped";
                              Navigator.pop(context);
                            });
                    },
                    child: TextFieldUtils().dynamicText(
                        'Shipped',
                        context,
                        const TextStyle(
                            color: ThemeApp.shippedOrderColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: height * .04,
                  ),
                  InkWell(
                    onTap: () {
                      StringConstant.isLogIn
                          ? setState(() {
                              data = Provider.of<HomeProvider>(context,
                                      listen: false)
                                  .loadJsonForChangeStatus(
                                      810,
                                      orderDetails['merchant_id'],
                                      orderDetails['order_id'],
                                      context);
                              selectedTypeOfOrders = "Delivered";
                              Navigator.pop(context);
                            })
                          : setState(() {
                              selectedTypeOfOrders = "Delivered";
                              Navigator.pop(context);
                            });
                    },
                    child: TextFieldUtils().dynamicText(
                        'Delivered',
                        context,
                        const TextStyle(
                            color: ThemeApp.deliveredOrderColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: height * .04,
                  ),
                  InkWell(
                    onTap: () {
                      StringConstant.isLogIn
                          ? setState(() {
                              data = Provider.of<HomeProvider>(context,
                                      listen: false)
                                  .loadJsonForChangeStatus(
                                      850,
                                      orderDetails['merchant_id'],
                                      orderDetails['order_id'],
                                      context);
                              selectedTypeOfOrders = "Reject";
                              Navigator.pop(context);
                            })
                          : setState(() {
                              selectedTypeOfOrders = "Reject";
                              Navigator.pop(context);
                            });
                    },
                    child: TextFieldUtils().dynamicText(
                        'Reject',
                        context,
                        const TextStyle(
                            color: ThemeApp.deliveredOrderColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // Future putApiForChangeStatus(int statusCode,var merchantId, var orderId,BuildContext context) async {
  //   setState(() {
  //     showSpinner = true ;
  //   });
  //
  //   print("orderId ID" + orderId.toString());
  //   print("merchantId ID" + merchantId.toString());
  //
  //   var url = '/order/$orderId/changeStatus';
  //
  //   Map<String, String> statusData = {
  //     'newStatusCode': statusCode.toString(),
  //     'merchantBasketId': merchantId.toString(),
  //
  //   };
  //   print("statusData Query$statusData");
  //   String queryString = Uri(queryParameters: statusData).query;
  //
  //   var requestUrl = '${ApiMapping.BaseAPI}$url?$queryString';
  //   print("statusData URL $requestUrl");
  //
  //   try {
  //     dynamic reply;
  //     http.Response response = await http.put(Uri.parse(requestUrl),
  //         headers: {'content-type': 'application/json'});
  //     print("response statusData" + response.body.toString());
  //     var jsonData = json.decode(response.body);
  //     if(response.statusCode == 200) {
  //       Provider.of<HomeProvider>(context, listen: false).loadJsonForGetMerchantBasket();
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => OrderDetailScreen(order: widget.order,))).then((value)  {
  //
  //
  //       });
  //     }else{
  //       setState(() {
  //         showSpinner = false ;
  //       });
  //
  //     }
  //     print("response  statusData" + jsonData['status'].toString());
  //
  //     // Utils.successToast(response.body.toString());}
  //     return reply;
  //
  //     return response;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

}

class ScannerWidget extends StatefulWidget {
  BarcodeFinderState state;
  var merchant_id;
  var orderId;

  ScannerWidget(
      {Key? key,
      required this.state,
      required this.merchant_id,
      required this.orderId})
      : super(key: key);

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  var getResult = 'QR Code Result';
  final controller = BarcodeFindersController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _scanBarcode = 'Please scan proper content';

  // QRCodeViewModel qrViewMode =QRCodeViewModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .25,
      padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
      decoration: const BoxDecoration(
          color: ThemeApp.whiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Center(
        child: Wrap(
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                final state = controller.state;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    proceedButton("Scan with Camera", ThemeApp.darkGreyColor,
                        context, false, () {
                      // Navigator.of(context).pop();

                      scanQR(context);
                    }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    _startScanFileButton(state),
                    // const Text(
                    //   'Code:',
                    //   textAlign: TextAlign.center,
                    // ),
                    /*    if (state is BarcodeFinderLoading)
                          _loading()
                        else if (state is BarcodeFinderError)


                          _text(
                            '${state.message}',
                          )
                        else if (state is BarcodeFinderSuccess)
                          _text(
                            '${state.code}',
                          ),*/
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loading() => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: CircularProgressIndicator(
          color: ThemeApp.darkGreyColor,
        )),
      );

  Future<void> scanQR(BuildContext context) async {
    String barcodeScanRes = '';
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      _scanBarcode = barcodeScanRes;
      print('_scanBarcode : ' + barcodeScanRes);
      print('_scanBarcode : ' + _scanBarcode);
      // getSingleProduct.getSingleProductScannerWithGet(_scanBarcode.toString());
      final prefs = await SharedPreferences.getInstance();

      if (_scanBarcode == '-1') {
        Navigator.pop(context);
        Utils.flushBarErrorMessage("Please scan proper content", context);
      } else {
        QRRepository().getProductDeliveryScannerList(
            widget.merchant_id.toString(),
            widget.orderId.toString(),
            barcodeScanRes.toString(),
            context);
        // Utils.successToast(_scanBarcode);
      }
      print('_scanBarcode timer... : ' + _scanBarcode);
      print('_scanBarcode pref befor... : ' + StringConstant.ScannedProductId);

      // qrViewMode.getDeliveryByScannerWithGet(widget.orderId.toString(),
      //     barcodeScanRes.toString(), context);

      // QRRepository().getProductDeliveryScannerList(widget.orderId.toString(),
      //     barcodeScanRes.toString(), context);
      // QRRepository().getProductDeliveryScannerList('2062',
      //     barcodeScanRes.toString(), context);


      StringConstant.ScannedProductId =
          (prefs.getString('ScannedProductIDPref')) ?? '';

      print('_scanBarcode pref after... : ' +
          StringConstant.ScannedProductId.toString());

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => ProductDetailsActivity(
      //       id:int.parse(StringConstant.ScannedProductId,
      //     ),
      //   ),
      //   ));
      // if (!mounted) return;

      print('_scanBarcode : ' + _scanBarcode);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant
  }

  Widget _startScanFileButton(BarcodeFinderState state) {
    return proceedButton(
        "Open Gallery", ThemeApp.tealButtonColor, context, false, () async {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
      if (pickedFile != null) {
        String? filePath = pickedFile.files.single.path;
        if (filePath != null) {
          final file = File(filePath);
          controller.scanFile(file, widget.merchant_id.toString(),
              widget.orderId.toString(), context);
        }
      } else {
        Utils.errorToast('Please select content');
      }
    });

/*
      Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: ThemeApp.darkGreyColor,
      ),
      child: InkWell(
          onTap: state is! BarcodeFinderLoading
              ? () async {
                  FilePickerResult? pickedFile =
                      await FilePicker.platform.pickFiles();
                  if (pickedFile != null) {
                    String? filePath = pickedFile.files.single.path;
                    if (filePath != null) {
                      final file = File(filePath);
                      controller.scanFile(file);
                    }
                  } else {
                    Utils.errorToast('Please select content');
                  }
                }
              : null,
          child: TextFieldUtils().usingPassTextFields(
              "Open Gallery", ThemeApp.whiteColor, context)),
    );*/
  }
}

class BarcodeFindersController extends ChangeNotifier {
  BarcodeFinderState state = BarcodeFinderInitial();
  var barcode = '';

  void scanFile(File file, String merchant_id, String orderId,
      BuildContext context) async {
    emit(BarcodeFinderLoading());
    try {
      barcode = (await BarcodeFinder.scanFile(
        path: file.path,
      ))!;
      _update(barcode);
      QRRepository().getProductDeliveryScannerList(
          merchant_id, orderId.toString(), barcode.toString(), context);

      print("scanned value is : barcode" + barcode.toString());
    } catch (_) {
      emit(
        BarcodeFinderError('Not found'),
      );
      Utils.errorToast('Please scan proper content');
    }
  }

  void emit(BarcodeFinderState newState) {
    state = newState;
    notifyListeners();
  }

  void _update(String? barcode) {
    if (barcode != null) {
      emit(
        BarcodeFinderSuccess(barcode),
      );
    } else {
      emit(
        BarcodeFinderError('Not Found'),
      );
    }
  }


}
