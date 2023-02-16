import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/Provider/Home_Provider.dart';
import '../../utils/GlobalWidgets/appBar.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import '../../utils/styles.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  bool isOutOfStock = false;
  String activeDropdownValue = 'All Stocks';

  var activeItems = [
    'Samsung',
    'Apple',
    'One Plus',
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBarWidget(
            context, searchBar(context), SizedBox(), setState(() {})),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context, 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              // dropdownShow(),

              Expanded(
                  child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ThemeApp.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(10)),
                                        child: Image.asset(
                                          'assets/images/laptopImage.jpg' ?? "",
                                          fit: BoxFit.fill,
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      // width: 100,
                                      // alignment: Alignment.center,
                                      child: TextFieldUtils().dynamicText(
                                          'Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add.' ??
                                              "",
                                          context,
                                          TextStyle(
                                              color: ThemeApp.blackColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              fontFamily: "Roboto",
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          isOutOfStock
                                              ? TextFieldUtils().dynamicText(
                                                  'In Stock',
                                                  context,
                                                  TextStyle(
                                                      color:
                                                          ThemeApp.blackColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      overflow: TextOverflow
                                                          .ellipsis))
                                              : TextFieldUtils().dynamicText(
                                                  'Out Of Stock',
                                                  context,
                                                  TextStyle(
                                                      color:
                                                          ThemeApp.blackColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                          Transform.scale(
                                            scale: 1.3,
                                            child: Switch(
                                              // This bool value toggles the switch.
                                              value: isOutOfStock ?? false,
                                              activeColor:
                                                  ThemeApp.greenappcolor,
                                              inactiveTrackColor:
                                                  ThemeApp.redColor,

                                              // inactiveThumbColor: ThemeApp.w,
                                              onChanged: (bool val) {
                                                // This is called when the user toggles the switch.
                                                setState(() {
                                                  isOutOfStock = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }

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
          width: MediaQuery.of(context).size.width * 0.5,
          // MediaQuery.of(context).size.width * .51,
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
                        fontSize: 16,
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
}
