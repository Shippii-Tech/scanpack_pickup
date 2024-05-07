import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scanpack_pickup/components/Stripes.dart';
import 'package:scanpack_pickup/font_awesome_flutter.dart';
import 'package:scanpack_pickup/layouts/MainLayout.dart';
import 'package:scanpack_pickup/services/pickup/pickup.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PickupWithStops extends StatefulWidget {
  final String id;

  const PickupWithStops({super.key, required this.id});

  @override
  State<PickupWithStops> createState() => _PickupWithStopsState();
}

class _PickupWithStopsState extends State<PickupWithStops> {
  int activeIndex = 0;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    UsePickup service = Provider.of(context);
    final scheme = Theme.of(context).colorScheme;
    return MainLayout(
      resources: [
          () => service.getStops(int.parse(widget.id))
      ],
      body:  Consumer<UsePickup>(
        builder: (_, provider, __) {
          return Stack(
            children: [
                Container(
                  color: Colors.grey.shade300,
                  child: Builder(
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
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                            child: Column(
                              children: [
                                Center(
                                  child: Material(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('data')
                                      ],
                                    ),
                                  ),
                                ),
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
                                              // elevation: index <= activeIndex ? 2 : 0,
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
                                          endChild: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                                            child: Text(provider.stops[index].name),
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
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  left: 20,
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: activeIndex == provider.stops.length ? Colors.green.shade400 : scheme.primary,
                      onPressed: () {
                        setState(() {
                          activeIndex = provider.stops.length <= activeIndex ? activeIndex : activeIndex + 1;
                        });
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: ProFontAwesome(
                        icon: activeIndex == provider.stops.length ? ProFontAwesomeIcon.check: ProFontAwesomeIcon.qrcode,
                        color: scheme.onPrimary,
                        weight: activeIndex == provider.stops.length ? ProFontAwesomeWeight.Solid : ProFontAwesomeWeight.Light,
                        size: 30,
                      ),
                    ),
                  ),
                ),
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
              ]
          );
        }
      )
    );
  }
}
