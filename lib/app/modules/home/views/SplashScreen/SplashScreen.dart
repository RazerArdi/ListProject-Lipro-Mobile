import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importing GetX for state management and routing
import '../../controllers/splash_controller.dart'; // Importing the SplashController for managing the splash screen logic

/// SplashScreen is the initial screen that shows when the app is launched.
/// It usually displays an app logo or some introductory information.
class SplashScreen extends StatelessWidget {
  // Getting the instance of SplashController using GetX's Get.find() method
  final SplashController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting the background color of the splash screen to black
      backgroundColor: Colors.black,

      // The body of the splash screen, centered content
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Aligning the content in the center vertically
          children: [
            // A check circle icon that serves as an app's logo or a visual indicator
            Icon(Icons.check_circle, color: Colors.purple, size: 100),
            SizedBox(height: 20), // Adding space between the icon and the text
            // The app's name displayed in bold white text with a larger font size
            Text(
              'UpTodo',
              style: TextStyle(
                color: Colors.white, // White color for the text
                fontSize: 28, // Font size of the text
                fontWeight: FontWeight.bold, // Bold text style
              ),
            ),
          ],
        ),
      ),
    );
  }
}
