import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:velocit_merchant/Screens/Order_ui/Cancel_order_screen.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/proceedButtons.dart';
import 'package:velocit_merchant/utils/utils.dart';

import '../../utils/GlobalWidgets/appBar.dart';
import '../../utils/GlobalWidgets/okPopUp.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import '../../utils/styles.dart';
import 'Delivered_order_screen.dart';

class OrderDeliveryScreen extends StatefulWidget {
  const OrderDeliveryScreen({Key? key}) : super(key: key);

  @override
  State<OrderDeliveryScreen> createState() => _OrderDeliveryScreenState();
}

class _OrderDeliveryScreenState extends State<OrderDeliveryScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  TextEditingController controller = TextEditingController(text: "");
  FocusNode focusNode = FocusNode();
  var OTP;
  bool hasError = false;
  String otpMsg = "";
  String currentText = "";
  bool isOtpValid = false;

  @override
  void initState() {
    // TODO: implement initState
    isOtpValid = false;
    otpSuccess = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(
            context,
            appTitle(context, "Complete Order - OID12067800"),
            const SizedBox()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
              /*    isOtpValid == true
                      ? Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: ThemeApp.redColor,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              20, 20, 20, 20),
                          child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Icon(Icons.cancel_outlined,
                                    size: height * .05,
                                    color: ThemeApp.whiteColor),
                                SizedBox(width: width*0.02,),
                                Center(
                                  child: TextFieldUtils().dynamicText(
                                      'OTP not matched with Order,',
                                      context,
                                      TextStyle(
                                          color:
                                          ThemeApp.whiteColor,
                                          fontSize: height * .02,
                                          fontWeight:
                                          FontWeight.w400)),
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.clear();

                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor:
                                        Colors.white,
                                        builder: (context) {
                                          return bottomSheetForOtp();
                                        });
                                  },
                                  child: Text(
                                    " Try again",
                                    style: TextStyle(
                                        color: ThemeApp.whiteColor,
                                        fontSize: height * .02,
                                        fontWeight:
                                        FontWeight.w600),
                                  ),
                                ),
                              ]),
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {});
                              isOtpValid = false;
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.clear,
                                color: ThemeApp.whiteColor,
                              ),
                            )),
                      ],
                    ),
                  )
                      : SizedBox(
                    height: 0,
                  ),*/

                  // otpSuccess==true?  otpVerificationCompleted():SizedBox(  height: 0,),
                  // isOtpValid == true
                  //     ? SizedBox(
                  //   height: height * .03,
                  // )
                  //     : SizedBox(
                  //   height: 0,
                  // ),
                  // otpSuccess == true
                  //     ? SizedBox(
                  //   height: height * .03,
                  // )
                  //     : SizedBox(
                  //   height: 0,
                  // ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: ThemeApp.whiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        onTap: () {
                          controller.clear();

                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              builder: (context) {
                                return bottomSheetForOtp();
                              });
                        },
                        child: Row(children: [
                          const Icon(Icons.image),
                          SizedBox(
                            width: width * .1,
                          ),
                          Center(
                            child: TextFieldUtils().dynamicText(
                                'Deliver by OTP',
                                context,
                                TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: height * .023,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  TextFieldUtils().dynamicText(
                      'OR',
                      context,
                      TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: height * .023,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: height * .03,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: ThemeApp.whiteColor,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFieldUtils().dynamicText(
                              'Deliver by Images Upload',
                              context,
                              TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: height * .023,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: height * .02,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(3),
                                    padding: const EdgeInsets.all(0),
                                    color: ThemeApp.textFieldBorderColor,
                                    dashPattern: [3, 3],
                                    strokeWidth: 1.5,
                                    child: imageFile1 == null
                                        ? InkWell(
                                      onTap: () {
                                        _getFromCamera1();
                                      },
                                      child: Container(
                                          height: height * 0.12,
                                          width: width,
                                          alignment:
                                          Alignment.center,
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Icon(Icons.add,
                                                    size: height *
                                                        .04),
                                                TextFieldUtils().dynamicText(
                                                    'Capture',
                                                    context,
                                                    TextStyle(
                                                        color: Colors
                                                            .grey
                                                            .shade700,
                                                        fontSize:
                                                        height *
                                                            .02,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400)),
                                              ])),
                                    )
                                        : Stack(
                                      children: [
                                        Container(
                                          height: height * 0.12,
                                          width: width,
                                          child: Image.file(
                                            imageFile1!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                imageFile1 = null;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(5),
                                              child: Container(
                                                alignment: Alignment
                                                    .topRight,
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: ThemeApp
                                                      .whiteColor,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  )),
                              SizedBox(width: width * .03),
                              Expanded(
                                  flex: 1,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(3),
                                    padding: const EdgeInsets.all(0),
                                    color: ThemeApp.textFieldBorderColor,
                                    dashPattern: [3, 3],
                                    strokeWidth: 1.5,
                                    child: imageFile2 == null
                                        ? InkWell(
                                      onTap: () {
                                        _getFromCamera2();
                                      },
                                      child: Container(
                                          height: height * 0.12,
                                          width: width,
                                          alignment:
                                          Alignment.center,
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Icon(Icons.add,
                                                    size: height *
                                                        .04),
                                                TextFieldUtils().dynamicText(
                                                    'Capture',
                                                    context,
                                                    TextStyle(
                                                        color: Colors
                                                            .grey
                                                            .shade700,
                                                        fontSize:
                                                        height *
                                                            .02,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400)),
                                              ])),
                                    )
                                        : Stack(
                                      children: [
                                        Container(
                                          height: height * 0.12,
                                          width: width,
                                          child: Image.file(
                                            imageFile2!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                imageFile2 = null;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(5),
                                              child: Container(
                                                alignment: Alignment
                                                    .topRight,
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: ThemeApp
                                                      .whiteColor,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  )),
                              SizedBox(width: width * .03),
                              Expanded(
                                  flex: 1,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(3),
                                    padding: const EdgeInsets.all(0),
                                    color: ThemeApp.textFieldBorderColor,
                                    dashPattern: [3, 3],
                                    strokeWidth: 1.5,
                                    child: imageFile3 == null
                                        ? InkWell(
                                      onTap: () {
                                        _getFromCamera3();
                                      },
                                      child: Container(
                                          height: height * 0.12,
                                          width: width,
                                          alignment:
                                          Alignment.center,
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                Icon(Icons.add,
                                                    size: height *
                                                        .04),
                                                TextFieldUtils().dynamicText(
                                                    'Capture',
                                                    context,
                                                    TextStyle(
                                                        color: Colors
                                                            .grey
                                                            .shade700,
                                                        fontSize:
                                                        height *
                                                            .02,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400)),
                                              ])),
                                    )
                                        : Stack(
                                      children: [
                                        Container(
                                          height: height * 0.12,
                                          width: width,
                                          child: Image.file(
                                            imageFile3!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                imageFile3 = null;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(5),
                                              child: Container(
                                                alignment: Alignment
                                                    .topRight,
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: ThemeApp
                                                      .whiteColor,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
              proceedButton("Complete Order", ThemeApp.tealButtonColor,
                  context,false, () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OrderCompletedSuccessful()));
                  })
            ],
          )

        ),
      ),
    );
  }

  /// Get from camera
  _getFromCamera1() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile1 = File(pickedFile.path);
      });
    }
  }

  /// Get from camera
  _getFromCamera2() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile2 = File(pickedFile.path);
      });
    }
  }

  /// Get from camera
  _getFromCamera3() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile3 = File(pickedFile.path);
      });
    }
  }

  Widget bottomSheetForOtp() {
    return SingleChildScrollView(
      child: Container(
        color: ThemeApp.innerBoxesColor,
        // height: height * .4,
        padding: MediaQuery
            .of(context)
            .viewInsets,
        // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height * .03,
            ),
            TextFieldUtils().dynamicText(
                'Enter OTP shared with Customer',
                context,
                const TextStyle(
                    color: ThemeApp.primaryNavyBlackColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: height * .04,
            ),
            PinCodeTextField(
              autofocus: false,
              controller: controller,
              hideCharacter: true,
              highlight: false,
              defaultBorderColor: ThemeApp.appBackgroundColor,
              hasTextBorderColor:
              controller.text.length <= 5 ? Colors.red : ThemeApp.appColor,

              // highlightPinBoxColor: Colors.orange,
              maxLength: 6,
              hasError: hasError,
              focusNode: focusNode,
              onTextChanged: (value) {
                setState(() {
                  if (value.length <= 5) {
                    otpMsg = "Please Enter Otp";
                  } else {
                    otpMsg = '';
                  }
                  currentText = value;
                });
              },
              onDone: (text) {
                print("OTP :  $text");
                print("OTP CONTROLLER ${controller.text}");
              },
              pinBoxWidth: 50,
              pinBoxHeight: 60,
              hasUnderline: false,
              wrapAlignment: WrapAlignment.spaceAround,
              pinBoxDecoration:
              ProvidedPinBoxDecoration.defaultPinBoxDecoration,
              pinTextStyle: const TextStyle(fontSize: 22.0),
              pinTextAnimatedSwitcherTransition:
              ProvidedPinBoxTextAnimation.scalingTransition,
              pinBoxRadius: 10,
//                    pinBoxColor: Colors.green[100],
              pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 300),
//                    highlightAnimation: true,
              highlightAnimationBeginColor: Colors.black,
              highlightAnimationEndColor: Colors.white12,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: height * .04,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: proceedButton(
                  'Verify OTP', ThemeApp.tealButtonColor, context,false, () {
                setState(() {});
                isOtpisValid();
                Navigator.pop(context);
              }),
            ),
            SizedBox(
              height: height * .02,
            ),
          ],
        ),
      ),
    );
  }

  bool otpSuccess = false;

  isOtpisValid() {
    if (controller.text.isEmpty || controller.text.length <= 5) {
      isOtpValid = true;
      Utils.errorToast('OTP not matched with Order');
      print(isOtpValid);
      print(controller.text.length.toString());
    } else {
      Utils.successToast('OTP Verification Successful');

      otpSuccess = true;
      isOtpValid = false;
      print(isOtpValid);
    }
  }

  Widget otpVerificationCompleted() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: ThemeApp.greenappcolor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OrderCompletedSuccessful()));
                  },
                  child: Row(children: [
                    Icon(
                      Icons.task_alt,
                      size: MediaQuery
                          .of(context)
                          .size
                          .height * .04,
                      color: ThemeApp.whiteColor,
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * .05,
                    ),
                    TextFieldUtils().dynamicText(
                        'OTP Verification Successful ',
                        context,
                        TextStyle(
                            color: ThemeApp.whiteColor,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .height * .022,
                            fontWeight: FontWeight.w400)),
                  ]),
                ),
              ),
            ),
          ],
        ),
        InkWell(
            onTap: () {
              setState(() {});
              otpSuccess = false;
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(0,10,10,0),
              alignment: Alignment.topRight,
              child: const Icon(
                Icons.clear,
                color: ThemeApp.whiteColor,
              ),
            )),
      ],
    );
  }
}

class OrderCompletedSuccessful extends StatelessWidget {
  const OrderCompletedSuccessful({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      body: SafeArea(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          // color: ThemeApp.appBackgrounColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFieldUtils().dynamicText(
                    'Order Completed ',
                    context,
                    TextStyle(
                        color: ThemeApp.primaryNavyBlackColor,
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .height * .04,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .02,
                ),
                Center(
                  child: Column(
                    children: [
                      Text('Congratulations! You have successfully',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height * .024,
                              fontWeight: FontWeight.w400)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('completed order',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height * .024,
                                  fontWeight: FontWeight.w400)),
                          Text(' OID12061800',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height * .024,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .04,
                ),
                proceedButton("Back to Active Orders", ThemeApp.tealButtonColor,
                    context,false, () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context) => const OrderDashboard()));

                    }),      
                     proceedButton("Cancel Orders", ThemeApp.tealButtonColor,
                    context, false,() {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context) => const CancelOrderScreen()));

                    }),
                      proceedButton("Delivered Orders", ThemeApp.tealButtonColor,
                    context, false,() {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context) => const DeliveredOrderScreen()));

                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
