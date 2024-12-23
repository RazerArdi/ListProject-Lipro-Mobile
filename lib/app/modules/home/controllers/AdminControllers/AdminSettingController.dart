import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminSettingController extends GetxController {
  // Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Firebase Storage instance
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Notification Settings
  var emailNotifications = true.obs;
  var pushNotifications = true.obs;
  var customNotifications = []
      .obs; // Example: [{'title': 'Task Reminder', 'enabled': true}]

  // System Settings
  var systemName = 'My Application'.obs;
  var appLogoUrl = ''.obs; // URL of the app logo
  var themeColor = Colors.blue.obs;
  var selectedLanguage = 'English'.obs;
  var timeZone = 'UTC'.obs;

  // Analytics & Reports
  var usageStats = {}.obs; // Example: {'projects': 10, 'tasks': 50, 'users': 5}
  var activityLogs = []
      .obs; // Example: [{'action': 'Added user', 'timestamp': '2024-12-22'}]

  // Security Settings
  var is2FAEnabled = false.obs;
  var loggedInDevices = []
      .obs; // Example: [{'device': 'iPhone 12', 'lastActive': '2024-12-21'}]

  // Backup & Maintenance
  var backupStatus = 'Up-to-date'.obs;
  var maintenanceMode = false.obs;

  // Initialize data
  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch initial data from Firebase
  }

  // Fetch data from Firebase
  Future<void> fetchData() async {
    try {
      DocumentReference adminRef = firestore.collection('settings').doc('admin');
      DocumentSnapshot adminSettings = await adminRef.get();

      // Check if the document exists, if not, create it with default values
      if (!adminSettings.exists) {
        await adminRef.set({
          'systemName': 'My Application',
          'appLogo': '', // Placeholder for logo
          'themeColor': Colors.blue.value, // Color in int format
          'selectedLanguage': 'English',
          'timeZone': 'UTC',
          'emailNotifications': true,
          'pushNotifications': true,
          'customNotifications': [],
          'maintenanceMode': false,
          'backupStatus': 'Up-to-date',
          'adminId': FirebaseAuth.instance.currentUser?.uid, // Add admin ID to Firestore
        });
        print('Admin document created with default data!');
      } else {
        print('Admin document already exists.');

        // Add or update missing fields
        Map<String, dynamic> updatedData = {};

        if (adminSettings['systemName'] == null) {
          updatedData['systemName'] = 'My Application';
        }
        if (adminSettings['appLogo'] == null) {
          updatedData['appLogo'] = '';
        }
        if (adminSettings['themeColor'] == null) {
          updatedData['themeColor'] = Colors.blue.value;
        }
        if (adminSettings['selectedLanguage'] == null) {
          updatedData['selectedLanguage'] = 'English';
        }
        if (adminSettings['timeZone'] == null) {
          updatedData['timeZone'] = 'UTC';
        }
        if (adminSettings['emailNotifications'] == null) {
          updatedData['emailNotifications'] = true;
        }
        if (adminSettings['pushNotifications'] == null) {
          updatedData['pushNotifications'] = true;
        }
        if (adminSettings['customNotifications'] == null) {
          updatedData['customNotifications'] = [];
        }
        if (adminSettings['maintenanceMode'] == null) {
          updatedData['maintenanceMode'] = false;
        }
        if (adminSettings['backupStatus'] == null) {
          updatedData['backupStatus'] = 'Up-to-date';
        }
        // If any data is missing, update the document in Firestore
        if (updatedData.isNotEmpty) {
          await adminRef.update(updatedData);
          print('Admin document updated with missing data.');
        }
      }

      // Fetch the data after making sure the document exists and is complete
      adminSettings = await adminRef.get();
      if (adminSettings.exists) {
        systemName.value = adminSettings['systemName'] ?? 'My Application';
        appLogoUrl.value = adminSettings['appLogo'] ?? ''; // Fetch app logo URL from Firestore
        themeColor.value = themeColor(adminSettings['themeColor'] ?? Colors.blue.value);
        selectedLanguage.value = adminSettings['selectedLanguage'] ?? 'English';
        timeZone.value = adminSettings['timeZone'] ?? 'UTC';
        emailNotifications.value = adminSettings['emailNotifications'] ?? true;
        pushNotifications.value = adminSettings['pushNotifications'] ?? true;
        customNotifications.value = List.from(adminSettings['customNotifications'] ?? []);
        maintenanceMode.value = adminSettings['maintenanceMode'] ?? false;
        backupStatus.value = adminSettings['backupStatus'] ?? 'Up-to-date';
      }
    } catch (e) {
      print('Error fetching admin settings: $e');
    }
  }


  // Update notification settings
  Future<void> updateNotificationSettings() async {
    try {
      await firestore.collection('settings').doc('admin').update({
        'emailNotifications': emailNotifications.value,
        'pushNotifications': pushNotifications.value,
        'customNotifications': customNotifications,
      });
    } catch (e) {
      print('Error updating notification settings: $e');
    }
  }

  // Update system settings
  Future<void> updateSystemSettings() async {
    try {
      await firestore.collection('settings').doc('admin').update({
        'systemName': systemName.value,
        'appLogo': appLogoUrl.value, // Menyimpan URL gambar logo
        'themeColor': themeColor.value.value,
        'selectedLanguage': selectedLanguage.value,
        'timeZone': timeZone.value,
      });
    } catch (e) {
      print('Error updating system settings: $e');
    }
  }

  // Toggle 2FA
  Future<void> toggle2FA(bool value) async {
    try {
      is2FAEnabled.value = value;
      await firestore.collection('settings').doc('admin').update({
        'is2FAEnabled': is2FAEnabled.value,
      });
    } catch (e) {
      print('Error toggling 2FA: $e');
    }
  }

  // Log admin actions
  Future<void> logAction(String action) async {
    try {
      await firestore.collection('activityLogs').add({
        'action': action,
        'timestamp': FieldValue.serverTimestamp(),
        'adminId': FirebaseAuth.instance.currentUser?.uid,
      });
    } catch (e) {
      print('Error logging action: $e');
    }
  }

// Function to toggle email notifications
  void toggleEmailNotifications(bool value) async {
    try {
      emailNotifications.value = value;

      await firestore.collection('settings').doc('admin').update({
        'emailNotifications': emailNotifications.value,
      });

      // Log the action (optional)
      await logAction(
          "Email notifications toggled to ${value ? 'enabled' : 'disabled'}");
    } catch (e) {
      print('Error toggling email notifications: $e');
    }
  }

// Function to toggle push notifications
  void togglePushNotifications(bool value) async {
    try {
      pushNotifications.value = value;

      await firestore.collection('settings').doc('admin').update({
        'pushNotifications': pushNotifications.value,
      });

      // Optionally log the action
      await logAction(
          "Push notifications toggled to ${value ? 'enabled' : 'disabled'}");
    } catch (e) {
      print('Error toggling push notifications: $e');
    }
  }
}
