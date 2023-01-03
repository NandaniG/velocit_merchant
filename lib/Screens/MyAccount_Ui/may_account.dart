import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocit_merchant/Screens/MyAccount_Ui/KYC/kyc_page.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../utils/GlobalWidgets/appBar.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';

class MyAccountActivity extends StatefulWidget {
  const MyAccountActivity({Key? key}) : super(key: key);

  @override
  State<MyAccountActivity> createState() => _MyAccountActivityState();
}

class _MyAccountActivityState extends State<MyAccountActivity> {
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
          appTitle(context, "My Profile"), const SizedBox()),
    ),
        bottomNavigationBar: bottomNavigationBarWidget(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child:Container(
              color: ThemeApp.appBackgrounColor,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20,top: 0),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // height: height * 0.12,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: ThemeApp.whiteColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                // flex: 1,
                                child: Container(
                                  width: 70.0,
                                  height: 70.0,
                                   decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              'assets/images/laptopImage.jpg',
                                            )))
                            ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextFieldUtils().dynamicText(
                                          'JK Mobile Shop',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.primaryNavyBlackColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: height * .024,
                                          )),
                                      SizedBox(
                                        height: height * .01,
                                      ),
                                      TextFieldUtils().dynamicText(
                                         'jkmobile@gmail.com',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.lightFontColor,
                                            fontSize: height * .018,
                                          )),
                                      SizedBox(
                                        height: height * .01,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          '+91 7894563252',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.lightFontColor,
                                            fontSize: height * .018,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                             
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          // height: height * 0.12,
                          alignment: Alignment.center,
                          // padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: ThemeApp.whiteColor,
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //     const MyOrdersActivity(),
                                  //   ),
                                  // );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,color: ThemeApp.appBackgrounColor
                                             /* image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  ))*/
                                          ),child: Icon(Icons.hide_image_rounded,)),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => KYCActivity(),
                  ),
                );
                                        },
                                        child: TextFieldUtils().dynamicText(
                                          'KYC',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: height * .023,
                                          )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeApp.backgroundColor, width: 1),
                                    // bottom: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //     const MyOrdersActivity(),
                                  //   ),
                                  // );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,color: ThemeApp.appBackgrounColor
                                            /* image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  ))*/
                                          ),child: Icon(Icons.hide_image_rounded,)),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          'Frequently asked questions',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: height * .023,
                                          )),
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeApp.backgroundColor, width: 1),
                                    // bottom: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //     const MyOrdersActivity(),
                                  //   ),
                                  // );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,color: ThemeApp.appBackgrounColor
                                            /* image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  ))*/
                                          ),child: Icon(Icons.hide_image_rounded,)),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          'Sign out',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: height * .023,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            )

        ),
      ),
    );
  }
}
