import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Screens/Auth_Screens/sign_in.dart';
import 'package:velocit_merchant/Screens/MyAccount_Ui/KYC/kyc_page.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../Routes/Routes.dart';
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
  File? imageFile1;
  final picker = ImagePicker();
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
          preferredSize: Size.fromHeight(height * .07),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: ThemeApp.appBackgroundColor,
            alignment: Alignment.center,
            child: AppBar(
              centerTitle: false,
              elevation: 0,
              backgroundColor: ThemeApp.appBackgroundColor,
              flexibleSpace: Container(
                height: height * .07,
                width: width,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ThemeApp.appBackgroundColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              ),
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //     const DashboardScreen(),
                  //   ),
                  // );

                  Navigator.of(context).pushNamedAndRemoveUntil(RoutesName.dashboardRoute, (route) => false).then((value) {
                    setState(() {

                    });
                  });

                },
                child: Transform.scale(
                  scale: 0.7,
                  child: Image.asset(
                    'assets/appImages/backArrow.png',
                    color: ThemeApp.primaryNavyBlackColor,
                    // height: height*.001,
                  ),
                ),
              ),

              // leadingWidth: width * .06,
              title: TextFieldUtils().dynamicText(
                  'My Account',
                  context,
                  TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      // fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.height * .022,
                      fontWeight: FontWeight.w500)),
              // Row
            ),
          ),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child:Container(
              color: ThemeApp.appBackgroundColor,
              width: width,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*.27,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: ThemeApp.whiteColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            imageFile1 != null
                                ? Stack(
                              // alignment: Alignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    // height: MediaQuery.of(context).size.height/254,
                                    decoration: new BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                            Colors.grey.shade600,
                                            spreadRadius: 1,
                                            blurRadius: 5)
                                      ],
                                      border: Border.all(
                                          color: ThemeApp.whiteColor,
                                          width: 4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(100)),
                                      child: Image.file(
                                        imageFile1!,
                                        fit: BoxFit.fill,
                                        width: 90.0,
                                        height: 90.0,
                                        errorBuilder: (context, error,
                                            stackTrace) {
                                          return Icon(
                                            Icons.image,
                                            color:
                                            ThemeApp.whiteColor,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0, right: width / 2.5,
                                  // width: 130.0,

                                  // height: 40.0,
                                  child: InkWell(
                                      onTap: () {
                                        _getFromCamera();
                                      },
                                      child: Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                30),
                                            color: ThemeApp.appColor),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(7),
                                          child: SvgPicture.asset(
                                            'assets/appImages/cameraIcon.svg',
                                            color:
                                            ThemeApp.whiteColor,
                                            semanticsLabel:
                                            'Acme Logo',

                                            // height: height * .03,
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            )
                                : Stack(
                              // alignment: Alignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    width: 110.0,
                                    height: 110.0,
                                    decoration: new BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: ThemeApp
                                                .appBackgroundColor,
                                            spreadRadius: 1,
                                            blurRadius: 15)
                                      ],
                                      color:
                                      ThemeApp.appBackgroundColor,
                                      border: Border.all(
                                          color: ThemeApp.whiteColor,
                                          width: 7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(100)),
                                      child: Image.file(
                                        File(StringConstant
                                            .ProfilePhoto),
                                        fit: BoxFit.fill,
                                        width: 130.0,
                                        height: 130.0,
                                        errorBuilder: (context, error,
                                            stackTrace) {
                                          return Icon(
                                            Icons.image,
                                            color:
                                            ThemeApp.whiteColor,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0, right: width / 2.5,
                                  // width: 130.0,

                                  // height: 40.0,
                                  child: InkWell(
                                      onTap: () {
                                        _getFromCamera();
                                      },
                                      child: Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                30),
                                            color: ThemeApp.appColor),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(7),
                                          child: SvgPicture.asset(
                                            'assets/appImages/cameraIcon.svg',
                                            color:
                                            ThemeApp.whiteColor,
                                            semanticsLabel:
                                            'Acme Logo',

                                            // height: height * .03,
                                          ),
                                        ),
                                      )
                                    /*; Container(
                                        // alignment: Alignment.bottomCenter,
                                        color: ThemeApp.primaryNavyBlackColor,
                                        alignment: const Alignment(-2, -0.1),
                                        child: iconsUtils(
                                            'assets/appImages/editIcon.svg'),
                                      ),*/
                                  ),
                                ),
                              ],
                            ),
                            /*        Center(
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: new BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: ThemeApp.appBackgroundColor,
                                      spreadRadius: 1,
                                      blurRadius: 20)
                                ],
                                border: Border.all(
                                    color: ThemeApp.whiteColor, width: 7),
                                shape: BoxShape.circle,
                                */ /*   image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              'assets/images/laptopImage.jpg',
                                            ))*/ /*
                              ),
                              child: ClipRRect(
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: Image.file(
                                    File(StringConstant
                                        .ProfilePhoto ??
                                        ""),
                                    fit: BoxFit.fill,
                                    width: 100.0,
                                    height: 100.0,
                                    errorBuilder: (context, error,
                                        stackTrace) {
                                      return Icon(
                                        Icons.image,
                                        color:
                                        ThemeApp.whiteColor,
                                      );
                                    },
                                  ) ??
                                      Container()) ??
                                  SizedBox(),
                            ),
                          ),*/
                            //with edit icon
                            /*      Stack(
                            // alignment: Alignment.center,
                            children: [
                              Center(
                                child: Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: new BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: ThemeApp.appBackgroundColor,
                                          spreadRadius: 1,
                                          blurRadius: 20)
                                    ],
                                    border: Border.all(
                                        color: ThemeApp.whiteColor, width: 7),
                                    shape: BoxShape.circle,
                                    */ /*   image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              'assets/images/laptopImage.jpg',
                                            ))*/ /*
                                  ),
                                  child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(100)),
                                          child: Image.file(
                                                File(StringConstant
                                                        .ProfilePhoto ??
                                                    ""),
                                                fit: BoxFit.fill,
                                                width: 100.0,
                                                height: 100.0,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(
                                                    Icons.image,
                                                    color:
                                                        ThemeApp.whiteColor,
                                                  );
                                                },
                                              ) ??
                                              Container()) ??
                                      SizedBox(),
                                ),
                              ),
                              Positioned(
                                bottom: 0, right: 160,
                                // width: 130.0,

                                // height: 40.0,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EditAccountActivity(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: ThemeApp.appColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: SvgPicture.asset(
                                          'assets/appImages/editIcon.svg',
                                          color: ThemeApp.whiteColor,
                                          semanticsLabel: 'Acme Logo',

                                          // height: height * .03,
                                        ),
                                      ),
                                    ) */ /*; Container(
                                    // alignment: Alignment.bottomCenter,
                                    color: ThemeApp.primaryNavyBlackColor,
                                    alignment: const Alignment(-2, -0.1),
                                    child: iconsUtils(
                                        'assets/appImages/editIcon.svg'),
                                  ),*/ /*
                                    ),
                              ),
                            ],
                          ),*/
                            SizedBox(
                              height: 20,
                            ),
                            TextFieldUtils().dynamicText(
                              // StringConstant.userAccountName,
                                StringConstant.loginUserName,
                                context,
                                TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.blackColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: -0.25)),
                            SizedBox(
                              height: 3,
                            ),
                            TextFieldUtils().dynamicText(
                              // StringConstant.userAccountEmail,
                                StringConstant.loginUserEmail,
                                context,
                                TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.lightFontColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                                            shape: BoxShape.circle,color: ThemeApp.appBackgroundColor
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
                                            shape: BoxShape.circle,color: ThemeApp.appBackgroundColor
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                     SignIn_Screen(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,color: ThemeApp.appBackgroundColor
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
            )

        ),
      ),
    );
  }
  Future _getFromCamera() async {
    var image = await picker.getImage(source: ImageSource.camera);
    final prefs = await SharedPreferences.getInstance();
    // StringConstant.CurrentPinCode = (prefs.getString('CurrentPinCodePref') ?? '');
    String imagePath = image!.path;

    await prefs.setString('profileImagePrefs', imagePath);

    setState(() {
      imageFile1 = File(image.path);

      // final   file = File(image!.path);
      //    final bytes =
      //    file!.readAsBytesSync();
      //   final img64 = base64Encode(bytes);
    });
    // Navigator.pop(this.context);
  }
}
