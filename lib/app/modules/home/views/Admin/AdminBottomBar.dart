import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/AdminFeedback.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/AdminScreen.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/AdminSetting.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/UsersManagementScreen.dart';

class AdminBottomBarController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    AdminScreen(),
    UsersManagementScreen(),
    AdminFeedback(),
    AdminSetting(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}

class AdminBottomBar extends StatelessWidget {
  final AdminBottomBarController controller = Get.put(AdminBottomBarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      backgroundColor: const Color(0xFF1E1E1E),
      currentIndex: controller.currentIndex.value,
      onTap: controller.changePage,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey[600],
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard, color: Colors.blueAccent),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people, color: Colors.blueAccent),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feedback_outlined),
          activeIcon: Icon(Icons.feedback, color: Colors.blueAccent),
          label: 'Feedback',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings, color: Colors.blueAccent),
          label: 'Settings',
        ),
      ],
    ));
  }
}
