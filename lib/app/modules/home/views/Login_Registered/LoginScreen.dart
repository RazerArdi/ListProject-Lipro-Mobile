import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/login_controller.dart';
import 'package:lipro_mobile/app/modules/home/controllers/PasswordRecoveryController.dart';

/// Login screen widget that handles user login, password recovery, and social logins.
class LoginScreen extends StatelessWidget {
  // Controllers for login and password recovery logic
  final LoginController loginController = Get.put(LoginController());
  final PasswordRecoveryController passwordRecoveryController = Get.put(PasswordRecoveryController());

  // Text editing controllers for capturing email and password input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures UI adjusts when keyboard is visible
      backgroundColor: Colors.black, // Set background color of screen to black
      appBar: AppBar(
        backgroundColor: Colors.black, // App bar color
        elevation: 0, // No elevation (flat design)
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back button to go to previous screen
          onPressed: () {
            Get.offNamed('/logreg'); // Navigate back to the login/register screen
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView( // Ensures content scrolls when keyboard appears
          padding: EdgeInsets.symmetric(horizontal: 24.0), // Padding around the form fields
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the content vertically
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches children horizontally
            children: <Widget>[
              // Title 'Login' at the top of the screen
              Text(
                'Login',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color white
                ),
              ),
              SizedBox(height: 40.0), // Space between title and email input

              // Email input field
              TextField(
                controller: emailController, // Controller to get input value
                style: TextStyle(color: Colors.white), // Text color white
                decoration: InputDecoration(
                  labelText: 'Email', // Label for the input field
                  labelStyle: TextStyle(color: Colors.white), // Label text color
                  filled: true, // Makes the background color filled
                  fillColor: Colors.grey[850], // Background color of input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded border for the input field
                    borderSide: BorderSide.none, // No border outline
                  ),
                ),
              ),
              SizedBox(height: 16.0), // Space between email and password fields

              // Password input field
              TextField(
                controller: passwordController, // Controller to get input value
                obscureText: true, // Obscure the password text
                style: TextStyle(color: Colors.white), // Text color white
                decoration: InputDecoration(
                  labelText: 'Password', // Label for password field
                  labelStyle: TextStyle(color: Colors.white), // Label text color
                  filled: true, // Makes the background color filled
                  fillColor: Colors.grey[850], // Background color of input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded border for the input field
                    borderSide: BorderSide.none, // No border outline
                  ),
                ),
              ),
              SizedBox(height: 24.0), // Space between password and login button

              // Login button, which changes appearance based on loading state
              Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Button background color
                  padding: EdgeInsets.symmetric(vertical: 16.0), // Vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                ),
                onPressed: loginController.isLoading.value
                    ? null // Disables button when loading is true
                    : () {
                  // Calls login function when the button is pressed
                  loginController.loginWithEmailPassword(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                child: loginController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white) // Shows loading indicator while logging in
                    : Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white, // Text color white
                  ),
                ),
              )
              ),
              SizedBox(height: 24.0), // Space between login button and 'Forgot Password?' link

              // "Forgot Password?" link that opens a password reset dialog
              GestureDetector(
                onTap: () {
                  _showPasswordResetDialog(context); // Show password reset dialog
                },
                child: Text(
                  "Forgot Password? Reset Password",
                  style: TextStyle(
                    color: Colors.grey, // Text color grey
                    decoration: TextDecoration.underline, // Underline text
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.0), // Space between 'Forgot Password?' and social login buttons

              // Divider separating login with email and social login options
              Row(
                children: <Widget>[
                  Expanded(child: Divider(color: Colors.grey)), // Left side of divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or', // 'or' text in the middle of divider
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey)), // Right side of divider
                ],
              ),
              SizedBox(height: 24.0), // Space between divider and Google login button

              // Google login button (currently shows a placeholder message)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0), // Padding for the button
                  side: BorderSide(color: Colors.grey), // Border color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                ),
                icon: Image.asset('assets/gog.png', height: 24.0), // Google logo icon
                label: Text(
                  'Login with Google',
                  style: TextStyle(color: Colors.white), // Text color white
                ),
                onPressed: loginController.showGoogleLoginMessage, // Placeholder function for Google login
              ),
              SizedBox(height: 16.0), // Space between Google and Microsoft login buttons

              // Microsoft login button (currently shows a placeholder message)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0), // Padding for the button
                  side: BorderSide(color: Colors.grey), // Border color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                ),
                icon: Image.asset('assets/Microsoft.png', height: 24.0), // Microsoft logo icon
                label: Text(
                  'Login with Microsoft',
                  style: TextStyle(color: Colors.white), // Text color white
                ),
                onPressed: loginController.showMicrosoftLoginMessage, // Placeholder function for Microsoft login
              ),
              SizedBox(height: 24.0), // Space between login buttons and register link

              // Register link that navigates to the registration screen
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/registered'); // Navigate to registration screen
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.grey), // Grey text for the "Don't have an account?" part
                        ),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: Colors.white, // White text for the "Register" part
                            decoration: TextDecoration.underline, // Underlined text
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

  /// Shows a dialog for resetting the password by entering the email.
  void _showPasswordResetDialog(BuildContext context) {
    TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reset Password"), // Dialog title
          content: Column(
            mainAxisSize: MainAxisSize.min, // Dialog content size adjusts to fit its content
            children: [
              Text("Enter your email address to receive a password reset link."),
              TextField(
                controller: resetEmailController, // Email input field for password reset
                decoration: InputDecoration(
                  labelText: 'Email', // Label for email input field
                  filled: true, // Filled background color
                  fillColor: Colors.grey[850], // Background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded border
                    borderSide: BorderSide.none, // No border outline
                  ),
                ),
              ),
            ],
          ),
          actions: [
            // Button to send the reset link
            TextButton(
              onPressed: () {
                String email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  passwordRecoveryController.resetPassword(email); // Call password recovery method
                  Get.back(); // Close dialog after action is performed
                } else {
                  Get.snackbar("Error", "Please enter your email address.",
                      snackPosition: SnackPosition.BOTTOM); // Show error message if email is empty
                }
              },
              child: Text("Send Reset Link"),
            ),
            // Cancel button
            TextButton(
              onPressed: () => Get.back(), // Close the dialog
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
