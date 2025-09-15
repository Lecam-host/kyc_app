import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyc_app/core/routes/page_route.dart';
import 'package:kyc_app/features/auth/presentation/pages/auth_page.dart';

class AppRouter extends GoRouter {
  AppRouter()
    : super.routingConfig(
        initialLocation: PageRoutes.auth,
        observers: <NavigatorObserver>[],
        routingConfig: ValueNotifier<RoutingConfig>(
          RoutingConfig(
            routes: [
              GoRoute(
                path: PageRoutes.auth,
                builder: (context, state) => const AuthPage(),
              ),
            ],
          ),
        ),
      );
}
