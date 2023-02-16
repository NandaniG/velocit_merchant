import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocit_merchant/Screens/MainScreens/raise_tickets.dart';
import 'package:velocit_merchant/Screens/MainScreens/tickets_details.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../utils/GlobalWidgets/appBar.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'dart:math' as math;

import '../../utils/GlobalWidgets/textFormFields.dart';
// import '../../utils/GlobalWidgets/textFormFields.dart';

class TicketsPageActivity extends StatefulWidget {
  const TicketsPageActivity({Key? key}) : super(key: key);

  @override
  State<TicketsPageActivity> createState() => _TicketsPageActivityState();
}

class _TicketsPageActivityState extends State<TicketsPageActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/dashBoardScreen');

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
   appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child:   appBarWidget(
            context, searchBar(context), SizedBox(), setState(() {})),
      ),
    // bottomNavigationBar: SafeArea(child: Container(
    //   margin: EdgeInsets.all(10),
    //   decoration: BoxDecoration(
    //     color:Colors.black,
    //     borderRadius: BorderRadius.circular(10) 
    //   ),
    //   child: MaterialButton(onPressed: (){

    //   },
    //   child: Text("Submit Documents",style: TextStyle(fontSize: 16,color: Colors.white),),
    //   ),
    // )),
        bottomNavigationBar: bottomNavigationBarWidget(context,3),
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const RaiseTicketsPageActivity(),
                                    ),
                                  );
            
          },
          child: Icon(Icons.add_circle,size: 50,color: Color(0xff00A7BF),),
        ),
        body: SafeArea(
          child:Column(
            children: List.generate(2, (index) {
              Color colorsStatus = ThemeApp.redColor;

                  if (index % 2 == 0) {
                    colorsStatus = ThemeApp.greenappcolor;
                  }

                  return InkWell(
                    onTap: () {
                          Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const TicketsDetailPageActivity(),
                                    ),
                                  );
                    },
                    
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 10,left: 10),
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
                          padding: EdgeInsets.only(left: 10,right: 10),
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * .9,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 15),
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
                                             "TID12061800",
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
                                              '8 Sep 2022, 2.00 PM', // earliest_delivery_date,
                                              context,
                                              TextStyle(
                                                color: ThemeApp.lightFontColor,
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                      
                                    ],
                                  ),
                                ),
                                SizedBox(height:10),
                                TextFieldUtils().dynamicText(
                                              'Ticket Title', // earliest_delivery_date,
                                              context,
                                              TextStyle(
                                                color: Color(0xff0C1A30),
                                                fontSize: 18,
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w700
                                              )),
                                              SizedBox(height:10),
                                TextFieldUtils().dynamicText(
                                              'Ticket description will go here. Lorem Ipsum is simply dummy text of the printing and typesetting industry', // earliest_delivery_date,
                                              context,
                                              TextStyle(
                                                color: ThemeApp.blackColor,
                                                fontSize: 12,
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w400
                                              )),
                                              SizedBox(height:20),
                                TextFieldUtils().dynamicText(
                                              index % 2 == 0 ? "Resolved" : 'Pending', // earliest_delivery_date,
                                              context,
                                              TextStyle(
                                                color: index % 2 == 0 ? ThemeApp.greenappcolor : ThemeApp.redColor,
                                                fontSize: 12,
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w700
                                              )),

                              ],
                            )),
                      ),
                      ),
                    ),
                  );;
            }),
          )

        ),
      ),
    );
  }
}
