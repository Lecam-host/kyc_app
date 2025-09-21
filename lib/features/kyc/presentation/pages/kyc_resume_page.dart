import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kyc_app/features/kyc/presentation/pages/controller/kyc_controller.dart';

class KycResumePage extends StatelessWidget {
  final KycController controller;

  const KycResumePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Informations personnelles"),
          _buildInfoRow("Nom complet", controller.nameController.text),
          _buildInfoRow("Date de naissance", controller.dateController.text),
          _buildInfoRow("Nationalité", controller.nationalityController.text),

          const SizedBox(height: 24),
          _buildSectionTitle("Pièce d'identité"),

          _buildDocPreview("Recto", controller.rectoDocPath.text),
          const SizedBox(height: 12),
          _buildDocPreview("Verso", controller.versoDocPath.text),

          const SizedBox(height: 24),
          _buildSectionTitle("Selfie"),

          Center(
            child: controller.selfiePath.text.isNotEmpty
                ? ClipOval(
                    child: Image.file(
                      File(controller.selfiePath.text),
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
               
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("KYC soumis avec succès ✅")),
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
            : const Text("⚠ Pas encore fourni"),
      ],
    );
  }
}
