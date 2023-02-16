import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../utils/GlobalWidgets/appBar.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'dart:math' as math;

import '../../utils/GlobalWidgets/textFormFields.dart';
// import '../../utils/GlobalWidgets/textFormFields.dart';

class TicketsDetailPageActivity extends StatefulWidget {
  const TicketsDetailPageActivity({Key? key}) : super(key: key);

  @override
  State<TicketsDetailPageActivity> createState() =>
      _TicketsDetailPageActivityState();
}

class _TicketsDetailPageActivityState extends State<TicketsDetailPageActivity> {
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
          child: appBar_backWidget(context,
              appTitle(context, "Order ID - 1234567"), const SizedBox()),
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
        bottomNavigationBar: bottomNavigationBarWidget(context, 4),
        // floatingActionButton: InkWell(
        //   onTap: () {

        //   },
        //   child: Icon(Icons.add_circle,size: 50,color: Color(0xff00A7BF),),
        // ),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TextFieldUtils().dynamicText(
                  'Subject', // earliest_delivery_date,
                  context,
                  TextStyle(
                      color: Color(0xff0C1A30),
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              TextFieldUtils().dynamicText(
                  'Ticket Subject', // earliest_delivery_date,
                  context,
                  TextStyle(
                      color: Color(0xff0C1A30),
                      fontSize: 12,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400)),
              SizedBox(height: 20),
              TextFieldUtils().dynamicText(
                  'Description', // earliest_delivery_date,
                  context,
                  TextStyle(
                      color: Color(0xff0C1A30),
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400)),
              SizedBox(height: 10),
              TextFieldUtils().dynamicText(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled', // earliest_delivery_date,
                  context,
                  TextStyle(
                      color: Color(0xff0C1A30),
                      fontSize: 12,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(left: 5, right: 5),
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Attachment",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: (MediaQuery.of(context).size.height * 0.2) * 0.7,
                      // color: Colors.yellow,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("GST Cert.(Optional)",style: TextStyle(fontSize: 12),),
                              SizedBox(
                                height: 10,
                              ),
                              DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(10),
                                  child: Container(
                                    height: 80,
                                    width: 70 * 2.5,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.picture_as_pdf,
                                            size: 50,
                                          ),
                                          // Text("Click to upload",style: TextStyle(fontSize: 16),)
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("Company InCorpration Cert.",style: TextStyle(fontSize: 12),),
                              SizedBox(
                                height: 10,
                              ),
                              DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(10),
                                  child: Container(
                                    height: 80,
                                    width: 70 * 2.5,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.picture_as_pdf,
                                            size: 50,
                                          ),
                                          // Text("Click to upload",style: TextStyle(fontSize: 16),)
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,

                // margin: EdgeInsets.all(10),
                child: TextFieldUtils().dynamicText(
                    'Pending', // earliest_delivery_date,
                    context,
                    TextStyle(
                        color: ThemeApp.redColor,
                        fontSize: 12,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w700)),
              )
            ],
          ),
        )),
      ),
    );
  }
}
