import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;

  Future<void> register(String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true; // Set loading state
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Registration successful
      Get.offNamed('/login'); // Navigate to login page
      Get.snackbar("Registration Successful", "You can now log in.", snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      // Handle error messages from Firebase
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }

  // Google and Microsoft login methods can be added similarly
  void showGoogleLoginMessage() {
    Get.snackbar("Coming Soon", "Google login coming soon!",
        snackPosition: SnackPosition.BOTTOM);
  }

  void showMicrosoftLoginMessage() {
    Get.snackbar("Coming Soon", "Microsoft login coming soon!",
        snackPosition: SnackPosition.BOTTOM);
  }
}
