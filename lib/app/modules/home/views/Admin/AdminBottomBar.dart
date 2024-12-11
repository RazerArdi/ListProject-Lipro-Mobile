import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminBottomBarController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void changePage(int index) {
    _currentIndex.value = index;

    // Navigate to corresponding routes
    switch (index) {
      case 0:
        Get.offNamed('/admin-dashboard');
        break;
      case 1:
        Get.offNamed('/admin-users');
        break;
      case 2:
        Get.offNamed('/admin-feedback');
        break;
      case 3:
        Get.offNamed('/admin-settings');
        break;
    }
  }
}

class AdminBottomBar extends StatelessWidget {
  final AdminBottomBarController controller = Get.put(AdminBottomBarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      backgroundColor: const Color(0xFF1E1E1E),
      currentIndex: controller.currentIndex,
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