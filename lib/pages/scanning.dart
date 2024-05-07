import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanpack_pickup/components/TheButton.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:scanpack_pickup/services/session/session.dart';
import 'package:intl/intl.dart';

class Scanning extends StatefulWidget {
  const Scanning({Key? key}) : super(key: key);

  @override
  _ScanningState createState() => _ScanningState();
}

class _ScanningState extends State<Scanning>{
  bool _cameraPermissionsAccepted = false;
  List<String> barcodes = [];
  late StreamSubscription<dynamic>? streamSubscription = null;
  late final AppLifecycleListener _listener;
  Timer? _timer;

  @override
  void initState() {
    _listener = AppLifecycleListener(
      onResume: () {
        if(streamSubscription != null){
          streamSubscription?.resume();
        }
      },
      onPause: (){
        if(streamSubscription != null){
          streamSubscription?.pause();
        }
      },
      onStateChange: didChangeAppLifecycleState,
    );

    askForPermissions();

    super.initState();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      checkPermissions();
    }
  }

  void checkPermissions() async {
    bool camera = await Permission.camera.status.isGranted;

    setState(()  {
      _cameraPermissionsAccepted = camera;
    });
  }


  void askForPermissions () async {
    if (await Permission.camera.request().isGranted) {
      if(!mounted){
        return;
      }

      setState(()  {
        _cameraPermissionsAccepted = true;
      });
    }
  }

  Future<void> startBarcodeScanStream() async {

    var barcode = await FlutterBarcodeScanner
        .scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);

    int index = barcodes.indexOf(barcode);
    if(index == -1 && barcode != '-1'){
      barcodes.add(barcode);
    }

    AudioPlayer().play(AssetSource('store-scanner-beep.mp3'));

    if(_timer != null){
      _timer?.cancel();
      _timer = null;
    }

    if(barcodes.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        saveSession();
        if(_timer != null){
          _timer?.cancel();
          _timer = null;
        }
      });
    }

    Timer(const Duration(seconds: 1), startBarcodeScanStream);
  }

  saveSession() async {
    UseSession service = UseSession();
    Session session = Session(
        pallets: barcodes,
        session: parseDateNow()
    );

    var res = await service.add(session);

    print(session.pallets);
    print(session.session);
    print(jsonEncode(res.body));
  }

  void onPressed() async {
    openAppSettings();
  }

  String parseDateNow() {
    DateTime now = DateTime.now();
    print(now);
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: _cameraPermissionsAccepted ?
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton.filled(
                      onPressed: startBarcodeScanStream,
                      padding: const EdgeInsets.all(20),
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        size: 40,
                      )
                  ),
                  const SizedBox(
                      height: 10
                  ),
                  const Text(
                      'Start scanning'
                  ),
                  const SizedBox(
                      height: 40
                  ),
                  Column(
                    children: barcodes.map((item) => Text(item)).toList(),
                  )
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                      'This app requires certain permissions to work properly, enable them before continuing.'
                  ),
                  const SizedBox(
                      height: 20
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            _cameraPermissionsAccepted ? Icons.check : Icons.close,
                            color:  _cameraPermissionsAccepted ? Colors.green : Colors.red,
                          ),
                        ),
                        const Text('Camera')
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 40
                  ),
                  TheButton(
                      variant: TheButtonVariant.tonal,
                      onPressed: onPressed,
                      text: ('Open permissions')
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
