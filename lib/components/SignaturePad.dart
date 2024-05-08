import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:scanpack_pickup/components/TheButton.dart';
import 'package:scanpack_pickup/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePad extends StatelessWidget {
  final Function(ByteData image) onSubmit;
  SignaturePad({super.key, required this.onSubmit});

 final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();


  void _handleClearButtonPressed() {
    _signaturePadKey.currentState!.clear();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;


    return Dialog.fullscreen(
      child: SafeArea(
        child: Column(
          children: [
            Expanded (
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  side: BorderSide(width:1, color: Colors.grey.shade200, strokeAlign: -1),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text('Signature', style: TextStyle(color: Colors.grey.withOpacity(0.15), letterSpacing: 1.1, fontSize: 40))
                        ),
                      ),
                    ),
                    SfSignaturePad(
                      key: _signaturePadKey,
                      backgroundColor: Colors.transparent
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton.filled(
                          onPressed: _handleClearButtonPressed,
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(1),
                            shadowColor:  MaterialStateProperty.all<Color>(Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(scheme.secondary),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(vertical: 2, horizontal: 8)
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ))
                          ),
                          icon: ProFontAwesome(
                            icon: ProFontAwesomeIcon.eraser,
                            color: scheme.onSecondary,
                            size: 24,
                          )
                      ),
                    ),
                  ],
                ),
              )
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TheButton(
                  size: TheButtonSize.l,
                  onPressed: () async {
                    ui.Image image = await _signaturePadKey.currentState!.toImage();
                    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
                    onSubmit(bytes!);
                  },
                  text: 'Submit',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
