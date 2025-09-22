import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
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
  const KycInfoWidget({super.key, required this.kyc, this.isNewSave = true});
  final KycModel kyc;
  final bool isNewSave;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KycCubit, KycState>(
      listener: (context, state) {
        if (state is KycSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text(context.tr("kyc_soumis_avec_succes")),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.go(PageRoutes.dashboard);
        } else if (state is KycError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 12),
                  Text(context.tr("erreur_api")),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          if (isNewSave) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange, size: 28),
                      SizedBox(width: 12),
                      Text(
                        context.tr("erreur_api"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr("impossible_d_envoyer_votre_kyc"),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      Text(
                        context.tr(
                          "voulez_vous_sauvegarder_vos_informations_en_local",
                        ),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        context.tr("annuler"),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final model = kyc;
                        context.read<KycCubit>().addKyc(model);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.save, color: Colors.white),
                                SizedBox(width: 12),
                                Text(context.tr("kyc_sauvegarde_en_local")),
                              ],
                            ),
                            backgroundColor: Colors.orange,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.save, size: 18),
                      label: Text(context.tr("sauvegarder")),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      builder: (context, asyncSnapshot) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey[50]!, Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionCard(
                  context: context,
                  title: context.tr("informations_personnelles"),

                  icon: Icons.person,
                  children: [
                    _buildInfoRow(
                      context.tr("annuler"),
                      kyc.fullName,
                      Icons.badge,
                    ),
                    _buildInfoRow(
                      context.tr("date_de_naissance"),
                      kyc.birthDate,
                      Icons.calendar_month,
                    ),
                    _buildInfoRow(
                      context.tr("Nationalité"),
                      kyc.nationality,
                      Icons.flag,
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Section pièce d'identité
                _buildSectionCard(
                  context: context,
                  title: context.tr("piece_d_identite"),
                  icon: Icons.credit_card,
                  children: [
                    _buildDocPreview(context.tr("annuler"), kyc.rectoPath),
                    if (kyc.versoPath != null) ...[
                      SizedBox(height: 16),
                      _buildDocPreview(
                        context.tr("verso"),
                        kyc.versoPath ?? "",
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 24),

                // Section selfie
                _buildSectionCard(
                  context: context,
                  title: context.tr("photo_selfie"),
                  icon: Icons.camera_alt,
                  children: [
                    Center(
                      child: kyc.photoPath.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.file(
                                  File(kyc.photoPath),
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    context.tr("aucun_selfie"),

                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),

                SizedBox(height: 40),

                // Bouton de soumission
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: asyncSnapshot is KycLoading
                        ? null
                        : () {
                            context.read<KycCubit>().kycSend(kyc);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: asyncSnapshot is KycLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                "${context.tr("soumission_en_cours")} ...",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, size: 24),
                              SizedBox(width: 12),
                              Text(
                                context.tr("confirmer_et_soumettre"),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                value.isNotEmpty ? value : tr("non_renseigne"),

                style: TextStyle(
                  fontSize: 15,
                  color: value.isNotEmpty ? Colors.grey[800] : Colors.grey[500],
                  fontWeight: value.isNotEmpty
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocPreview(String label, String path) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image, size: 18, color: Colors.grey[600]),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        path.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Image.file(
                        File(path),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 12),
                    Text(
                      tr("document_non_fourni"),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
