import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importing GetX for state management and routing
import 'package:lipro_mobile/app/modules/home/controllers/UserControllers/home_controller.dart'; // Importing HomeController
import 'package:lipro_mobile/app/modules/home/views/User/calendar_screen.dart'; // Importing the CalendarScreen widget
import 'package:lipro_mobile/app/modules/home/views/User/focus_screen.dart'; // Importing the FocusScreen widget
import 'package:lipro_mobile/app/modules/home/views/User/IndexPage/index_screen.dart'; // Importing the IndexScreen widget
import 'package:lipro_mobile/app/modules/home/views/User/profile_screen.dart'; // Importing the ProfileScreen widget
import 'package:lipro_mobile/app/modules/home/views/User/add_task_screen.dart'; // Importing the AddTaskScreen widget
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart'; // Importing the persistent bottom navigation bar package
import 'package:firebase_storage/firebase_storage.dart'; // Importing Firebase Storage for image uploading
import 'package:image_picker/image_picker.dart'; // Importing ImagePicker for selecting images from gallery

/// HomeScreen is the main screen of the app that contains a bottom navigation bar
/// to navigate between different sections like Index, Calendar, Task, Focus, and Profile.
class HomeScreen extends StatelessWidget {
  // Initializing the controller for home logic
  final HomeController controller = Get.put(HomeController());
  // PersistentTabController is used to manage the index of the persistent bottom navigation bar
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  // ImagePicker is used to pick images from the gallery or camera
  final ImagePicker _picker = ImagePicker();
  // FirebaseStorage is used to upload images to Firebase
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Constructor to load user profile on the HomeScreen initialization
  HomeScreen() {
    controller.loadUserProfile();
  }

  // This method allows the user to pick an image from the gallery and upload it to Firebase Storage
  Future<void> _pickAndUploadImage() async {
    // Picking an image from the gallery
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Converting the picked file into a File object
      File imageFile = File(pickedFile.path);
      try {
        // Creating a reference to store the file in Firebase Storage with a unique file name
        Reference ref = _storage.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
        // Uploading the image file to Firebase Storage
        await ref.putFile(imageFile);
        // Getting the download URL for the uploaded image
        String url = await ref.getDownloadURL();
        // Saving the URL of the uploaded image to the user's profile
        await controller.saveUserProfileImage(url);
      } catch (e) {
        // Handling errors that may occur during the image upload process
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Setting the background color of the screen
      appBar: AppBar(
        backgroundColor: Colors.black, // Setting the AppBar color to black
        elevation: 0, // Removing the elevation for a flat AppBar
        title: const Text("Index", style: TextStyle(color: Colors.white)), // Setting the title of the app bar
        actions: [
          GestureDetector(
            // Triggering the image upload process when the profile image is tapped
            onTap: _pickAndUploadImage,
            child: Obx(() {
              // Displaying the user's profile image if available
              return CircleAvatar(
                backgroundColor: Colors.black, // Black background for the profile image
                backgroundImage: controller.profileImageUrl.value.isNotEmpty
                    ? NetworkImage(controller.profileImageUrl.value) // Displaying the uploaded image
                    : null, // If no image, show default icon
                child: controller.profileImageUrl.value.isEmpty
                    ? Icon(Icons.person, color: Colors.white) // Default icon if no image is uploaded
                    : null,
              );
            }),
          ),
          const SizedBox(width: 16), // Adding space between the profile image and other elements in the app bar
        ],
      ),
      body: PersistentTabView(
        context,
        controller: _controller, // Setting the tab controller for the navigation bar
        screens: _buildScreens(), // Defining the screens for the different tabs
        items: _navBarsItems(context), // Defining the navigation items for the bottom navigation bar
        backgroundColor: Colors.black, // Background color for the bottom navigation bar
        navBarStyle: NavBarStyle.style15, // Styling the navigation bar
      ),
    );
  }

  // Method that returns a list of screens for each bottom navigation tab
  List<Widget> _buildScreens() {
    return [
      IndexScreen(), // The main index screen
      CalendarScreen(), // Calendar screen
      Container(), // Placeholder screen for Task, since Task screen will be shown as a modal
      FocusScreen(), // Focus screen
      ProfileScreen(), // Profile screen
    ];
  }

  // Method that defines the items for the persistent bottom navigation bar
  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home), // Icon for the Index tab
        title: ("Index"), // Title for the Index tab
        activeColorPrimary: Colors.white, // Color for active tab
        inactiveColorPrimary: Colors.grey, // Color for inactive tab
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_today), // Icon for the Calendar tab
        title: ("Calendar"), // Title for the Calendar tab
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: GestureDetector(
          // Icon for the Task tab, when tapped it shows the AddTaskScreen as a modal
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent, // Transparent background for modal
              builder: (context) {
                return AddTaskScreen(); // Showing AddTaskScreen in the modal
              },
            );
          },
          child: Icon(Icons.add, color: Colors.blueAccent, size: 40.0), // Add task icon
        ),
        title: ("Task"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.timelapse), // Icon for the Focus tab
        title: ("Focus"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person), // Icon for the Profile tab
        title: ("Profile"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
