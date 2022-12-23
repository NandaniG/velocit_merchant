import 'package:flutter/material.dart';
import 'package:velocit_merchant/Screens/Auth_Screens/sign_in.dart';

import '../../utils/AppTheme.dart';
import '../../utils/GlobalWidgets/proceedButtons.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  bool _validateEmail = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeApp.appBackgrounColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: ThemeApp.blackColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )),
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 40),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFieldUtils().textFieldHeightThree(
                    AppLocalizations.of(context).forgotPassword, context),
                const SizedBox(
                  height: 5,
                ),
                TextFieldUtils().subHeadingTextFields(
                    AppLocalizations.of(context).forgotPasswordSubHeading,
                    context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                TextFieldUtils().titleTextFields(
                    AppLocalizations.of(context).registeredEmailAddress,
                    context),
                TextFormFieldsWidget(
                    errorText: AppLocalizations.of(context).emailError,
                    textInputType: TextInputType.emailAddress,
                    controller: email,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: AppLocalizations.of(context).email,
                    onChange: (val) {
                      setState(() {
                        if (val.isEmpty && email.text.isEmpty) {
                          _validateEmail = true;
                        } else if (!StringConstant().isEmail(val) &&
                            !StringConstant().isPhone(val)) {
                          _validateEmail = true;
                        } else {
                          _validateEmail = false;
                        }
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty && email.text.isEmpty) {
                        _validateEmail = true;
                        return AppLocalizations.of(context)
                            .validateRegisteredEmail;
                      } else if (!StringConstant().isEmail(value) &&
                          !StringConstant().isPhone(value)) {
                        _validateEmail = true;
                        return AppLocalizations.of(context)
                            .validateRegisteredEmail;
                      } else {
                        _validateEmail = false;
                      }
                      return null;
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .025,
                ),
                proceedButton(AppLocalizations.of(context).resetPassword,
                    ThemeApp.tealButtonColor, context, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PasswordResetScreen(),
                    ),
                  );
                  /*        if (_formKey.currentState!.validate() &&
                  email.text.isNotEmpty) {
                if (email.text == 'codeelan@gmail.com' ) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PasswordResetScreen(),
                    ),
                  );
                } else {
                  final snackBar = SnackBar(
                    content: Text('Please enter valid Details.....'),
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemeApp.greenappcolor,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }


              } else {

                final snackBar = SnackBar(
                  content: Text('Please enter valid Details.'),
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: ThemeApp.greenappcolor,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }*/
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => OTPScreen(),
                  //   ),
                  // );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
          child: Stack(
            children: [
              Positioned(
                  right: 1,
                  top: 0.0,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                        // color: Colors.cyan,
                        // width: MediaQuery.of(context).size.width,
                        child: Icon(
                      Icons.clear,
                      size: 40,
                      color: ThemeApp.darkGreyTab,
                    )),
                  )),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 80,
                      color: ThemeApp.darkGreyTab,
                    ),
                    TextFieldUtils().dynamicText(
                        AppLocalizations.of(context).passwordResetSuccessfully,
                        context,
                        AppTheme.h1Style),
                    AppTheme.sizeBoxH2(context),
                    TextFieldUtils().dynamicText(
                        "${AppLocalizations.of(context).weHaveSentAnTemporaryPasswordToYourRegEmail} dawid@gmail.com",
                        context,
                        AppTheme.h6Style),
                    AppTheme.sizeBoxH6(context),
                    proceedButton(AppLocalizations.of(context).signInNow,
                        ThemeApp.blackColor, context, () {})
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
