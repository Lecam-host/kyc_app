import 'dart:developer';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class CountrySelectInpunt extends FormField<CountryCode> {
  CountrySelectInpunt({
    super.key,
    required Function(CountryCode) onSelect,
    String? label,
    super.initialValue,
    super.validator,
  }) : super(
         builder: (FormFieldState<CountryCode> state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               CountryCodePicker(
                 headerText: "",
                 initialSelection: "",
                 onChanged: (CountryCode country) {
                   onSelect(country);
                   state.didChange(country); //  met à jour le FormField
                 },
                 onInit: (CountryCode? country) {
                   WidgetsBinding.instance.addPostFrameCallback((_) {
                     state.didChange(country);
                   });
                 },

                 showFlagMain: true,
                 showFlag: true,
                 showCountryOnly: false,
                 showOnlyCountryWhenClosed: false,
                 builder: (CountryCode? country) => Container(
                   padding: const EdgeInsets.all(15),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(12),
                     border: Border.all(
                       color: state.hasError ? Colors.red : Colors.grey,
                     ),
                     //color: Colors.white,
                   ),
                   child: Row(
                     children: [
                       if (country != null && country.flagUri != null)
                         Image.asset(
                           country.flagUri!,
                           package: 'country_code_picker',
                           width: 32,
                         ),
                       const SizedBox(width: 10),
                       Text(country?.name ?? "Sélectionnez un pays"),
                       const Spacer(),
                       const Icon(Icons.arrow_drop_down),
                     ],
                   ),
                 ),
                 countryFilter: const ['IT', 'FR', "CI"],
               ),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(top: 5, left: 8),
                   child: Text(
                     state.errorText!,
                     style: const TextStyle(color: Colors.red, fontSize: 12),
                   ),
                 ),
             ],
           );
         },
       );
}
