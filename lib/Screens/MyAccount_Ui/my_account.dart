import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Screens/Auth_Screens/sign_in.dart';
import 'package:velocit_merchant/Screens/MyAccount_Ui/FAQs/frequently_asked_questions.dart';
import 'package:velocit_merchant/Screens/MyAccount_Ui/KYC/kyc_page.dart';
import 'package:velocit_merchant/Screens/MyAccount_Ui/profileImageDialog.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../Core/Model/userModel.dart';
import '../../Core/repository/auth_repository.dart';
import '../../Routes/Routes.dart';
import '../../utils/GlobalWidgets/appBar.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import 'EditAccount/EditAccountActivity.dart';

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
    getPreference();
  }

  getPreference() async {
    final preferences = await SharedPreferences.getInstance();

    StringConstant.UserLoginId =
        (await preferences.getString('isUserId'))!;

    StringConstant.userAccountName =
        (await preferences.getString('usernameLogin'))!;
    StringConstant.userAccountEmail =
    (await preferences.getString('emailLogin'))!;
    StringConstant.userAccountMobile =
        (await Prefs.instance.getToken(StringConstant.userAccountMobilePref))!;
    StringConstant.userAccountPass =
        (await Prefs.instance.getToken(StringConstant.userAccountPassPref))!;
    print(StringConstant.userAccountName);

    StringConstant.userAccountImagePicker = (await Prefs.instance
        .getToken(StringConstant.userAccountImagePickerPref))!;

    print("StringConstant.userAccountImagePicker");
    print(StringConstant.userAccountImagePicker);
    setState(() {});

    final prefs = await SharedPreferences.getInstance();
    bool check = prefs.containsKey('profileImagePrefs');
    if (check) {
      setState(() {
        print("yes/./././.");
        StringConstant.ProfilePhoto = prefs.getString('profileImagePrefs')!;
      });
      return;
    } else {
      StringConstant.ProfilePhoto = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute);
        // Navigator.of(context).pop();
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

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          RoutesName.dashboardRoute, (route) => false)
                      .then((value) {
                    setState(() {});
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
        bottomNavigationBar: bottomNavigationBarWidget(context, 0),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
            child: FutureBuilder<UserModel>(
                future: AuthRepository()
                    .getUserDetailsById(StringConstant.UserLoginId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? Container(
          color: ThemeApp.appBackgroundColor,
          width: width,
          child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .27,
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
                            StringConstant.ProfilePhoto.toString() != null
                                ? Stack(
                                    // alignment: Alignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 110.0,
                                          height: 110.0,
                                          decoration: new BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: ThemeApp.buttonShade2,
                                                  spreadRadius: 1,
                                                  blurRadius: 5)
                                            ],
                                            border: Border.all(
                                                color: ThemeApp.whiteColor,
                                                width: 4),
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(100)),
                                            child: Image.file(
                                              File(StringConstant.ProfilePhoto),
                                              fit: BoxFit.fitWidth,
                                              width: 90.0,
                                              height: 90.0,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.image,
                                                  color: ThemeApp.whiteColor,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: width / 2.5,
                                        // width: 130.0,

                                        // height: 40.0,
                                        child: InkWell(
                                            onTap: () {
                                              // _getFromCamera();

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
                                                    return Stack(
                                                      alignment: Alignment
                                                          .center, // <---------

                                                      children: [
                                                        Container(
                                                          width: width,
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  top: 30.0),
                                                          child:
                                                              bottomSheetForImagePicker(),
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
                                                  });
                                              // showDialog(
                                              //     context: context,
                                              //     builder: (BuildContext context) {
                                              //       return ProfileImageDialogBox(
                                              //         imageFile1: imageFile1,
                                              //         isEditAccount: true,
                                              //       );
                                              //     });
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
                                                  'assets/appImages/cameraIcon.svg',
                                                  color: ThemeApp.whiteColor,
                                                  semanticsLabel: 'Acme Logo',

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
                                                  color: ThemeApp.buttonShade2,
                                                  spreadRadius: 1,
                                                  blurRadius: 15)
                                            ],
                                            color: ThemeApp.buttonShade2,
                                            border: Border.all(
                                                color: ThemeApp.whiteColor,
                                                width: 7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(100)),
                                            child: Image.file(
                                              File(StringConstant.ProfilePhoto),
                                              fit: BoxFit.fitWidth,
                                              width: 130.0,
                                              height: 130.0,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.image,
                                                  color: ThemeApp.whiteColor,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: width / 2.5,
                                        // width: 130.0,

                                        // height: 40.0,
                                        child: InkWell(
                                            onTap: () {
                                              // _getFromCamera();
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return ProfileImageDialogBox(
                                                      imageFile1: imageFile1,
                                                      isEditAccount: true,
                                                    );
                                                  });
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
                                                  'assets/appImages/cameraIcon.svg',
                                                  color: ThemeApp.whiteColor,
                                                  semanticsLabel: 'Acme Logo',

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
                            SizedBox(
                              height: 20,
                            ),
                            TextFieldUtils().dynamicText(
                                // StringConstant.userAccountName,
                                snapshot.data!.payload!.username.toString()??'',
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
                                snapshot.data!.payload!.email
                                    .toString()??"",
                                context,
                                TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.lightFontColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    letterSpacing: -0.25)),
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => KYCActivity(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    iconsUtils(
                                        'assets/appImages/KYCIcon.svg', 18.65, 18),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    accountTextList('KYC'),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const FAQsActivity(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    iconsUtils('assets/appImages/headPhoneIcon.svg',
                                        18.65, 18),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    accountTextList('Frequently asked questions'),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditAccountActivity(
                                        // payload:
                                        //     snapshot.data!.payload,
                                        ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    iconsUtils(
                                        'assets/appImages/settingIcon.svg', 20, 18),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    accountTextList('Edit profile'),
                                  ],
                                ),
                              ),
                            ), //change password

                            //sign out
                            InkWell(
                              onTap: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setInt('isUserLoggedIn', 0);
                                prefs.setString('RandomUserId', '');
                                StringConstant.UserLoginId = '';
                                StringConstant.RandomUserLoginId = '';
                                StringConstant.UserCartID = '';
                                StringConstant.BadgeCounterValue = '';
                                StringConstant.ScannedProductId = '';
                                final pref = await SharedPreferences.getInstance();
                                Utils.successToast('You are signed out');
                                await pref.clear();

                                Navigator.pushReplacementNamed(
                                        context, RoutesName.dashboardRoute)
                                    .then((value) {
                                  prefs.setBool('isLogin', false);
                                  StringConstant.isLogIn = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    iconsUtils(
                                        'assets/appImages/signOutIcon.svg', 18, 18),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    accountTextList('Sign Out'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
          ),
        ):SizedBox();
              }
            )),
      ),
    );
  }

  Widget iconsUtils(String svgIcon, double height, double width) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: ThemeApp.appColor),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: SvgPicture.asset(
          svgIcon,
          color: ThemeApp.whiteColor,
          semanticsLabel: 'Acme Logo',
          height: height,
          width: width,
          // height: height * .03,
        ),
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

  Widget bottomSheetForImagePicker() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
        decoration: const BoxDecoration(
            color: ThemeApp.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            accountTextList('Change Profile Photo'),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();

                    FilePickerResult? pickedFile =
                        await FilePicker.platform.pickFiles();
                    if (pickedFile != null) {
                      String? filePath = pickedFile.files.single.path;
                      if (filePath != null) {
                        final file = File(filePath);
                        await prefs.setString('profileImagePrefs', filePath);

                        imageFile1 = file;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MyAccountActivity(),
                          ),
                        );
                      }
                    }
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
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    var image =
                        await picker.getImage(source: ImageSource.camera);
                    final prefs = await SharedPreferences.getInstance();
                    // StringConstant.CurrentPinCode = (prefs.getString('CurrentPinCodePref') ?? '');
                    String imagePath = image!.path;

                    await prefs.setString('profileImagePrefs', imagePath);
                    Map data = {
                      "imgUrl": image.path,
                    };

                    setState(() {
                      imageFile1 = File(image.path);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MyAccountActivity(),
                        ),
                      );
                    });
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Future _getFromCamera() async {
//   var image = await picker.getImage(source: ImageSource.camera);
//   final prefs = await SharedPreferences.getInstance();
//   // StringConstant.CurrentPinCode = (prefs.getString('CurrentPinCodePref') ?? '');
//   String imagePath = image!.path;

//   await prefs.setString('profileImagePrefs', imagePath);

//   setState(() {
//     imageFile1 = File(image.path);

//     // final   file = File(image!.path);
//     //    final bytes =
//     //    file!.readAsBytesSync();
//     //   final img64 = base64Encode(bytes);
//   });
//   // Navigator.pop(this.context);
// }

}
