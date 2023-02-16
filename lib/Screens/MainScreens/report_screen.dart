import 'package:flutter/material.dart';

import '../../utils/GlobalWidgets/appBar.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import '../../utils/styles.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBarWidget(
            context, appTitle(context, 'Reports'), SizedBox(), setState(() {})),
      ),
      bottomNavigationBar: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Color(0xff056C84),
                    borderRadius: BorderRadius.circular(100)),
                child: MaterialButton(
                  onPressed: () {},
                  height: 50,
                  child: Text(
                    "Share Reports",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            bottomNavigationBarWidget(context,4)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
          child: Container(
        height: 350.0,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: _items
              .map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      // height: height * 0.12,
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: ThemeApp.whiteColor,
                      ),
                      child: CheckboxListTile(
                        activeColor: ThemeApp.appColor,
                        side: BorderSide(
                          color: ThemeApp.appColor, //your desire colour here
                          width: 1.5,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: TextFieldUtils().dynamicText(
                            t.title,
                            context,
                            TextStyle(
                              color: ThemeApp.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: height * .023,
                            )),
                        value: t.isChecked,
                        onChanged: (val) {
                          setState(() {
                            t.isChecked = val!;
                            if (val == true) {
                              _currText = t.title;
                            }
                          });
                        },
                      ),
                    ),
                  ))
              .toList(),
        ),
      )),
    );
  }

  final List<SimpleModel> _items = <SimpleModel>[
    SimpleModel("Order Report", false),
    SimpleModel("Inventory Report", false),
    SimpleModel("Revenue Report", false),
  ];

  String _currText = '';
}

class SimpleModel {
  String title;
  bool isChecked;

  SimpleModel(this.title, this.isChecked);
}
