import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kyc_app/features/widgets/form/country_field_widget.dart';
import 'package:kyc_app/features/widgets/form/date_field_widget.dart';
import 'package:kyc_app/features/widgets/form/text_field_widget.dart';

class KycUserInfoPage extends StatefulWidget {
  const KycUserInfoPage({
    super.key,
    required this.userInfoFormKey,
    required this.nameController,
    required this.dateController,
    required this.nationality,
  });
  final GlobalKey<FormState> userInfoFormKey;

  final TextEditingController nameController;
  final TextEditingController dateController;
  final TextEditingController nationality;
  @override
  State<KycUserInfoPage> createState() => _KycUserInfoPageState();
}

class _KycUserInfoPageState extends State<KycUserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.userInfoFormKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 20,
          children: [
            Text(
              context.tr("veuillez_renseigner_vos_informations_personnelles"),
            ),
            TextFieldWidget(
              controller: widget.nameController,
              labelText: context.tr("nom_complet"),
              validator: (value) {
                return value!.isEmpty
                    ? context.tr("veuillez_renseigner_votre_nom_complet")
                    : null;
              },
            ),

            DateFieldWidget(
              controller: widget.dateController,
              validator: (value) {
                return value!.isEmpty
                    ? context.tr("veuillez_renseigner_votre_date_de_naissance")
                    : null;
              },
            ),
            CountrySelectInpunt(
              onSelect: (CountryCode p1) {
                setState(() {
                  widget.nationality.text = p1.name ?? "";
                });
              },
              validator: (value) {
                return value == null
                    ? context.tr("veuillez_renseigner_votre_nationalite")
                    : null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
