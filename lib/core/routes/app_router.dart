import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyc_app/core/routes/page_route.dart';
import 'package:kyc_app/features/auth/presentation/pages/auth_page.dart';
import 'package:kyc_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:kyc_app/features/dashboard/presentation/kyc_resume_screen.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_screen.dart';
import 'package:kyc_app/features/splash/presentation/splash_screen.dart';

class AppRouter extends GoRouter {
  AppRouter()
    : super.routingConfig(
        initialLocation: PageRoutes.splash,
        observers: <NavigatorObserver>[],
        routingConfig: ValueNotifier<RoutingConfig>(
          RoutingConfig(
            routes: [
              GoRoute(
                path: PageRoutes.auth,
                builder: (context, state) => const AuthPage(),
              ),
              GoRoute(
                path: PageRoutes.splash,
                builder: (context, state) => const SplashPage(),
              ),
              GoRoute(
                path: PageRoutes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
              GoRoute(
                path: PageRoutes.kyc,
                builder: (context, state) => const KycScreen(),
              ),
              GoRoute(
                path: PageRoutes.dashboardKycResume,
                builder: (context, state) {
                  final kyc = state.extra as KycModel;
                  return KycResumeScreen(kyc: kyc);
                },
              ),
            ],
          ),
        ),
      );
}
