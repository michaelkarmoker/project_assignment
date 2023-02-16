import 'dart:convert';
import 'dart:io';



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_assessment/data/model/body/login_body.dart';
import 'package:project_assessment/data/model/body/signup_body.dart';
import 'package:project_assessment/data/model/response/login_response.dart';
import 'package:project_assessment/view/base/custom_snackbar.dart';
import 'package:project_assessment/view/screen/auth/signIn.dart';
import 'package:project_assessment/view/screen/home/home_screen.dart';




import '../data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;


  AuthController({
    required this.authRepo,
  });





  bool _isLoading = false;
  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  set isActiveRememberMe(bool value) {
    _isActiveRememberMe = value;
    update();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }



  Future<void> signIn(LoginBody loginBody) async {
    _isLoading = true;
    update();

    Response response = await authRepo.signIn(loginBody: loginBody);


    if (response.statusCode == 200) {
      LoginResponse loginResponse =LoginResponse.fromJson(response.body);

       if(_isActiveRememberMe){
         await authRepo.saveUserNameAndPassword(loginBody.username!, loginBody.password!);
       }else{
         await authRepo.clearUserNumberAndPassword();
       }

       //save user session id
        await authRepo.saveUserSession(loginResponse!.sessionId!);
       //show successful toast
        showCustomSnackBar("Login Successfully",isError: false);
        //move to home screen
        Get.offAll(Home(exitFromApp: true,));

    } else {
    //if unsuccessful status code then showing error massage
      showCustomSnackBar(response.body["error_description"]);

    }

    _isLoading = false;
    update();
  }




  Future<void> signUp(SignUpBody signUpBody) async {
    _isLoading = true;
    update();

    Response response = await authRepo.signUp(signUpBody: signUpBody);


    if (response.statusCode == 201) {

      //show successful toast
      showCustomSnackBar("SignUp Successfully,Please login now!!",isError: false);
      //move to signIn screen
      Get.offAll(SignIn(exitFromApp: true));

    } else {
      //if unsuccessful status code then showing error massage
      showCustomSnackBar(response.body["error_description"]);

    }

    _isLoading = false;
    update();
  }





  bool isLoggedIn() {

    return authRepo.isLoggedIn();
  }


  void saveUserNameAndPassword(
    String UserName,
    String password,
  ) {
    authRepo.saveUserNameAndPassword(UserName, password);
  }

  String getUserName() {
    return authRepo.getUserName() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }


  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }
  Future<bool> signOut() async {
    Get.offAll(SignIn(exitFromApp: true));
    return authRepo.clearUserSigningInfo();
  }

  String getUserSession() {
    return authRepo.getUserSession();
  }

}
