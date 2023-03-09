import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'notificationservices/local_notification_service.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
Future<void> backgroundHandler(RemoteMessage message) async {
  print('FirebaseMessaging : ' + message.data.toString());
  print('FirebaseMessaging : ' + message.notification!.title.toString());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
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
              ),selectedRowColor: ThemeApp.buttonShade2,backgroundColor:ThemeApp.buttonShade2,
              focusColor: ThemeApp.appBarShadowColor,
              primarySwatch: colorCustomForMaterialApp,
            ),
            color: ThemeApp.appColor,
            // initialRoute: '/',
            initialRoute: RoutesName.splashScreenRoute,
            onGenerateRoute: Routes.generateRoute,
            // routes: {
            //   "/": (context) => SplashScreen(),
            //   // "/":(context)=>OrderDashboard(),
            //   // '/': (context) =>StringConstant.isLogIn==true?  const OrderDashboard():SignIn_Screen(),
            //   '/forgotPasswordScreen': (context) => const ForgotPassword(),
            // },
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

class _SplashScreenState extends State<SplashScreen> {  String deviceTokenToSendPushNotification = '';

@override
  void initState() {
    super.initState();
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
    // startTime();
    setScreen();
  }

  // Step 1.  Get the device token

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();

    print("Token Value $deviceTokenToSendPushNotification");

  }

  setScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    StringConstant.isLogIn = pref.getBool('isLogin') ?? false;
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //  Provider.of<HomeProvider>(context,).loadJson();
    //   });
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
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
              Text(' versionCode 2(1.0.1)'),
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
