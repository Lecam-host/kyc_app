import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyc_app/core/di.dart';
import 'package:kyc_app/features/auth/data/datasources/auth_local_ds.dart';
import 'package:kyc_app/features/auth/domain/entities/user_entity.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_cubit.dart'
    show AuthCubit;
import 'package:kyc_app/features/auth/presentation/cubit/auth_state.dart';
import '../../../../core/routes/page_route.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AccountLocalDataSourceImpl accountLocalDataSource =
      AccountLocalDataSourceImpl(sharedPreferences: di());
  UserEntity? currentUser;
  getUserLocaldata() async {
    currentUser = await accountLocalDataSource.loadData();
    setState(() {
      currentUser;
    });
  }

  @override
  void initState() {
    context.read<AuthCubit>().getCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(PageRoutes.dashboard);
        } else if (state is AuthLoggedOut) {
          context.go(PageRoutes.auth);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [const SizedBox(height: 10), const Text("....")],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
