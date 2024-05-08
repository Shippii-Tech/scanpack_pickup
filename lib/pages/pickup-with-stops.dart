import 'dart:async';
import 'dart:convert';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scanpack_pickup/components/AskForPermissionsDialog.dart';
import 'package:scanpack_pickup/components/SignaturePad.dart';
import 'package:scanpack_pickup/components/Stripes.dart';
import 'package:scanpack_pickup/components/TheSnackBar.dart';
import 'package:scanpack_pickup/font_awesome_flutter.dart';
import 'package:scanpack_pickup/layouts/MainLayout.dart';
import 'package:scanpack_pickup/services/error/error.dart';
import 'package:scanpack_pickup/services/pickup/pickup.dart';
import 'package:scanpack_pickup/services/session/session.dart';
import 'package:scanpack_pickup/services/stop/stop.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PickupWithStops extends StatefulWidget {
  final String id;

  const PickupWithStops({super.key, required this.id});

  @override
  State<PickupWithStops> createState() => _PickupWithStopsState();
}

class _PickupWithStopsState extends State<PickupWithStops> with TickerProviderStateMixin {
  int activeIndex = 0;
  List<String> barcodes = [];
  Timer? _timer;
  bool _cameraPermissionsAccepted = false;
  final Tween<double> sizeTween = Tween<double>(
    begin: 0,
    end: 1,
  );

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  UseStop service = UseStop();

  @override
  void initState() {
    askForPermissions();
    super.initState();
  }

  Future<void> _signatureDialog(BuildContext context,int stopsLength) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SignaturePad(
          onSubmit: (value) async {
            Map<String, dynamic> payload = {
              'signature': MultipartFile.fromBytes(value.buffer.asInt8List()),
            };

            final formData = FormData.fromMap(payload);
            try {
              await service.save(formData);

              setState(() {
                activeIndex = stopsLength <= activeIndex ? activeIndex : activeIndex + 1;
              });
            } on TheError catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  TheSnackBar.of(
                      body: e.message,
                      status: e.status));
            }

