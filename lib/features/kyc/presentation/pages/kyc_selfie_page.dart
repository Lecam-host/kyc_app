import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kyc_app/features/kyc/presentation/pages/controller/kyc_controller.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_camera.dart';
import 'package:kyc_app/features/kyc/presentation/widget/section_title_card.dart';
import 'package:kyc_app/features/widgets/camera/camera_card_page.dart';

class KycSelfiePage extends StatefulWidget {
  const KycSelfiePage({super.key, required this.controller});
  final KycController controller;

  @override
  State<KycSelfiePage> createState() => _KycSelfiePageState();
}

class _KycSelfiePageState extends State<KycSelfiePage>
    with SingleTickerProviderStateMixin {
  late KycController controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    controller = widget.controller;

    // Initialiser les animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = controller.selfiePath.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitleCard(
                        title: context.tr("photo_de_profil"),
                        subtitle: context.tr(
                          "positionnez_votre_visage_dans_le_cadre",
                        ),
                        icon: Icons.face_retouching_natural,
                      ),

                      const SizedBox(height: 32),

                      // Section principale avec photo ou placeholder
                      Center(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 32),

                              // Avatar section
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Cercles décoratifs animés
                                  ...List.generate(3, (index) {
                                    return AnimatedContainer(
                                      duration: Duration(
                                        milliseconds: 1000 + (index * 200),
                                      ),
                                      curve: Curves.easeInOut,
                                      width: 100 + (index * 40.0),
                                      height: 100 + (index * 40.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(
                                            0xFF8B5CF6,
                                          ).withOpacity(0.1 - (index * 0.03)),
                                          width: 2,
                                        ),
                                      ),
                                    );
                                  }),

                                  // Photo ou placeholder
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: hasPhoto ? null : Colors.grey[100],
                                      border: Border.all(
                                        color: hasPhoto
                                            ? const Color(0xFF10B981)
                                            : Colors.grey[300]!,
                                        width: 4,
                                      ),
                                      boxShadow: hasPhoto
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF10B981,
                                                ).withOpacity(0.3),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: hasPhoto
                                        ? ClipOval(
                                            child: Image.file(
                                              File(controller.selfiePath.text),
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.person_outline,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                  ),

                                  // Badge de validation
                                  if (hasPhoto)
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF10B981),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Statut et description
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: hasPhoto
                                      ? const Color(0xFF10B981).withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  hasPhoto
                                      ? "✓ ${context.tr("photo_valid")}"
                                      : "⚠ ${context.tr("photo_requise")}",
                                  style: TextStyle(
                                    color: hasPhoto
                                        ? const Color(0xFF10B981)
                                        : Colors.orange[700],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Text(
                                  hasPhoto
                                      ? context.tr(
                                          "parfait_votre_photo_a_etee_capturee_avec_succes",
                                        )
                                      : context.tr(
                                          "positionnez_votre_visage_dans_le_cadre_pour_prendre_votre_photo",
                                        ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Bouton d'action
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  0,
                                  24,
                                  32,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _navigateToCamera(context),
                                    icon: Icon(
                                      hasPhoto
                                          ? Icons.refresh
                                          : Icons.camera_alt,
                                      size: 24,
                                    ),
                                    label: Text(
                                      hasPhoto
                                          ? context.tr("reprendre_la_photo")
                                          : context.tr("prendre_la_photo"),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Conseils pour un bon selfie
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToCamera(BuildContext context) {
    // Animation lors de la navigation
    _animationController.reverse().then((_) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => KycCamera(
            isSelfie: true,
            controller: controller,
            title: "",
            description: context.tr("positionnez_votre_visage_dans_le_cadre"),
            descriptionPicture: "",
            path: controller.selfiePath,
            format: OverlayFormat.oval,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ).then((value) {
        // Relancer l'animation au retour
        _animationController.forward();
        setState(() {
          controller.selfiePath;
        });
      });
    });
  }
}
