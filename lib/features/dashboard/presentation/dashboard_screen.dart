import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyc_app/core/routes/page_route.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:kyc_app/features/kyc/presentation/cubit/kyc_cubit.dart';
import 'package:kyc_app/features/kyc/presentation/cubit/kyc_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    context.read<AuthCubit>().getCurrentUser();
    context.read<KycCubit>().loadKycs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoggedOut) {
          context.go(PageRoutes.auth);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthAuthenticated) {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              bottomSheet: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthCubit>().logout(context, state.user);
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Se déconnecter",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.deepPurple,
                title: const Text(
                  "Tableau de bord",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Carte Profil utilisateur
                    // Card(
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(16),
                    //   ),
                    //   //elevation: 4,
                    //   child: ,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.deepPurple[100],
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  state.user.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Carte KYC
                    BlocBuilder<KycCubit, KycState>(
                      builder: (context, kycState) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Vérification d'identité (KYC)",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  kycState is KycSavedLocal
                                      ? "KYC sauvegardé en local"
                                      : "Complétez votre inscription",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kycState is KycSavedLocal
                                        ? Colors.orange
                                        : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (kycState is KycSavedLocal) {
                                        context.push(
                                          PageRoutes.dashboardKycResume,
                                          extra: kycState.kyc,
                                        );
                                      } else {
                                        context.push(PageRoutes.kyc);
                                      }
                                    },
                                    icon: const Icon(Icons.badge),
                                    label: const Text(
                                      "Terminer votre KYC",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
