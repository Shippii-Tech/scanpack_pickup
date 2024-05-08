
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanpack_pickup/components/TheButton.dart';

class AskForPermissionsDialog extends StatefulWidget {
  final Function(bool value) onClose;

  const AskForPermissionsDialog({super.key, required this.onClose});

  @override
  _AskForPermissionsDialogState createState() => _AskForPermissionsDialogState();
}

class _AskForPermissionsDialogState extends State<AskForPermissionsDialog>{
  bool _cameraPermissionsAccepted = false;
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    _listener = AppLifecycleListener(
      onStateChange: didChangeAppLifecycleState,
    );

    checkPermissions();
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
  
  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('This app requires certain permissions to work properly, enable them before continuing.'),
                const SizedBox(height: 20),
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
                const SizedBox(height: 40),
                TheButton(
                    variant: TheButtonVariant.tonal,
                    onPressed: () {
                      !_cameraPermissionsAccepted ?
                        openAppSettings() :
                        widget.onClose(_cameraPermissionsAccepted);
                    },
                    text: _cameraPermissionsAccepted ? 'Close' : 'Open permissions'
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
