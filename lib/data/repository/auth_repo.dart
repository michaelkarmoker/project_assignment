import 'dart:async';




import 'package:flutter/foundation.dart';
import 'package:get/get.dart';



import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';
import '../model/body/login_body.dart';
import '../model/body/signup_body.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});


  Future<Response> signIn({required LoginBody loginBody}) async {

    return await apiClient.postData(AppConstants.LOGIN_URI, loginBody.toJson());
  }

  Future<Response> signUp({required SignUpBody signUpBody}) async {

    return await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBody.toJson());
  }





  // for  user token
  Future<bool> saveUserSession(String session) async {
    return await sharedPreferences.setString(AppConstants.SESSION_ID, session);
  }


  String getUserSession() {
    return sharedPreferences.getString(AppConstants.SESSION_ID) ?? "";
  }


  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.SESSION_ID);
  }



  // for  Remember Email
  Future<void> saveUserNameAndPassword(String name, String password,) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NAME, name);

    } catch (e) {
      throw e;
    }
  }





  String getUserName() {
    return sharedPreferences.getString(AppConstants.USER_NAME) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }



  Future<bool> clearUserSigningInfo() async {
    return await sharedPreferences.remove(AppConstants.SESSION_ID);

  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstants.USER_NAME);
  }
}
