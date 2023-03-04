import 'dart:async';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Services/HomeModel.dart';

import '../Core/repository/repository.dart';
import '../Services/Provider/Home_Provider.dart';
import '../utils/GlobalWidgets/appBar.dart';
import '../utils/GlobalWidgets/textFormFields.dart';
import '../utils/constants.dart';
import '../utils/styles.dart';
import 'Order_ui/Order_details_screen.dart';

class OrderDashboard extends StatefulWidget {
  const OrderDashboard({Key? key}) : super(key: key);

  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  int subIndexOrderList = 0;
  int indexForItems = 0;
  bool viewMore = false;
  var data;
  bool isNewNotifications = false;
  bool isActiveOrders = true;
  bool isLogIn = StringConstant.isLogIn;
  String activeDropdownValue = 'All Orders';
  DateFormat formate = DateFormat('dd MMM yyyy hh:mm aaa');
  DateTime date = DateTime.parse(DateTime.now().toString());
  var activeItems = [
    'All Orders',
    'Acceptance Pending',
    'Packed Orders',
    'Shipped Orders',
  ];
  String allDropdownValue = 'Past 7 Days';

  var allItems = [
    'Past 7 Days',
    'Past 1 Month',
    'Past 3 Months',
    'Past 6 Months',
  ];
  int indexOfOrders = 0;
  var statusData = '';
  HomeProvider homeProvider = HomeProvider();
  bool showSpinner = true;

  @override
  void initState() {
    // TODO: implement initState
    viewMore = false;
    isNewNotifications = false;
    isActiveOrders = false;
    data = Provider.of<HomeProvider>(context, listen: false)
        .loadJsonForGetMerchantBasket();

    Provider.of<HomeProvider>(context, listen: false).IsActiveOrderList = true;
    loader();
    super.initState();
    setPram();
  }

