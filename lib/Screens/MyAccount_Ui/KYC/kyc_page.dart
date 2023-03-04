import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Core/repository/auth_repository.dart';
import '../../../Core/AppConstant/apiMapping.dart';
import '../../../Core/Model/KYCDataModel.dart';
import '../../../utils/GlobalWidgets/proceedButtons.dart';
import '../../../utils/GlobalWidgets/textFormFields.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../utils/GlobalWidgets/appBar.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart'as path;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  File? licenceFile;
  File? addressFile;
  File? panFront;
  File? gstCert;
  File? compIncorpCert;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }
getPref() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  StringConstant.MerchantLoginId = (pref.getInt('merchant_id')) ?? 0;
}
  @override
  Widget build(
    BuildContext context,
  ) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        // Navigator.pushReplacementNamed(context, '/dashBoardScreen');
        Navigator.pop(context);
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
            child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: FutureBuilder<KYCDataModel>(
              future: AuthRepository()
                  .getKYCDetails(StringConstant.MerchantLoginId.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? Container(
                color: ThemeApp.appBackgroundColor,
                width: width,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
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
                            Flexible(
                              child: Text(
                                "Only JPG files upto 1 MB file size allowed.",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Licence",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    "Address Proof",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
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
                                      // Text(
                                      //   "Front Side",
                                      //   style: TextStyle(fontSize: 12),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      snapshot.data!.payload!.licenseImageUrl == null
                                          ? InkWell(
                                              onTap: () {
                                                // _getLicenceCamera();
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(60.0),
                                                    ),
                                                    builder: (context) {
                                                      return imageSelectionForLicence();
                                                    });
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/appImages/addIcon.svg',
                                                            color: ThemeApp
                                                                .lightFontColor,
                                                            semanticsLabel:
                                                                'Acme Logo',

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
                                          :     InkWell(
                                        onTap: () {
                                          // _getLicenceCamera();
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                              Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(60.0),
                                              ),
                                              builder: (context) {
                                                return  imageSelectionForLicence();
                                              });
                                        },
                                            child: Container(
                                        decoration: BoxDecoration(
                                            color: ThemeApp.backgroundColor,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                        ),
                                        height: 90,
                                        width: 70 * 2.5,
                                        child: Image.network(
                                            snapshot.data!.payload!.licenseImageUrl??"",
                                            errorBuilder: (context, error,
                                                stackTrace) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                    ThemeApp.appColor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10),
                                                  ),
                                                  height: 90,
                                                  width: 70 * 2.5);
                                            },
                                            // fit: BoxFit.fill,
                                        ),
                                      ),
                                          ),
                                    ],
                                  )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   "Back Side",
                                      //   style: TextStyle(fontSize: 12),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      snapshot.data!.payload!.addressImageUrl == null
                                          ? InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(60.0),
                                                    ),
                                                    builder: (context) {
                                                      return  imageSelectionForAddress();
                                                    });                                              },
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/appImages/addIcon.svg',
                                                            color: ThemeApp
                                                                .lightFontColor,
                                                            semanticsLabel:
                                                                'Acme Logo',

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
                                          :   InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                              Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(60.0),
                                              ),
                                              builder: (context) {
                                                return  imageSelectionForAddress();
                                              });
                                        },
                                            child: Container(
                                        decoration: BoxDecoration(
                                            color: ThemeApp.backgroundColor,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                        ),
                                        height: 90,
                                        width: 70 * 2.5,
                                        child: Image.network(
                                            errorBuilder: (context, error,
                                                stackTrace) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                    ThemeApp.appColor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10),
                                                  ),
                                                  height: 90,
                                                  width: 70 * 2.5);
                                            },
                                            snapshot.data!.payload!.addressImageUrl!.toString(),
                                            // fit: BoxFit.fill,
                                        ),
                                      ),
                                          ),
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
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
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
                                      // Text(
                                      //   "Front Side",
                                      //   style: TextStyle(fontSize: 12),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      snapshot.data!.payload!.panImageUrl == null
                                          ? InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(60.0),
                                                    ),
                                                    builder: (context) {
                                                      return  imageSelectionForPAN();
                                                    });
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/appImages/addIcon.svg',
                                                            color: ThemeApp
                                                                .lightFontColor,
                                                            semanticsLabel:
                                                                'Acme Logo',

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
                                          :InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                              Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(60.0),
                                              ),
                                              builder: (context) {
                                                return  imageSelectionForPAN();
                                              });
                                        },
                                            child: Container(
                                        decoration: BoxDecoration(
                                            color: ThemeApp.backgroundColor,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                        ),
                                        height: 90,
                                        width: 70 * 2.5,
                                        child: Image.network(
                                            errorBuilder: (context, error,
                                                stackTrace) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                    ThemeApp.appColor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10),
                                                  ),
                                                  height: 90,
                                                  width: 70 * 2.5);
                                            },
                                            snapshot.data!.payload!.panImageUrl!,
                                            // fit: BoxFit.fill,
                                        ),
                                      ),
                                          ),
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
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
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
                                      snapshot.data!.payload!.gstImageUrl == null
                                          ? InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(60.0),
                                                    ),
                                                    builder: (context) {
                                                      return  imageSelectionForGST();
                                                    });                                              },
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
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/appImages/addIcon.svg',
                                                      color: ThemeApp
                                                          .lightFontColor,
                                                      semanticsLabel:
                                                      'Acme Logo',

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
                                          :   InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                              Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(60.0),
                                              ),
                                              builder: (context) {
                                                return  imageSelectionForGST();
                                              });
                                        },
                                            child: Container(
                                        decoration: BoxDecoration(
                                            color: ThemeApp.backgroundColor,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                        ),
                                        height: 90,
                                        width: 70 * 2.5,
                                        child: Image.network(
                                            errorBuilder: (context, error,
                                                stackTrace) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                    ThemeApp.appColor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10),
                                                  ),
                                                  height: 90,
                                                  width: 70 * 2.5);
                                            },
                                            snapshot.data!.payload!.gstImageUrl!,
                                            // fit: BoxFit.fill,
                                        ),
                                      ),
                                          ),
                                    ],
                                  )),
                                  /*  SizedBox(
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
                                  ))*/
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
                            Flexible(
                              child: Text(
                                "Only JPG files upto 1 MB file size allowed.",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      /*  if(adhaarFront.toString().isNotEmpty ||
                    adhaarBack.toString().isNotEmpty ||
                    panFront.toString().isNotEmpty ||
                    gstCert.toString().isNotEmpty ||
                    compIncorpCert.toString().isNotEmpty)  */
                      // Padding(
                      //     padding: const EdgeInsets.only(
                      //         left: 20, right: 20, bottom: 20),
                      //     child: /*adhaarFront != null &&
                      //           adhaarBack != null &&
                      //           panFront != null &&
                      //           gstCert != null &&
                      //           compIncorpCert != null
                      //       ? */
                      //         proceedButton("Submit Documents",
                      //             ThemeApp.tealButtonColor, context, false, () {
                      //       // uploadImage();
                      //     })
                      //     // : inActiveButton("Submit Documents", context, () {}),
                      //     ),
                    ],
                  ),
                ),
              ):Container(
                  color: ThemeApp.appBackgroundColor,
                  width: width,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: SingleChildScrollView(
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
                              Flexible(
                                child: Text(
                                  "Only JPG files upto 1 MB file size allowed.",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w700),
                                ),
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Licence",
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Address Proof",
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
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
                                            // Text(
                                            //   "Front Side",
                                            //   style: TextStyle(fontSize: 12),
                                            // ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            licenceFile == null
                                                ? InkWell(
                                              onTap: () {
                                                // _getLicenceCamera();
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(60.0),
                                                    ),
                                                    builder: (context) {
                                                      return  imageSelectionForLicence();
                                                    });
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
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/appImages/addIcon.svg',
                                                            color: ThemeApp
                                                                .lightFontColor,
                                                            semanticsLabel:
                                                            'Acme Logo',

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
                                                    errorBuilder: (context, error,
                                                        stackTrace) {
                                                      return Container(
                                                          decoration: BoxDecoration(
                                                            color:
                                                            ThemeApp.appColor,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                          ),
                                                          height: 90,
                                                          width: 70 * 2.5);
                                                    },
                                                    licenceFile!,
                                                    // fit: BoxFit.fill,
                                                  ),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        licenceFile = null;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          right: 15, top: 5),
                                                      child: Container(
                                                        alignment:
                                                        Alignment.topRight,
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
                                            // Text(
                                            //   "Back Side",
                                            //   style: TextStyle(fontSize: 12),
                                            // ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            addressFile == null
                                                ? InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(60.0),
                                                    ),
                                                    builder: (context) {
                                                      return  imageSelectionForAddress();
                                                    });
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
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/appImages/addIcon.svg',
                                                            color: ThemeApp
                                                                .lightFontColor,
                                                            semanticsLabel:
                                                            'Acme Logo',

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
                                                    errorBuilder: (context, error,
                                                        stackTrace) {
                                                      return Container(
                                                          decoration: BoxDecoration(
                                                            color:
                                                            ThemeApp.appColor,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                          ),
                                                          height: 90,
                                                          width: 70 * 2.5);
                                                    },
                                                    addressFile!,
                                                    // fit: BoxFit.fill,
                                                  ),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        addressFile = null;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          right: 15, top: 5),
                                                      child: Container(
                                                        alignment:
                                                        Alignment.topRight,
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
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
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

                                                  showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                      Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(60.0),
                                                      ),
                                                      builder: (context) {
                                                        return  imageSelectionForGST();
                                                      });
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
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/appImages/addIcon.svg',
                                                            color: ThemeApp
                                                                .lightFontColor,
                                                            semanticsLabel:
                                                            'Acme Logo',

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
                                                    errorBuilder: (context, error,
                                                        stackTrace) {
                                                      return Container(
                                                          decoration: BoxDecoration(
                                                            color:
                                                            ThemeApp.appColor,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(10),
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
                                                      padding:
                                                      const EdgeInsets.only(
                                                          right: 20, top: 5),
                                                      child: Container(
                                                        width: 70 * 2.5,
                                                        alignment:
                                                        Alignment.topRight,
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
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
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
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(60.0),
                                                    ),
                                                    builder: (context) {
                                                      return  imageSelectionForGST();
                                                    });
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
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/appImages/addIcon.svg',
                                                            color: ThemeApp
                                                                .lightFontColor,
                                                            semanticsLabel:
                                                            'Acme Logo',

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
                                                    errorBuilder: (context, error,
                                                        stackTrace) {
                                                      return Container(
                                                          decoration: BoxDecoration(
                                                            color:
                                                            ThemeApp.appColor,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(10),
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
                                                      padding:
                                                      const EdgeInsets.only(
                                                          right: 15, top: 5),
                                                      child: Container(
                                                        alignment:
                                                        Alignment.topRight,
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
                                    /*  SizedBox(
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
                                  ))*/
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
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: /*adhaarFront != null &&
                                adhaarBack != null &&
                                panFront != null &&
                                gstCert != null &&
                                compIncorpCert != null
                            ? */
                            proceedButton("Submit Documents",
                                ThemeApp.tealButtonColor, context, false, () {
                                  // uploadImage();
                                })
                          // : inActiveButton("Submit Documents", context, () {}),
                        ),
                      ],
                    ),
                  ),
                );
            }
          ),
        )),
      ),
    );
  }
  Widget accountTextList(String text) {
    return TextFieldUtils().dynamicText(
        text,
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: -0.25));
  }

  bool showSpinner = false;
  Widget imageSelectionForLicence() {
    return Stack(alignment: Alignment.center,
      children: [
        Container(
          width: width,
          padding:
          const EdgeInsets.only(
              top: 30.0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
              decoration: const BoxDecoration(
                  color: ThemeApp.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  accountTextList('Change KYC Image'),
                  SizedBox(
                    height: 10,
                  ),
                  Row( crossAxisAlignment: CrossAxisAlignment.center,   mainAxisAlignment: MainAxisAlignment.center,
                    children: [    InkWell(
                      onTap: () async {
                        _getLicenceCamera(ImageSource.camera);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.boxLightColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          // border: Border.all(color: ThemeApp.lightBorderColor)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SvgPicture.asset(
                            'assets/appImages/cameraIconGrey.svg',
                            color: ThemeApp.subIconColor,
                            semanticsLabel: 'Acme Logo',
                            height: 37,
                            // height: height * .03,
                          ),
                        ),
                      ),
                    ), SizedBox(
                      width: 10,
                    ),
                      InkWell(
                        onTap: () async {
                          _getLicenceCamera(ImageSource.gallery);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeApp.boxLightColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            // border: Border.all(color: ThemeApp.lightBorderColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SvgPicture.asset(
                              'assets/appImages/imageIcon.svg',
                              color: ThemeApp.subIconColor,
                              semanticsLabel: 'Acme Logo',
                              height: 37,
                              // height: height * .03,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // InkWell(
                      //   onTap: () async {
                      //     _getLicencePDF();
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: ThemeApp.boxLightColor,
                      //       borderRadius: BorderRadius.all(Radius.circular(8)),
                      //       // border: Border.all(color: ThemeApp.lightBorderColor)
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(20),
                      //       child: SvgPicture.asset(
                      //         'assets/appImages/pdfIcon.svg',
                      //         color: ThemeApp.subIconColor,
                      //         semanticsLabel: 'Acme Logo',
                      //         height: 37,
                      //         // height: height * .03,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: InkWell(
            onTap: () {
              Navigator.pop(
                  context);
            },
            child: Container(
                alignment: Alignment
                    .center,
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: ThemeApp
                      .whiteColor,
                )),
          ),
        ),
      ],
    );
  }

  _getLicenceCamera(ImageSource imageSource) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: imageSource,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        print('pickedFile :  ${pickedFile.path}');
        licenceFile = File(pickedFile.path);
      });
      uploadLicenceImageToURLApi(File(pickedFile.path));
    }
  }
  _getLicencePDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        print('pickedFile :  ${result.paths}');
        // licenceFile = File(result.paths);
      });
      // uploadLicencePDFToURLApi(result.paths);
    }
  }


  Widget imageSelectionForAddress() {
    return Stack(alignment: Alignment.center,
      children: [
        Container(
          width: width,
          padding:
          const EdgeInsets.only(
              top: 30.0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
              decoration: const BoxDecoration(
                  color: ThemeApp.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  accountTextList('Change KYC Image'),
                  SizedBox(
                    height: 10,
                  ),
                  Row( crossAxisAlignment: CrossAxisAlignment.center,   mainAxisAlignment: MainAxisAlignment.center,
                    children: [    InkWell(
                      onTap: () async {
                        _getLicenceCamera(ImageSource.camera);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.boxLightColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          // border: Border.all(color: ThemeApp.lightBorderColor)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SvgPicture.asset(
                            'assets/appImages/cameraIconGrey.svg',
                            color: ThemeApp.subIconColor,
                            semanticsLabel: 'Acme Logo',
                            height: 37,
                            // height: height * .03,
                          ),
                        ),
                      ),
                    ), SizedBox(
                      width: 10,
                    ),
                      InkWell(
                        onTap: () async {
                          _getAddressCamera(ImageSource.gallery);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeApp.boxLightColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            // border: Border.all(color: ThemeApp.lightBorderColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SvgPicture.asset(
                              'assets/appImages/imageIcon.svg',
                              color: ThemeApp.subIconColor,
                              semanticsLabel: 'Acme Logo',
                              height: 37,
                              // height: height * .03,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // InkWell(
                      //   onTap: () async {
                      //     _getAddressCamera(ImageSource.gallery);
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: ThemeApp.boxLightColor,
                      //       borderRadius: BorderRadius.all(Radius.circular(8)),
                      //       // border: Border.all(color: ThemeApp.lightBorderColor)
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(20),
                      //       child: SvgPicture.asset(
                      //         'assets/appImages/pdfIcon.svg',
                      //         color: ThemeApp.subIconColor,
                      //         semanticsLabel: 'Acme Logo',
                      //         height: 37,
                      //         // height: height * .03,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: InkWell(
            onTap: () {
              Navigator.pop(
                  context);
            },
            child: Container(
                alignment: Alignment
                    .center,
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: ThemeApp
                      .whiteColor,
                )),
          ),
        ),
      ],
    );
  }


  _getAddressCamera(ImageSource imageSource) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: imageSource,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        addressFile = File(pickedFile.path);
      });
      uploadAddressImageToURLApi(File(pickedFile.path));
    }
  }
  Widget imageSelectionForPAN() {
    return Stack(alignment: Alignment.center,
      children: [
        Container(
          width: width,
          padding:
          const EdgeInsets.only(
              top: 30.0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
              decoration: const BoxDecoration(
                  color: ThemeApp.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  accountTextList('Change KYC Image'),
                  SizedBox(
                    height: 10,
                  ),
                  Row( crossAxisAlignment: CrossAxisAlignment.center,   mainAxisAlignment: MainAxisAlignment.center,
                    children: [    InkWell(
                      onTap: () async {
                        _getPanFrontCamera(ImageSource.camera);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.boxLightColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          // border: Border.all(color: ThemeApp.lightBorderColor)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SvgPicture.asset(
                            'assets/appImages/cameraIconGrey.svg',
                            color: ThemeApp.subIconColor,
                            semanticsLabel: 'Acme Logo',
                            height: 37,
                            // height: height * .03,
                          ),
                        ),
                      ),
                    ), SizedBox(
                      width: 10,
                    ),
                      InkWell(
                        onTap: () async {
                          _getPanFrontCamera(ImageSource.gallery);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeApp.boxLightColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            // border: Border.all(color: ThemeApp.lightBorderColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SvgPicture.asset(
                              'assets/appImages/imageIcon.svg',
                              color: ThemeApp.subIconColor,
                              semanticsLabel: 'Acme Logo',
                              height: 37,
                              // height: height * .03,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // InkWell(
                      //   onTap: () async {
                      //     _getPanFrontCamera(ImageSource.gallery);
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: ThemeApp.boxLightColor,
                      //       borderRadius: BorderRadius.all(Radius.circular(8)),
                      //       // border: Border.all(color: ThemeApp.lightBorderColor)
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(20),
                      //       child: SvgPicture.asset(
                      //         'assets/appImages/pdfIcon.svg',
                      //         color: ThemeApp.subIconColor,
                      //         semanticsLabel: 'Acme Logo',
                      //         height: 37,
                      //         // height: height * .03,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: InkWell(
            onTap: () {
              Navigator.pop(
                  context);
            },
            child: Container(
                alignment: Alignment
                    .center,
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: ThemeApp
                      .whiteColor,
                )),
          ),
        ),
      ],
    );
  }

  _getPanFrontCamera(ImageSource imageSource) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: imageSource,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        panFront = File(pickedFile.path);
      });

      uploadPANImageToURLApi(File(pickedFile.path));
    }
  }
  Widget imageSelectionForGST() {
    return Stack(alignment: Alignment.center,
      children: [
        Container(
          width: width,
          padding:
          const EdgeInsets.only(
              top: 30.0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
              decoration: const BoxDecoration(
                  color: ThemeApp.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  accountTextList('Change KYC Image'),
                  SizedBox(
                    height: 10,
                  ),
                  Row( crossAxisAlignment: CrossAxisAlignment.center,   mainAxisAlignment: MainAxisAlignment.center,
                    children: [    InkWell(
                      onTap: () async {
                        _getGstCertCamera(ImageSource.camera);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.boxLightColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          // border: Border.all(color: ThemeApp.lightBorderColor)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SvgPicture.asset(
                            'assets/appImages/cameraIconGrey.svg',
                            color: ThemeApp.subIconColor,
                            semanticsLabel: 'Acme Logo',
                            height: 37,
                            // height: height * .03,
                          ),
                        ),
                      ),
                    ), SizedBox(
                      width: 10,
                    ),
                      InkWell(
                        onTap: () async {
                          _getGstCertCamera(ImageSource.gallery);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeApp.boxLightColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            // border: Border.all(color: ThemeApp.lightBorderColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SvgPicture.asset(
                              'assets/appImages/imageIcon.svg',
                              color: ThemeApp.subIconColor,
                              semanticsLabel: 'Acme Logo',
                              height: 37,
                              // height: height * .03,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // InkWell(
                      //   onTap: () async {
                      //     _getGstCertCamera(ImageSource.gallery);
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: ThemeApp.boxLightColor,
                      //       borderRadius: BorderRadius.all(Radius.circular(8)),
                      //       // border: Border.all(color: ThemeApp.lightBorderColor)
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(20),
                      //       child: SvgPicture.asset(
                      //         'assets/appImages/pdfIcon.svg',
                      //         color: ThemeApp.subIconColor,
                      //         semanticsLabel: 'Acme Logo',
                      //         height: 37,
                      //         // height: height * .03,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: InkWell(
            onTap: () {
              Navigator.pop(
                  context);
            },
            child: Container(
                alignment: Alignment
                    .center,
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: ThemeApp
                      .whiteColor,
                )),
          ),
        ),
      ],
    );
  }

  _getGstCertCamera(ImageSource imageSource) async {
    PickedFile? pickedFile = await ImagePicker( ).getImage(
      source: imageSource,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        gstCert = File(pickedFile.path);
      });uploadGSTImageToURLApi(File(pickedFile.path));
    }
  }

  /// uploadLicenceImageToURLApi
  Future uploadLicenceImageToURLApi(File imageFile) async {
    setState(() {
      showSpinner = true;
    });
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var url = ApiMapping.BASEAPI + ApiMapping.createImageURL;
    print(url);
    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('imageFile', stream, length,
        filename: path.basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print("response Image " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        showSpinner = false;
      });
      response.stream.transform(utf8.decoder).listen((value) {
        print("Image response " + value);

        String jsonString = value;
        Map<String, dynamic> d = json.decode(jsonString.trim());
        print(d['payload']['image_url']);
        var jsonMap = {
          "update_license":true,
          "license_image_url":d['payload']['image_url'],
          "license_number":"aSDFASDFASDF"
        };

        licencePostRequest(jsonMap, context);
        // List<MyModel> list = List<MyModel>.from(d['jsonArrayName'].map((x) => MyModel.fromJson(x)));
      });
    } else {
      setState(() {
        showSpinner = false;
      });
    }
  }
