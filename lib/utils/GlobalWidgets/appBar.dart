import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/Screens/MainScreens/Notification_screen.dart';
import 'package:velocit_merchant/Screens/MainScreens/raise_view_tickets.dart';
import 'package:velocit_merchant/Screens/orders_Dashboard.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/proceedButtons.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/textFormFields.dart';

import '../../Screens/MainScreens/Stock_screen.dart';
import '../../Screens/MainScreens/report_screen.dart';
import '../../Screens/MyAccount_Ui/AccountVerificationDialog.dart';
import '../../Screens/MyAccount_Ui/my_account.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;

import '../features/scannerWithGallery.dart';
import '../utils.dart';
import 'SpeechToTextDialog_Screen.dart';
import 'autoSearchLocation_popup.dart';

speechToText.SpeechToText? speech;

class AppBarWidget extends StatefulWidget {
  final BuildContext context;
  final Widget titleWidget;
  final Widget location;

  AppBarWidget(
      {Key? key,
        required this.context,
        required this.titleWidget,
        required this.location})
      : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  getPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      StringConstant.ProfilePhoto =
          prefs.getString('userProfileImagePrefs') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return appBarWidget(context, );
  }

  Widget appBarWidget(
      BuildContext context,
      ) {
    double height = 0.0;
    double width = 0.0;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: ThemeApp.appBackgroundColor,
            child: AppBar(
              centerTitle: true,
              titleSpacing: 5,

              // elevation: 1,
              backgroundColor: ThemeApp.appBackgroundColor,
              flexibleSpace: Container(
                height: MediaQuery.of(context).size.height * .08,
                width: width,
                decoration: const BoxDecoration(
                  color: ThemeApp.appBackgroundColor,
                ),
              ),
              automaticallyImplyLeading: false,
              // leading: InkWell(
              //   onTap: () async {
              //     final preferences = await SharedPreferences.getInstance();
              //
              //     StringConstant.isUserLoggedIn =
              //         preferences.getInt('isUserLoggedIn') ?? 0;
              //
              //     if (StringConstant.isUserLoggedIn != 0) {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //           builder: (context) => MyAccountActivity(),
              //         ),
              //       );
              //     } else {
              //       showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AccountVerificationDialog();
              //           });
              //     }
              //   },
              //   child: Container(
              //       alignment: Alignment.center,
              //       child:
              //       Icon(Icons.menu, color: ThemeApp.blackColor, size: 30)),
              // ),

              title:widget.titleWidget,
              // Row
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Center(
                      // height: 25,
                      // width: 25,
                      child: SvgPicture.asset(
                        'assets/appImages/notificationIcon.svg',
                        color: ThemeApp.primaryNavyBlackColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.primaryNavyBlackColor,
                        ),
                        height: 28,
                        width: 28,
                      ), /*badges.Badge(
                              badgeContent: Text(
                                0.toString(),
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                // textAlign: TextAlign.center,
                              ),
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: ThemeApp.redColor,
                                padding: EdgeInsets.all(7),
                              ),
                              child: SvgPicture.asset(
                                'assets/appImages/notificationIcon.svg',
                                color: ThemeApp.primaryNavyBlackColor,
                                semanticsLabel: 'Acme Logo',
                                theme: SvgTheme(
                                  currentColor: ThemeApp.primaryNavyBlackColor,
                                ),
                                height: 28,
                                width: 28,
                              ),
                            ),*/
                    ),
                  ),
                ),

                          InkWell(

                              onTap: () async {
                                final preferences = await SharedPreferences.getInstance();

                                StringConstant.isUserLoggedIn =
                                    preferences.getInt('isUserLoggedIn') ?? 0;

                                if (StringConstant.isUserLoggedIn != 0) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MyAccountActivity(),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AccountVerificationDialog();
                                      });
                                }
                              },

                            child: StringConstant.ProfilePhoto.isEmpty
                                ? Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                'assets/appImages/Username.svg',
                                color: ThemeApp.appColor,
                                semanticsLabel: 'Acme Logo',
                                theme: SvgTheme(
                                  currentColor: ThemeApp.appColor,
                                ),
                                height: 28,
                                width: 28,
                              ),
                            )
                                : Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: new BoxDecoration(

                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: ThemeApp.appLightColor,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100)),
                                    child: Image.network(
                                      StringConstant.ProfilePhoto.toString(),
                                      height: 28,
                                      width: 28,
                                      errorBuilder: (context, error, stackTrace) {
                                        return SvgPicture.asset(
                                          'assets/appImages/Username.svg',
                                          color: ThemeApp.appColor,
                                          semanticsLabel: 'Acme Logo',
                                          theme: SvgTheme(
                                            currentColor: ThemeApp.appColor,
                                          ),
                                          height: 28,
                                          width: 28,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          )

              ],
            ),
          ),
          widget.location
        ],
      ),
    );
  }
}

