import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      isLoading.value = true;

      // Firebase Authentication Login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data (including role) from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user?.uid).get();

      // Ensure the user document exists and has role information
      if (userDoc.exists) {
        String role = userDoc['role'] ?? 'user'; // Default to 'user' if role is not found

        // Log the role for debugging purposes
        print('Role from Firestore: $role');  // Debugging log

        // Redirect based on role
        if (role == 'Admin') {  // Ensure role is compared with the correct value
          Get.snackbar(
            "Admin Login Successful",
            "Welcome Admin ${userCredential.user?.email}!",
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offNamed('/admin');
        } else if (role == 'User') {
          Get.snackbar(
            "User Login Successful",
            "Welcome ${userCredential.user?.email}!",
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offNamed('/home');
        } else {
          throw FirebaseAuthException(
            code: 'invalid-role',
            message: 'Invalid role assigned to this email.',
          );
        }
      } else {
        // User data not found in Firestore
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User data not found.',
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "No user found for that email.";
          break;
        case 'wrong-password':
          message = "Wrong password provided.";
          break;
        case 'invalid-role':
          message = "Invalid role assigned to this email.";
          break;
        default:
          message = "An error occurred. Please try again.";
      }
      Get.snackbar(
        "Login Failed",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Placeholder methods for Google and Microsoft login
  void showGoogleLoginMessage() {
    Get.snackbar("Coming Soon", "Google login coming soon!", snackPosition: SnackPosition.BOTTOM);
  }

  void showMicrosoftLoginMessage() {
    Get.snackbar("Coming Soon", "Microsoft login coming soon!", snackPosition: SnackPosition.BOTTOM);
  }
}