  loader() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        showSpinner = false;
      });
    });
  }

  setPram() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    StringConstant.isLogIn = (pref.getBool('isLogin')) ?? false;
  }

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: ThemeApp.appBackgroundColor,
          key: scaffoldGlobalKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * .19),
            child: Container(
              color: ThemeApp.appBackgroundColor,
              height: height * .19,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppBarWidget(
                      context: context,
                      titleWidget: searchBar(context),
                      location: SizedBox()),
                  SizedBox(
                    height: 10,
                  ),
                  Consumer<HomeProvider>(
                      builder: (context, value, child) {
                    return Container(
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        border: Border.all(color: ThemeApp.appColor),
                        color: ThemeApp.whiteColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                // data = Provider.of<HomeProvider>(context, listen: false).loadJson();
                               setState((){
                                 showSpinner = true;
                               });

                                value.IsActiveOrderList = true;
                                if (value.IsActiveOrderList == true) {
                                  data = await Provider.of<HomeProvider>(
                                          context,
                                          listen: false)
                                      .loadJsonForGetMerchantBasket();
                                }
                               setState(() {
                                  print("Is Active Orders  " +
                                      value.IsActiveOrderList.toString());
                                  showSpinner = false;
                                  isActiveOrders = true;
                                  isActiveOrders = !isActiveOrders;
                                  data;
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 9.0, 0, 9.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    color: isActiveOrders
                                        ? ThemeApp.whiteColor
                                        : ThemeApp.appColor,
                                  ),
                                  child: Center(
                                    child: TextFieldUtils()
                                        .usingPassTextFields(
                                            'Active Orders',
                                            isActiveOrders
                                                ? ThemeApp.blackColor
                                                : ThemeApp.whiteColor,
                                            context),
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {

                                value.IsActiveOrderList = false;
                                if (value.IsActiveOrderList == false) {
                                  data = await Provider.of<HomeProvider>(
                                          context,
                                          listen: false)
                                      .loadJsonForGetMerchantBasket();
                                }

                                setState(() {
                                  print("Is Past Orders" +
                                      value.IsActiveOrderList.toString());

                                  isActiveOrders = true;

                                  data;
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 9.0, 0, 9.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    color: isActiveOrders
                                        ? ThemeApp.appColor
                                        : ThemeApp.whiteColor,
                                  ),
                                  child: Center(
                                    child: TextFieldUtils()
                                        .usingPassTextFields(
                                            'Past Orders',
                                            isActiveOrders
                                                ? ThemeApp.whiteColor
                                                : ThemeApp.blackColor,
                                            context),
                                  )),
                            ),
                          ),

                          // Expanded(
                          //   flex: 1,
                          //   child: InkWell(
                          //       onTap: () {
                          //         setState(() {
                          //           isActiveOrders = false;
                          //         });
                          //       },
                          //       child: Container(
                          //           padding:
                          //               const EdgeInsets.fromLTRB(0, 9.0, 0, 9.0),
                          //           decoration: BoxDecoration(
                          //             borderRadius: const BorderRadius.all(
                          //               Radius.circular(100),
                          //             ),
                          //             color: !isActiveOrders
                          //                 ? ThemeApp.appColor
                          //                 : ThemeApp.whiteColor,
                          //           ),
                          //           child: Center(
                          //             child: TextFieldUtils().usingPassTextFields(
                          //                 "Past Orders",
                          //                 !isActiveOrders
                          //                     ? ThemeApp.whiteColor
                          //                     : ThemeApp.blackColor,
                          //                 context),
                          //           ))),
                          // ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          bottomNavigationBar: bottomNavigationBarWidget(context, 0),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            child: Container(
              color: ThemeApp.appBackgroundColor,
              width: width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: data == '' ? Text('') : mainUI()),
            ),
          ),
        ),
      ),
    );
  }

  Widget mainUI() {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return !StringConstant.isLogIn
          ? unAuthorizedUser()
          : (value.jsonDataBasket.isNotEmpty &&
                  value.jsonDataBasket['error'] == null)
              ? Stack(
                  children: [
                    /*  isActiveOrders == true
                    ? Column(
                        children: [
                          activeOrderDropdownShow(),
                          SizedBox(
                            height: height * .02,
                          ),
                          StringConstant.isLogIn
                              ? Container()
                              : Center(
                                  child: Text(
                                    "For OnBoarding\nPlease connect to Sales Team",
                                    style: TextStyle(
                                        fontSize: 16, color: ThemeApp.appColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          activeOrderList(value)
                        ],
                      )
                    : Column(
                        children: [
                          pastOrderDropdownShow(value),
                          SizedBox(
                            height: height * .02,
                          ),
                          pastOrderList(value)
                        ],
                      ),

*/
                    Column(
                      children: [
                        !isActiveOrders
                            ? activeOrderDropdownShow()
                            : pastOrderDropdownShow(value),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        isActiveOrders
                            ? pastOrderList(value)
                            : activeOrderList(value)
                      ],
                    ),
                    isNewNotifications == true
                        ? Positioned(
                            bottom: 0,
                            right: 2,
                            left: 2,
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: ThemeApp.appColor,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextFieldUtils().dynamicText(
                                            'New Order',
                                            context,
                                            TextStyle(
                                                color: ThemeApp.whiteColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700)),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isNewNotifications = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            size: 30,
                                            color: ThemeApp.whiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   height: height * .1,
                                    //   child: ListView.builder(
                                    //       itemCount: 3,
                                    //       itemBuilder: (_, index) {
                                    //         return Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.spaceBetween,
                                    //           children: [
                                    //             Flexible(
                                    //               child: Text('',
                                    //                   //"${value.myOrdersList[1]["myOrderDetailList"][0]["productDetails"]}",
                                    //                   style: TextStyle(
                                    //                       color:
                                    //                           ThemeApp.whiteColor,
                                    //                       fontSize: height * .022,
                                    //                       fontWeight:
                                    //                           FontWeight.w300,
                                    //                       overflow: TextOverflow
                                    //                           .ellipsis)),
                                    //             ),
                                    //             TextFieldUtils().dynamicText(
                                    //                 "* 3",
                                    //                 context,
                                    //                 TextStyle(
                                    //                     color: ThemeApp.blackColor,
                                    //                     fontSize: height * .022,
                                    //                     fontWeight: FontWeight.w400,
                                    //                     overflow:
                                    //                         TextOverflow.ellipsis)),
                                    //           ],
                                    //         );
                                    //       }),
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isNewNotifications = false;
                                        });
                                      },
                                      child: Container(
                                        // width: width * .3,
                                        // padding: const EdgeInsets.fromLTRB(
                                        //     20.0, 10, 20.0, 10),
                                        // decoration: const BoxDecoration(
                                        //   borderRadius: BorderRadius.all(
                                        //     Radius.circular(20),
                                        //   ),
                                        //   color: ThemeApp.whiteColor,
                                        // ),
                                        child: TextFieldUtils().dynamicText(
                                            "View",
                                            context,
                                            TextStyle(
                                                color: ThemeApp.whiteColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                )
              : value.jsonDataBasket['error'] != null
                  ? Container()
                  : Center(child: Text(''));
    });
  }

  Widget unAuthorizedUser() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "For OnBoarding\nPlease connect to Sales Team",
            style: TextStyle(fontSize: 16, color: ThemeApp.appColor),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 20),
            child: Container(
                padding: EdgeInsets.only(
                  right: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: ThemeApp.appColor,
                ),
                child: Container(
                  padding: const EdgeInsets.all(15),

                  // height: height * 0.12,
                  // width: width * .8,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: ThemeApp.whiteColor,
                  ),
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //image grid
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            color: ThemeApp.whiteColor,
                          ),
                          child: Row(
                            // mainAxisAlignment:
                            // MainAxisAlignment.start,
                            // crossAxisAlignment:
                            // CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 44,
                                  width: 45,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: FittedBox(
                                    child: Icon(Icons.image_outlined),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   width: width * .03,
                              // ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFieldUtils().dynamicText(
                                        "Order ID : 1212",
                                        context,
                                        TextStyle(
                                          fontFamily: 'Roboto',
                                          color: ThemeApp.primaryNavyBlackColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        )),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    Container(
                                      width: 300,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextFieldUtils().dynamicText(
                                              formate.format(date).toString(),
                                              context,
                                              TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color:
                                                      ThemeApp.lightFontColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400)),
                                          TextFieldUtils().dynamicText(
                                              statusData,
                                              // "Acceptance Pending",
                                              // '${order['overall_status']}',
                                              // earliest_delivery_date,
                                              context,
                                              TextStyle(
                                                  color:
                                                      ThemeApp.lightFontColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  width: 280,
                                  child: Text('POCO M3 Pro 5G(Yellow, 32GB)',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: ThemeApp.blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.25,
                                          overflow: TextOverflow.ellipsis)),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text("* 1",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.25,
                                      overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        )),

                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          // alignment: Alignment.centerLeft,
                          child: Row(
                            // crossAxisAlignment:
                            // CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFieldUtils().dynamicText(
                                  '250',
                                  context,
                                  TextStyle(
                                      color: ThemeApp.blackColor,
                                      fontSize: height * .025,
                                      fontWeight: FontWeight.w700)),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => OrderDetailScreen(
                                            order: {},
                                          )));
                                },
                                child: Text(
                                  "View",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: ThemeApp.tealButtonColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                )))
      ],
    );
  }

  Widget activeOrderList(HomeProvider value) {
    return Expanded(
      child: value.jsonDataBasket['status'] == "EXCEPTION"
          ? Text("")
          : ListView.builder(
              itemCount:
                  value.jsonDataBasket['payload']['merchant_baskets'].length,
              itemBuilder: (_, index) {
                List orderList =
                    value.jsonDataBasket['payload']['merchant_baskets'];
                Map order = orderList[index];
                DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
                DateTime date = DateTime.parse(
                    (order['earliest_delivery_date'] ??
                        DateTime.now().toString()));
                var earliest_delivery_date = format.format(date);

                getColorCodeStatus(order);

                return value
                                .jsonDataBasket['payload']['merchant_baskets']
                                    [index]['orders']
                                .length -
                            1 <
                        0
                    ? SizedBox()
                    : order["status_code"] == 1000?SizedBox():Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 20),
                        child: Container(
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: colorsStatus,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(15),

                              // height: height * 0.12,
                              // width: width * .8,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                color: ThemeApp.whiteColor,
                              ),
                              child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //image grid
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        color: ThemeApp.whiteColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // crossAxisAlignment:
                                        // CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 44,
                                              width: 45,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              child: FittedBox(
                                                child: Image.network(
                                                        // width: double.infinity,
                                                        order['orders'][0]
                                                                ["image_url"] ??
                                                            "",
                                                        fit: BoxFit.fill,
                                                        height: 22,
                                                        width: 21, errorBuilder:
                                                            ((context, error,
                                                                stackTrace) {
                                                      return Icon(
                                                          Icons.image_outlined);
                                                    })) ??
                                                    SizedBox(),
                                              ),
                                              /* GridView.builder(
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisSpacing: 0,
                                                  mainAxisSpacing: 0,
                                                  crossAxisCount: 2,
                                                  // childAspectRatio: 4/7
                                                ),
                                                itemCount: order['orders'].length,
                                                itemBuilder:
                                                    (context, indexOrderList) {
                                                  subIndexOrderList =
                                                      indexOrderList;
                                                  return order['orders']
                                                                  [indexOrderList]
                                                              ['cancelled'] ==
                                                          'true'
                                                      ? SizedBox()
                                                      : Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: ThemeApp
                                                                      .whiteColor)),
                                                          child: FittedBox(
                                                            child: Image.network(
                                                                    // width: double.infinity,
                                                                    order['orders']
                                                                                [
                                                                                indexOrderList]
                                                                            [
                                                                            "image_url"] ??
                                                                        "",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    height: 22,
                                                                    width: 21,
                                                                    errorBuilder:
                                                                        ((context,
                                                                            error,
                                                                            stackTrace) {
                                                                  return Icon(Icons
                                                                      .image_outlined);
                                                                })) ??
                                                                SizedBox(),
                                                          ),
                                                        );

                                                  // Item rendering
                                                },
                                              ),*/
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: width * .03,
                                          // ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextFieldUtils().dynamicText(
                                                    "Basket ID : " +
                                                        order['id'].toString(),
                                                    context,
                                                    TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: ThemeApp
                                                          .primaryNavyBlackColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    )),
                                                SizedBox(
                                                  height: height * .01,
                                                ),
                                                TextFieldUtils().dynamicText(
                                                    earliest_delivery_date,
                                                    context,
                                                    TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color: ThemeApp
                                                            .lightFontColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              alignment: Alignment.bottomRight,
                                              child: TextFieldUtils()
                                                  .dynamicText(
                                                      statusData,
                                                      // "Acceptance Pending",
                                                      // '${order['overall_status']}',
                                                      // earliest_delivery_date,
                                                      context,
                                                      TextStyle(
                                                          color: ThemeApp
                                                              .lightFontColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        height: order['orders'].length >= 2
                                            ? !viewMore
                                                ? 50
                                                : 80
                                            : 30,
                                        // width: width * .63,
                                        child: ListView.builder(
                                          physics: order['orders'].length > 2
                                              ? ScrollPhysics()
                                              : NeverScrollableScrollPhysics(),
                                          itemCount: order['orders'].length > 2
                                              ? !viewMore
                                                  ? 2
                                                  : order['orders'].length
                                              : order['orders'].length,
                                          itemBuilder:
                                              (context, indexOrderDetails) {
                                            indexOfOrders == 0
                                                ? indexOfOrders - 1
                                                : indexOfOrders =
                                                    indexOrderDetails;
                                            // print("Order Id : " +
                                            //     order['orders'][indexOfOrders]
                                            //             ['order_id']
                                            //         .toString());
                                            return (order['orders'].length > 3)
                                                ? !viewMore
                                                    ? order['orders'][
                                                                    indexOrderDetails]
                                                                ['cancelled'] ==
                                                            'true'
                                                        ? SizedBox()
                                                        : Container(
                                                            //more than 3 item
                                                            child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    width: 280,
                                                                    child: Text(
                                                                        order['orders'][indexOrderDetails]["oneliner"] != 'null'
                                                                            ? order['orders'][indexOrderDetails]["oneliner"]
                                                                                .toString()
                                                                            : "",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            color: ThemeApp
                                                                                .blackColor,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            letterSpacing:
                                                                                -0.25,
                                                                            overflow:
                                                                                TextOverflow.ellipsis)),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 30,
                                                                ),
                                                                Text(
                                                                    "* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        letterSpacing:
                                                                            -0.25,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              ],
                                                            ),
                                                          ))
                                                    : order['orders'][
                                                                    indexOrderDetails]
                                                                ['cancelled'] ==
                                                            'true'
                                                        ? SizedBox()
                                                        : Container(
                                                            //not execute
                                                            child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                // Flexible(
                                                                //   child:
                                                                //       Container(
                                                                //     width: 280,
                                                                //     child: Text(
                                                                //         "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                //         style: TextStyle(
                                                                //             fontFamily:
                                                                //                 'Roboto',
                                                                //             color: ThemeApp
                                                                //                 .blackColor,
                                                                //             fontSize:
                                                                //             12,
                                                                //             fontWeight: FontWeight
                                                                //                 .bold,
                                                                //             letterSpacing:
                                                                //                 -0.25,
                                                                //             overflow:
                                                                //                 TextOverflow.ellipsis)),
                                                                //   ),
                                                                // ),
                                                                // SizedBox(
                                                                //   width: 30,
                                                                // ),
                                                                // Text(
                                                                //     "* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                //     style: TextStyle(
                                                                //         fontFamily:
                                                                //             'Roboto',
                                                                //         color: ThemeApp
                                                                //             .blackColor,
                                                                //         fontSize:
                                                                //             12,
                                                                //         fontWeight:
                                                                //             FontWeight
                                                                //                 .w700,
                                                                //         letterSpacing:
                                                                //             -0.25,
                                                                //         overflow:
                                                                //             TextOverflow.ellipsis)),
                                                              ],
                                                            ),
                                                          ))
                                                : order['orders'][
                                                                indexOrderDetails]
                                                            ['cancelled'] ==
                                                        'true'
                                                    ? SizedBox()
                                                    : Container(
                                                        child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                width: 280,
                                                                child: Text(
                                                                    "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        letterSpacing:
                                                                            -0.25,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text("* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: ThemeApp
                                                                        .blackColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    letterSpacing:
                                                                        -0.25,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis)),
                                                          ],
                                                        ),
                                                      ));
                                          },
                                        )),

                                    order['orders'].length < 2
                                        ? SizedBox()
                                        : Row(
                                            children: [
                                              order['orders'].length > 2
                                                  ? !viewMore
                                                      ? InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              viewMore =
                                                                  !viewMore;
                                                            });
                                                          },
                                                          child: TextFieldUtils().dynamicText(
                                                              '+ View More',
                                                              context,
                                                              TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: ThemeApp
                                                                      .tealButtonColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              viewMore =
                                                                  !viewMore;
                                                            });
                                                          },
                                                          child: TextFieldUtils().dynamicText(
                                                              '- View Less',
                                                              context,
                                                              TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: ThemeApp
                                                                      .tealButtonColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        )
                                                  : SizedBox(),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      // alignment: Alignment.centerLeft,
                                      child: Row(
                                        // crossAxisAlignment:
                                        // CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextFieldUtils().dynamicText(
                                              indianRupeesFormat.format(
                                                  order["total_payable"] ?? 0),
                                              context,
                                              TextStyle(
                                                  color: ThemeApp.blackColor,
                                                  fontSize: height * .025,
                                                  fontWeight: FontWeight.w700)),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetailScreen(
                                                            order: order,
                                                          )));
                                            },
                                            child: Text(
                                              "View",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: ThemeApp.tealButtonColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            )));
              }),
    );
  }

  Color colorsStatus = ThemeApp.appColor;

  getColorCodeStatus(Map order) {
    // print('${order['id']}      ${order['overall_status']}');
    if (order["status_code"] == 1000) {
      //
      colorsStatus = ThemeApp.whiteColor;
      statusData = 'Completed';

    } else if (order["status_code"] == 900) {
      //cancelled
      colorsStatus = ThemeApp.redColor;
      statusData = 'Cancelled';
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

  Widget pastOrderList(HomeProvider value) {
    return Expanded(
      child: value.jsonDataBasket['status'] == "EXCEPTION"
          ? Text("")
          : ListView.builder(
              itemCount:
                  value.jsonDataBasket['payload']['merchant_baskets'].length,
              itemBuilder: (_, index) {
                List orderList =
                    value.jsonDataBasket['payload']['merchant_baskets'];
                Map order = orderList[index];
                DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
                DateTime date = DateTime.parse(
                    (order['earliest_delivery_date'] ??
                        DateTime.now().toString()));
                var earliest_delivery_date = format.format(date);

                getColorCodeStatus(order);

                return value
                                .jsonDataBasket['payload']['merchant_baskets']
                                    [index]['orders']
                                .length -
                            1 <
                        0
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 20),
                        child: Container(
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: colorsStatus,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(15),

                              // height: height * 0.12,
                              // width: width * .8,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                color: ThemeApp.whiteColor,
                              ),
                              child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //image grid
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        color: ThemeApp.whiteColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // crossAxisAlignment:
                                        // CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 44,
                                              width: 45,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              child: FittedBox(
                                                child: Image.network(
                                                        // width: double.infinity,
                                                        order['orders'][0]
                                                                ["image_url"] ??
                                                            "",
                                                        fit: BoxFit.fill,
                                                        height: 22,
                                                        width: 21, errorBuilder:
                                                            ((context, error,
                                                                stackTrace) {
                                                      return Icon(
                                                          Icons.image_outlined);
                                                    })) ??
                                                    SizedBox(),
                                              ),
                                              /* GridView.builder(
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisSpacing: 0,
                                                  mainAxisSpacing: 0,
                                                  crossAxisCount: 2,
                                                  // childAspectRatio: 4/7
                                                ),
                                                itemCount: order['orders'].length,
                                                itemBuilder:
                                                    (context, indexOrderList) {
                                                  subIndexOrderList =
                                                      indexOrderList;
                                                  return order['orders']
                                                                  [indexOrderList]
                                                              ['cancelled'] ==
                                                          'true'
                                                      ? SizedBox()
                                                      : Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: ThemeApp
                                                                      .whiteColor)),
                                                          child: FittedBox(
                                                            child: Image.network(
                                                                    // width: double.infinity,
                                                                    order['orders']
                                                                                [
                                                                                indexOrderList]
                                                                            [
                                                                            "image_url"] ??
                                                                        "",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    height: 22,
                                                                    width: 21,
                                                                    errorBuilder:
                                                                        ((context,
                                                                            error,
                                                                            stackTrace) {
                                                                  return Icon(Icons
                                                                      .image_outlined);
                                                                })) ??
                                                                SizedBox(),
                                                          ),
                                                        );

                                                  // Item rendering
                                                },
                                              ),*/
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: width * .03,
                                          // ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextFieldUtils().dynamicText(
                                                    "Basket ID : " +
                                                        order['id'].toString(),
                                                    context,
                                                    TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: ThemeApp
                                                          .primaryNavyBlackColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    )),
                                                SizedBox(
                                                  height: height * .01,
                                                ),
                                                TextFieldUtils().dynamicText(
                                                    earliest_delivery_date,
                                                    context,
                                                    TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color: ThemeApp
                                                            .lightFontColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              alignment: Alignment.bottomRight,
                                              child: TextFieldUtils()
                                                  .dynamicText(
                                                      statusData,
                                                      // "Acceptance Pending",
                                                      // '${order['overall_status']}',
                                                      // earliest_delivery_date,
                                                      context,
                                                      TextStyle(
                                                          color: ThemeApp
                                                              .lightFontColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        height: order['orders'].length >= 2
                                            ? !viewMore
                                                ? 50
                                                : 80
                                            : 30,
                                        // width: width * .63,
                                        child: ListView.builder(
                                          physics: order['orders'].length > 2
                                              ? ScrollPhysics()
                                              : NeverScrollableScrollPhysics(),
                                          itemCount: order['orders'].length > 2
                                              ? !viewMore
                                                  ? 2
                                                  : order['orders'].length
                                              : order['orders'].length,
                                          itemBuilder:
                                              (context, indexOrderDetails) {
                                            indexOfOrders == 0
                                                ? indexOfOrders - 1
                                                : indexOfOrders =
                                                    indexOrderDetails;
                                            // print("Order Id : " +
                                            //     order['orders'][indexOfOrders]
                                            //             ['order_id']
                                            //         .toString());
                                            return (order['orders'].length > 2)
                                                ? !viewMore
                                                    ? order['orders'][
                                                                    indexOrderDetails]
                                                                ['cancelled'] ==
                                                            'true'
                                                        ? SizedBox()
                                                        : Container(
                                                            child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    width: 280,
                                                                    child: Text(
                                                                        order['orders'][indexOrderDetails]["oneliner"] != 'null'
                                                                            ? order['orders'][indexOrderDetails]["oneliner"]
                                                                                .toString()
                                                                            : "",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            color: ThemeApp
                                                                                .blackColor,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            letterSpacing:
                                                                                -0.25,
                                                                            overflow:
                                                                                TextOverflow.ellipsis)),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 30,
                                                                ),
                                                                Text(
                                                                    "* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        letterSpacing:
                                                                            -0.25,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              ],
                                                            ),
                                                          ))
                                                    : order['orders'][
                                                                    indexOrderDetails]
                                                                ['cancelled'] ==
                                                            'true'
                                                        ? SizedBox()
                                                        : Container(
                                                            child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    width: 280,
                                                                    child: Text(
                                                                        "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            color: ThemeApp
                                                                                .blackColor,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            letterSpacing:
                                                                                -0.25,
                                                                            overflow:
                                                                                TextOverflow.ellipsis)),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 30,
                                                                ),
                                                                Text(
                                                                    "* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        letterSpacing:
                                                                            -0.25,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              ],
                                                            ),
                                                          ))
                                                : order['orders'][
                                                                indexOrderDetails]
                                                            ['cancelled'] ==
                                                        'true'
                                                    ? SizedBox()
                                                    : Container(
                                                        child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                width: 280,
                                                                child: Text(
                                                                    "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        letterSpacing:
                                                                            -0.25,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text("* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: ThemeApp
                                                                        .blackColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    letterSpacing:
                                                                        -0.25,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis)),
                                                          ],
                                                        ),
                                                      ));
                                          },
                                        )),

                                    order['orders'].length < 2
                                        ? SizedBox()
                                        : Row(
                                            children: [
                                              order['orders'].length > 2
                                                  ? !viewMore
                                                      ? InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              viewMore =
                                                                  !viewMore;
                                                            });
                                                          },
                                                          child: TextFieldUtils().dynamicText(
                                                              '+ View More',
                                                              context,
                                                              TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: ThemeApp
                                                                      .tealButtonColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              viewMore =
                                                                  !viewMore;
                                                            });
                                                          },
                                                          child: TextFieldUtils().dynamicText(
                                                              '- View Less',
                                                              context,
                                                              TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: ThemeApp
                                                                      .tealButtonColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        )
                                                  : SizedBox(),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      // alignment: Alignment.centerLeft,
                                      child: Row(
                                        // crossAxisAlignment:
                                        // CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextFieldUtils().dynamicText(
                                              indianRupeesFormat.format(
                                                  order["total_payable"] ?? 0),
                                              context,
                                              TextStyle(
                                                  color: ThemeApp.blackColor,
                                                  fontSize: height * .025,
                                                  fontWeight: FontWeight.w700)),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetailScreen(
                                                            order: order,
                                                          )));
                                            },
                                            child: Text(
                                              "View",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: ThemeApp.tealButtonColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            )));
              }),
    );
  }

  Widget activeOrderDropdownShow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .5,
          child: CustomDropdownButton2(
            // buttonWidth: MediaQuery.of(context).size.width,
            // dropdownWidth: MediaQuery.of(context).size.width,
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ThemeApp.whiteColor,
            ),
            icon: Icon(Icons.arrow_drop_down_outlined,
                color: ThemeApp.subIconColor),
            iconSize: 30,
            hint: '',
            dropdownWidth: MediaQuery.of(context).size.width * .5,
            dropdownItems: activeItems,
            value: activeDropdownValue,
            onChanged: (value) {
              setState(() {
                activeDropdownValue = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget pastOrderDropdownShow(HomeProvider value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .5,
          child: CustomDropdownButton2(
            // buttonWidth: MediaQuery.of(context).size.width,
            // dropdownWidth: MediaQuery.of(context).size.width,
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ThemeApp.whiteColor,
            ),
            icon: Icon(Icons.arrow_drop_down_outlined,
                color: ThemeApp.subIconColor),
            iconSize: 30,
            hint: '',
            dropdownWidth: MediaQuery.of(context).size.width * .5,
            dropdownItems: allItems,
            value: allDropdownValue,
            onChanged: (newValue) {
              setState(() {
                allDropdownValue = newValue!;
                print(newValue);

                if (newValue == 'Past 7 Days') {
                  value.PastDays = 7;
                }
                if (newValue == 'Past 1 Month') {
                  value.PastDays = 30;
                }
                if (newValue == 'Past 3 Months') {
                  value.PastDays = 90;
                }
                if (newValue == 'Past 6 Months') {
                  value.PastDays = 180;
                }

                data = Provider.of<HomeProvider>(context, listen: false)
                    .loadJsonForGetMerchantBasket();
              });
            },
          ),
        ),
      ],
    );
  }

