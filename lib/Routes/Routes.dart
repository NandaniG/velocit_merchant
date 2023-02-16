import 'package:flutter/material.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';
import 'package:velocit_merchant/main.dart';

import '../Screens/Auth_Screens/Sign_Up.dart';
import '../Screens/Auth_Screens/sign_in.dart';
import '../Screens/MyAccount_Ui/my_account.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreenRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
        case RoutesName.signUpRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignUp());
      case RoutesName.signInRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignIn_Screen(),);
      case RoutesName.dashboardRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => OrderDashboard());

    case RoutesName.myAccountRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => MyAccountActivity());
   case RoutesName.myAccountRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => MyAccountActivity());

      // case RoutesName.otpRoute:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => OTPScreen(mobileNumber: ''));
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("No routes are there.")),
          );
        });
    }
  }
}

class RoutesName{

  static const String splashScreenRoute = 'SplashScreen';
  static const String signInRoute = 'signIn';
  static const String signUpRoute = 'signUp';
  static const String otpRoute = 'otpScreen';
  static const String dashboardRoute = 'dashBoardScreenRoute';
  static const String myAccountRoute = 'myAccountRouteRoute';
  static const String changeForgotPassRoute = 'changeForgotPass';


}