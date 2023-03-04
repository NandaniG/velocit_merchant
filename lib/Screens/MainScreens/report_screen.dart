import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = Provider.of<HomeProvider>(context, listen: false)
        .loadJsonForGetMerchantBasket();
    getPermission();
  }

  void getPermission() async {
    print("getPermission");
    // Map<PermissionGroup, PermissionStatus> permissions =
    PermissionStatus permission = await Permission.storage.status;

    await Permission.storage.request().isGranted;
  }

  void _generateActiveOrderCsvFile(HomeProvider value) async {
    DateFormat format = DateFormat('dd_MM_yyyy_hh_mm_aaa');
    DateTime date = DateTime.now();
    var currentDate = format.format(date);

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
        row.add(
            'Rs. ${value.jsonDataBasket['payload']['merchant_baskets'][i]['orders'][j]['mrp']}');

        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]
            ['overall_status']);
        rows.add(row);
      }
    }

    String csv = const ListToCsvConverter().convert(rows);
    //create file path
    var directory =
        await Directory('/storage/emulated/0/VelocITt Merchant Reports');
    if (await directory.exists() == false) {
      directory.create();
      print('Directory path active:${directory.path}');
    } else {
      directory;
    }
    //save pdf file
    final file = File('${directory.path}/ActiveOrders_$currentDate.csv');
    Utils.successToast('Reports Downloaded Successfully');
    file.writeAsString(csv);

    setState(() {
      _counter++;
    });
  }

  void _generatePastOrderCsvFile(HomeProvider value) async {
    DateFormat format = DateFormat('dd_MM_yyyy_hh_mm_aaa');
    DateTime date = DateTime.now();
    var currentDate = format.format(date);

    print('date ;' + currentDate);

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
        row.add((i + 1));
        row.add('NA');
        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]['id']);
        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]['orders']
            [j]['order_id']);
        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]['orders']
            [j]['oneliner']);
        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]['orders']
            [j]['item_qty']);
        row.add(
            'Rs. ${value.jsonDataBasket['payload']['merchant_baskets'][i]['orders'][j]['mrp']}');

        row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]
            ['overall_status']);
        rows.add(row);
      }
    }

    String csv = const ListToCsvConverter().convert(rows);
    //create file path
    var directory =
        await Directory('/storage/emulated/0/VelocITt Merchant Reports');
    if (await directory.exists() == false) {
      directory.create();
      print('Directory path past:${directory.path}');
    } else {
      directory;
    }

    //save pdf file
    final file = File('${directory.path}/PastOrders_$currentDate.csv');
    Utils.successToast('Reports Downloaded Successfully');
    file.writeAsString(csv);

    setState(() {
      _counter++;
    });
  }

  void _generateCancelledOrderCsvFile(HomeProvider value) async {
    DateFormat format = DateFormat('dd_MM_yyyy_hh_mm_aaa');
    DateTime date = DateTime.now();
    var currentDate = format.format(date);

    print('date ;' + currentDate);

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

    for (int i = 0;
        i < value.jsonDataBasket['payload']['merchant_baskets'].length;
        i++) {
      for (int j = 0;
          j <
              value.jsonDataBasket['payload']['merchant_baskets'][i]['orders']
                  .length;
          j++) {
        // Map cancelledOrderList;
        if (value.jsonDataBasket['payload']['merchant_baskets'][i]['orders'][j]
                ['current_status_code'] ==
            2000) {
          print('Cancelled Order' +
              value.jsonDataBasket['payload']['merchant_baskets'][i]['orders']
                      [j]['order_id']
                  .toString());

          List<dynamic> row = [];
          row.add(i + 1);
          row.add('NA');
          row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]['id']);
          row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]
              ['orders'][j]['order_id']);
          row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]
              ['orders'][j]['oneliner']);
          row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]
              ['orders'][j]['item_qty']);
          row.add(
              'Rs. ${value.jsonDataBasket['payload']['merchant_baskets'][i]['orders'][j]['mrp']}');

          row.add(value.jsonDataBasket['payload']['merchant_baskets'][i]
              ['overall_status']);
          rows.add(row);
        }
      }
    }

    String csv = const ListToCsvConverter().convert(rows);
    //create file path
    var directory =
        await Directory('/storage/emulated/0/VelocITt Merchant Reports');
    if (await directory.exists() == false) {
      directory.create();
      print('Directory path past:${directory.path}');
    } else {
      directory;
    }
    // print('Directory path :${directory.path}');

    //save pdf file
    final file = File('${directory.path}/CancelledOrders_$currentDate.csv');
    Utils.successToast('Reports Downloaded Successfully');
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
                      child: proceedButton(
                              "Share Reports",
                              ThemeApp.tealButtonColor,
                              context,
                              false, () async {
                              for (int i = 0; i < _items.length; i++) {
                                if (_items[i].index == 1 &&
                                    _items[i].isChecked == true) {
                                  print("index 1 Active Orders");
                                  value.IsActiveOrderList = true;

                                  print("Is Past Orders  " +
                                      value.IsActiveOrderList.toString());

                                  data = await Provider.of<HomeProvider>(
                                          context,
                                          listen: false)
                                      .loadJsonForGetMerchantBasket();
                                  _generateActiveOrderCsvFile(value);
                                } else if (_items[i].index == 2 &&
                                    _items[i].isChecked == true) {
                                  print("index 1 Past Orders");
                                  value.IsActiveOrderList = false;

                                  print("Is Past Orders  " +
                                      value.IsActiveOrderList.toString());

                                  data = await Provider.of<HomeProvider>(
                                          context,
                                          listen: false)
                                      .loadJsonForGetMerchantBasket();

                                  _generatePastOrderCsvFile(value);
                                } else if (_items[i].index == 3 &&
                                    _items[i].isChecked == true) {
                                  print("index 1 Past Orders");
                                  value.IsActiveOrderList = false;

                                  print("Is Past Orders  " +
                                      value.IsActiveOrderList.toString());

                                  data = await Provider.of<HomeProvider>(
                                          context,
                                          listen: false)
                                      .loadJsonForGetMerchantBasket();

                                  _generateCancelledOrderCsvFile(value);
                                }
                              }
                            })
                          ,
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
                            isAnySelected = true;
                            print(t.index);
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
    SimpleModel(1, "Active Order Report", false),
    SimpleModel(2, "Past 7 Days Order Report", false),
    SimpleModel(3, "Cancelled Order Report", false),
  ];

  String _currText = '';
}

class SimpleModel {
  int index;
  String title;
  bool isChecked;

  SimpleModel(this.index, this.title, this.isChecked);
}
