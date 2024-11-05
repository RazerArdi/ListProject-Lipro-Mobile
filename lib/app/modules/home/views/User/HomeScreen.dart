import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:lipro_mobile/app/modules/home/views/calendar_screen.dart';
import 'package:lipro_mobile/app/modules/home/views/focus_screen.dart';
import 'package:lipro_mobile/app/modules/home/views/index_screen.dart';
import 'package:lipro_mobile/app/modules/home/views/profile_screen.dart';
import 'package:lipro_mobile/app/modules/home/views/add_task_screen.dart'; // Import the AddTaskScreen
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  HomeScreen() {
    controller.loadUserProfile();
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        Reference ref = _storage.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
        await ref.putFile(imageFile);
        String url = await ref.getDownloadURL();
        await controller.saveUserProfileImage(url);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Index", style: TextStyle(color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: _pickAndUploadImage,
            child: Obx(() {
              return CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: controller.profileImageUrl.value.isNotEmpty
                    ? NetworkImage(controller.profileImageUrl.value)
                    : null,
                child: controller.profileImageUrl.value.isEmpty
                    ? Icon(Icons.person, color: Colors.white)
                    : null,
              );
            }),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(context), // Pass context here
        backgroundColor: Colors.black,
        navBarStyle: NavBarStyle.style15,
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      IndexScreen(),
      CalendarScreen(),
      Container(), // Dummy screen for Task, since we're using a modal
      FocusScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Index"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_today),
        title: ("Calendar"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: GestureDetector(
          onTap: () {
            // Show AddTaskScreen as a modal bottom sheet
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return AddTaskScreen(); // Pass the AddTaskScreen here
              },
            );
          },
          child: Icon(Icons.add, color: Colors.blueAccent, size: 40.0),
        ),
        title: ("Task"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.timelapse),
        title: ("Focus"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
