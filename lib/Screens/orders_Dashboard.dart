import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Services/HomeModel.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    viewMore = false;
    isNewNotifications = true;
    isActiveOrders = true;
    data = Provider.of<HomeProvider>(context, listen: false).loadJson();
    super.initState();
    setPram();
  }

  setPram() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
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

    return Scaffold(
      backgroundColor: ThemeApp.appBackgrounColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .19),
        child: Container(
          height: height * .22,
          child: Column(
            children: [
              appBarWidget(
                  context, searchBar(context), SizedBox(), setState(() {})),
              Container(
                height: height * .075,
                // margin: EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                    border: Border.all(color: ThemeApp.appColor, width: 1)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isActiveOrders = true;
                              // isActiveOrders = !isActiveOrders;
                              // email.clear();
                              // _usingPassVisible==true ? _validateEmail = true:_validateEmail=false;
                            });
                          },
                          child: Container(
                              height: height - 10,
                              decoration: BoxDecoration(
                                color: isActiveOrders
                                    ? ThemeApp.appColor
                                    : ThemeApp.whiteColor,
                              ),
                              child: Center(
                                child: TextFieldUtils().usingPassTextFields(
                                    'Active Orders',
                                    isActiveOrders
                                        ? ThemeApp.whiteColor
                                        : ThemeApp.blackColor,
                                    context),
                              ))),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isActiveOrders = false;
                            });
                          },
                          child: Container(
                              height: height - 10,
                              decoration: BoxDecoration(
                                color: !isActiveOrders
                                    ? ThemeApp.appColor
                                    : ThemeApp.whiteColor,
                              ),
                              child: Center(
                                child: TextFieldUtils().usingPassTextFields(
                                    "Past Orders",
                                    !isActiveOrders
                                        ? ThemeApp.whiteColor
                                        : ThemeApp.blackColor,
                                    context),
                              ))),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Container(
          color: ThemeApp.appBackgrounColor,
          width: width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
              padding: const EdgeInsets.only(left:10,right: 10),
              child: data == '' ? CircularProgressIndicator() : mainUI()),
        ),
      ),
    );
  }

  Widget mainUI() {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return (value.jsonData.isNotEmpty && value.jsonData['error'] == null)
          ? Stack(
              children: [
                isActiveOrders == true
                    ? Column(
                        children: [
                          SizedBox(height: 5,),
                          dropdownShow(),
                          SizedBox(
                            height: height * .02,
                          ),
                          StringConstant.isLogIn
                              ? Container()
                              : Center(
                                  child: Text(
                                    "For OwnBoarding\nPlease connect to Sales Team",
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
                          allOrderDropdownShow(),
                          SizedBox(
                            height: height * .02,
                          ),
                          activeOrderList(value)
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
                            color: ThemeApp.primaryNavyBlackColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            fontSize: height * .032,
                                            fontWeight: FontWeight.bold)),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isNewNotifications = false;
                                        });
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        size: height * .05,
                                        color: ThemeApp.whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height * .1,
                                  child: ListView.builder(
                                      itemCount: 3,
                                      itemBuilder: (_, index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  '', //"${value.myOrdersList[1]["myOrderDetailList"][0]["productDetails"]}",
                                                  style: TextStyle(
                                                      color:
                                                          ThemeApp.whiteColor,
                                                      fontSize: height * .022,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ),
                                            TextFieldUtils().dynamicText(
                                                "* 3",
                                                context,
                                                TextStyle(
                                                    color: ThemeApp.blackColor,
                                                    fontSize: height * .022,
                                                    fontWeight: FontWeight.w400,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                          ],
                                        );
                                      }),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isNewNotifications = false;
                                    });
                                  },
                                  child: Container(
                                    width: width * .3,
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 10, 20.0, 10),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: ThemeApp.whiteColor,
                                    ),
                                    child: Center(
                                      child: TextFieldUtils().dynamicText(
                                          "View",
                                          context,
                                          TextStyle(
                                              color: ThemeApp
                                                  .primaryNavyBlackColor,
                                              fontSize: height * .023,
                                              fontWeight: FontWeight.w500)),
                                    ),
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
          : value.jsonData['error'] != null
              ? Container()
              : Center(child: CircularProgressIndicator());
    });
  }

  String activeDropdownValue = 'All Orders';

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

  Widget dropdownShow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // TextFieldUtils().dynamicText(
        //     "Show",
        //     context,
        //     TextStyle(
        //         color: ThemeApp.blackColor,
        //         fontSize: height * .022,
        //         fontWeight: FontWeight.w500,
        //         overflow: TextOverflow.ellipsis)),
        // SizedBox(
        //   width: width * .03,
        // ),
        Container(
          decoration: BoxDecoration(
            color: ThemeApp.whiteColor, //<-- SEE HERE
          ),
          width: MediaQuery.of(context).size.width * .51,
          // height: 35,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              fillColor: ThemeApp.whiteColor,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            style: TextStyle(
                color: ThemeApp.lightFontColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis),

            value: activeDropdownValue,

            // Down Arrow Icon
            // icon: const Icon(Icons.arrow_drop_down,size: 30),

            // Array list of items
            items: activeItems.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: TextFieldUtils().dynamicText(
                    items,
                    context,
                    TextStyle(
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis)),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                activeDropdownValue = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget allOrderDropdownShow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // TextFieldUtils().dynamicText(
        //     "Show",
        //     context,
        //     TextStyle(
        //         color: ThemeApp.blackColor,
        //         fontSize: height * .022,
        //         fontWeight: FontWeight.w500,
        //         overflow: TextOverflow.ellipsis)),
        // SizedBox(
        //   width: width * .03,
        // ),
        Container(
          decoration: BoxDecoration(
            color: ThemeApp.whiteColor, //<-- SEE HERE
          ),
          width: MediaQuery.of(context).size.width * .51,
          // height: 35,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              fillColor: ThemeApp.whiteColor,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            style: TextStyle(
                color: ThemeApp.lightFontColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis),

            value: allDropdownValue,

            // Down Arrow Icon
            // icon: const Icon(Icons.arrow_drop_down,size: 30),

            // Array list of items
            items: allItems.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: TextFieldUtils().dynamicText(
                    items,
                    context,
                    TextStyle(
                        color: ThemeApp.lightFontColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis)),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                allDropdownValue = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget activeOrderList(HomeProvider value) {
    return (value.jsonData.length > 0 && value.jsonData['status'] == 'OK')
        ? Expanded(
            child: ListView.builder(
                itemCount: value.jsonData['payload']['merchant_baskets'].length,
                itemBuilder: (_, index) {
                  List orderList = value
                      .jsonData['payload']['merchant_baskets'];
                  Map order = orderList[index];
                  DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
                  DateTime date =
                      DateTime.parse(order['earliest_delivery_date']);
                  var earliest_delivery_date = format.format(date);
                  Color colorsStatus = ThemeApp.appColor;
                  if (order["overall_status"] == "Acceptance Pending") {
                    colorsStatus = ThemeApp.redColor;
                  }
                  if (order["overall_status"] == "Shipped") {
                    colorsStatus = ThemeApp.shippedOrderColor;
                  }
                  if (order["overall_status"] == "Completed") {
                    colorsStatus = ThemeApp.activeOrderColor;
                  }

                  return InkWell(
                    
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 10,
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
                            // height: height * 0.12,
                            width: width * .8,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              color: ThemeApp.whiteColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    color: ThemeApp.whiteColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(
                                      //   width: width * .03,
                                      // ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextFieldUtils().dynamicText(
                                             'Order ID - ' + order['id'].toString(),
                                              context,
                                              TextStyle(
                                                color: ThemeApp
                                                    .primaryNavyBlackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              )),
                                          SizedBox(
                                            height: height * .01,
                                          ),
                                          TextFieldUtils().dynamicText(
                                              '${order['overall_status']}', // earliest_delivery_date,
                                              context,
                                              TextStyle(
                                                color: ThemeApp.lightFontColor,
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                      TextFieldUtils().dynamicText(
                                          earliest_delivery_date,
                                          context,
                                          TextStyle(
                                            color: ThemeApp.lightFontColor,
                                            fontSize: 12,
                                          )),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ThemeApp.darkGreyTab)),
                                      child: FittedBox(
                                        child: Image(
                                          image: NetworkImage(
                                              order['image_url'] ?? ''),
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Container(
                                        height: height * .05,
                                        width: width * .55,
                                        child: ListView.builder(
                                          itemCount: order['orders'].length,
                                          itemBuilder:
                                              (context, indexOrderDetails) {
                                            indexForItems = indexOrderDetails;
                                            Map subOrders = order['orders'][indexForItems];
                                            return Container(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                      "${subOrders["short_name"]}",
                                                      style: TextStyle(
                                                          color: ThemeApp
                                                              .blackColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          overflow: TextOverflow
                                                              .ellipsis)),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                TextFieldUtils().dynamicText(
                                                    "* ${subOrders['item_qty']}",
                                                    context,
                                                    TextStyle(
                                                        color:
                                                            ThemeApp.blackColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis)),
                                              ],
                                            ));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * .02,
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 20, bottom: 20),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                        Row(
                                          children: [
                                            /*  value.myOrdersList[index]
                                                        ["myOrderStatus"] ==
                                                    "Acceptance Pending"
                                                ? SizedBox()
                                                : Container(
                                                    child: TextFieldUtils()
                                                        .dynamicText(
                                                            "Change Status to:",
                                                            context,
                                                            TextStyle(
                                                                color:
                                                                    ThemeApp
                                                                        .blackColor,
                                                                fontSize:
                                                                    height *
                                                                        .018,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                  ),
                                            SizedBox(
                                              width: width * .02,
                                            ),*/
                                            Container(
                                              // margin: EdgeInsets.all(10),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: ThemeApp.appColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrderReviewSubActivity(
                                                                order: order,
                                                              )));
                                                },
                                                child: Text(
                                                  "View",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      ),
                    ),
                  );
                }),
          )
        : Center(
            child: TextFieldUtils().dynamicText(
                'No data found',
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis)),
          );
  }
}
