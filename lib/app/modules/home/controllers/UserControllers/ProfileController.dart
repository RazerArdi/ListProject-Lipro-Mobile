import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  // Initialize Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Observables for user profile data
  var profileImageUrl = ''.obs; // Observable for profile image URL
  var userName = ''.obs; // Observable for username

  // Load user data from Firestore
  Future<void> loadUserProfile() async {
    User? user = _auth.currentUser;

    if (user == null) {
      Get.snackbar("Error", "User not logged in.");
      return;
    }

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        // Safely get the field values using null-aware operators
        var userData = userDoc.data() as Map<String, dynamic>;
        profileImageUrl.value = userData['profileImageUrl'] ?? ''; // Default to empty string if not found
        userName.value = userData['fullName'] ?? 'User'; // Default to 'User' if not found
      } else {
        Get.snackbar("Error", "User profile not found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load user profile: $e");
    }
  }

  Future<void> changeUserName(String newName) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Update in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'fullName': newName,
        });

        // Update the local state
        userName.value = newName;

        // Show success message
        Get.snackbar(
          'Success',
          'Name updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update name: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Change profile image
  Future<void> changeProfileImage() async {
    User? user = _auth.currentUser;
    if (user == null) {
      Get.snackbar("Error", "User not logged in.");
      return;
    }

    // Pick image from gallery
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      Get.snackbar("Error", "No image selected.");
      return;
    }

    try {
      // Upload image to Firebase Storage
      File file = File(image.path);
      String fileName = 'profile_images/${user.uid}.jpg';
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(file);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with the new image URL
      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': downloadUrl,
      });

      // Update the observable profile image URL
      profileImageUrl.value = downloadUrl;

      Get.snackbar("Success", "Profile image updated successfully.");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile image: $e");
    }
  }

  // Method to change password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user == null) {
      Get.snackbar("Error", "User not logged in.");
      return;
    }

    try {
      // Re-authenticate the user with the old password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      // Re-authenticate the user to ensure they are logged in
      await user.reauthenticateWithCredential(credential);

      // Update to the new password
      await user.updatePassword(newPassword);

      // Show success message
      Get.snackbar("Success", "Password changed successfully.");
    } catch (e) {
      // Handle errors and show an error message
      Get.snackbar("Error", "Failed to change password: ${e.toString()}");
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", "Failed to log out: $e");
    }
  }
}
