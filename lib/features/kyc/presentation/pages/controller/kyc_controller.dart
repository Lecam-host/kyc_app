import 'package:flutter/material.dart';

class KycController {
  final PageController progressController = PageController(initialPage: 0);
  final GlobalKey<FormState> userInfoFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController rectoDocPath = TextEditingController();
  TextEditingController versoDocPath = TextEditingController();
  TextEditingController selfiePath = TextEditingController();

  int currentPage = 0;
  int pageCount = 0;
  //Navigation methods to go to the next page
  void goNext(VoidCallback onUpdate, int pageCount) {
    if (currentPage < pageCount - 1) {
      if (currentPage == 0 &&
          userInfoFormKey.currentState?.validate() == true) {
        progressController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      } else if (currentPage == 1 && rectoDocPath.text.isNotEmpty) {
        progressController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      } else if (currentPage == 2 && selfiePath.text.isNotEmpty) {
        progressController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    }
  }

  //Navigation methods to go to the previous page
  void goPrevious(BuildContext context) {
    if (currentPage > 0) {
      progressController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void onPageChanged(int index, VoidCallback onUpdate) {
    currentPage = index;
    onUpdate();
  }

  void dispose() {
    progressController.dispose();
    nameController.dispose();
    dateController.dispose();
    nationalityController.dispose();
  }
}
