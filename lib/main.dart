import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kyc_app/core/di.dart';
import 'package:kyc_app/core/routes/app_router.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kyc_app/features/kyc/presentation/cubit/kyc_cubit.dart';

final router = di<AppRouter>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  await EasyLocalization.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'assets/lang',
      fallbackLocale: const Locale('fr', 'FR'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di<AuthCubit>()),
        BlocProvider(create: (context) => di<KycCubit>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,

        supportedLocales: context.supportedLocales,

        builder: (context, child) {
          return child!;
        },
        routerConfig: router,
        title: 'kyc app',
      ),
    );
  }
}
