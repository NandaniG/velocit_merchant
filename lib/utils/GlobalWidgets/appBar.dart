import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:velocit_merchant/Screens/MainScreens/Notification_screen.dart';
import 'package:velocit_merchant/Screens/MainScreens/raise_view_tickets.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/proceedButtons.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/textFormFields.dart';

import '../../Screens/MainScreens/Stock_screen.dart';
import '../../Screens/MainScreens/report_screen.dart';
import '../../Screens/MyAccount_Ui/my_account.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;

import '../features/scannerWithGallery.dart';
import '../utils.dart';
import 'SpeechToTextDialog_Screen.dart';
import 'autoSearchLocation_popup.dart';

speechToText.SpeechToText? speech;

Widget appBarWidget(
  BuildContext context,
  Widget titleWidget,
  Widget location,
  void setState,
) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;

  return SafeArea(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: ThemeApp.appBackgroundColor,
          child: AppBar(
            centerTitle: true,
            // elevation: 1,
            shadowColor:ThemeApp.appBackgroundColor ,
            backgroundColor: ThemeApp.appBackgroundColor,
            flexibleSpace: Container(
              height: height * .08,
              width: width,
              decoration: const BoxDecoration(
                color: ThemeApp.appBackgroundColor,
              ),
            ),
            leading: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyAccountActivity(),
                  ),
                );
              },
              child: Container(
                  alignment: Alignment.center,
                  child:
                      Icon(Icons.menu, color: ThemeApp.blackColor, size: 30)),
            ),
            // leadingWidth: width * .07,
            title: titleWidget,
            actions: [
              InkWell(
                onTap:(){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
              },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 10),
                  child: Image.asset('assets/appImages/notificationIcon.png',
                      color: ThemeApp.primaryNavyBlackColor,
                      height: 20,
                      fit: BoxFit.fitWidth),
                ),
              ),
            ],
          ),
        ),
        location
      ],
    ),
  );
}

Widget appBar_backWidget(
  BuildContext context,
  Widget titleWidget,
  Widget location,
) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey();

  return SafeArea(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        color: ThemeApp.appBackgroundColor,
        child: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: ThemeApp.appBackgroundColor,
          flexibleSpace: Container(
            height: height * .08,
            width: width,
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
              Navigator.of(context).pop();
            },
            child: Transform.scale(
                scale: 1.3,
                child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
          ),

          // leadingWidth: width * .06,
          title: titleWidget,
          // Row
        ),
      ),
      location
    ],
  ));
}

Widget appTitle(BuildContext context, String text) {
  return Container(
    alignment: Alignment.centerLeft,
    child: TextFieldUtils().dynamicText(
        text,
        context,
        const TextStyle(
            color: ThemeApp.blackColor,
            fontSize: 16,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400)),
  );
}

//codeElan.velocIT
Widget searchBar(BuildContext context) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  return Container(
    width: width,
    height: height * .1,
    // color: ThemeApp.innerTextFieldErrorColor,
    padding: const EdgeInsets.only(top: 10, left: 0),
    alignment: Alignment.center,
    child: TextFormField(
      textInputAction: TextInputAction.search,

      controller: StringConstant.controllerSpeechToText,
      onFieldSubmitted: (value) {
        print("search");
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return OkDialog(text: StringConstant.controllerSpeechToText.text);
        //     });
      },
      onChanged: (val) {
        // print("StringConstant.speechToText..." +
        //     StringConstant.speechToText);
        // (() {
        //   if (val.isEmpty) {
        //     val = StringConstant.speechToText;
        //   } else {
        //     StringConstant.speechToText = StringConstant.controllerSpeechToText.text;
        //   }
        // });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: ThemeApp.whiteColor,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        /* -- Text and Icon -- */
        hintText: "Search for Products...",
        hintStyle: const TextStyle(
          fontSize: 18,
          color: ThemeApp.darkGreyTab,
        ),
        prefixIcon: Image.asset(
          'assets/appImages/SearchIcon.png',
          color: ThemeApp.primaryNavyBlackColor,
          height: 35,
          width: 22,
        ),

        suffixIcon: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SpeechToTextDialog();
                });
          },
          child: Image.asset(
            'assets/appImages/SpeechIcon.png',
            color: ThemeApp.primaryNavyBlackColor,
            height: 35,
            width: 22,
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: ThemeApp.innerTextFieldErrorColor, width: 1)),
        // OutlineInputBorder
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: ThemeApp.backgroundColor, width: 1)),
        // OutlineInputBorder
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: ThemeApp.backgroundColor, width: 1)),
      ), // InputDecoration
    ),
  );
}

