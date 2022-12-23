import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  bool isActiveOrders = false;

  @override
  void initState() {
    // TODO: implement initState
    viewMore = false;
    isNewNotifications = true;
    isActiveOrders = false;
    data = Provider.of<HomeProvider>(context, listen: false).loadJson();
    super.initState();
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
          height: height * .19,
          child: Column(
            children: [
              appBarWidget(
                  context, searchBar(context), SizedBox(), setState(() {})),
              Container(
                height: height * .077,
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
                              isActiveOrders = !isActiveOrders;
                              // email.clear();
                              // _usingPassVisible==true ? _validateEmail = true:_validateEmail=false;
                            });
                          },
                          child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                color: isActiveOrders
                                    ? ThemeApp.whiteColor
                                    : ThemeApp.appColor,
                              ),
                              child: Center(
                                child: TextFieldUtils().usingPassTextFields(
                                    'Active Orders',
                                    isActiveOrders
                                        ? ThemeApp.blackColor
                                        : ThemeApp.whiteColor,
                                    context),
                              ))),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isActiveOrders = true;
                            });
                          },
                          child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                color: isActiveOrders
                                    ? ThemeApp.appColor
                                    : ThemeApp.whiteColor,
                              ),
                              child: Center(
                                child: TextFieldUtils().usingPassTextFields(
                                    "Past Orders",
                                    isActiveOrders
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
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: data == '' ? CircularProgressIndicator() : mainUI()),
        ),
      ),
    );
  }

  Widget mainUI() {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return value.jsonData.isNotEmpty
          ? Stack(
              children: [
                isActiveOrders != true
                    ? Column(
                        children: [
                          dropdownShow(),
                          SizedBox(
                            height: height * .02,
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
                                                  "${value.myOrdersList[1]["myOrderDetailList"][1]["productDetails"]}",
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
                fontSize: height * .02,
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
                        fontSize: height * .02,
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
    return value.myOrdersList.length > 0
        ? Expanded(
            child: ListView.builder(
                itemCount: value.myOrdersList.length,
                itemBuilder: (_, index) {
                  Color colorsStatus = ThemeApp.appColor;
                  if (value.myOrdersList[index]["myOrderStatus"] ==
                      "Acceptance Pending") {
                    colorsStatus = ThemeApp.redColor;
                  }
                  if (value.myOrdersList[index]["myOrderStatus"] == "Shipped") {
                    colorsStatus = ThemeApp.shippedOrderColor;
                  }
                  if (value.myOrdersList[index]["myOrderStatus"] ==
                      "Completed") {
                    colorsStatus = ThemeApp.activeOrderColor;
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OrderReviewSubActivity()));
                    },
                    child: Padding(
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
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    color: ThemeApp.whiteColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: height * .08,
                                        width: width * .15,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0,
                                            crossAxisCount: 2,
                                            // childAspectRatio: 4/7
                                          ),
                                          itemCount: value
                                              .myOrdersList[index]
                                                  ["myOrderDetailList"]
                                              .length,
                                          itemBuilder:
                                              (context, indexOrderList) {
                                            subIndexOrderList = indexOrderList;
                                            return Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: ThemeApp
                                                          .darkGreyTab)),
                                              child: FractionallySizedBox(
                                                  // width: 50.0,
                                                  // height: 50.0,
                                                  widthFactor: width * .0025,
                                                  heightFactor: height * .0018,
                                                  child: FittedBox(
                                                    child: Image(
                                                      image: AssetImage(
                                                        value.myOrdersList[
                                                                        index][
                                                                    "myOrderDetailList"]
                                                                [indexOrderList]
                                                            ["productImage"],
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )),
                                            );

                                            // Item rendering
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextFieldUtils().dynamicText(
                                              value.myOrdersList[index]
                                                  ["myOrderId"],
                                              context,
                                              TextStyle(
                                                color: ThemeApp
                                                    .primaryNavyBlackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: height * .025,
                                              )),
                                          SizedBox(
                                            height: height * .01,
                                          ),
                                          TextFieldUtils().dynamicText(
                                              value.myOrdersList[index]
                                                  ["myOrderDate"],
                                              context,
                                              TextStyle(
                                                color: ThemeApp.lightFontColor,
                                                fontSize: height * .022,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                     right: 10),
                                  child: Container(
                                    height:
                                        height * .05,
                                    width: width * .75,
                                    child: ListView.builder(
                                      itemCount: value
                                          .myOrdersList[index]
                                              ["myOrderDetailList"]
                                          .length,
                                      itemBuilder:
                                          (context, indexOrderDetails) {
                                        indexForItems = indexOrderDetails;
                                        return Container(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  "${value.myOrdersList[index]["myOrderDetailList"][indexOrderDetails]["productDetails"]}",
                                                  style: TextStyle(
                                                      color:
                                                          ThemeApp.blackColor,
                                                      fontSize: height * .024,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ),
                                            SizedBox(
                                              width: width * .005,
                                            ),
                                            TextFieldUtils().dynamicText(
                                                "* 3",
                                                context,
                                                TextStyle(
                                                    color: ThemeApp.blackColor,
                                                    fontSize: height * .022,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                          ],
                                        ));
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * .02,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10, bottom: 20),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextFieldUtils().dynamicText(
                                            indianRupeesFormat.format(int.parse(
                                                value.myOrdersList[index]
                                                    ["myOrderPrice"])),
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 8, 10, 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30),
                                                ),
                                                // border: Border.all(
                                                //     color: colorsStatus),
                                                color: ThemeApp.whiteColor,
                                              ),
                                              child: TextFieldUtils()
                                                  .dynamicText(
                                                      value.myOrdersList[index]
                                                          ["myOrderStatus"],
                                                      context,
                                                      TextStyle(
                                                          color: colorsStatus,
                                                          fontSize:
                                                              height * .02,
                                                          fontWeight:
                                                              FontWeight.w500)),
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
