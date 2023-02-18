import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Screens/MyAccount_Ui/profileImageDialog.dart';

import '../../../../Core/Model/userModel.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../Routes/Routes.dart';
import '../../../utils/GlobalWidgets/proceedButtons.dart';
import '../../../utils/GlobalWidgets/textFormFields.dart';
import '../../../utils/StringUtils.dart';
import 'OTPVerificationDialog.dart';

class EditAccountActivity extends StatefulWidget {
  // final Payload? payload;

  EditAccountActivity({
    Key? key,
    /*this.payload*/
  }) : super(key: key);

  @override
  State<EditAccountActivity> createState() => _EditAccountActivityState();
}

class _EditAccountActivityState extends State<EditAccountActivity> {
  double height = 0.0;
  double width = 0.0;
  final picker = ImagePicker();
  late File _profileImage;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  TextEditingController userNameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  bool _validateFullName = false;
  bool _validateMobile = false;
  bool _validateEmail = false;

  @override
  void initState() {
    // TODO: implement initState

    getPrefValue();
    getUserData();
    super.initState();
  }

  getPrefValue() async {
    final prefs = await SharedPreferences.getInstance();
    bool check = prefs.containsKey('profileImagePrefs');
    if (check) {
      setState(() {
        print("yes/./././.");
        StringConstant.ProfilePhoto = prefs.getString('profileImagePrefs')!;
      });
      return;
    }
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      StringConstant.userProfileName =
          prefs.getString('userProfileNamePrefs') ?? "";
      StringConstant.userProfileEmail =
          prefs.getString('userProfileEmailPrefs') ?? "";
      StringConstant.userProfileMobile =
          prefs.getString('userProfileMobilePrefs') ?? "";
      userNameController =
          TextEditingController(text: StringConstant.userProfileName);
      mobileController =
          TextEditingController(text: StringConstant.userProfileMobile);
      emailController =
          TextEditingController(text: StringConstant.userProfileEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeApp.appBackgroundColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.myAccountRoute);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: ThemeApp.blackColor,
            ),
          ),
        ),
        title: TextFieldUtils().dynamicText(
            'Edit my Account',
            context,
            TextStyle(
                fontFamily: 'Roboto',
                color: ThemeApp.blackColor,
                // fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height * .022,
                fontWeight: FontWeight.w500)),
      ),
      body: SafeArea(
        child: ListView(
          children: [mainUI()],
        ),
      ),
    );
  }

  Widget mainUI() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: ThemeApp.whiteColor,
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageFile1 != null
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
                                color: ThemeApp.whiteColor, width: 4),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Image.file(
                              imageFile1!,
                              fit: BoxFit.fill,
                              width: 110.0,
                              height: 110.0,
                              errorBuilder: (context, error, stackTrace) {
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
                        bottom: 0, right: width / 2.7,
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
                                        isEditAccount: false);
                                  });
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
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
                                color: ThemeApp.whiteColor, width: 7),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Image.file(
                              File(StringConstant.ProfilePhoto),
                              fit: BoxFit.fitWidth,
                              width: 110.0,
                              height: 110.0,
                              errorBuilder: (context, error, stackTrace) {
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
                        bottom: 0, right: width / 2.7,
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
                                        isEditAccount: false);
                                  });
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
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
            /*     imageFile1 != null
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          // height: 50,width:50,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () async {
                              _getFromCamera();
                            },
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              child: Image.file(
                                imageFile1!,
                                fit: BoxFit.fill,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                        ))
                    : Align(
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () async {
                                _getFromCamera();
                              },
                              child: Icon(
                                Icons.account_circle_rounded,
                                size: height * .15,
                                color: ThemeApp.backgroundColor,
                              ),
                            ))),*/
            SizedBox(
              height: height * .03,
            ),
            TextFieldUtils().asteriskTextField(
              StringUtils.fullName,
              context,
            ),
            CharacterTextFormFieldsWidget(
                // isEnable: true,
                errorText: StringUtils.enterFullName,
                textInputType: TextInputType.name,
                controller: userNameController,
                autoValidation: AutovalidateMode.onUserInteraction,
                intialvalue: 'Testing Name',
                hintText: 'Full Name',
                onChange: (val) {
                  setState(() {
                    if (val.isEmpty && userNameController.text.isEmpty) {
                      _validateFullName = true;
                    } else {
                      _validateFullName = false;
                    }
                  });
                },
                validator: (value) {
                  if (value.isEmpty && userNameController.text.isEmpty) {
                    _validateFullName = true;
                    return StringUtils.validUserNameError;
                  } else {
                    _validateFullName = false;
                  }
                  return null;
                }),
            SizedBox(
              height: height * .02,
            ),
            Text(
              StringUtils.emailAddress,
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ThemeApp.primaryNavyBlackColor,
              ),
            ),
            EmailTextFormFieldsWidget(
                enabled: false,
                errorText: StringUtils.validEmailError,
                textInputType: TextInputType.emailAddress,
                controller: emailController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: '',
                onChange: (val) {},
                validator: (val) {
                  return null;
                }),
            SizedBox(
              height: height * .02,
            ),
            Text(
              StringUtils.mobileNumber,
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ThemeApp.primaryNavyBlackColor,
              ),
            ),
            MobileNumberTextFormField(
                controller: mobileController,
                enable: false,
                onChanged: (phone) {
                  print(phone.completeNumber);
                  if (phone.countryCode == "IN") {
                    print("india selected");
                    print(phone.completeNumber);
                  } else {
                    print("india not selected");
                  }
                },
                validator: (value) {
                  return null;
                }),
            SizedBox(
              height: 5,
            ),
            Text(
              "In order to prevent unauthorized access of personal information, request you to contact admin for changing the registered mobile number and email address.",
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ThemeApp.lightFontColor,
              ),
            ),
            SizedBox(
              height: height * .03,
            ),
            updateButton(),
            SizedBox(
              height: height * .02,
            ),
          ],
        ),
      ),
    );
  }

  File? imageFile1;

  // _getFromCamera() async {
  //
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedImage != null) {
  //     setState(() {
  //       imageFile1 = File(pickedImage.path);
  //       // isEnable = true;
  //
  //     });
  //   }
  // }

  Future _getFromCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
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

  bool isEnable = false;

/*  Widget fullName(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().dynamicText(
            StringUtils.fullName,
            context,
            TextStyle(
                fontFamily: 'Roboto',
                color: ThemeApp.blackColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w600)),
        CharacterTextFormFieldsWidget(
            isEnable: true,
            errorText: StringUtils.enterFullName,
            textInputType: TextInputType.name,
            controller: provider.userNameController,
            autoValidation: AutovalidateMode.onUserInteraction,
            hintText: 'Type your name',
            onChange: (val) {},
            validator: (value) {
              return null;
            }),
      ],
    );
  }

  Widget mobileNumber(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().dynamicText(
            StringUtils.mobileNumber,
            context,
            TextStyle(
                fontFamily: 'Roboto',
                color: ThemeApp.blackColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w600)),
        MobileNumberTextFormField(
            controller: provider.userMobileController,
            enable: false,
            validator: (value) {
              if (value.isEmpty && provider.userMobileController.text.isEmpty) {
                _validateMobile = true;
                return StringUtils.enterMobileNumber;
              } else if (provider.userMobileController.text.length < 10) {
                _validateMobile = true;
                return StringUtils.enterMobileNumber;
              } else {
                _validateMobile = false;
              }
              return null;
            }),
      ],
    );
  }

  Widget emailId(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().dynamicText(
            StringUtils.emailAddress,
            context,
            TextStyle(
                fontFamily: 'Roboto',
                color: ThemeApp.blackColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w600)),
        EmailTextFormFieldsWidget(
            errorText: StringUtils.validEmailError,
            textInputType: TextInputType.emailAddress,
            controller: provider.userEmailController,
            autoValidation: AutovalidateMode.onUserInteraction,
            hintText: 'test@gmail.com',

            onChange: (val) {},
            validator: (val) {
              if (val.isEmpty && provider.userEmailController.text.isEmpty) {
                _validateEmail = true;
                return StringUtils.validEmailError;
              } else if (!StringConstant().isEmail(val)) {
                _validateEmail = true;
                return StringUtils.validEmailError;
              } else {
                _validateEmail = false;
              }
              return null;
            }),
      ],
    );
  }*/

  Widget updateButton() {
    return proceedButton(
        StringUtils.update, ThemeApp.tealButtonColor, context, false, () {
      FocusManager.instance.primaryFocus?.unfocus();

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return OTPVerificationDialog();
          });
    });
  }

  // // String images='';
  // Future<String> getBase64Image(PickedFile img) async {
  //   List<int> imageBytes = File(img.path).readAsBytesSync();
  //   String img64 = base64Encode(imageBytes);
  //   // print(img.path);
  //   // print(img64);
  //   return img64;
  // }
}
