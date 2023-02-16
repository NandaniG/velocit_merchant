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
// import '../../utils/GlobalWidgets/textFormFields.dart';

class FAQsActivity extends StatefulWidget {
  const FAQsActivity({Key? key}) : super(key: key);

  @override
  State<FAQsActivity> createState() => _FAQsActivityState();
}

class _FAQsActivityState extends State<FAQsActivity> {
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
          appTitle(context, "Frequently Aksed Questions"), const SizedBox()),
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
        // bottomNavigationBar: bottomNavigationBarWidget(context),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child:Column(
            children: List.generate(5, (index) {
              return Container(
              color: ThemeApp.appBackgroundColor,
              width: width,
              margin: EdgeInsets.only(left: 10,right: 10),
              child: ExpansionWidget(
    initiallyExpanded: false,
    titleBuilder: (double animationValue, _, bool isExpaned, toogleFunction) {
      return InkWell(
          onTap: () => toogleFunction(animated: true),
          child: Padding(
            padding: EdgeInsets.only(left: 8,right: 8,bottom: 2),
            child: Container(
              // padding: EdgeInsets.only(left: 2,right: 2),
              color: Colors.white,
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 5,),
                Expanded(child: Text('Expansion Widget Title ${index+1}')),
                Transform.rotate(
                  angle: math.pi * animationValue / 2,
                  child: Icon(Icons.arrow_right, size: 40),
                  alignment: Alignment.center,
                ),
                // Divider(thickness: 1,color: Colors.black,)
              ],
            ),
            ),
          ));
    },
    content: Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 5,left: 8,right: 8),
      child: Text('Expaned Content'),
    )),
            );
            }),
          )

        ),
      ),
    );
  }
}
