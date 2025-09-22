import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kyc_app/features/kyc/presentation/pages/controller/kyc_controller.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_camera.dart';
import 'package:kyc_app/features/kyc/presentation/widget/section_title_card.dart';
import 'package:kyc_app/features/widgets/camera/camera_card_page.dart';

class KycDocPage extends StatefulWidget {
  const KycDocPage({super.key, required this.controller});
  final KycController controller;

  @override
  State<KycDocPage> createState() => _KycDocPageState();
}

class _KycDocPageState extends State<KycDocPage> {
  late KycController controller;
  TextEditingController path = TextEditingController();

  @override
  void initState() {
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec titre et description
              SectionTitleCard(
                title: context.tr('verification_d_identite'),
                subtitle: context.tr(
                  'photographiez_les_deux_faces_de_votre_piece_d_identite',
                ),
                icon: Icons.credit_card,
              ),

              const SizedBox(height: 32),

              // Section Recto
              _buildDocumentSection(
                context,
                title: context.tr('face_avant'),
                subtitle: context.tr(
                  'photographiez_la_face_avant_de_votre_document',
                ),
                imagePath: controller.rectoDocPath.text,
                icon: Icons.photo_camera_front,
                color: Theme.of(context).primaryColor,
                onTap: () => _navigateToCamera(
                  context,
                  context.tr('prenez_une_photo_recto_de_la_carte_d_identite'),
                  context.tr('prenez_une_photo_verso_de_la_carte_d_identite'),
                  controller.rectoDocPath,
                ),
                isRecto: true,
              ),

              const SizedBox(height: 24),

              // Section Verso
              _buildDocumentSection(
                context,
                title: context.tr('face_arriere'),
                subtitle: context.tr(
                  'photographiez_la_face_arriere_de_votre_document',
                ),
                imagePath: controller.versoDocPath.text,
                icon: Icons.photo_camera_back,
                color: Theme.of(context).primaryColor,
                onTap: () => _navigateToCamera(
                  context,
                  context.tr('prenez_une_photo_recto_de_la_carte_d_identite'),
                  context.tr('prenez_une_photo_verso_de_la_carte_d_identite'),
                  controller.versoDocPath,
                ),
              ),

              const SizedBox(height: 40),

              // Conseils
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isRecto = false,
  }) {
    final bool hasImage = imagePath.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.05),
          //   blurRadius: 10,
          //   offset: const Offset(0, 2),
          // ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hasImage ? Colors.green[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    hasImage ? Icons.check_circle : Icons.circle_outlined,
                    color: hasImage ? Colors.green : Colors.grey[400],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          if (!hasImage && isRecto) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "⚠ ${context.tr('photo_requise')}",
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],

          if (hasImage) ...[
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
          ],

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onTap,
                icon: Icon(
                  hasImage ? Icons.refresh : Icons.camera_alt,
                  size: 20,
                ),
                label: Text(
                  hasImage
                      ? context.tr('reprendre_la_photo')
                      : context.tr('prendre_la_photo'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCamera(
    BuildContext context,
    String title,
    String description,
    TextEditingController pathController,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KycCamera(
          isSelfie: false,
          controller: controller,
          title: "",
          description: description,
          descriptionPicture: "",
          path: pathController,
          format: OverlayFormat.cardID1,
        ),
      ),
    ).then((value) {
      setState(() {
        // Force rebuild pour afficher la nouvelle image
      });
    });
  }
}
