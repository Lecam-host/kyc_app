import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyc_app/core/routes/page_route.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';
import 'package:kyc_app/features/kyc/presentation/cubit/kyc_cubit.dart';
import 'package:kyc_app/features/kyc/presentation/cubit/kyc_state.dart';
import 'package:kyc_app/features/kyc/presentation/pages/controller/kyc_controller.dart';

class KycResumePage extends StatelessWidget {
  final KycController controller;

  const KycResumePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return KycInfoWidget(
      kyc: KycModel(
        fullName: controller.nameController.text,
        photoPath: controller.selfiePath.text,
        rectoPath: controller.rectoDocPath.text,
        nationality: controller.nationalityController.text,
        birthDate: controller.dateController.text,
        versoPath: controller.versoDocPath.text,
      ),
    );
  }
}

class KycInfoWidget extends StatelessWidget {
  const KycInfoWidget({super.key, required this.kyc});
  final KycModel kyc;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KycCubit, KycState>(
      listener: (context, state) {
        if (state is KycSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("KYC soumis avec succès")),
          );
          context.go(PageRoutes.dashboard);
        } else if (state is KycError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Erreur d'envoi"),
                content: const Text(
                  "Impossible d'envoyer votre KYC pour le moment.\n"
                  "Voulez-vous sauvegarder vos informations en local pour réessayer plus tard ?",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // fermer le dialog
                    },
                    child: const Text("Annuler"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // fermer le dialog

                      // Sauvegarde locale (Hive ou autre)
                      final model = kyc;
                      context.read<KycCubit>().addKyc(model);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("KYC sauvegardé en local"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    child: const Text("Sauvegarder"),
                  ),
                ],
              );
            },
          );
        }
      },

      builder: (context, asyncSnapshot) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Informations personnelles"),
              _buildInfoRow("Nom complet", kyc.fullName),
              _buildInfoRow("Date de naissance", kyc.birthDate),
              _buildInfoRow("Nationalité", kyc.nationality),

              const SizedBox(height: 24),
              _buildSectionTitle("Pièce d'identité"),

              _buildDocPreview("Recto", kyc.rectoPath),
              const SizedBox(height: 12),
              if (kyc.versoPath != null)
                _buildDocPreview("Verso", kyc.versoPath ?? ""),

              const SizedBox(height: 24),
              _buildSectionTitle("Selfie"),

              Center(
                child: kyc.photoPath.isNotEmpty
                    ? ClipOval(
                        child: Image.file(
                          File(kyc.photoPath),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Text("Aucun selfie pris"),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<KycCubit>().kycSend(kyc);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("KYC soumis avec succès ")),
                    );
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    "Confirmer et soumettre",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 4, child: Text(value.isNotEmpty ? value : "—")),
        ],
      ),
    );
  }

  Widget _buildDocPreview(String label, String path) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        path.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(path),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : const Text("Pas encore fourni"),
      ],
    );
  }
}
