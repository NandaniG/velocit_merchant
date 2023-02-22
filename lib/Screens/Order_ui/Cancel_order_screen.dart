import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/GlobalWidgets/appBar.dart';
import '../../utils/GlobalWidgets/proceedButtons.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import '../../utils/StringUtils.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({Key? key}) : super(key: key);

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );

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
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(context,
            appTitle(context, "Order ID - OID12067800"), const SizedBox()),
      ),
      body: SafeArea(
          child: Container(
        color: ThemeApp.appBackgroundColor,
        width: width,
        child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /* stepperWidget(),  SizedBox(
                    height: height * .02,
                  ),*/
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextFieldUtils().dynamicText(
                                      StringUtils.deliveryDetails,
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
                                  StringConstant.selectedFullName,
                                  context,
                                  TextStyle(
                                      color: ThemeApp.primaryNavyBlackColor,
                                      fontSize: height * .023,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(
                                height: height * .01,
                              ),
                              Text(
                                  // provider.orderCheckOutDetails[0]
                                  //     ["orderCheckOutDeliveryAddress"],
                                  address,
                                  style: TextStyle(
                                      color: ThemeApp.primaryNavyBlackColor,
                                      fontSize: height * .021,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(
                                height: height * .02,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.phone_in_talk_sharp,
                                      color: ThemeApp.tealButtonColor),
                                  SizedBox(
                                    width: width * .02,
                                  ),
                                  TextFieldUtils().dynamicText(
                                      " +91 7894561235",
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
                        Container(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Image.asset(
                                'assets/appImages/cancrlOrder.png',
                                height: 200,
                              ),
                            )),
                        ],
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Container(
                        // height: height * 0.6,
                        width: width,
                        padding: const EdgeInsets.all(20),
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
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
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
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            // width: double.infinity,
                            // snapshot.data![index].serviceImage,
                            'assets/images/androidImage.jpg',
                            fit: BoxFit.fill,
                            // width: width*.18,
                            height: height * .08,
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
                                        color: ThemeApp.primaryNavyBlackColor,
                                        fontSize: height * .02,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400)),
                                TextFieldUtils().dynamicText(
                                    'Quantity:1',
                                    context,
                                    TextStyle(
                                        color: ThemeApp.primaryNavyBlackColor,
                                        fontSize: height * .022,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ),
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
              "${indianRupeesFormat.format(45452)}",
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
                    TextFieldUtils()
                        .homePageTitlesTextFields("Price (2 items)", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(25222),
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
                        "- ${indianRupeesFormat.format(120)}", context),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldUtils()
                        .homePageTitlesTextFields("Delivery charges", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(60), context),
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
                  "${indianRupeesFormat.format(25062)} ", context),
            ],
          ),
        ),
        SizedBox(
          height: height * .02,
        )
      ],
    );
  }
}