/// post licence url
  Future licencePostRequest(Map jsonMap, BuildContext context) async {
    dynamic responseJson;
    Map<String, String> queryParams = {
      'merchant_id': StringConstant.MerchantLoginId.toString(),
    };
    var url = ApiMapping.BaseAPI + '/merchant-kyc/updatekycdata';
    String queryString = Uri(queryParameters: queryParams).query;

    var requestUrl = '$url?$queryString';
    print(requestUrl.toString());
    print("response url : " + requestUrl.toString());
    print("jsonMap url : " + jsonMap.toString());

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(requestUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'licence PostRequest Response:');

    if (jsonData['status'].toString() == 'OK') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => KYCActivity(),
        ),
      );
    } else {
      Utils.errorToast("Please enter valid details.");
      httpClient.close();
      return responseJson;
    }
  }

  /// uploadLicenceImageToURLApi
  Future uploadAddressImageToURLApi(File imageFile) async {
    setState(() {
      showSpinner = true;
    });
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var url = ApiMapping.BASEAPI + ApiMapping.createImageURL;
    print(url);
    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('imageFile', stream, length,
        filename: path.basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print("response Image " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        showSpinner = false;
      });
      response.stream.transform(utf8.decoder).listen((value) {
        print("Image response " + value);

        String jsonString = value;
        Map<String, dynamic> d = json.decode(jsonString.trim());
        print(d['payload']['image_url']);
        var jsonMap = {
          "update_address_image":true,
          "address_image_url":d['payload']['image_url']
        };

        addressPostRequest(jsonMap, context);
        // List<MyModel> list = List<MyModel>.from(d['jsonArrayName'].map((x) => MyModel.fromJson(x)));
      });
    } else {
      setState(() {
        showSpinner = false;
      });
    }
  }
  /// post licence url
  Future addressPostRequest(Map jsonMap, BuildContext context) async {
    dynamic responseJson;
    Map<String, String> queryParams = {
      'merchant_id': StringConstant.MerchantLoginId.toString(),
    };
    var url = ApiMapping.BaseAPI + '/merchant-kyc/updatekycdata';
    String queryString = Uri(queryParameters: queryParams).query;

    var requestUrl = '$url?$queryString';
    print(requestUrl.toString());
    print("jsonMap url : " + jsonMap.toString());
    print("response url : " + requestUrl.toString());

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(requestUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'address PostRequest Response:');

    if (jsonData['status'].toString() == 'OK') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => KYCActivity(),
        ),
      );
    } else {
      Utils.errorToast("Please enter valid details.");
      httpClient.close();
      return responseJson;
    }
  }


  /// uploadPanImageToURLApi
  Future uploadPANImageToURLApi(File imageFile) async {
    setState(() {
      showSpinner = true;
    });
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var url = ApiMapping.BASEAPI + ApiMapping.createImageURL;
    print(url);
    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('imageFile', stream, length,
        filename: path.basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print("response Image " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        showSpinner = false;
      });
      response.stream.transform(utf8.decoder).listen((value) {
        print("Image response " + value);

        String jsonString = value;
        Map<String, dynamic> d = json.decode(jsonString.trim());
        print(d['payload']['image_url']);
        var jsonMap = {
          "update_pan":true,
          "pan_image_url":d['payload']['image_url'],
          "name_as_per_pan":"TARA BHAI MEHTA",
          "pan_number":"AAS1231AC"
        };
        PANPostRequest(jsonMap, context);
        // List<MyModel> list = List<MyModel>.from(d['jsonArrayName'].map((x) => MyModel.fromJson(x)));
      });
    } else {
      setState(() {
        showSpinner = false;
      });
    }
  }
  /// post licence url
  Future PANPostRequest(Map jsonMap, BuildContext context) async {
    dynamic responseJson;
    Map<String, String> queryParams = {
      'merchant_id': StringConstant.MerchantLoginId.toString(),
    };
    var url = ApiMapping.BaseAPI + '/merchant-kyc/updatekycdata';
    String queryString = Uri(queryParameters: queryParams).query;

    var requestUrl = '$url?$queryString';
    print(requestUrl.toString());
    print("jsonMap url : " + jsonMap.toString());
    print("response url : " + requestUrl.toString());

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(requestUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'PAN PostRequest Response:');

    if (jsonData['status'].toString() == 'OK') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => KYCActivity(),
        ),
      );
    } else {
      Utils.errorToast("Please enter valid details.");
      httpClient.close();
      return responseJson;
    }
  }


  /// uploadGSTImageToURLApi
  Future uploadGSTImageToURLApi(File imageFile) async {
    setState(() {
      showSpinner = true;
    });
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var url = ApiMapping.BASEAPI + ApiMapping.createImageURL;
    print(url);
    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('imageFile', stream, length,
        filename: path.basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print("response Image " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        showSpinner = false;
      });
      response.stream.transform(utf8.decoder).listen((value) {
        print("Image response " + value);

        String jsonString = value;
        Map<String, dynamic> d = json.decode(jsonString.trim());
        print(d['payload']['image_url']);
        var jsonMap = {
          "update_gst":true,
          "gst_image_url":d['payload']['image_url'],
          "is_gst_applicable":true,
          "gst_number":"AAS1231AC"
        };
        GSTPostRequest(jsonMap, context);
        // List<MyModel> list = List<MyModel>.from(d['jsonArrayName'].map((x) => MyModel.fromJson(x)));
      });
    } else {
      setState(() {
        showSpinner = false;
      });
    }
  }
  /// post licence url
  Future GSTPostRequest(Map jsonMap, BuildContext context) async {
    dynamic responseJson;
    Map<String, String> queryParams = {
      'merchant_id': StringConstant.MerchantLoginId.toString(),
    };
    var url = ApiMapping.BaseAPI + '/merchant-kyc/updatekycdata';
    String queryString = Uri(queryParameters: queryParams).query;

    var requestUrl = '$url?$queryString';
    print(requestUrl.toString());
    print("jsonMap url : " + jsonMap.toString());
    print("response url : " + requestUrl.toString());

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(requestUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'PAN PostRequest Response:');

    if (jsonData['status'].toString() == 'OK') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => KYCActivity(),
        ),
      );
    } else {
      Utils.errorToast("Please enter valid details.");
      httpClient.close();
      return responseJson;
    }
  }


}
