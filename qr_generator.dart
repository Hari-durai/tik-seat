import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:loginpage1/routes.dart';

//void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(backgroundColor: Colors.green[300],
            appBar: AppBar(title: const Text('Welcome'),centerTitle: true,backgroundColor: Colors.brown,actions: [IconButton(icon: Icon(Icons.logout),
                onPressed: (){FirebaseAuth.instance.signOut();})]),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                       // ElevatedButton(
                       //     onPressed: () => scanBarcodeNormal(),
                        //    child: Text('Start barcode scan')),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(30),

                              decoration: BoxDecoration(
                                color: Colors.black54,
                                  border: Border.all(
                                    color: Colors.red[500],
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              //onPressed: () => scanQR(),
                              child: Text('Start QR scan',style: TextStyle(color: Colors.redAccent),)),
                          onTap:() => scanQR() ,
                        ),
                       // ElevatedButton(
                        //    onPressed: () => startBarcodeScanStream(),
                        //    child: Text('Start barcode scan stream')),
                       // Text('Scan result : $_scanBarcode\n',
                        //    style: TextStyle(fontSize: 20)),
                        if(_scanBarcode!='')
                          ElevatedButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Routes(_scanBarcode)),
                            );
                          }, child: Text("NEXT"))
                      ]));
            })));
  }
}