import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelpFeedbackController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  var isSubmitting = false.obs;

  Future<void> submitFeedback() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        messageController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    isSubmitting.value = true;

    try {
      User? user = _auth.currentUser;

      await _firestore.collection('user_feedback').add({
        'userId': user?.uid,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'message': messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending'
      });

      nameController.clear();
      emailController.clear();
      messageController.clear();

      Get.snackbar(
        'Success',
        'Feedback submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit feedback: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}