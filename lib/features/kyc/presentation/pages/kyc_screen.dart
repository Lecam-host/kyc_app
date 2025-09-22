import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kyc_app/features/kyc/presentation/pages/controller/kyc_controller.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_doc_page.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_resume_page.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_selfie_page.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_user_info_page.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  late KycController controller;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    controller = KycController();
    pages = [
      KycUserInfoPage(
        userInfoFormKey: controller.userInfoFormKey,
        nameController: controller.nameController,
        dateController: controller.dateController,
        nationality: controller.nationalityController,
      ),
      KycDocPage(controller: controller),
      KycSelfiePage(controller: controller),
      KycResumePage(controller: controller),
    ];
    controller.pageCount = pages.length;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: () => controller.goPrevious(context),
            child: Text(
              controller.currentPage > 0
                  ? context.tr("precedent")
                  : context.tr("annuler"),
            ),
          ),
          if (controller.currentPage != pages.length - 1)
            TextButton(
              onPressed: () =>
                  controller.goNext(() => setState(() {}), pages.length),
              child: Text(context.tr("suivant")),
            ),
        ],
      ),
      body: PageView(
        controller: controller.progressController,
        onPageChanged: (index) =>
            controller.onPageChanged(index, () => setState(() {})),
        children: pages,
      ),
    );
  }
}
