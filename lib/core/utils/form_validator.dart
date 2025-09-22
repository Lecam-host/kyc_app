import 'package:form_field_validator/form_field_validator.dart';

class FormValidatorManage {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: "Le mot de passe est obligatoire"),
    MinLengthValidator(
      8,
      errorText: "Le mot de passe doit comporter au moins 8 caractères",
    ),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
    //     errorText: "")
  ]);

  final emaildValidator = MultiValidator([
    RequiredValidator(errorText: "L'email est obligatoire"),
    EmailValidator(errorText: "L'email n'est pas valide"),
    PatternValidator(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      errorText: "L'email n'est pas valide",
    ),
  ]);
}
