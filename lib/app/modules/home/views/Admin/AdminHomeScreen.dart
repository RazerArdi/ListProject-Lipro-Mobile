import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AdminAppBar.dart';
import 'AdminBottomBar.dart';

class AdminHomeScreen extends StatelessWidget {
  final AdminBottomBarController controller = Get.put(AdminBottomBarController());

  AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(
        title: 'Admin Dashboard',
        showCrudActions: true, // Enable CRUD actions
      ),
      body: Obx(() {
        // Menampilkan halaman sesuai currentIndex
        return controller.pages[controller.currentIndex.value];
      }),
      bottomNavigationBar: AdminBottomBar(),
    );
  }
}
