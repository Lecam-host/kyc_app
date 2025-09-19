import 'package:flutter/material.dart';
import 'package:kyc_app/features/kyc/presentation/pages/controller/kyc_controller.dart';
import 'package:kyc_app/features/widgets/camera/camera_card_page.dart';

class KycCamera extends StatefulWidget {
  const KycCamera({
    super.key,
    required this.path,
    required this.title,
    required this.description,
    required this.descriptionPicture,
    required this.controller,
    required this.format,
  });
  final TextEditingController path;
  final String title;
  final String description;
  final String descriptionPicture;
  final OverlayFormat format;
  final KycController controller;

  @override
  State<KycCamera> createState() => _KycCameraState();
}

class _KycCameraState extends State<KycCamera> {
  late KycController controller;

  @override
  void initState() {
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CameraPage(
      format: widget.format,
      title: widget.title,
      description: widget.description,
      descriptionPicture: widget.descriptionPicture,
      onCapture: (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              format: widget.format,
              imagePath: value.path,
              onPressed: () {
                widget.path.text = value.path;
                controller.goNext(() => setState(() {}));
                Navigator.pop(context);
                Navigator.pop(context);
              },
              s: 0,
              title: widget.title,
              description: widget.description,
              descriptionPicture: widget.descriptionPicture,
            ),
          ),
        );
      },
      context: context,
    );
  }
}
