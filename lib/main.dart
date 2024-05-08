import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scanpack_pickup/router.dart';
import 'package:scanpack_pickup/services/pickup/pickup.dart';
import 'package:scanpack_pickup/services/session/session.dart';
import 'package:scanpack_pickup/services/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<UseSession>(create: (_) => UseSession()),
            ChangeNotifierProvider<UsePickup>(create: (_) => UsePickup()),
            ChangeNotifierProvider<Store>(create: (_) => Store()),
          ],
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DKV',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            primary: const Color.fromRGBO(245, 163, 0, 1),
            onPrimary: Colors.white,
            secondary: const Color.fromRGBO(58, 158, 253, 1),
            onSecondary: Colors.white,
            onSurface: const Color.fromRGBO(56, 56, 56, 1),
            tertiary: const Color.fromRGBO(62, 68, 145, 1),
            onTertiary: Colors.white,
            background: Colors.white,
            error: Colors.red.shade400
        ),
        appBarTheme: const AppBarTheme(
            color: Colors.white
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}