
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_assessment/controller/auth_controller.dart';
import 'package:project_assessment/view/screen/auth/signIn.dart';
import 'package:project_assessment/view/screen/home/home_screen.dart';

import 'helper/get_di.dart';
import 'theme/light_theme.dart';
import 'util/app_constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //controller binding
  await init();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.APP_NAME,
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      theme:light,
      home: Get.find<AuthController>().isLoggedIn()?Home(exitFromApp: true,):SignIn(exitFromApp: true,),
      defaultTransition: Transition.topLevel,
      transitionDuration: Duration(milliseconds: 500),
    );
  }
}


