import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../utils/GlobalWidgets/appBar.dart';
// import '../../utils/GlobalWidgets/textFormFields.dart';

class KYCActivity extends StatefulWidget {
  const KYCActivity({Key? key}) : super(key: key);

  @override
  State<KYCActivity> createState() => _KYCActivityState();
}

class _KYCActivityState extends State<KYCActivity> {
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
        backgroundColor: ThemeApp.appBackgrounColor,
        key: scaffoldGlobalKey,
   appBar: PreferredSize(
      preferredSize: Size.fromHeight(height * .09),
      child: appBar_backWidget(context,
          appTitle(context, "KYC"), const SizedBox()),
    ),
    bottomNavigationBar: Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:Colors.black,
        borderRadius: BorderRadius.circular(10) 
      ),
      child: MaterialButton(onPressed: (){

      },
      child: Text("Submit Documents",style: TextStyle(fontSize: 16,color: Colors.white),),
      ),
    ),
        // bottomNavigationBar: bottomNavigationBarWidget(context),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child:Container(
              color: ThemeApp.appBackgrounColor,
              width: width,
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Aadhaar Card",style: TextStyle(fontSize: 20),),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Front Side",style: TextStyle(fontSize: 12),),
                            SizedBox(height: 10,),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              child: Container(
                                height: 80,
                                width: 70 * 2.5,
                                child: Center(
                                  child: Text("Click to upload",style: TextStyle(fontSize: 16),),
                                ),
                            ))
                          ],
                        ) 
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Back Side",style: TextStyle(fontSize: 12),),
                            SizedBox(height: 10,),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              child: Container(
                                height: 80,
                                width: 70 * 2.5,
                                child: Center(
                                  child: Text("Click to upload",style: TextStyle(fontSize: 16),),
                                ),
                            ))
                          ],
                        ) 
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Pan Card",style: TextStyle(fontSize: 20),),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Front Side",style: TextStyle(fontSize: 12),),
                            SizedBox(height: 10,),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              child: Container(
                                height: 80,
                                width: 70 * 2.5,
                                child: Center(
                                  child: Text("Click to upload",style: TextStyle(fontSize: 16),),
                                ),
                            ))
                          ],
                        ) 
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Back Side",style: TextStyle(fontSize: 12),),
                            SizedBox(height: 10,),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              child: Container(
                                height: 80,
                                width: 70 * 2.5,
                                child: Center(
                                  child: Text("Click to upload",style: TextStyle(fontSize: 16),),
                                ),
                            ))
                          ],
                        ) 
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("Other Documents",style: TextStyle(fontSize: 20),),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("GST Cert.(Optional)",style: TextStyle(fontSize: 12),),
                            SizedBox(height: 10,),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              child: Container(
                                height: 80,
                                width: 70 * 2.5,
                                child: Center(
                                  child: Text("Click to upload",style: TextStyle(fontSize: 16),),
                                ),
                            ))
                          ],
                        ) 
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Company InCorpration Cert.",style: TextStyle(fontSize: 12),),
                            SizedBox(height: 10,),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              child: Container(
                                height: 80,
                                width: 70 * 2.5,
                                child: Center(
                                  child: Text("Click to upload",style: TextStyle(fontSize: 16),),
                                ),
                            ))
                          ],
                        ) 
                        )
                      ],
                    ),
                  )
                ],
              ),
            )

        ),
      ),
    );
  }
}