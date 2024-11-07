import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/// Controller responsible for handling login actions and managing login state.
class LoginController extends GetxController {
  /// Observable variable to track loading state.
  var isLoading = false.obs;

  /// Firebase Authentication instance for handling login.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Logs in the user with email and password using Firebase Authentication.
  ///
  /// If the login is successful, a welcome message is shown and the user
  /// is redirected to the home screen. In case of an error, displays
  /// an error message based on the exception code.
  ///
  /// - Parameters:
  ///   - `email`: The user's email address.
  ///   - `password`: The user's password.
  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      // Set loading state to true to indicate that the login process has started.
      isLoading.value = true;

      // Attempt to sign in the user with the provided email and password.
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Display a success message and redirect the user to the home screen.
      Get.snackbar(
        "Login Successful",
        "Welcome ${userCredential.user?.email}!",
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to the home screen after successful login.
      Get.offNamed('/home');
    } on FirebaseAuthException catch (e) {
      // Handle login errors by displaying appropriate messages.
      String message;
      switch (e.code) {
        case 'user-not-found':
        // Case when the email does not correspond to any user account.
          message = "No user found for that email.";
          break;
        case 'wrong-password':
        // Case when the password is incorrect for the given email.
          message = "Wrong password provided.";
          break;
        default:
        // Default message for any other error.
          message = "An error occurred. Please try again.";
      }

      // Display error message in a snackbar.
      Get.snackbar(
        "Login Failed",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Set loading state back to false after login attempt.
      isLoading.value = false;
    }
  }

  /// Displays a placeholder message for Google login option.
  ///
  /// Currently, Google login is not implemented, so this method
  /// provides feedback to the user that it is coming soon.
  void showGoogleLoginMessage() {
    Get.snackbar(
      "Coming Soon",
      "Google login coming soon!",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Displays a placeholder message for Microsoft login option.
  ///
  /// Currently, Microsoft login is not implemented, so this method
  /// provides feedback to the user that it is coming soon.
  void showMicrosoftLoginMessage() {
    Get.snackbar(
      "Coming Soon",
      "Microsoft login coming soon!",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
