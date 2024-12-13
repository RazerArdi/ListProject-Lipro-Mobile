import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;
  var selectedRole = 'User'.obs;

  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email.trim());
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<void> register(
      String fullName,
      String email,
      String password,
      String confirmPassword,
      String role,
      ) async {
    // Comprehensive input validation
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || fullName.isEmpty) {
      Get.snackbar('Error', 'All fields must be filled', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!isValidEmail(email)) {
      Get.snackbar('Error', 'Invalid email format', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!isValidPassword(password)) {
      Get.snackbar('Error', 'Password must be at least 6 characters long', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      isLoading.value = true;

      // Buat user di Firebase Authentication
      UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Memastikan userCredential dan user tidak null dengan pengecekan null yang aman
      if (userCredential?.user != null) {
        // Simpan data pengguna di Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential!.user!.uid)
            .set({
          'email': email,
          'fullName': fullName,  // Save the fullName here
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'uid': userCredential.user!.uid,
        });

        // Arahkan berdasarkan role
        if (role == 'Admin') {
          Get.offNamed('/admin-home');
        } else {
          Get.offNamed('/home');
        }

        Get.snackbar(
            "Registration Successful",
            "Registered as $role",
            snackPosition: SnackPosition.BOTTOM
        );
      } else {
        // Tangani jika userCredential.user adalah null
        Get.snackbar(
            'Registration Error',
            'Unable to create user account',
            snackPosition: SnackPosition.BOTTOM
        );
      }

    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;
        default:
          message = 'Registration failed. ${e.message}';
      }
      Get.snackbar('Registration Error', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Tangani error yang tidak terduga
      Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Existing methods remain the same
  void showGoogleLoginMessage() {
    Get.snackbar("Coming Soon", "Google login coming soon!",
        snackPosition: SnackPosition.BOTTOM);
  }

  void showMicrosoftLoginMessage() {
    Get.snackbar("Coming Soon", "Microsoft login coming soon!",
        snackPosition: SnackPosition.BOTTOM);
  }
}