/*
class AppBarWidget extends StatefulWidget {
  final BuildContext context;
  final Widget titleWidget;
  final Widget location;

  AppBarWidget(
      {Key? key,
        required this.context,
        required this.titleWidget,
        required this.location})
      : super(key: key);
  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return appBarWidget(context,);
  }
  Widget appBarWidget(
      BuildContext context,
      // Widget titleWidget,
      // Widget location,

      ) {
    double height = 0.0;
    double width = 0.0;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: ThemeApp.appBackgroundColor,
            child: AppBar(
              // centerTitle: true,
              titleSpacing: 5,

              shadowColor: ThemeApp.appBackgroundColor,
              backgroundColor: ThemeApp.appBackgroundColor,
              flexibleSpace: Container(
                height: height * .08,
                width: width,
                decoration: const BoxDecoration(
                  color: ThemeApp.appBackgroundColor,
                ),
              ),
              leading: InkWell(
                onTap: () async {
                  final preferences = await SharedPreferences.getInstance();

                  StringConstant.isUserLoggedIn =
                      preferences.getInt('isUserLoggedIn') ?? 0;

                  if (StringConstant.isUserLoggedIn != 0) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MyAccountActivity(),
                      ),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AccountVerificationDialog();
                        });
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    child:
                    Icon(Icons.menu, color: ThemeApp.blackColor, size: 30)),
              ),
              // leadingWidth: width * .07,
              title: Center(child: widget.titleWidget),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Center(
                      // height: 25,
                      // width: 25,
                      child: SvgPicture.asset(
                        'assets/appImages/notificationIcon.svg',
                        color: ThemeApp.primaryNavyBlackColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.primaryNavyBlackColor,
                        ),
                        height: 28,
                        width: 28,
                      ), */
/*badges.Badge(
                              badgeContent: Text(
                                0.toString(),
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                // textAlign: TextAlign.center,
                              ),
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: ThemeApp.redColor,
                                padding: EdgeInsets.all(7),
                              ),
                              child: SvgPicture.asset(
                                'assets/appImages/notificationIcon.svg',
                                color: ThemeApp.primaryNavyBlackColor,
                                semanticsLabel: 'Acme Logo',
                                theme: SvgTheme(
                                  currentColor: ThemeApp.primaryNavyBlackColor,
                                ),
                                height: 28,
                                width: 28,
                              ),
                            ),*//*

                    ),
                  ),
                ),
              ],
            ),
          ),
          widget. location
        ],
      ),
    );
  }
}
*/



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
          shadowColor: ThemeApp.appBackgroundColor,

          centerTitle: false,
          // elevation: 0,
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
            child:  Transform.scale(
              scale: 0.7,
              child: Image.asset(
                'assets/appImages/backArrow.png',
                color: ThemeApp.primaryNavyBlackColor,
                // height: height*.001,
              ),
            ),
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

class AppBar_BackWidget extends StatefulWidget {
  final BuildContext context;
  final Widget titleWidget;
  final Widget location;

  AppBar_BackWidget(
      {Key? key,
      required this.context,
      required this.titleWidget,
      required this.location})
      : super(key: key);

  @override
  State<AppBar_BackWidget> createState() => _AppBar_BackWidgetState();
}

class _AppBar_BackWidgetState extends State<AppBar_BackWidget> {
  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, () {
          setState(() {});
        });
        return Future.value(true);
      },
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: ThemeApp.appBackgroundColor,
            child: AppBar(
              centerTitle: false,
              backgroundColor: ThemeApp.appBackgroundColor,
              flexibleSpace: Container(
                height: height * .08,
                width: width,
                decoration: const BoxDecoration(
                  color: ThemeApp.appBackgroundColor,
                ),
              ),

              titleSpacing: 1,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context, () {
                    setState(() {});
                  }); // Provider.of<ProductProvider>(context, listen: false);
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
              title: widget.titleWidget,
              // Row
            ),
          ),
          widget.location
        ],
      )),
    );
  }
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
class searchBarWidget extends StatefulWidget {
  const searchBarWidget({Key? key}) : super(key: key);

  @override
  State<searchBarWidget> createState() => _searchBarWidgetState();
}

