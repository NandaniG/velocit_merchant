import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Core/ViewModel/auth_view_model.dart';
import 'package:velocit_merchant/Screens/Auth_Screens/sign_in.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';
import 'package:velocit_merchant/utils/constants.dart';

import 'Screens/Auth_Screens/forgot_password.dart';
import 'Services/Provider/Home_Provider.dart';
import 'l10n/l10n.dart';
import 'l10n/localeProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main()  {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)  {
    return  MultiProvider(
        providers: [
        ChangeNotifierProvider(
        create: (_) => AuthViewModel(),
    ), ChangeNotifierProvider(
            create: (_) => LocaleProvider(),
          ),
          ChangeNotifierProvider(
        create: (_) => HomeProvider(),
    ),],
      child: Consumer<LocaleProvider>(
          builder: (context, localeProvider, snapshot) {
        return ScreenUtilInit(
          designSize: const Size(360, 640 ),

          builder:  (_,child) =>
           MaterialApp(
            locale: localeProvider.locale,
            localizationsDelegates: const [
              //AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],debugShowCheckedModeBanner: false,
            supportedLocales: L10n.all,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              "/":(context)=>SplashScreen(),
              // "/":(context)=>OrderDashboard(),
              // '/': (context) =>StringConstant.isLogIn==true?  const OrderDashboard():SignIn_Screen(),
              '/forgotPasswordScreen': (context) => const ForgotPassword(),
            },
          ),
        );
      }),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setScreen();
  }

  setScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance(); 
  StringConstant.isLogIn = pref.getBool('isLogin') ?? false;
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //  Provider.of<HomeProvider>(context,).loadJson();
  //   });
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => StringConstant.isLogIn ? const OrderDashboard() : SignIn_Screen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.white,
      child: Image.asset(
        'assets/images/VelocIT_Icon_512.png',
        height: 120,
        width: 100,
      ),
    );
  }
}
