import 'package:flutter/material.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';

import '../../../utils/GlobalWidgets/proceedButtons.dart';
import '../../../utils/GlobalWidgets/textFormFields.dart';
import '../../../utils/StringUtils.dart';
import '../my_account.dart';

class OTPVerificationDialog extends StatefulWidget {
  const OTPVerificationDialog({Key? key}) : super(key: key);

  @override
  State<OTPVerificationDialog> createState() => _OTPVerificationDialogState();
}

class _OTPVerificationDialogState extends State<OTPVerificationDialog> {
  TextEditingController emailOTPController = new TextEditingController();
  TextEditingController mobileOTPController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _validatePassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreference();
  }

  getPreference() async {
    final prefs = await SharedPreferences.getInstance();

    StringConstant.loginUserEmail = (prefs.getString('emailLogin')) ?? '';

    setState(() {});
    StringConstant.userAccountImagePicker = (await Prefs.instance
                .getToken(StringConstant.userAccountImagePickerPref))!
            .isEmpty
        ? StringConstant.userAccountImagePicker
        : (await Prefs.instance
            .getToken(StringConstant.userAccountImagePickerPref))!;
    StringConstant.userAccountName = (await Prefs.instance
                .getToken(StringConstant.userAccountNamePref))!
            .isEmpty
        ? StringConstant.userAccountName
        : (await Prefs.instance.getToken(StringConstant.userAccountNamePref))!;
    StringConstant.userAccountEmail = (await Prefs.instance
                .getToken(StringConstant.userAccountEmailPref))!
            .isEmpty
        ? StringConstant.userAccountEmail
        : (await Prefs.instance.getToken(StringConstant.userAccountEmailPref))!;
    StringConstant.userAccountMobile =
        (await Prefs.instance.getToken(StringConstant.userAccountMobilePref))!
                .isEmpty
            ? StringConstant.userAccountMobile
            : (await Prefs.instance
                .getToken(StringConstant.userAccountMobilePref))!;
    StringConstant.userAccountPass = (await Prefs.instance
                .getToken(StringConstant.userAccountPassPref))!
            .isEmpty
        ? StringConstant.userAccountPass
        : (await Prefs.instance.getToken(StringConstant.userAccountPassPref))!;
    print(StringConstant.userAccountName);
  }

  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 440,
          maxHeight: 444,
          // maxWidth: MediaQuery.of(context).size.width,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Container(
          // height: 444,
          // width: 400,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: TextFieldUtils().dynamicText(
                          "OTP Verification",
                          context,
                          TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 30,
                        ))
                  ],
                ),
                SizedBox(height: 15),
                TextFieldUtils().dynamicText(
                    "${StringUtils.otpSentTo} ${StringConstant.loginUserEmail}",
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.primaryNavyBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
                TextFormFieldsWidget(
                    errorText: StringUtils.otpSentTo,
                    textInputType: TextInputType.text,
                    controller: emailOTPController,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: 'Enter OTP',
                    suffixText: InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: 58,
                        padding: EdgeInsets.only(right: 10),
                        child: Text("Resend",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.tealButtonColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    onChange: (val) {},
                    validator: (value) {
                      return null;
                    }),
                SizedBox(
                  height: 15,
                ),
                TextFieldUtils().dynamicText(
                    "${StringUtils.otpSentTo} ${StringConstant.userAccountMobile}",
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.primaryNavyBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
                TextFormFieldsWidget(
                    errorText: StringUtils.otpSentTo,
                    textInputType: TextInputType.text,
                    controller: mobileOTPController,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: 'Enter OTP',
                    suffixText: InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: 58,
                        padding: EdgeInsets.only(right: 10),
                        child: Text("Resend",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.tealButtonColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    onChange: (val) {},
                    validator: (value) {
                      return null;
                    }),
                SizedBox(
                  height: 15,
                ),
                TextFieldUtils().asteriskTextField(
                  "${StringUtils.password}",
                  context,
                ),
                PasswordTextFormFieldsWidget(
                    errorText: StringUtils.passwordError,
                    textInputType: TextInputType.text,
                    controller: passwordController,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: StringUtils.password,
                    onChange: (val) {
                      setState(() {
                        if (val.isEmpty && passwordController.text.isEmpty) {
                          _validatePassword = true;
                        } else if (!StringConstant().isPass(val)) {
                          _validatePassword = true;
                        } else {
                          _validatePassword = false;
                        }
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty && passwordController.text.isEmpty) {
                        _validatePassword = true;
                        return StringUtils.passwordError;
                      } else if (!StringConstant().isPass(value)) {
                        _validatePassword = true;
                        return StringUtils.validPasswordError;
                      } else {
                        _validatePassword = false;
                      }
                      return null;
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: proceedButton(StringUtils.cancel,
                          ThemeApp.buttonShade2, context, false, () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyAccountActivity(),
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: proceedButton(StringUtils.update,
                          ThemeApp.tealButtonColor, context, false, () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyAccountActivity(),
                          ),
                        );
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
