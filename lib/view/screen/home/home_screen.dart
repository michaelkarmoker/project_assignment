import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:project_assessment/controller/auth_controller.dart';
import 'package:project_assessment/helper/notification_helper.dart';
import 'package:project_assessment/util/dimensions.dart';
import 'package:project_assessment/view/base/custom_alert_dialog_for_permission.dart';
import 'package:project_assessment/view/base/custom_button.dart';

import '../../../main.dart';

class Home extends StatefulWidget {
  final bool exitFromApp;
   Home({Key? key, required this.exitFromApp}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _canExit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"),
       actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: (){
                  Get.dialog( CustomAlerDialogForPermission(yesBtnText: 'Yes', yesBtntap: () {  Get.find<AuthController>().signOut(); },
                    noBtnText: 'No', title: 'Are you sure want to log out?',isError:true));


                },
                child: Icon(Icons.login,size: 25,color: Colors.white,)),
          )
       ],
      ),
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
        child: SafeArea(child: Container(

          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomButton(buttonText: 'Get Notification', onPressed: () async {
                  await   NotificationHelper.showBigTextNotification(title: "Local Notification",
                      body: "This is local notification for testing ", fln: flutterLocalNotificationsPlugin);
                },

                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
