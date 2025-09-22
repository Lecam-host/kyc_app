import 'package:flutter/material.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_resume_page.dart';

class KycResumeScreen extends StatelessWidget {
  const KycResumeScreen({super.key, required this.kyc});
  final KycModel kyc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kyc Resume")),
      body: KycInfoWidget(kyc: kyc),
    );
  }
}
