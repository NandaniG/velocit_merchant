import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/GlobalWidgets/proceedButtons.dart';
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
  File? adhaarFront;
  File? adhaarBack;
  File? panFront;
  File? gstCert;
  File? compIncorpCert;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
          child: appBar_backWidget(
              context, appTitle(context, "KYC"), const SizedBox()),
        ),
        // bottomNavigationBar: SafeArea(
        //     child:     Padding(
        //       padding: const EdgeInsets.only(left: 20, right: 20),
        //       child: proceedButton("Submit Documents", ThemeApp.tealButtonColor,
        //           context, false, () {}),
        //     ),),
        // bottomNavigationBar: bottomNavigationBarWidget(context),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
            child: Container(
          color: ThemeApp.appBackgroundColor,
          width: width,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/appImages/imageFileSizeIcon.svg',
                      // color: ThemeApp.appColor,
                      semanticsLabel: 'Acme Logo',

                      // height: height * .03,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Only PDF or JPG files upto 1 MB file size allowed",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(left: 10, right: 10),
                // height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Aadhaar Card",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),

                      // height: (MediaQuery.of(context).size.height * 0.2) * 0.7,
                      // color: Colors.yellow,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Front Side",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              adhaarFront == null
                                  ? InkWell(
                                      onTap: () {
                                        _getAadharFrontCamera();
                                      },
                                      child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: ThemeApp.lightFontColor,
                                          radius: Radius.circular(10),
                                          child: Container(
                                            height: 90,
                                            width: 70 * 2.5,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/appImages/addIcon.svg',
                                                    color:
                                                        ThemeApp.lightFontColor,
                                                    semanticsLabel: 'Acme Logo',

                                                    // height: height * .03,
                                                  ),
                                                  Text(
                                                    "Click to upload",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: ThemeApp
                                                          .lightFontColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ThemeApp.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 90,
                                          width: 70 * 2.5,
                                          child: Image.file(
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    color: ThemeApp.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  height: 90,
                                                  width: 70 * 2.5);
                                            },
                                            adhaarFront!,
                                            // fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                adhaarFront = null;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15, top: 5),
                                              child: Container(
                                                alignment: Alignment.topRight,
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: ThemeApp.appColor,
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                            ],
                          )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Back Side",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              adhaarBack == null
                                  ? InkWell(
                                      onTap: () {
                                        _getAadharBackCamera();
                                      },
                                      child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: ThemeApp.lightFontColor,
                                          radius: Radius.circular(10),
                                          child: Container(
                                            height: 90,
                                            width: 70 * 2.5,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/appImages/addIcon.svg',
                                                    color:
                                                        ThemeApp.lightFontColor,
                                                    semanticsLabel: 'Acme Logo',

                                                    // height: height * .03,
                                                  ),
                                                  Text(
                                                    "Click to upload",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: ThemeApp
                                                          .lightFontColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ThemeApp.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 90,
                                          width: 70 * 2.5,
                                          child: Image.file(
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    color: ThemeApp.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  height: 90,
                                                  width: 70 * 2.5);
                                            },
                                            adhaarBack!,
                                            // fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                adhaarBack = null;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15, top: 5),
                                              child: Container(
                                                alignment: Alignment.topRight,
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: ThemeApp.appColor,
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                            ],
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(left: 10, right: 10),
                // height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "PAN Card",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),

                      // height: (MediaQuery.of(context).size.height * 0.2) * 0.7,
                      // color: Colors.yellow,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Front Side",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              panFront == null
                                  ? InkWell(
                                      onTap: () {
                                        _getPanFrontCamera();
                                      },
                                      child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: ThemeApp.lightFontColor,
                                          radius: Radius.circular(10),
                                          child: Container(
                                            height: 90,
                                            width: 70 * 2.5,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/appImages/addIcon.svg',
                                                    color:
                                                        ThemeApp.lightFontColor,
                                                    semanticsLabel: 'Acme Logo',

                                                    // height: height * .03,
                                                  ),
                                                  Text(
                                                    "Click to upload",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: ThemeApp
                                                          .lightFontColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ThemeApp.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 90,
                                          width: 70 * 2.5,
                                          child: Image.file(
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    color: ThemeApp.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  height: 90,
                                                  width: 70 * 2.5);
                                            },
                                            panFront!,
                                            // fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(

                                            onTap: () {
                                              setState(() {
                                                panFront = null;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20, top: 5),
                                              child: Container(    width: 70 * 2.5,
                                                alignment: Alignment.topRight,
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: ThemeApp.appColor,
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                            ],
                          )),
                          SizedBox(
                            width: 20,
                          ),
                          // Expanded(
                          //   child:Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text("Company InCorpration Cert.",style: TextStyle(fontSize: 12),),
                          //     SizedBox(height: 10,),
                          //     DottedBorder(
                          //       borderType: BorderType.RRect,
                          //       radius: Radius.circular(10),
                          //       child: Container(
                          //         height: 80,
                          //         width: 70 * 2.5,
                          //         child: Center(
                          //           child: Column(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: [
                          //               Icon(Icons.add),
                          //               Text("Click to upload",style: TextStyle(fontSize: 16),)
                          //             ],
                          //           ),
                          //         ),
                          //     ))
                          //   ],
                          // )
                          // )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(left: 10, right: 10),
                // height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Other Documents",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      // height: (MediaQuery.of(context).size.height * 0.2) * 0.7,
                      // color: Colors.yellow,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "GST Cert.(Optional)",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              gstCert == null
                                  ? InkWell(
                                      onTap: () {
                                        _getGstCertCamera();
                                      },
                                      child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: ThemeApp.lightFontColor,
                                          radius: Radius.circular(10),
                                          child: Container(
                                            height: 90,
                                            width: 70 * 2.5,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/appImages/addIcon.svg',
                                                    color:
                                                        ThemeApp.lightFontColor,
                                                    semanticsLabel: 'Acme Logo',

                                                    // height: height * .03,
                                                  ),
                                                  Text(
                                                    "Click to upload",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: ThemeApp
                                                          .lightFontColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ThemeApp.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 90,
                                          width: 70 * 2.5,
                                          child: Image.file(
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    color: ThemeApp.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  height: 90,
                                                  width: 70 * 2.5);
                                            },
                                            gstCert!,
                                            // fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                gstCert = null;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15, top: 5),
                                              child: Container(
                                                alignment: Alignment.topRight,
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: ThemeApp.appColor,
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                            ],
                          )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Company InCorpration Cert.",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              compIncorpCert == null
                                  ? InkWell(
                                      onTap: () {
                                        _getCompanyInCorpoCamera();
                                      },
                                      child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: ThemeApp.lightFontColor,
                                          radius: Radius.circular(10),
                                          child: Container(
                                            height: 90,
                                            width: 70 * 2.5,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/appImages/addIcon.svg',
                                                    color:
                                                        ThemeApp.lightFontColor,
                                                    semanticsLabel: 'Acme Logo',

                                                    // height: height * .03,
                                                  ),
                                                  Text(
                                                    "Click to upload",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: ThemeApp
                                                          .lightFontColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ThemeApp.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 90,
                                          width: 70 * 2.5,
                                          child: Image.file(
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    color: ThemeApp.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  height: 90,
                                                  width: 70 * 2.5);
                                            },
                                            compIncorpCert!,
                                            // fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                compIncorpCert = null;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15, top: 5),
                                              child: Container(
                                                alignment: Alignment.topRight,
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: ThemeApp.appColor,
                                                ),
                                              ),
                                            )),
                                      ],
                                    )
                            ],
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              /*  if(adhaarFront.toString().isNotEmpty ||
            adhaarBack.toString().isNotEmpty ||
            panFront.toString().isNotEmpty ||
            gstCert.toString().isNotEmpty ||
            compIncorpCert.toString().isNotEmpty)  */
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: adhaarFront != null &&
                        adhaarBack != null &&
                        panFront != null &&
                        gstCert != null &&
                        compIncorpCert != null
                    ? proceedButton("Submit Documents",
                        ThemeApp.tealButtonColor, context, false, () {})
                    : inActiveButton("name", context, () {}),
              ),
            ],
          ),
        )),
      ),
    );
  }

  _getAadharFrontCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        adhaarFront = File(pickedFile.path);
      });
    }
  }

  _getAadharBackCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        adhaarBack = File(pickedFile.path);
      });
    }
  }

  _getPanFrontCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        panFront = File(pickedFile.path);
      });
    }
  }

  _getGstCertCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        gstCert = File(pickedFile.path);
      });
    }
  }

  _getCompanyInCorpoCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        compIncorpCert = File(pickedFile.path);
      });
    }
  }
}
