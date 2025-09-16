import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:kyc_app/features/widgets/form/text_field_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth')),
      body: Column(
        children: [
          TextFieldWidget(controller: emailController),
          TextFieldWidget(controller: password),

          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().login(
                emailController.text,
                password.text,
              );
            },
            child: const Text("Se connecter"),
          ),

          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const CircularProgressIndicator();
              } else if (state is AuthAuthenticated) {
                return Text("Bienvenue ${state.user.email}");
              } else if (state is AuthError) {
                return Text(state.message, style: TextStyle(color: Colors.red));
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
