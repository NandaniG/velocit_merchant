/* ---------------------its useful file-------------------------*/

import 'package:barcode_finder/barcode_finder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';


import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../utils/styles.dart';
import '../../utils/utils.dart';

class ScannerWithGallery extends StatefulWidget {
  const ScannerWithGallery({Key? key}) : super(key: key);

  @override
  State<ScannerWithGallery> createState() => _ScannerWithGalleryState();
}

class _ScannerWithGalleryState extends State<ScannerWithGallery> {
  final controller = BarcodeFinderController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Barcode Finder',
          ),
        ),
        body: Center(
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              final state = controller.state;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        scanQR();
                      },
                      child: Container(child: Text("Click"))),
                  Text(_scanBarcode),
                  // Text(
                  //   'Code:',
                  //   textAlign: TextAlign.center,
                  // ),
                  if (state is BarcodeFinderLoading)
                    _loading()
                  else if (state is BarcodeFinderError)
                    _text(
                      state.message,
                    )
                  else if (state is BarcodeFinderSuccess)
                    _text(
                      state.code,
                    ),
                  _startScanFileButton(state),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ThemeApp.darkGreyTab,
          onPressed: () {
            // scanQRCode();
            // scanQR();
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => StepperScreen(),
            //   ),
            // );
            // showModalBottomSheet(
            //     context: context,
            //     builder: (context) {
            //       return _scannerWidget();
            //     });
          },
          child:
              Icon(Icons.document_scanner_outlined, color: ThemeApp.whiteColor),
        ),
      ),
    );
  }

  String _scanBarcode = 'Unknown';

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (kDebugMode) {
        print(barcodeScanRes);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Widget _startScanFileButton(BarcodeFinderState state) {
    return ElevatedButton(
      child: Text('Scan PDF or image file'),
      onPressed: state is! BarcodeFinderLoading
          ? () async {
              FilePickerResult? pickedFile =
                  await FilePicker.platform.pickFiles();
              if (pickedFile != null) {
                String? filePath = pickedFile.files.single.path;
                if (filePath != null) {
                  final file = File(filePath);
                  controller.scanFile(file);
                }
              }
            }
          : null,
    );
  }

  Widget _loading() => Center(child: CircularProgressIndicator());

  Text _text(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }
}

abstract class BarcodeFinderState {}

class BarcodeFinderInitial extends BarcodeFinderState {}

class BarcodeFinderLoading extends BarcodeFinderState {}

class BarcodeFinderSuccess extends BarcodeFinderState {
  final String code;

  BarcodeFinderSuccess(this.code);
}

class BarcodeFinderError extends BarcodeFinderState {
  final String message;

  BarcodeFinderError(this.message);
}

class BarcodeFinderController extends ChangeNotifier {
  BarcodeFinderState state = BarcodeFinderInitial();
  var barcode = '';

  void scanFile(File file) async {
    emit(BarcodeFinderLoading());
    try {
      barcode = (await BarcodeFinder.scanFile(
        path: file.path,
      ))!;
      _update(barcode);
      Utils.successToast(barcode.toString());


      print("scanned value is : barcode" + barcode.toString());
    } catch (_) {
      emit(
        BarcodeFinderError('Not found'),
      );
      Utils.errorToast('Please scan proper content');
    }
  }

  void emit(BarcodeFinderState newState) {
    state = newState;
    notifyListeners();
  }

  void _update(String? barcode) {
    if (barcode != null) {
      emit(
        BarcodeFinderSuccess(barcode),
      );
    } else {
      emit(
        BarcodeFinderError('Not Found'),
      );
    }
  }
}
