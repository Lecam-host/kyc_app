import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kyc_app/features/kyc/presentation/pages/controller/kyc_controller.dart';
import 'package:kyc_app/features/kyc/presentation/pages/kyc_camera.dart';
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
    return SafeArea(
      child: Column(
        children: [
          if (controller.rectoDocPath.text.isNotEmpty)
            SizedBox(
              height: 250,
              child: Image.file(
                File(controller.rectoDocPath.text),
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
                    title: "Prenez une photo recto de la carte d'identité",
                    description: "Positionnez votre carte d'identité recto",
                    descriptionPicture: "",
                    path: controller.rectoDocPath,
                    format: OverlayFormat.cardID1,
                  ),
                ),
              ).then((value) {
                setState(() {
                  controller.rectoDocPath;
                });
              });
            },
            child: Text('Recto'),
          ),
          if (controller.versoDocPath.text.isNotEmpty)
            SizedBox(
              height: 250,
              child: Image.file(
                File(controller.versoDocPath.text),
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
                    title: "Prenez une photo verso de la carte d'identité",
                    description: "Positionnez votre carte d'identité verso",
                    descriptionPicture: "",
                    path: controller.versoDocPath,
                    format: OverlayFormat.cardID1,
                  ),
                ),
              ).then((value) {
                setState(() {
                  controller.versoDocPath;
                });
              });
            },
            child: Text('verso'),
          ),
        ],
      ),
    );
  }
}
