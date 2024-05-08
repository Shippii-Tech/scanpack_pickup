import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scanpack_pickup/components/FancyButton.dart';
import 'package:scanpack_pickup/font_awesome_flutter.dart';
import 'package:scanpack_pickup/layouts/MainLayout.dart';
import 'package:scanpack_pickup/services/pickup/pickup.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing>{


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    UsePickup service = Provider.of(context);
    final scheme = Theme.of(context).colorScheme;

    return MainLayout(
      resources: [
          () => service.get()
      ],
      body: Container(
        color: Colors.white,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                  expandedHeight: 105,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: scheme.tertiary.withOpacity(.85),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                            child: Column(
                              children: [
                                Text('Current active pickup', textAlign: TextAlign.center, style: TextStyle(color: scheme.onTertiary)),

                                IconButton.filled(
                                    onPressed: (){},
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all<double?>(2.0),
                                      shadowColor:  MaterialStateProperty.all<Color?>(Colors.black),
                                    ),
                                    color: scheme.primary,
                                    icon: ProFontAwesome(
                                      icon: ProFontAwesomeIcon.arrowProgress,
                                      color: scheme.onPrimary,
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              )
            ];
          },
          body: Column(
            children: [
              Expanded(
                child: Consumer<UsePickup>(
                  builder: (_, provider, __) {
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
                      if(provider.items.isNotEmpty){
                        return ListView.builder(
                          itemCount: provider.items.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                index == 0 ?  const Divider(color: Colors.transparent) : const SizedBox(),
                                ListTile(
                                  title: Text(provider.items[index].name),
                                  trailing: FancyButton(
                                    onPressed: () {
                                      context.push(Uri(path:'/pickup-stops/${provider.items[index].id}').toString());
                                    },
                                    variant: FancyButtonVariant.icon,
                                    loading: service.loading,
                                    child: const ProFontAwesome(
                                      icon: ProFontAwesomeIcon.arrowRight,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  )
                                ),
                                Divider(color: Colors.grey.shade300)
                              ],
                            );
                          },
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
                            const Text('No pickups available!f'),
                          ],
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
