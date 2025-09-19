import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kyc_app/features/kyc/presentation/pages/controller/kyc_controller.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_camera.dart';
import 'package:kyc_app/features/widgets/camera/camera_card_page.dart';

class KycSelfiePage extends StatefulWidget {
  const KycSelfiePage({super.key, required this.controller});
  final KycController controller;

  @override
  State<KycSelfiePage> createState() => _KycSelfiePageState();
}

class _KycSelfiePageState extends State<KycSelfiePage> {
  late KycController controller;
  @override
  void initState() {
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (controller.selfiePath.text.isNotEmpty)
            SizedBox(
              height: 250,
              child: Image.file(
                File(controller.selfiePath.text),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KycCamera(
                    controller: controller,
                    title: "Prenez une photo de vous",
                    description: "Positionnez votre visage",
                    descriptionPicture: "",
                    path: controller.selfiePath,
                    format: OverlayFormat.cardID1,
                  ),
                ),
              ).then((value) {
                setState(() {
                  controller.selfiePath;
                });
              });
            },
            child: Text('prendre la photo'),
          ),
        ],
      ),
    );
  }
}
