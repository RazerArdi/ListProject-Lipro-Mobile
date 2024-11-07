import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/// Controller responsible for handling password recovery actions and managing loading state.
class PasswordRecoveryController extends GetxController {
  /// Observable variable to track loading state during password reset request.
  var isLoading = false.obs;

  /// Firebase Authentication instance for handling password recovery requests.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sends a password reset email to the user.
  ///
  /// - Parameters:
  ///   - `email`: The user's email address to send the password reset instructions to.
  ///
  /// Displays a success message if the email is sent successfully.
  /// If an error occurs, displays an appropriate error message based on the exception code.
  Future<void> resetPassword(String email) async {
    try {
      // Set loading state to true to indicate the password reset process has started.
      isLoading.value = true;

      // Send a password reset email using Firebase Authentication.
      await _auth.sendPasswordResetEmail(email: email);

      // Display a success message informing the user to check their email.
      Get.snackbar(
        "Reset Email Sent",
        "Check your email for password reset instructions.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors and set a default error message.
      String message = "An error occurred.";

      // Check for specific FirebaseAuthException codes to provide detailed messages.
      if (e.code == 'invalid-email') {
        // Case when the email format is invalid.
        message = "The email address is not valid.";
      } else if (e.code == 'user-not-found') {
        // Case when no user is associated with the provided email.
        message = "No user found for that email.";
      }

      // Display the error message in a snackbar.
      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Reset loading state to false after the password reset attempt completes.
      isLoading.value = false;
    }
  }
}