            context.pop();
          }
        );
      },
    );
  }

  Future<void> _permissionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AskForPermissionsDialog(
          onClose: (bool value) {
            setState(() {
              _cameraPermissionsAccepted = value;
            });

            context.pop();
          },
        );
      },
    );
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

  String parseDateNow() {
    DateTime now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  mobileScanner () async {
    final scheme = Theme.of(context).colorScheme;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Stack(
          children: [
            AiBarcodeScanner(
              bottomBarText: 'Scan barcode',
              validator: (value) {
                return value.length == 13;
              },
              bottomBar: const SizedBox(),
              canPop: false,
              onScan: (String value) {
                debugPrint(value);
                int index = barcodes.indexOf(value);
                if(index == -1){
                  AudioPlayer().play(AssetSource('store-scanner-beep.mp3'));
                  barcodes.add(value);
                }

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
              },
              onDispose: () {
                debugPrint("Barcode scanner disposed!");
              },
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: Center(
                child: FloatingActionButton(
                  backgroundColor: scheme.primary,
                  onPressed: () {
                    context.pop();
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: ProFontAwesome(
                    icon: ProFontAwesomeIcon.xMark,
                    color: scheme.onPrimary,
                    weight: ProFontAwesomeWeight.Light,
                    size: 30,
                  ),
                ),
              ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    UsePickup service = Provider.of(context);
    final scheme = Theme.of(context).colorScheme;

    return MainLayout(
      resources: [
          () => service.getStops(int.parse(widget.id))
      ],
      body: Container(
        color: Colors.grey.shade300,
        child: Consumer<UsePickup>(
          builder: (_, provider, __) {
            return Stack(
              children: [
                  const Positioned(
                      top: 0,
                      bottom: 0,
                      left: 20,
                      child: Stripes(color: Colors.white, width: 8)
                  ),
                  const Positioned(
                      top: 0,
                      bottom: 0,
                      right: 20,
                      child: Stripes(color: Colors.white, width: 8)
                  ),
                  Builder(
                    builder: (_) {
                      if(provider.loading){
                        return SizedBox(
                          height: size.height,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2)
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        if(provider.stops.isNotEmpty){
                          return Padding(
                            padding: const EdgeInsets.only(left: 30, top: 15.0, bottom: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Material(
                                      color: Colors.green.shade600,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(3)),
                                        side: BorderSide(width: 2, color: Colors.white, strokeAlign: -1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              provider.item!.name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),

                                            const SizedBox(width: 12),
                                            const ProFontAwesome(
                                              icon: ProFontAwesomeIcon.road,
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: provider.stops.length,
                                      itemBuilder: (context, index) {
                                        return TimelineTile(
                                          alignment: TimelineAlign.manual,
                                          lineXY: 0.15,
                                          isFirst: index == 0,
                                          isLast: index == provider.stops.length - 1,
                                          beforeLineStyle: LineStyle(
                                            thickness: 2,
                                            color: scheme.tertiary,
                                          ),
                                          indicatorStyle: IndicatorStyle(
                                            width: 50,
                                            height: 50,
                                            indicator: Material(
                                              color: index <= activeIndex ? scheme.tertiary : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                  side: BorderSide(width: 2, color: scheme.tertiary, style: BorderStyle.solid)
                                              ),
                                              child: Center(
                                                child: index <= activeIndex ? ProFontAwesome(
                                                  icon: index <= activeIndex - 1 ? ProFontAwesomeIcon.check : ProFontAwesomeIcon.circleLocationArrow,
                                                  color: scheme.primary,
                                                  size: 30,
                                                  weight: ProFontAwesomeWeight.Solid,
                                                ): const SizedBox(),
                                              ),
                                            ),
                                          ),
                                          endChild: Container(
                                            constraints: const BoxConstraints(
                                              minHeight: 80,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onHorizontalDragUpdate: (value){
                                                      if(value.delta.dx < -1){
                                                        _controller.forward();
                                                      }

                                                      if(value.delta.dx > 1){
                                                        _controller.reverse();
                                                      }
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                                            child: Text(provider.stops[index].name),
                                                          ),
                                                          Builder(builder: (_){
                                                            return index == activeIndex ? Positioned(
                                                                left: size.width - 190,
                                                                top: 8,
                                                                child: const Image(
                                                                  image: AssetImage('assets/drag-3.png'),
                                                                  width: 28,
                                                                  height: 28,
                                                                  fit: BoxFit.contain,
                                                                )
                                                            ) : const SizedBox();
                                                          })
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Builder(builder: (_){
                                                  return index == activeIndex ? Stack(
                                                    alignment: Alignment.centerRight,
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                        height: 50,
                                                        child: Material(
                                                          color: Colors.grey.shade400,
                                                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                                        ),
                                                      ),
                                                      SizeTransition(
                                                        axis: Axis.horizontal,
                                                        sizeFactor: sizeTween.animate(_controller),
                                                        child: SizedBox(
                                                          width: 50,
                                                          height: 80,
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(height: 16),
                                                              Material(
                                                                color: Colors.grey.shade400,
                                                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                                                child: IconButton.filled(
                                                                    onPressed: () {_signatureDialog(context, provider.stops.length);},
                                                                    color: scheme.secondary,
                                                                    style: ButtonStyle(
                                                                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                                          const EdgeInsets.symmetric(vertical: 2, horizontal: 8)
                                                                        ),
                                                                        minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                        ))
                                                                    ),
                                                                    icon: ProFontAwesome(
                                                                      icon: ProFontAwesomeIcon.check,
                                                                      color: scheme.onSecondary,
                                                                      size: 24,
                                                                    )
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ) : const SizedBox();
                                                })
                                              ],
                                            ),
                                          ),
                                          startChild: Container(
                                            constraints: const BoxConstraints(
                                              minHeight: 80,
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          );
                        }
                        else{
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProFontAwesome(
                                icon: ProFontAwesomeIcon.hexagonExclamation,
                                color: scheme.error,
                                size: 60,
                                weight: ProFontAwesomeWeight.Light,
                              ),
                              const Text('No pickups available!'),
                            ],
                          );
                        }
                      }
                    },
                  ),
                  !provider.loading ? Positioned(
                    bottom: 20,
                    right: 20,
                    left: 20,
                    child: Center(
                      child: FloatingActionButton(
                        backgroundColor: _cameraPermissionsAccepted ?
                                            activeIndex == provider.stops.length ?
                                              Colors.green.shade400 :
                                              scheme.primary :
                                            scheme.error,
                        onPressed: () {
                          setState(() {
                            if(activeIndex == provider.stops.length){
                              context.pop();
                            } else{
                              _cameraPermissionsAccepted ? mobileScanner() : _permissionsDialog(context);
                            }
                          });
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: ProFontAwesome(
                          icon: _cameraPermissionsAccepted ?
                            activeIndex == provider.stops.length ?
                                            ProFontAwesomeIcon.check :
                                            ProFontAwesomeIcon.qrcode :
                                          ProFontAwesomeIcon.xMark,
                          color: scheme.onPrimary,
                          weight: activeIndex == provider.stops.length ? ProFontAwesomeWeight.Solid : ProFontAwesomeWeight.Light,
                          size: 30,
                        ),
                      ),
                    ),
                  ) : const SizedBox(),
                ]
            );
          }
        ),
      )
    );
  }
}
