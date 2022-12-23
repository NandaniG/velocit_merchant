import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';
import '../../Core/ViewModel/auth_view_model.dart';
import '../../Core/repository/auth_repository.dart';
import '../../utils/GlobalWidgets/proceedButtons.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import '../../utils/utils.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import 'Sign_Up.dart';
import 'forgot_password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn_Screen extends StatefulWidget {
  @override
  State<SignIn_Screen> createState() => _SignIn_ScreenState();
}

class _SignIn_ScreenState extends State<SignIn_Screen> {
  TextEditingController email = new TextEditingController();
  TextEditingController emailOtp = new TextEditingController();
  TextEditingController password = new TextEditingController();
  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _validateEmail = false;
  bool _validateEmailOtp = false;
  bool _validatePassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: ThemeApp.appBackgrounColor,
      body: Container(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 40),
        child: Stack(
          children: [
            Positioned(
              top: 30.0,
              right: 0.0,
              left: 0.0,
              child: Container(
                // group796Z38 (213:207)

                width: double.infinity,
                height: 70,
                child: Image.asset(
                  'assets/appImages/appicon.png',
                  width: double.infinity,
                  height: 70,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldUtils().textFieldHeightThree(
                      AppLocalizations.of(context).signin, context),
                  const SizedBox(
                    height: 5,
                  ),
                  // Text(AppLocalizations.of(context)!.helloWorld);

                  TextFieldUtils().subHeadingTextFields(
                      AppLocalizations.of(context).signinSubTitle, context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),

                  TextFieldUtils().asteriskTextField(
                      AppLocalizations.of(context).emailORMobile, context),

                  TextFormFieldsWidget(
                      errorText: AppLocalizations.of(context).emailError,
                      textInputType: TextInputType.emailAddress,
                      controller: email,
                      autoValidation: AutovalidateMode.onUserInteraction,
                      hintText: AppLocalizations.of(context).emailORMobile,
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
                          return AppLocalizations.of(context).validEmailError;
                        } else if (!StringConstant().isEmail(value) &&
                            !StringConstant().isPhone(value)) {
                          _validateEmail = true;
                          return AppLocalizations.of(context).validEmailError;
                        } else {
                          _validateEmail = false;
                        }
                        return null;
                      }),

                  const SizedBox(
                    height: 0,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  TextFieldUtils().asteriskTextField(
                      AppLocalizations.of(context).password, context),
                  PasswordTextFormFieldsWidget(
                      errorText: AppLocalizations.of(context).passwordError,
                      textInputType: TextInputType.text,
                      controller: password,
                      autoValidation: AutovalidateMode.onUserInteraction,
                      hintText: AppLocalizations.of(context).password,
                      onChange: (val) {
                        setState(() {
                          if (val.isEmpty && password.text.isEmpty) {
                            _validatePassword = true;
                          } else if (!StringConstant().isPass(val)) {
                            _validatePassword = true;
                          } else {
                            _validatePassword = false;
                          }
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty && password.text.isEmpty) {
                          _validatePassword = true;
                          return AppLocalizations.of(context).passwordError;
                        } else if (!StringConstant().isPass(value)) {
                          _validatePassword = true;
                          return AppLocalizations.of(context)
                              .validPasswordError;
                        } else {
                          _validatePassword = false;
                        }
                        return null;
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()),
                        );
                      },
                      child: TextFieldUtils().hyperLinkTextFields(
                          AppLocalizations.of(context).forgotPassword, context),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  proceedButton(AppLocalizations.of(context).signin,
                      ThemeApp.tealButtonColor, context, () {
                    Prefs.instance
                        .setToken(StringConstant.emailPref, email.text);
                    if (_formKey.currentState!.validate() &&
                        email.text.isNotEmpty &&
                        password.text.isNotEmpty) {
                      Map emailData = {
                        'email': email.text,
                        'password': password.text
                      };
                      Map mobileData = {
                        'mobile': email.text,
                        'password': password.text
                      };

                      if (StringConstant().isNumeric(email.text)) {
                        print("Digit found");
                        Map mobileData = {
                          'mobile': email.text,
                          'password': password.text
                        };
                        AuthRepository()
                            .postApiUsingEmailRequest(mobileData, context);
                      } else {
                        AuthRepository()
                            .postApiUsingEmailRequest(emailData, context);
                        print("Digit not found");
                      }
                      // authViewModel.loginApiWithGet(context);

                    } else {
                      Utils.errorToast("Please enter Details.");
                    }
                  })
                ],
              ),
            ),
            Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: Container(
                  padding: const EdgeInsets.only(top: 190, bottom: 10),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                            color: ThemeApp.primaryNavyBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUp()));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
