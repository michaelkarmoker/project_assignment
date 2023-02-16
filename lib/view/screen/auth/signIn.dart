
import 'dart:async';
import 'dart:io';


import 'package:project_assessment/data/model/body/login_body.dart';
import 'package:project_assessment/util/images.dart';
import 'package:project_assessment/view/base/custom_button.dart';
import 'package:project_assessment/view/base/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_assessment/view/screen/auth/signUp.dart';



import '../../../controller/auth_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

import '../../base/custom_snackbar.dart';





class SignIn extends StatefulWidget {
  final bool exitFromApp;

  const SignIn({Key? key, required this.exitFromApp}) : super(key: key);
  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<SignIn> {


  //text field controller
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //text field focus node
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _canExit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
          setRememberUser(Get.find<AuthController>());
          Get.find<AuthController>().getUserName().isNotEmpty?Get.find<AuthController>().isActiveRememberMe=true:Get.find<AuthController>().isActiveRememberMe=false;
          Get.find<AuthController>().update();
        });

  }
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
                  backgroundColor: Color(0xff29CA8E),
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
                      height: Get.height,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0,right: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

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
                                      SizedBox(height:10),

                                      Container(
                                        padding: EdgeInsets.all(10),

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            Column(
                                              children: [
                                                CustomTextField(

                                                  hintText: "Email",
                                                  controller: userNameController,
                                                  focusNode: _emailFocus,
                                                  nextFocus: _passwordFocus,
                                                  inputType: TextInputType.emailAddress,
                                                  capitalization: TextCapitalization.words,
                                                  divider: false, onSubmit: (){}, prefixIcon:'assets/icon/user.png',

                                                ),
                                                CustomTextField(

                                                  hintText: "Password",
                                                  controller: passwordController,
                                                  focusNode: _passwordFocus,
                                                  inputAction: TextInputAction.done,
                                                  inputType: TextInputType.visiblePassword,
                                                  capitalization: TextCapitalization.words,
                                                  divider: false,
                                                  isPassword: true, prefixIcon: "assets/icon/lock.png", onSubmit: (){}, nextFocus: null,

                                                ),
                                              ],
                                            ),


                                            SizedBox(height: 10,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Checkbox(

                                                  value: authController.isActiveRememberMe,

                                                  onChanged: (bool? isChecked) => authController.isActiveRememberMe=isChecked!,
                                                ),

                                                Text('Remember me',style: TextStyle(fontSize: Dimensions.fontSizeExtraLarge),),
                                              ],
                                            ),
                                            SizedBox(height: 20,),
                                            !authController.isLoading ?CustomButton(

                                              width: Get.width,

                                              buttonText: 'Sign In',
                                              onPressed: ()=>{
                                                loginVerification(authController)

                                              },
                                            ):Center(child: CircularProgressIndicator()),
                                            SizedBox(height: 25,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Don't have any account?"),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            CustomButton(

                                              width: Get.width,

                                              buttonText: 'Sign Up',
                                              onPressed: ()=>{
                                                Get.to(SignUp(exitFromApp: false))

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
                            SizedBox(height: 20,),


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
  Future<void> setRememberUser(AuthController controller) async {
    String userName = controller.getUserName();
    String password = controller.getUserPassword();
    userNameController.text = userName;
    passwordController.text = password;
  }



  void loginVerification(AuthController controller) async {
    String _userName = userNameController.text.trim();
    String _password = passwordController.text.trim();

    if (_userName.isEmpty) {
      showCustomSnackBar('Enter username');
    } else if (_password.isEmpty) {
      showCustomSnackBar('Enter password');
    } else if (_password.length < 5) {
      showCustomSnackBar('The Password must be at least 5 Characters');
    } else {
      controller.signIn(new LoginBody(username: _userName,password: _password));
    }

  }
}
