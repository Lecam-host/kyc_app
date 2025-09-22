import 'package:easy_localization/easy_localization.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormValidatorManage {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: tr("le_mot_de_passe_est_obligatoire")),
    MinLengthValidator(
      8,
      errorText: tr("mot_de_passe_doit_comporter_au_moins_8_caracteres"),
    ),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
    //     errorText: "")
  ]);

  final emaildValidator = MultiValidator([
    RequiredValidator(errorText: tr("email_obligatoire")),
    EmailValidator(errorText: tr("email_invalide")),
    PatternValidator(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      errorText: tr("email_invalide"),
    ),
  ]);
}
