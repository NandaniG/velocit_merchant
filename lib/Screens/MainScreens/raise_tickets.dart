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
import 'package:dropdown_button2/custom_dropdown_button2.dart';
// import '../../utils/GlobalWidgets/textFormFields.dart';

class RaiseTicketsPageActivity extends StatefulWidget {
  const RaiseTicketsPageActivity({Key? key}) : super(key: key);

  @override
  State<RaiseTicketsPageActivity> createState() =>
      _RaiseTicketsPageActivityState();
}

class _RaiseTicketsPageActivityState extends State<RaiseTicketsPageActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;

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
        bottomNavigationBar: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Color(0xff056C84),
                    borderRadius: BorderRadius.circular(100)),
                child: MaterialButton(
                  onPressed: () {},
                  height: 50,
                  child: Text(
                    "Raise Ticket",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            bottomNavigationBarWidget(context,3)
          ],
        ),
      ),
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
              Container(
                child: CustomDropdownButton2(
                  buttonWidth: MediaQuery.of(context).size.width,
                  dropdownWidth: MediaQuery.of(context).size.width,
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                    )
                  ),
                  hint: 'Choose Subject',
                  dropdownItems: items,
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              TextFieldUtils().dynamicText(
                  'Description', // earliest_delivery_date,
                  context,
                  TextStyle(
                      color: Color(0xff0C1A30),
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400)),
              SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: TextField(
                  expands: true,
                  maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Write description here",
                          labelStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1))
                                ),
                    ),
              ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
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
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 50,
                                          ),
                                          // Text("Click to upload",style: TextStyle(fontSize: 16),)
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldUtils().dynamicText(
                  'Browse File', // earliest_delivery_date,
                  context,
                  TextStyle(
                      color: Color(0xff0C1A30),
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700)),
                      SizedBox(height: 5,),
                      TextFieldUtils().dynamicText(
                  'Max file size allowed 2MB', // earliest_delivery_date,
                  context,
                  TextStyle(
                      color: Color(0xff0C1A30),
                      fontSize: 12,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
