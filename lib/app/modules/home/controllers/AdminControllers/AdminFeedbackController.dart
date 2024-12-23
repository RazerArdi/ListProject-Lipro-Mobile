import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/Model/FeedbackModel.dart';

class AdminFeedbackController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<FeedbackModel> feedbackList = <FeedbackModel>[].obs;
  final Rx<FeedbackModel?> selectedFeedback = Rx<FeedbackModel?>(null);
  final RxBool isLoading = false.obs;

  final TextEditingController responseController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  @override
  void onClose() {
    responseController.dispose();
    super.onClose();
  }

  Future<void> fetchFeedbacks() async {
    try {
      // Explicitly check authentication
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      // Check admin status from Firestore user document
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      // Check if user exists and has 'Admin' role
      if (!userDoc.exists ||
          (userDoc.data() as Map<String, dynamic>?)?['role'] != 'Admin') {
        throw Exception('User is not an admin');
      }

      // Firestore query for feedbacks
      QuerySnapshot querySnapshot = await _firestore
          .collection('user_feedback')
          .orderBy('timestamp', descending: true)
          .get();

      feedbackList.value = querySnapshot.docs
          .map((doc) => FeedbackModel.fromFirestore(doc))
          .toList();

    } catch (e) {
      print('Full Error Details: $e');
      _showErrorSnackbar('Failed to fetch feedbacks', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFeedbackStatus(String feedbackId, String status) async {
    try {
      await _firestore
          .collection('user_feedback')
          .doc(feedbackId)
          .update({'status': status});

      await fetchFeedbacks();
    } catch (e) {
      _showErrorSnackbar('Failed to update feedback status', e);
    }
  }

  Future<void> respondToFeedback() async {
    if (selectedFeedback.value == null) return;

    if (responseController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Response cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await _firestore
          .collection('user_feedback')
          .doc(selectedFeedback.value!.id)
          .update({
        'adminResponse': responseController.text.trim(),
        'status': 'resolved'
      });

      responseController.clear();
      selectedFeedback.value = null;
      await fetchFeedbacks();

      Get.snackbar(
        'Success',
        'Feedback response submitted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
    } catch (e) {
      _showErrorSnackbar('Failed to submit response', e);
    }
  }

  Future<void> deleteFeedback(String feedbackId) async {
    try {
      await _firestore.collection('user_feedback').doc(feedbackId).delete();
      await fetchFeedbacks();
      Get.snackbar(
        'Success',
        'Feedback deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
    } catch (e) {
      _showErrorSnackbar('Failed to delete feedback', e);
    }
  }

  void selectFeedbackForResponse(FeedbackModel feedback) {
    selectedFeedback.value = feedback;
  }

  void _showErrorSnackbar(String message, dynamic error) {
    Get.snackbar(
      'Error',
      '$message: ${error.toString()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }
}