

import 'package:project_assessment/controller/auth_controller.dart';
import 'package:project_assessment/view/base/custom_snackbar.dart';
import 'package:project_assessment/view/screen/auth/signIn.dart';
import 'package:get/get.dart';




class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      showCustomSnackBar(response.statusText!);
      Get.find<AuthController>().signOut();

      Get.offAll(SignIn(exitFromApp: true,));
    }else {
     showCustomSnackBar(response.statusText!);
    }
  }
}
