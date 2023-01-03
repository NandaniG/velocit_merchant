import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/proceedButtons.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/GlobalWidgets/appBar.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import 'Order_delivery_screen.dart';

class OrderReviewSubActivity extends StatefulWidget {
  OrderReviewSubActivity({Key? key, required this.order}) : super(key: key);

  final Map order;
  @override
  State<OrderReviewSubActivity> createState() => _OrderReviewSubActivityState();
}

class _OrderReviewSubActivityState extends State<OrderReviewSubActivity> {
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

  var dropDownForAcceptedProducts = [
    'Accepted',
    'Packed',
    'Shipped',
    'Delivered',
    'Cancel'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var address =
      'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021';

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgrounColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(
            context,
            appTitle(context, "Order ID - ${widget.order["id"]}"),
            const SizedBox()),
      ),
      bottomNavigationBar: 
      singleSelectOptions ? Container(
        height: 0,
      ) : Container(
        height: 45,
        child: Row(
          children: [
            Expanded(
                child: Container(
              // margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: ThemeApp.appColor,
                  borderRadius: BorderRadius.circular(0)),
              child: MaterialButton(
                onPressed: () {

                },
                child: Text(
                  "Accept",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )),
            Expanded(
                child: Container(
              // margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(0)),
              child: MaterialButton(
                onPressed: () {},
                child: Text(
                  "Reject",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ))
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        color: ThemeApp.appBackgrounColor,
        width: width,
        child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:20,right: 20),
                child: Column(
                  children: [
                    /* stepperWidget(),  SizedBox(
                    height: height * .02,
                  ),*/
                  Row(
                    children: [
                      Text('Current Status:',style: TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400),),
                      Text(widget.order['overall_status'],style: TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(height: 10,),
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
                                  AppLocalizations.of(context).deliveryDetails,
                                  context,
                                  TextStyle(
                                      color: ThemeApp.primaryNavyBlackColor,
                                      fontSize: height * .025,
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
                                  border: Border.all(
                                      color: ThemeApp.packedButtonColor),
                                  color: ThemeApp.whiteColor,
                                ),
                                child: TextFieldUtils().dynamicText(
                                    StringConstant.selectedTypeOfAddress,
                                    context,
                                    TextStyle(
                                        color: ThemeApp.packedButtonColor,
                                        fontSize: height * .018,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          TextFieldUtils().dynamicText(
                              widget.order["customer_name"],
                              context,
                              TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: height * .01,
                          ),
                          Text(
                              // provider.orderCheckOutDetails[0]
                              //     ["orderCheckOutDeliveryAddress"],
                              '${widget.order["delivery_address_line1"]},${widget.order["delivery_address_line2"]},${widget.order["delivery_address_city"]},${widget.order["delivery_address_pincode"]},${widget.order["delivery_address_state"]}',
                              softWrap: true,
                              style: TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: height * .02,
                          ),
                          Divider(thickness: 1,),
                          Row(
                            children: [
                              Icon(Icons.phone_in_talk_sharp,
                                  color: ThemeApp.tealButtonColor),
                              SizedBox(
                                width: width * .02,
                              ),
                              TextFieldUtils().dynamicText(
                                  " +91 ${widget.order['customer_contact']}",
                                  context,
                                  TextStyle(
                                      color: ThemeApp.primaryNavyBlackColor,
                                      fontSize: height * .022,
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
                        padding: const EdgeInsets.only(left:20,right: 20,top: 20),
                        decoration: const BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldUtils().dynamicText(
                                AppLocalizations.of(context).orderSummary,
                                context,
                                TextStyle(
                                    color: ThemeApp.primaryNavyBlackColor,
                                    fontSize: height * .023,
                                    fontWeight: FontWeight.bold)),
                            cartProductList(),
                          ],
                        )),
                    SizedBox(
                      height: height * .02,
                    ),
                    priceDetails(),
                    SizedBox(
                      height: height * .01,
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
                    SizedBox(
                      height: height * .01,
                    ),
                  ],
                ),
              ),
            ]),
      )),
    );
  }

  Widget cartProductList() {
    return ListView.builder(
        shrinkWrap: true,
        // separatorBuilder: (BuildContext context, int index) =>
        // const Divider(thickness: 2, color: ThemeApp.primaryNavyBlackColor),
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.order['orders'].length,
        itemBuilder: (BuildContext context, int index) {
          Map orderDetails = (widget.order['orders'].values.toList())[index];
          bool orderStatus = false;
          if (orderDetails['is_order_placed']) {
            orderStatus = true;
          } else if(orderDetails['is_packed']) {
            orderStatus = true;
          }else if(orderDetails['is_shipped']) {
            orderStatus = true;
          }else if(orderDetails['is_delivered']) {
            orderStatus = true;
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
                                fit: BoxFit.fill,
                                // width: width*.18,
                                height: 70,
                                width: 70,
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
                                        // 'POCO M3 Pro 5G(Yellow, 32GB)',
                                        '${orderDetails['oneliner']}',
                                        context,
                                        TextStyle(
                                            color:
                                                ThemeApp.primaryNavyBlackColor,
                                            fontSize: height * .02,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w400)),
                                            SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextFieldUtils().dynamicText(
                                        'Quantity:${orderDetails['item_qty']}',
                                        context,
                                        TextStyle(
                                            color:
                                                ThemeApp.primaryNavyBlackColor,
                                            fontSize: height * .022,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w700)),
                                            orderStatus ? Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                              border: Border.all(width: 1),
                                            ),
                                              child: DropDownForStatusChange(),
                                            ) : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      orderStatus ? Container() : Row(
                        children: [
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(left:5,right: 5),
                            decoration: BoxDecoration(
                                color: ThemeApp.appColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  singleSelectOptions = true;
                                  orderDetails['is_order_placed'] = true;
                                });
                              },
                              child: Text(
                                "Accept",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(left:5,right: 5),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  singleSelectOptions = true;
                                });
                              },
                              child: Text(
                                "Reject",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(height: 5,),
                      Divider(thickness: 1,)
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget prices() {
    return Container(
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
    );
  }

  Widget priceDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height * 0.16,
          width: width,
          decoration: const BoxDecoration(
            color: ThemeApp.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldUtils().appBarTextField("Price Details", context),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldUtils().homePageTitlesTextFields(
                        "Price (${widget.order['order_count']} items)",
                        context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(widget.order['total_mrp']),
                        // counterPrice == 1
                        //     ? value.originialAmount.toString()
                        //     : value.originalPriceCounter.toString(),
                        context)
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldUtils()
                        .homePageTitlesTextFields("Discount", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        "- ${indianRupeesFormat.format(widget.order['total_discount'])}",
                        context),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldUtils()
                        .homePageTitlesTextFields("Delivery charges", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat
                            .format(widget.order['total_delivery_charges']),
                        context),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: width,
          decoration: const BoxDecoration(
            color: ThemeApp.whiteColor,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          padding:
              const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFieldUtils().titleTextFields("Total Amount", context),
              TextFieldUtils().titleTextFields(
                  "${indianRupeesFormat.format(widget.order['total_payable'])} ",
                  context),
            ],
          ),
        ),
        SizedBox(
          height: height * .02,
        )
      ],
    );
  }

  Widget DropDownForStatusChange() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
          width: 110,
          height: 40,
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

            value: 'Accepted',

            // Down Arrow Icon
            // icon: const Icon(Icons.arrow_drop_down,size: 30),

            // Array list of items
            items: dropDownForAcceptedProducts.map((String items) {
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
                // allDropdownValue = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }
}
