import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Core/ViewModel/auth_view_model.dart';
import 'package:velocit_merchant/Screens/Auth_Screens/sign_in.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';
import 'package:velocit_merchant/utils/constants.dart';
import 'package:velocit_merchant/utils/styles.dart';

import 'Routes/Routes.dart';
import 'Screens/Auth_Screens/forgot_password.dart';
import 'Services/Provider/Home_Provider.dart';
import 'l10n/l10n.dart';
import 'l10n/localeProvider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => LocaleProvider(),
        // ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
      ],
      child: /*Consumer<LocaleProvider>(
          builder: (context, localeProvider, snapshot) {
        return*/ ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (_, child) => MaterialApp(
            // locale: localeProvider.locale,
            // localizationsDelegates: const [
            //   //AppLocalizationsDelegate(),
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            //   AppLocalizations.delegate,
            // ],
            debugShowCheckedModeBanner: false,
            // supportedLocales: L10n.all,
            title: 'Flutter Demo',
            theme: ThemeData(
              unselectedWidgetColor: ThemeApp.appColor,
              textTheme: GoogleFonts.robotoTextTheme(
                Theme.of(context).textTheme,
              ),
              primarySwatch: colorCustomForMaterialApp,
            ),
            color: ThemeApp.appColor,
            // initialRoute: '/',
            initialRoute: RoutesName.splashScreenRoute,
            onGenerateRoute: Routes.generateRoute,
            routes: {
              "/": (context) => SplashScreen(),
              // "/":(context)=>OrderDashboard(),
              // '/': (context) =>StringConstant.isLogIn==true?  const OrderDashboard():SignIn_Screen(),
              '/forgotPasswordScreen': (context) => const ForgotPassword(),
            },
          ),
        )
      // }),
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
            context,
            MaterialPageRoute(
                builder: (context) => StringConstant.isLogIn
                    ? const OrderDashboard()
                    : SignIn_Screen())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              // end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xff95EAF1),
                Color(0xff75E4ED),
                Color(0xff02D3E3),
                Color(0xff00A7BF),
                Color(0xff007896),
                // Color(0xff3AA17E),
                // Color(0xff3AA17E),
              ],
              // Gradient from https://learnui.design/tools/gradient-generator.html
              tileMode: TileMode.mirror,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/appImages/splashScreen.png',
                  alignment: Alignment.center,
                  height: 173,
                  width: 253,
                  // height: 300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