class _searchBarWidgetState extends State<searchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return searchBar(context);
  }

  Widget searchBar(BuildContext context) {
    double height = 0.0;
    double width = 0.0;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      // padding: const EdgeInsets.only(top: 20, bottom: 20),

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
                  // contentPadding:
                  //     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  /* -- Text and Icon -- */
                  hintText: "Search",
                  hintStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: ThemeApp.darkGreyTab,
                  ),
                  prefixIconColor: ThemeApp.primaryNavyBlackColor,
                  prefixIcon: /*const Icon(
                Icons.search,
                size: 26,
                color: Colors.black54,
              ),*/
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/appImages/searchIcon.svg',
                      color: ThemeApp.primaryNavyBlackColor,
                      semanticsLabel: 'Acme Logo',
                      theme: SvgTheme(fontSize: 5,
                        currentColor: ThemeApp.primaryNavyBlackColor,
                      ),
                      // height: 18,
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SpeechToTextDialog();
                          });
                    },
                    child:   Container(
                      margin:const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/appImages/miceIcon.svg',
                        color: ThemeApp.primaryNavyBlackColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(fontSize: 5,
                          currentColor: ThemeApp.primaryNavyBlackColor,
                        ),
                      ),
                    ), /*const Icon(
                  Icons.mic,
                  size: 26,
                  color: Colors.black54,
                ),*/
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: ThemeApp.redColor, width: 1)),
                  // OutlineInputBorder
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: ThemeApp.appBackgroundColor, width: 1)),
                  // OutlineInputBorder
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: ThemeApp.appBackgroundColor, width: 1)),
                ), // InputDecoration
              ),
            );


  }
}
Widget searchBar(BuildContext context) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;

  return Container(

    // padding: const EdgeInsets.only(top: 20, bottom: 20),

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
        // contentPadding:
        //     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        /* -- Text and Icon -- */
        hintText: "Search",
        hintStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: ThemeApp.darkGreyTab,
        ),
        prefixIconColor: ThemeApp.primaryNavyBlackColor,
        prefixIcon: /*const Icon(
                Icons.search,
                size: 26,
                color: Colors.black54,
              ),*/
        Container(
          margin: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/appImages/searchIcon.svg',
            color: ThemeApp.primaryNavyBlackColor,
            semanticsLabel: 'Acme Logo',
            theme: SvgTheme(fontSize: 5,
              currentColor: ThemeApp.primaryNavyBlackColor,
            ),
            // height: 18,
          ),
        ),
        suffixIcon: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SpeechToTextDialog();
                });
          },
          child:   Container(
            margin:const EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/appImages/miceIcon.svg',
              color: ThemeApp.primaryNavyBlackColor,
              semanticsLabel: 'Acme Logo',
              theme: SvgTheme(fontSize: 5,
                currentColor: ThemeApp.primaryNavyBlackColor,
              ),
            ),
          ), /*const Icon(
                  Icons.mic,
                  size: 26,
                  color: Colors.black54,
                ),*/
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            const BorderSide(color: ThemeApp.redColor, width: 1)),
        // OutlineInputBorder
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: ThemeApp.appBackgroundColor, width: 1)),
        // OutlineInputBorder
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: ThemeApp.appBackgroundColor, width: 1)),
      ), // InputDecoration
    ),
  );


}
/*
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
        */
/* -- Text and Icon -- *//*

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
*/

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

Widget bottomNavBarItems(BuildContext context, int indexSelected) {
  int _currentIndex = indexSelected;

  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: ThemeApp.whiteColor,
    selectedItemColor: ThemeApp.appColor,
    unselectedItemColor: ThemeApp.unSelectedBottomBarItemColor,
    currentIndex: _currentIndex,
    onTap: (int index) {
      _currentIndex = index;
      if (_currentIndex == 0) {
        // Navigator.pushNamed(context, '/dashBoardScreen');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OrderDashboard(),
            ),
           );
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
                  child: SvgPicture.asset(
                    'assets/appImages/OrderIconHome.svg',
                    color: ThemeApp.appColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.appColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SvgPicture.asset(
                    'assets/appImages/OrderIconHome.svg',
                    color: ThemeApp.unSelectedBottomBarItemColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.unSelectedBottomBarItemColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
                ),
          label: 'Orders'),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: _currentIndex == 1
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SvgPicture.asset(
                    'assets/appImages/InventoryIcon.svg',
                    color: ThemeApp.appColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.appColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SvgPicture.asset(
                    'assets/appImages/InventoryIcon.svg',
                    color: ThemeApp.unSelectedBottomBarItemColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.unSelectedBottomBarItemColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
                ),
          label: 'Inventory'),
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
                  child: SvgPicture.asset(
                    'assets/appImages/ticketIcon.svg',
                    color: ThemeApp.appColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.appColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SvgPicture.asset(
                    'assets/appImages/ticketIcon.svg',
                    color: ThemeApp.unSelectedBottomBarItemColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.unSelectedBottomBarItemColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
                ),
          label: 'Tickets'),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: _currentIndex == 4
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SvgPicture.asset(
                    'assets/appImages/ReportIcon.svg',
                    color: ThemeApp.appColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.appColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SvgPicture.asset(
                    'assets/appImages/ReportIcon.svg',
                    color: ThemeApp.unSelectedBottomBarItemColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.unSelectedBottomBarItemColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
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
          label: 'Reports'),
    ],
  );
}

Widget bottomNavigationBarWidget(BuildContext context, int indexSelected) {
  final controller = BarcodeFinderController();
  return Stack(
    alignment: const FractionalOffset(.5, 1.0),
    children: [
      bottomNavBarItems(context, indexSelected),
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
              child: SvgPicture.asset(
                'assets/appImages/scanIcon.svg',
                color: ThemeApp.whiteColor,
                semanticsLabel: 'Acme Logo',
                width: 29,
                height: 29,

                // height: height * .03,
              ),
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
                        proceedButton("Scan with Camera",
                            ThemeApp.darkGreyColor, context, false, () {
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
    return
      proceedButton( "Open Gallery", ThemeApp.tealButtonColor, context,false, () async {
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
      });

/*
      Container(
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
    );*/
  }
}
