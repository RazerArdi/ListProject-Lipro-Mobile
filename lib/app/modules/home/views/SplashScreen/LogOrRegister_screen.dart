import 'package:flutter/material.dart';
import 'package:get/get.dart'; // To manage navigation using GetX
import 'package:lipro_mobile/app/modules/home/controllers/OnboardingController.dart'; // Controller for onboarding
import 'package:lipro_mobile/app/routes/app_pages.dart'; // Routes for navigation

/// LogOrRegister_screen is a screen that provides options for the user to either login or create a new account.
class LogOrRegister_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting the background color of the screen to black
      backgroundColor: Colors.black,

      // AppBar with a back button to navigate to the Onboarding screen
      appBar: AppBar(
        backgroundColor: Colors.black, // Black background for AppBar
        elevation: 0, // No shadow for a flat design
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
          onPressed: () {
            Get.toNamed(Routes.ONBOARDING); // Navigates to the Onboarding screen when back button is pressed
          },
        ),
      ),

      // Main body of the screen with padding for layout and spacing
      body: Padding(
        padding: EdgeInsets.all(20.0), // Padding around the content
        child: Column(
          // Using Column to layout the widgets vertically
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between children
          children: [
            // First Column for the welcome text and description
            Column(
              children: [
                // Title text to greet the user
                Text(
                  'Welcome to UpTodo',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Centers the title text
                ),
                SizedBox(height: 20), // Adds space between the title and description text

                // Description text explaining the purpose of the screen
                Text(
                  'Please login to your account or create a new account to continue',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center, // Centers the description text
                ),
              ],
            ),

            // Second Column for the action buttons (Login and Create Account)
            Column(
              children: [
                // Login button
                ElevatedButton(
                  onPressed: () {
                    Get.offNamed(Routes.LOGIN); // Navigate to the Login screen when pressed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Button color (purple)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                    ),
                    minimumSize: Size(double.infinity, 50), // Button should span the full width with height 50
                  ),
                  child: Text(
                    'LOGIN', // Text for the Login button
                    style: TextStyle(color: Colors.white, fontSize: 16), // White text on the purple button
                  ),
                ),
                SizedBox(height: 10), // Adds space between the two buttons

                // Create Account button
                ElevatedButton(
                  onPressed: () {
                    Get.offNamed(Routes.REGISTERED); // Navigate to the Register screen when pressed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button color (white)
                    foregroundColor: Colors.purple, // Text color (purple)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                    ),
                    minimumSize: Size(double.infinity, 50), // Button should span the full width with height 50
                  ),
                  child: Text(
                    'CREATE ACCOUNT', // Text for the Create Account button
                    style: TextStyle(color: Colors.purple, fontSize: 16), // Purple text on the white button
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
