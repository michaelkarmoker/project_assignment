
import 'dart:async';
import 'dart:io';


import 'package:project_assessment/data/model/body/signup_body.dart';
import 'package:project_assessment/view/base/custom_button.dart';
import 'package:project_assessment/view/base/custom_snackbar.dart';
import 'package:project_assessment/view/base/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_assessment/view/screen/auth/signIn.dart';



import '../../../controller/auth_controller.dart';
import '../../../util/dimensions.dart';
class SignUp extends StatefulWidget {
  final bool exitFromApp;

  const SignUp({Key? key, required this.exitFromApp}) : super(key: key);
  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<SignUp> {


  //text field controller
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //text field focus node
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode userNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool _canExit = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: WillPopScope(
          onWillPop: ()async {
            if(widget.exitFromApp) {
              if (_canExit) {
                if (GetPlatform.isAndroid) {
                  SystemNavigator.pop();
                } else if (GetPlatform.isIOS) {
                  exit(0);
                } else {
                 // Navigator.pushNamed(context, RouteHelper.getInitialRoute());
                }
                return Future.value(false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Back press again to exit', style: TextStyle(color: Colors.white)),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                ));
                _canExit = true;
                Timer(Duration(seconds: 2), () {
                  _canExit = false;
                });
                return Future.value(false);
              }
            }else {
              return true;
            }
          },
          child: SafeArea(
            child: GetBuilder<AuthController>(

              builder: (authController) {
                return SingleChildScrollView(
                  child: Container(

                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0,right: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: Get.height/10,),
                            Card(
                              elevation: 4,
                              child: Container(

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white24
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      Container(
                                        padding: EdgeInsets.all(10),

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            CustomTextField(

                                              hintText: "First Name",
                                              controller: firstNameController,
                                              focusNode: firstNameFocus,
                                              nextFocus: lastNameFocus,
                                              inputType: TextInputType.text,
                                              capitalization: TextCapitalization.words,
                                              divider: true, onSubmit: (){}, prefixIcon:'assets/icon/user.png',

                                            ),
                                            CustomTextField(

                                              hintText: "Last Name",
                                              controller: lastNameController,
                                              focusNode: lastNameFocus,
                                              nextFocus: userNameFocus,
                                              inputType: TextInputType.text,
                                              capitalization: TextCapitalization.words,
                                              divider: true, onSubmit: (){}, prefixIcon:'assets/icon/user.png',

                                            ),
                                            CustomTextField(

                                              hintText: "User Name",
                                              controller: userNameController,
                                              focusNode: userNameFocus,
                                              nextFocus: emailFocus,
                                              inputType: TextInputType.text,
                                              capitalization: TextCapitalization.words,
                                              divider: true, onSubmit: (){}, prefixIcon:'assets/icon/user.png',

                                            ),
                                            CustomTextField(

                                              hintText: "Email",
                                              controller: emailController,
                                              focusNode: emailFocus,
                                              nextFocus: passwordFocus,
                                              inputType: TextInputType.emailAddress,
                                              capitalization: TextCapitalization.words,
                                              divider: true, onSubmit: (){}, prefixIcon:'assets/icon/email.png',

                                            ),
                                            CustomTextField(

                                              hintText: "Password",
                                              controller: passwordController,
                                              focusNode: passwordFocus,
                                              nextFocus: passwordFocus,
                                              inputType: TextInputType.visiblePassword,
                                              capitalization: TextCapitalization.words,
                                              divider: true,
                                              isPassword: true, prefixIcon: "assets/icon/lock.png", onSubmit: (){},

                                            ),
                                            CustomTextField(

                                              hintText: "Confirm Password",
                                              controller: confirmPasswordController,
                                              focusNode: confirmPasswordFocus,
                                              inputAction: TextInputAction.done,
                                              inputType: TextInputType.visiblePassword,
                                              capitalization: TextCapitalization.words,
                                              divider: true,
                                              isPassword: true, prefixIcon: "assets/icon/lock.png", onSubmit: (){}, nextFocus: null,

                                            ),
                                            SizedBox(height: 10,),

                                            SizedBox(height: 20,),
                                            !authController.isLoading ?CustomButton(
                                              width: Get.width,
                                              buttonText: 'Sign Up',
                                              onPressed: ()=>{
                                                signUpValidation(authController),
                                              },
                                            ):Center(child: CircularProgressIndicator()),
                                            SizedBox(height: 25,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Already have an account?"),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            CustomButton(

                                              width: Get.width,

                                              buttonText: 'Sign In',
                                              onPressed: ()=>{
                                                Get.offAll(SignIn(exitFromApp: true))

                                              },
                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            )
          ),
        )

    );
  }

  // validation of user data
  void signUpValidation (AuthController controller) async {
    String _firstName = userNameController.text.trim();
    String _lastName = userNameController.text.trim();
    String _userName = userNameController.text.trim();
    String _email = userNameController.text.trim();
    String _confirmPassword = confirmPasswordController.text.trim();
    String _password = passwordController.text.trim();

    if (_firstName.isEmpty) {
      showCustomSnackBar('Enter First Name');
    }else if (_lastName.isEmpty) {
      showCustomSnackBar('Enter Last Name');
    }
    else if (_userName.isEmpty) {
      showCustomSnackBar('Enter your username');
    }
    else if (_email.isEmpty) {
      showCustomSnackBar('Enter your email');
    }
    else if (_password.isEmpty) {
      showCustomSnackBar('Enter your password');
    } else if (_password.length < 5) {
      showCustomSnackBar('The Password must be at least 5 Characters');
    }
    else if (_confirmPassword.length < 5) {
      showCustomSnackBar("The Confirm password doesn't match");
    }else {

      controller.signUp(new SignUpBody(username: _userName,password: _password,email: _email,profile:new Profile(firstName: _firstName,lastName: _lastName)));
    }

  }
}
