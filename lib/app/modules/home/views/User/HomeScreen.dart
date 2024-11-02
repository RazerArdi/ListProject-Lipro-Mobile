import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  // Create a PersistentTabController
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  // Image Picker and Firebase Storage instances
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  HomeScreen() {
    // Load user profile on initialization
    controller.loadUserProfile();
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        // Create a reference to the Firebase Storage location
        Reference ref = _storage.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
        await ref.putFile(imageFile);

        // Get the download URL
        String url = await ref.getDownloadURL();

        // Save the image URL to Firestore
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
            onTap: _pickAndUploadImage, // Trigger image picker on tap
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
        items: _navBarsItems(),
        backgroundColor: Colors.black,
        navBarStyle: NavBarStyle.style15,
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      Center(
        child: Obx(() {
          if (controller.tasks.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/emptyTask.png', height: 200),
                const SizedBox(height: 20),
                const Text(
                  "What do you want to do today?",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Tap + to add your tasks",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            );
          } else {
            return ListView.builder(
              itemCount: controller.tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    controller.tasks[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          }
        }),
      ),
      Center(child: Text('Calendar', style: TextStyle(color: Colors.white))),
      Center(child: Text('Focus', style: TextStyle(color: Colors.white))),
      Center(child: Text('Profile', style: TextStyle(color: Colors.white))),
      Center(child: Text('Settings', style: TextStyle(color: Colors.white))),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
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
        icon: Icon(Icons.add, color: Colors.blueAccent, size: 40.0),
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
