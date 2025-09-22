import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kyc_app/core/di.dart';
import 'package:kyc_app/core/routes/app_router.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';
import 'package:kyc_app/features/kyc/presentation/cubit/kyc_cubit.dart';

final router = di<AppRouter>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(KycModelAdapter());
  await configureDependencies();

  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
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

        builder: (context, child) {
          return child!;
        },
        routerConfig: router,
        title: 'kyc app',
      ),
    );
  }
}
