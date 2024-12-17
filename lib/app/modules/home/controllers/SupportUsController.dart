import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lipro_mobile/app/modules/home/Model/SupportUsModel.dart';

class SupportUsController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final amountController = TextEditingController();
  final messageController = TextEditingController();

  final isSubmitting = false.obs;
  final submissionSuccess = false.obs;
  final pickedImage = Rxn<File>();

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    amountController.dispose();
    messageController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        pickedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter donation amount';
    }
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  Future<void> submitSupport() async {
    if (formKey.currentState!.validate() && pickedImage.value != null) {
      try {
        isSubmitting.value = true;

        // Step 1: Upload image to Firebase Storage
        final imageUrl = await _uploadImageToFirebase();

        // Step 2: Create a model object
        final supportModel = SupportUsModel(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          amount: double.parse(amountController.text.trim()),
          message: messageController.text.trim(),
          transferProofUrl: imageUrl,
        );

        // Step 3: Save data to Firestore
        await FirebaseFirestore.instance.collection('SupportUS').add({
          'name': supportModel.name,
          'email': supportModel.email,
          'amount': supportModel.amount,
          'message': supportModel.message,
          'transferProofUrl': supportModel.transferProofUrl,
          'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
        });

        // Success Snackbar
        submissionSuccess.value = true;
        clearForm();

        Get.snackbar(
          'Thank You!',
          'Your support means a lot to us.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        // Error Snackbar
        Get.snackbar(
          'Error',
          'Failed to submit support. Please try again. $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isSubmitting.value = false;
      }
    } else {
      Get.snackbar(
        'Error',
        'Please fill all required fields and upload transfer proof.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String> _uploadImageToFirebase() async {
    if (pickedImage.value == null) {
      throw Exception('No image selected to upload.');
    }

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child('support_proofs/$fileName');

      final uploadTask = storageRef.putFile(pickedImage.value!);
      final snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    amountController.clear();
    messageController.clear();
    pickedImage.value = null;
    submissionSuccess.value = false;
  }
}
