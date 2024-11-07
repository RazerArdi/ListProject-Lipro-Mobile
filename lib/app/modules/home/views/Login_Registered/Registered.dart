import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/register_controller.dart';

/// Register screen widget for user registration.
class RegisterScreen extends StatelessWidget {
  // RegisterController to handle registration logic
  final RegisterController registerController = Get.put(RegisterController());

  // Controllers for capturing user input in the form
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // State variables to manage password visibility
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures UI adjusts when keyboard is visible
      backgroundColor: Colors.black, // Sets the background color of the screen to black
      appBar: AppBar(
        backgroundColor: Colors.black, // App bar background color
        elevation: 0, // No elevation for a flat design
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back button to navigate to previous screen
          onPressed: () {
            Get.offNamed('/logreg'); // Navigates back to login/register screen
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView( // Allows scrolling when keyboard is visible
          padding: EdgeInsets.symmetric(horizontal: 24.0), // Padding around the form fields
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the content vertically
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches children horizontally
            children: <Widget>[
              // Register title text
              Text(
                'Register',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28.0, // Font size for the title
                  fontWeight: FontWeight.bold, // Bold font weight
                  color: Colors.white, // White color for the text
                ),
              ),
              SizedBox(height: 40.0), // Space between title and form fields

              // Email input field
              TextField(
                controller: emailController, // Text controller to manage email input
                style: TextStyle(color: Colors.white), // White text color
                decoration: InputDecoration(
                  labelText: 'Email', // Label for email input
                  labelStyle: TextStyle(color: Colors.white), // White label text color
                  filled: true, // Makes the background color filled
                  fillColor: Colors.grey[850], // Background color for the input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners for the field
                    borderSide: BorderSide.none, // No border outline
                  ),
                ),
              ),
              SizedBox(height: 16.0), // Space between email field and password field

              // Password input field with visibility toggle
              Obx(() => TextField(
                controller: passwordController, // Text controller to manage password input
                obscureText: !isPasswordVisible.value, // Hide text if password is not visible
                style: TextStyle(color: Colors.white), // White text color
                decoration: InputDecoration(
                  labelText: 'Password', // Label for password input
                  labelStyle: TextStyle(color: Colors.white), // White label text color
                  filled: true, // Makes the background color filled
                  fillColor: Colors.grey[850], // Background color for the input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners for the field
                    borderSide: BorderSide.none, // No border outline
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      isPasswordVisible.value = !isPasswordVisible.value; // Toggles visibility of password
                    },
                  ),
                ),
              )),
              SizedBox(height: 16.0), // Space between password field and confirm password field

              // Confirm password input field with visibility toggle
              Obx(() => TextField(
                controller: confirmPasswordController, // Text controller to manage confirm password input
                obscureText: !isConfirmPasswordVisible.value, // Hide text if confirm password is not visible
                style: TextStyle(color: Colors.white), // White text color
                decoration: InputDecoration(
                  labelText: 'Confirm Password', // Label for confirm password input
                  labelStyle: TextStyle(color: Colors.white), // White label text color
                  filled: true, // Makes the background color filled
                  fillColor: Colors.grey[850], // Background color for the input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners for the field
                    borderSide: BorderSide.none, // No border outline
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value; // Toggles visibility of confirm password
                    },
                  ),
                ),
              )),
              SizedBox(height: 24.0), // Space between confirm password field and register button

              // Register button
              Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Button color
                  padding: EdgeInsets.symmetric(vertical: 16.0), // Vertical padding for button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners for the button
                  ),
                ),
                onPressed: registerController.isLoading.value
                    ? null // Disables the button when registration is in progress
                    : () {
                  // Call the register function from the controller
                  registerController.register(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    confirmPasswordController.text.trim(),
                  );
                },
                child: registerController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white) // Shows loading indicator if registering
                    : Text(
                  'Register', // Text for the register button
                  style: TextStyle(
                    fontSize: 16.0, // Font size of the button text
                    color: Colors.white, // White text color
                  ),
                ),
              )),
              SizedBox(height: 24.0), // Space between register button and OR divider

              // Divider with 'or' text for social login options
              Row(
                children: <Widget>[
                  Expanded(child: Divider(color: Colors.grey)), // Left side of the divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or',
                      style: TextStyle(color: Colors.grey), // Style for 'or' text
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey)), // Right side of the divider
                ],
              ),
              SizedBox(height: 24.0), // Space between divider and social login buttons

              // Google Register button (currently shows a placeholder message)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0), // Button padding
                  side: BorderSide(color: Colors.grey), // Border color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                ),
                icon: Image.asset('assets/gog.png', height: 24.0), // Google logo icon
                label: Text(
                  'Register with Google', // Text for the Google register button
                  style: TextStyle(color: Colors.white), // White text color
                ),
                onPressed: registerController.showGoogleLoginMessage, // Placeholder function for Google login
              ),
              SizedBox(height: 16.0), // Space between Google and Microsoft register buttons

              // Microsoft Register button (currently shows a placeholder message)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0), // Button padding
                  side: BorderSide(color: Colors.grey), // Border color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                ),
                icon: Image.asset('assets/Microsoft.png', height: 24.0), // Microsoft logo icon
                label: Text(
                  'Register with Microsoft', // Text for the Microsoft register button
                  style: TextStyle(color: Colors.white), // White text color
                ),
                onPressed: registerController.showMicrosoftLoginMessage, // Placeholder function for Microsoft login
              ),
              SizedBox(height: 24.0), // Space between register buttons and login link

              // Login link, which navigates to the login screen
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/login'); // Navigate to login screen if user already has an account
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.grey), // Grey text for the "Already have an account?" part
                        ),
                        TextSpan(
                          text: "Login", // Text for the "Login" link
                          style: TextStyle(
                            color: Colors.white, // White color for the "Login" part
                            decoration: TextDecoration.underline, // Underline the "Login" link
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
