import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/OnboardingController.dart';
import 'package:lipro_mobile/app/modules/home/controllers/UserControllers/calendar_controller.dart';
import 'package:lipro_mobile/app/modules/home/controllers/UserControllers/home_controller.dart';
import 'package:lipro_mobile/app/modules/home/controllers/splash_controller.dart';
import 'package:lipro_mobile/app/modules/home/controllers/SupportUsController.dart'; // Add this import
import 'package:lipro_mobile/app/modules/home/views/Admin/AdminFeedback.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/AdminHomeScreen.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/AdminScreen.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/UsersManagementScreen.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/UsersManagementScreen.dart';
import 'package:lipro_mobile/app/modules/home/views/Login_Registered/LoginScreen.dart';
import 'package:lipro_mobile/app/modules/home/views/SplashScreen/SplashScreen.dart';
import 'package:lipro_mobile/app/modules/home/views/User/HomeScreen.dart';
import 'package:lipro_mobile/app/modules/home/views/User/add_task_screen.dart';
import 'package:lipro_mobile/app/modules/home/views/User/Help/HelpScreen.dart';
import 'package:lipro_mobile/app/modules/home/views/User/SupportUsView.dart'; // Add this import
import 'package:lipro_mobile/app/modules/home/views/splashscreen/logorregister_screen.dart';
import 'package:lipro_mobile/app/modules/home/views/splashscreen/onboarding_screen.dart';
import 'package:lipro_mobile/app/modules/home/views/login_registered/registered.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: BindingsBuilder(() => Get.put(SplashController())),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => OnboardingController())),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.LOGREG,
      page: () => LogOrRegister_screen(),
    ),
    GetPage(
      name: Routes.REGISTERED,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: BindingsBuilder(() => Get.put(HomeController())),
    ),
    GetPage(
      name: Routes.ADD_TASK,
      page: () => AddTaskScreen(),
      binding: BindingsBuilder(() => Get.put(CalendarController())),
    ),
    GetPage(
      name: Routes.ADMIN,
      page: () => AdminScreen(),
    ),
    GetPage(
      name: Routes.HELP,
      page: () => HelpScreen(),
    ),
    GetPage(
      name: Routes.adminFeedback,
      page: () => AdminFeedback(),
    ),
    GetPage(
      name: Routes.SUPPORT_US,
      page: () => SupportUsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SupportUsController>(() => SupportUsController());
      }),
    ),
    GetPage(
      name: Routes.adminHome,
      page: () => AdminHomeScreen(),
    ),
    GetPage(
      name: Routes.usersManagement,
      page: () => UsersManagementScreen(),
      transition: Transition.cupertino,
    ),
  ];
}