import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../Services/Provider/Home_Provider.dart';
import '../../utils/GlobalWidgets/appBar.dart';
import '../../utils/GlobalWidgets/proceedButtons.dart';
import '../../utils/GlobalWidgets/textFormFields.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  bool isAnySelected = false;
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }

  void getPermission() async {
    print("getPermission");
    // Map<PermissionGroup, PermissionStatus> permissions =
    PermissionStatus permission = await Permission.storage.status;

    await Permission.storage.request().isGranted;
  }

  void _generateCsvFile(HomeProvider value) async {
    List<dynamic> associateList = [
      {"number": 1, "lat": "14.97534313396318", "lon": "101.22998536005622"},
      {"number": 2, "lat": "14.97534313396318", "lon": "101.22998536005622"},
      {"number": 3, "lat": "14.97534313396318", "lon": "101.22998536005622"},
      {"number": 4, "lat": "14.97534313396318", "lon": "101.22998536005622"}
    ];

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add("Sr. no.");
    row.add("Order Date");
    row.add("Basket ID");
    row.add("Order ID");
    row.add("Order Description");
    row.add("Order Quantity");
    row.add("Amount");
    row.add("Current Status");
    rows.add(row);
    // for (int i = 0; i < associateList.length; i++) {
    //   List<dynamic> row = [];
    //   row.add(associateList[i]["number"] - 1);
    //   row.add(associateList[i]["lat"]);
    //   row.add(associateList[i]["lon"]);
    //   rows.add(row);
    // }
    for (int i = 0;
        i < value.jsonDataBasket['payload']['merchant_baskets'].length;
        i++) {
      for (int j = 0;
          j <
              value.jsonDataBasket['payload']['merchant_baskets'][i]['orders']
                  .length;
          j++) {
        // print(\u{20B9 +value.jsonDataBasket['payload']['merchant_baskets'][i]['orders'][j]['mrp']}');
        List<dynamic> row = [];
        row.add(i + 1);
        row.add('NA');
        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]['id']);
        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]['orders']
            [j]['order_id']);
        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]['orders']
            [j]['oneliner']);
        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]['orders']
            [j]['item_qty']);
        row.add('Rs. ${value.jsonDataBasket['payload']['merchant_baskets'][i]['orders'][j]
                    ['mrp']}');

        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]
            ['overall_status']);
        rows.add(row);
      }
    }

    String csv = const ListToCsvConverter().convert(rows);
    //create file path
    var directory =
        await Directory('/storage/emulated/0/VelocITt Merchant Reports')
            .create();
    print('Directory path :${directory.path}');

    //save pdf file
    final file = File('${directory.path}/ActiveOrders.csv');
    Utils.successToast('Report Successfully Downloaded');
    // String dir = await ExternalPath.getExternalStoragePublicDirectory(
    //     ExternalPath.DIRECTORY_DOWNLOADS);
    //
    //
    // print("dir $dir");
    // String file = "$dir";
    //
    // File f = File(file + "/filename.csv");

    file.writeAsString(csv);

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .08),
        child: AppBarWidget(
            context: context,
            titleWidget: appTitle(context, 'Reports'),
            location: SizedBox()),
      ),
      bottomNavigationBar:
          Consumer<HomeProvider>(builder: (context, value, child) {
        return (value.jsonDataBasket.isNotEmpty &&
                value.jsonDataBasket['error'] == null)
            ? Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: isAnySelected == true
                          ? proceedButton("Share Reports",
                              ThemeApp.tealButtonColor, context, false, () {
                              _generateCsvFile(value);
                            })
                          : inActiveButton("Share Reports", context, () {}),
                    ),
                    bottomNavigationBarWidget(context, 4)
                  ],
                ),
              )
            : SizedBox();
      }),
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
                            isAnySelected = val;
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