// Widget activeOrderList(HomeProvider value) {
//   return (value.jsonData.length > 0 && value.jsonData['status'] == 'OK')
//       ? Expanded(
//           child: ListView.builder(
//               itemCount: value.jsonData['payload'].length,
//               itemBuilder: (_, index) {
//                 List orderList = value.jsonData['payload'];
//                 Map order = orderList[index];
//                 DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
//                 DateTime date = DateTime.parse(
//                     (order['earliest_delivery_date'] ??
//                         DateTime.now().toString()));
//                 var earliest_delivery_date = format.format(date);
//                 Color colorsStatus = ThemeApp.appColor;
//                 if (order["overall_status"] == "Acceptance Pending") {
//                   colorsStatus = ThemeApp.redColor;
//                 }
//                 if (order["overall_status"] == "Shipped") {
//                   colorsStatus = ThemeApp.shippedOrderColor;
//                 }
//                 if (order["overall_status"] == "Completed") {
//                   colorsStatus = ThemeApp.activeOrderColor;
//                 }
//
//                 return InkWell(
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 10, bottom: 10),
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                       elevation: 10,
//                       child: Container(
//                         padding: EdgeInsets.only(
//                           right: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(8),
//                           ),
//                           color: colorsStatus,
//                         ),
//                         child: Container(
//                             // height: height * 0.12,
//                             width: width * .8,
//                             alignment: Alignment.center,
//                             decoration: const BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(8),
//                                 bottomLeft: Radius.circular(8),
//                               ),
//                               color: ThemeApp.whiteColor,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.only(
//                                       left: 15, right: 15, top: 15),
//                                   decoration: const BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(8),
//                                       topRight: Radius.circular(8),
//                                     ),
//                                     color: ThemeApp.whiteColor,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: ThemeApp.darkGreyTab)),
//                                         child: FittedBox(
//                                           child: Image(
//                                             image: NetworkImage(
//                                               order['image_url'] ?? '',
//                                             ),
//                                             errorBuilder:
//                                                 (context, error, stackTrace) {
//                                               return Icon(
//                                                 Icons.error,
//                                               );
//                                             },
//                                             fit: BoxFit.fill,
//                                             height: 50,
//                                             width: 50,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: width * .03,
//                                       ),
//                                       Container(color: ThemeApp.appColor,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             TextFieldUtils().dynamicText(
//                                                 'Order ID - ' +
//                                                     order['id'].toString(),
//                                                 context,
//                                                 TextStyle(
//                                                   color: ThemeApp
//                                                       .primaryNavyBlackColor,
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 14,
//                                                 )),
//                                             SizedBox(
//                                               height: height * .01,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 TextFieldUtils().dynamicText(
//                                                     earliest_delivery_date,
//                                                     context,
//                                                     TextStyle(
//                                                       color: ThemeApp
//                                                           .lightFontColor,
//                                                       fontSize: 12,
//                                                     )),
//                                                 SizedBox(width: 20,),
//                                                 TextFieldUtils().dynamicText(
//                                                     "Acceptance Pending",
//                                                     // '${order['overall_status']}',
//                                                     // earliest_delivery_date,
//                                                     context,
//                                                     TextStyle(
//                                                       color: ThemeApp
//                                                           .lightFontColor,
//                                                       fontSize: 12,
//                                                     )),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//
//                                 Divider(
//                                   thickness: 1,
//                                 ),
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           right: 10, left: 10),
//                                       child: Container(
//                                         height: height * .05,
//                                         width: width * .65,
//                                         child: ListView.builder(
//                                           itemCount: order['orders'].length,
//                                           itemBuilder:
//                                               (context, indexOrderDetails) {
//                                             indexForItems = indexOrderDetails;
//                                             Map subOrders = order['orders']
//                                                 [indexForItems];
//                                             return Container(
//                                                 child: Row(
//                                               // mainAxisAlignment:
//                                               //     MainAxisAlignment
//                                               //         .spaceBetween,
//                                               children: [
//                                                 Expanded(
//                                                   flex:3,
//                                                   child: Text(
//                                                       "${subOrders["short_name"]}",
//                                                       style: TextStyle(
//                                                           color: ThemeApp
//                                                               .blackColor,
//                                                           fontSize: 12,
//                                                           fontWeight:
//                                                               FontWeight.w400,
//                                                           overflow:
//                                                               TextOverflow
//                                                                   .ellipsis)),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Expanded(flex: 1,
//                                                   child: TextFieldUtils().dynamicText(
//                                                       "* ${subOrders['item_qty']}",
//                                                       context,
//                                                       TextStyle(
//                                                           color: ThemeApp
//                                                               .blackColor,
//                                                           fontSize: 14,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           overflow: TextOverflow
//                                                               .ellipsis)),
//                                                 ),
//                                               ],
//                                             ));
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: height * .02,
//                                 ),
//                                 Divider(
//                                   thickness: 1,
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       right: 10, left: 20, bottom: 20),
//                                   child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         TextFieldUtils().dynamicText(
//                                             indianRupeesFormat.format(
//                                                 order["total_payable"] ?? 0),
//                                             context,
//                                             TextStyle(
//                                                 color: ThemeApp.blackColor,
//                                                 fontSize: height * .025,
//                                                 fontWeight: FontWeight.w700)),
//                                         Row(
//                                           children: [
//                                             /*  value.myOrdersList[index]
//                                                       ["myOrderStatus"] ==
//                                                   "Acceptance Pending"
//                                               ? SizedBox()
//                                               : Container(
//                                                   child: TextFieldUtils()
//                                                       .dynamicText(
//                                                           "Change Status to:",
//                                                           context,
//                                                           TextStyle(
//                                                               color:
//                                                                   ThemeApp
//                                                                       .blackColor,
//                                                               fontSize:
//                                                                   height *
//                                                                       .018,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w400)),
//                                                 ),
//                                           SizedBox(
//                                             width: width * .02,
//                                           ),*/
//                                             Container(
//                                               // margin: EdgeInsets.all(10),
//                                               // height: 40,
//                                               decoration: BoxDecoration(
//                                                   // color: ThemeApp.appColor,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10)),
//                                               child: MaterialButton(
//                                                 onPressed: () {
//                                                   Navigator.of(context).push(
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               OrderReviewSubActivity(
//                                                                 order: order,
//                                                               )));
//                                                 },
//                                                 child: Text(
//                                                   "View",
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontWeight:
//                                                         FontWeight.w700,
//                                                     color: ThemeApp
//                                                         .tealButtonColor,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//         )
//       : Center(
//           child: TextFieldUtils().dynamicText(
//               'No data found',
//               context,
//               TextStyle(
//                   color: ThemeApp.blackColor,
//                   fontSize: height * .02,
//                   fontWeight: FontWeight.w400,
//                   overflow: TextOverflow.ellipsis)),
//         );
// }
}
