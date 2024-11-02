import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar("Login Successful", "Welcome ${userCredential.user?.email}!",
          snackPosition: SnackPosition.BOTTOM);
      // Navigate to the home screen
      Get.offNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "No user found for that email.";
          break;
        case 'wrong-password':
          message = "Wrong password provided.";
          break;
        default:
          message = "An error occurred. Please try again.";
      }
      Get.snackbar("Login Failed", message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void showGoogleLoginMessage() {
    Get.snackbar("Coming Soon", "Google login coming soon!",
        snackPosition: SnackPosition.BOTTOM);
  }

  void showMicrosoftLoginMessage() {
    Get.snackbar("Coming Soon", "Microsoft login coming soon!",
        snackPosition: SnackPosition.BOTTOM);
  }
}