Widget addressWidget(BuildContext context, String addressString) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  return InkWell(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AutoSearchPlacesPopUp();
          });
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => AddressScreen(),
      //   ),
      // );
    },
    child: Center(
      child: Container(
        height: height * .036,
        color: ThemeApp.darkGreyTab,
        width: width,
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * .02,
            ),
            Icon(
              Icons.not_listed_location_outlined,
              color: ThemeApp.whiteColor,
              size: MediaQuery.of(context).size.height * .028,
            ),
            SizedBox(
              width: width * .01,
            ),
            SizedBox(
              child: TextFieldUtils().subHeadingTextFieldsWhite(
                  "Deliver to - $addressString ", context),
            ),
            //Text(StringConstant.placesFromCurrentLocation),
            SizedBox(
              width: width * .01,
            ),
            Icon(
              Icons.mode_edit_outlined,
              color: ThemeApp.whiteColor,
              // size: 20,
              size: MediaQuery.of(context).size.height * .028,
            ),
          ],
        ),
      ),
    ),
  );
}

final List _tabIcons = List.unmodifiable([
  {'icon': 'assets/icons/home.png'},
  {'icon': 'assets/icons/percentage.png'},
  {'icon': 'assets/icons/percentage.png'},
  {'icon': 'assets/icons/shop.png'},
  {'icon': 'assets/icons/shopping-cart.png'},
]);

final List<Widget> _tabs = List.unmodifiable([
  // SearchList(),
  const OrderDashboard(),
  Container(),
  Container(),
  Container(),
  Container(),
]);

Widget bottomNavBarItems(BuildContext context) {
  int _currentIndex = 0;
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: _currentIndex,
    onTap: (int index) {
      _currentIndex = index;
      if (_currentIndex == 0) {
        // Navigator.pushNamed(context, '/dashBoardScreen');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OrderDashboard(),
            ),
            (route) => false);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));

      }
      if (_currentIndex == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const StockScreen(),
            ),
                (route) => false);
      }
      if (_currentIndex == 3) {

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const TicketsPageActivity(),
            ),
                (route) => false);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ShopByCategoryActivity(
        //           shopByCategoryList:
        //           provider.jsonData["shopByCategoryList"],
        //           shopByCategorySelected:0),
        //     ),
        //         (route) => false);
      }
      if (_currentIndex == 4) {
        // colors = ThemeApp.blackColor;

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ReportScreen()),
            (route) => false);
      }
    },
    items: [
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: _currentIndex == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.shopping_bag_outlined,  size: 35,color: ThemeApp.appColor,)
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.shopping_bag_outlined,  size: 35)
                ),
          label: ''),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: _currentIndex == 1
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child:   Icon(Icons.dashboard,  size: 35,color: ThemeApp.appColor,)
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child:  Icon(Icons.dashboard,  size: 35,color: ThemeApp.appColor,)
                ),
          label: ''),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: _currentIndex == 2
              ? const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.add, color: Colors.transparent),
                )
              : const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.add, color: Colors.transparent),
                ),
          label: ''),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: _currentIndex == 3
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child:
                  Icon(Icons.post_add_outlined,  size: 35,color: ThemeApp.appColor,)/* Image.asset('assets/icons/shop.png', height: 30),*/
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.post_add_outlined,  size: 35,color: ThemeApp.appColor,)
            /*Image.asset('assets/icons/shop.png', height: 30),*/
                ),
          label: ''),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Stack(
            children: <Widget>[
              _currentIndex == 4
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Icon(Icons.event_note,  size: 35,color: ThemeApp.appColor,) /*Image.asset('assets/icons/shopping-cart.png',
                          height: 35),*/
                    )
                  :  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.event_note,size: 35,color: ThemeApp.appColor,) /*Image.asset('assets/icons/shopping-cart.png',
                          height: 35),*/
              )
            ],
          ),

          // _currentIndex == 4
          //     ? Padding(
          //         padding: const EdgeInsets.only(top: 5.0),
          //         child: Image.asset('assets/icons/shopping-cart.png',
          //             height: 30),
          //       )
          //     : Padding(
          //         padding: const EdgeInsets.only(top: 5.0),
          //         child: Image.asset('assets/icons/shopping-cart.png',
          //             height: 30),
          //       ),
          label: ''),
    ],
  );
}

