import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PasswordRecoveryController extends GetxController {
  var isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Reset Email Sent", "Check your email for password reset instructions.",
          snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred.";
      if (e.code == 'invalid-email') {
        message = "The email address is not valid.";
      } else if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
