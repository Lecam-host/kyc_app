import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyc_app/core/routes/page_route.dart';
import 'package:kyc_app/core/utils/form_validator.dart';
import 'package:kyc_app/features/auth/data/dto/register_dto.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:kyc_app/features/widgets/form/date_field_widget.dart';
import 'package:kyc_app/features/widgets/form/text_field_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FormValidatorManage _validator = FormValidatorManage();
  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              labelColor: Colors.teal.shade900,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: Colors.teal.shade900,
              tabs: [
                Tab(text: context.tr("se_connecter")),
                Tab(text: context.tr("s_inscrire")),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildLoginForm(context), _buildSignUpForm()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(PageRoutes.dashboard);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${context.tr("bienvenue")} ${state.user.email}"),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.tr("connectez_vous_pour_acceder_a_votre_compte"),
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                const SizedBox(height: 30),

                TextFieldWidget(
                  controller: _emailController,
                  labelText: context.tr("email"),
                  validator: (value) => _validator.emaildValidator.call(value),
                ),
                const SizedBox(height: 20),

                TextFieldWidget(
                  controller: _passwordController,
                  labelText: context.tr("mot_de_passe"),
                  validator: (value) =>
                      _validator.passwordValidator.call(value),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (loginFormKey.currentState!.validate()) {
                              context.read<AuthCubit>().login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.teal.shade900,
                    ),
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            context.tr("se_connecter"),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignUpForm() {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final birthDateController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(PageRoutes.dashboard);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "${context.tr("votre_compte_a_bien_etee_cree")} ${state.user.name}",
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr("inscrivez_vous_pour_acceder_a_votre_compte"),
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      labelText: "Nom complet",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.tr(
                            "veuillez_renseigner_votre_nom_complet",
                          );
                        }
                        return null;
                      },
                      controller: nameController,
                    ),

                    TextFieldWidget(
                      labelText: context.tr("email"),
                      validator: (value) =>
                          _validator.emaildValidator.call(value),
                      controller: emailController,
                    ),
                    DateFieldWidget(
                      controller: birthDateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.tr(
                            "veuillez_renseigner_votre_date_de_naissance",
                          );
                        }
                        return null;
                      },
                    ),
                    TextFieldWidget(
                      labelText: context.tr("numero_de_telephone"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.tr(
                            "veuillez_entrer_votre_numero_de_telephone",
                          );
                        }
                        return null;
                      },
                      controller: phoneController,
                    ),

                    TextFieldWidget(
                      labelText: context.tr("mot_de_passe"),
                      validator: (value) =>
                          _validator.passwordValidator.call(value),
                      controller: passwordController,
                    ),
                    TextFieldWidget(
                      labelText: context.tr("confirmer_le_mot_de_passe"),
                      validator: (value) =>
                          _validator.passwordValidator.call(value),
                      controller: confirmPasswordController,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  if (passwordController.text.trim() !=
                                      confirmPasswordController.text.trim()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.tr(
                                            "les_mots_de_passe_ne_correspondent_pas",
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  } else {
                                    context.read<AuthCubit>().register(
                                      RegisterDto(
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                        name: nameController.text.trim(),
                                        phone: phoneController.text.trim(),
                                        birthDate: birthDateController.text
                                            .trim(),
                                      ),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.teal.shade900,
                        ),
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                context.tr("s_inscrire"),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