Widget bottomNavigationBarWidget(BuildContext context) {
  final controller = BarcodeFinderController();
  return Stack(
    alignment: const FractionalOffset(.5, 1.0),
    children: [
      bottomNavBarItems(context),
      Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Container(
          margin: EdgeInsets.only(bottom: 50),
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: ThemeApp.appColor,
            onPressed: () {
              // scanQRCode();
              // scanFile();
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => StepperScreen(),
              //   ),
              // );
              showModalBottomSheet(
                  isDismissible: true,
                  context: context,
                  builder: (context) {
                    return ScannerWidget(state: controller.state);
                  });
            },
            child: const Icon(Icons.document_scanner_outlined,
                color: ThemeApp.whiteColor),
          ),
        ),
      ),
    ],
  );
}

class ScannerWidget extends StatefulWidget {
  BarcodeFinderState state;

  ScannerWidget({Key? key, required this.state}) : super(key: key);

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  var getResult = 'QR Code Result';
  final controller = BarcodeFinderController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _scanBarcode = 'Please scan proper content';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .25,
      color: Colors.cyan,
      margin: const EdgeInsets.all(10.0),
      child: Scaffold(
          key: _scaffoldKey,
          body: Center(
            child: Wrap(
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) {
                    final state = controller.state;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        proceedButton(
                            "Scan with Camera", ThemeApp.darkGreyColor, context,
                            () {
                          // Navigator.of(context).pop();

                          scanQR();
                        }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        _startScanFileButton(state),
                        // const Text(
                        //   'Code:',
                        //   textAlign: TextAlign.center,
                        // ),
                        /*    if (state is BarcodeFinderLoading)
                          _loading()
                        else if (state is BarcodeFinderError)


                          _text(
                            '${state.message}',
                          )
                        else if (state is BarcodeFinderSuccess)
                          _text(
                            '${state.code}',
                          ),*/
                      ],
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget _loading() => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: CircularProgressIndicator(
          color: ThemeApp.darkGreyColor,
        )),
      );

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      _scanBarcode = barcodeScanRes;
      print('_scanBarcode : ' + barcodeScanRes);
      print('_scanBarcode : ' + _scanBarcode);

      if (_scanBarcode == '-1') {
        Utils.flushBarErrorMessage("Please scan proper content", context);
      } else {
        Utils.successToast(_scanBarcode);
      }
      print('_scanBarcode timer... : ' + _scanBarcode);

      if (!mounted) return;
      print('_scanBarcode : ' + _scanBarcode);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant
  }

  Widget _startScanFileButton(BarcodeFinderState state) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: ThemeApp.darkGreyColor,
      ),
      child: InkWell(
          onTap: state is! BarcodeFinderLoading
              ? () async {
                  FilePickerResult? pickedFile =
                      await FilePicker.platform.pickFiles();
                  if (pickedFile != null) {
                    String? filePath = pickedFile.files.single.path;
                    if (filePath != null) {
                      final file = File(filePath);
                      controller.scanFile(file);
                    }
                  } else {
                    Utils.errorToast('Please select content');
                  }
                }
              : null,
          child: TextFieldUtils().usingPassTextFields(
              "Open Gallery", ThemeApp.whiteColor, context)),
    );
  }
}
