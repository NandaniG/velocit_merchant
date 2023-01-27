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
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child:   appBarWidget(
            context, searchBar(context), SizedBox(), setState(() {})),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Consumer<HomeProvider>(builder: (context, value, child) {
          return Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
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
                                    children: [
                                      Expanded(
                                        child: Container(
                                            width: 60.0,
                                            height: 60.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(10),
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new AssetImage(
                                                      'assets/images/laptopImage.jpg',
                                                    )))),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            TextFieldUtils().dynamicText(
                                                value.budgetBuyList[
                                                index][
                                                "budgetBuyDescription"]!,
                                                context,
                                                TextStyle(
                                                    color:
                                                    ThemeApp
                                                        .blackColor,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize:
                                                    12,
                                                    fontFamily: "Roboto",
                                                    overflow: TextOverflow
                                                        .ellipsis)),

                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          TextFieldUtils().dynamicText(
                                             'In Stock',
                                              context,
                                              TextStyle(
                                                  color:
                                                  ThemeApp
                                                      .blackColor,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize:
                                                  height * .02,
                                                  overflow: TextOverflow
                                                      .ellipsis)),
                                          Transform.scale(
                                            scale: 1.3,
                                            child: Switch(
                                              // This bool value toggles the switch.
                                              value:  value.budgetBuyList[
                                              index][
                                              "isActive"]!,
                                              activeColor: ThemeApp.greenappcolor,
                                              inactiveTrackColor: ThemeApp.redColor,

                                              // inactiveThumbColor: ThemeApp.w,
                                              onChanged: (bool val) {
                                                // This is called when the user toggles the switch.
                                                setState(() {
                                                  value.budgetBuyList[
                                                  index][
                                                  "isActive"] = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
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
          );
        }),
      ),
    );
  }
}
