import 'package:go_router/go_router.dart';
import 'package:scanpack_pickup/pages/landing.dart';
import 'package:scanpack_pickup/pages/pickup-with-stops.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const Landing(),
    ),
    GoRoute(
      path: '/pickup-stops/:id',
      builder: (_, state) => PickupWithStops(id: state.pathParameters['id']!),
    )
  ],
);