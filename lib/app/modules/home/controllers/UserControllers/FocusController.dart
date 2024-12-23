import 'dart:async';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FocusController extends GetxController {
  static const platform = MethodChannel('com.example.app/usageStats');

  var focusTimeRemaining = 1800.obs; // Total focus time in seconds (30 minutes)
  var isFocusing = false.obs; // State to track if focusing
  var selectedView = "This Week".obs; // Current selected view
  var appUsage = <String, int>{}.obs; // To store real-time app usage data
  var dailyUsage = 0.obs; // Store daily screen-on time in seconds
  var weeklyUsage = <double>[0, 0, 0, 0, 0, 0, 0].obs; // Store weekly usage for each day
  var monthlyUsage = 0.obs; // Store monthly screen-on time in seconds
  var yearlyUsage = 0.obs; // Store yearly screen-on time in seconds
  Timer? _timer; // Timer instance

  @override
  void onInit() {
    super.onInit();
    fetchAppUsage(); // Fetch usage stats at initialization
    Timer.periodic(Duration(minutes: 5), (Timer t) => fetchAppUsage()); // Periodically fetch app usage
  }

  // Fetch real-time app usage data from the platform channel
  Future<void> fetchAppUsage() async {
    if (await hasUsageStatsPermission()) {
      try {
        final Map<dynamic, dynamic> usageData = await platform.invokeMethod('getAppUsage');
        appUsage.clear(); // Clear previous data
        appUsage.addAll(usageData.map((key, value) => MapEntry(key.toString(), value as int))); // Update usage data

        // Update all time period usage
        updateUsageStatistics();
      } on PlatformException catch (e) {
        print("Failed to get app usage data: '${e.message}'.");
      }
    } else {
      await openUsageAccessSettings(); // Prompt the user to enable the permission
    }
  }

  void updateUsageStatistics() {
    dailyUsage.value = 0;
    monthlyUsage.value = 0;
    yearlyUsage.value = 0;

    // Reset weekly usage for each day
    for (int i = 0; i < 7; i++) {
      weeklyUsage[i] = 0.0; // Initialize the weekly usage for each day
    }

    appUsage.forEach((appName, usageTime) {
      int usageInSeconds = (usageTime ~/ 1000); // Convert milliseconds to seconds
      dailyUsage.value += usageInSeconds; // Daily usage

      // Assuming we're treating all usage as this week's usage for simplicity
      DateTime now = DateTime.now();
      int currentDayOfWeek = now.weekday; // 1 = Monday, 7 = Sunday
      weeklyUsage[currentDayOfWeek - 1] += usageInSeconds; // Update the current day's usage

      monthlyUsage.value += usageInSeconds; // Monthly usage
      yearlyUsage.value += usageInSeconds; // Yearly usage
    });

    dailyUsage.refresh();
    monthlyUsage.refresh();
    yearlyUsage.refresh();
    weeklyUsage.refresh();
  }

  // Check if usage stats permission is granted
  Future<bool> hasUsageStatsPermission() async {
    try {
      return await platform.invokeMethod('checkUsageStatsPermission');
    } catch (e) {
      print("Error checking permission: $e");
      return false; // Assume permission is not granted on error
    }
  }

  Future<void> openUsageAccessSettings() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.USAGE_ACCESS_SETTINGS',
      );
      try {
        await intent.launch();
      } catch (e) {
        print('Error launching settings: $e');
      }
    }
  }

  // Method to toggle focus mode
  void toggleFocusMode() {
    isFocusing.value = !isFocusing.value; // Toggle the focusing state

    if (isFocusing.value) {
      startFocusing(); // Start focusing if it's set to true
    } else {
      stopFocusing(); // Stop focusing if it's set to false
    }
  }

  // Start focusing and countdown timer
  void startFocusing() {
    startFocusCountdown(); // Start the countdown timer
  }

  // Stop focusing
  void stopFocusing() {
    isFocusing.value = false; // Set focusing state to false
    _timer?.cancel(); // Cancel the timer if running
  }

  // Countdown timer logic
  void startFocusCountdown() {
    _timer?.cancel(); // Cancel any existing timer

    // Start a new timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (focusTimeRemaining.value > 0) {
        focusTimeRemaining.value -= 1; // Decrement timer by 1 second
      } else {
        stopFocusing(); // Stop focus mode when time runs out
        // Optionally, notify the user (e.g., using a dialog)
        Get.defaultDialog(
          title: "Time's Up!",
          middleText: "Your focus session has ended.",
          onConfirm: () {
            Get.back(); // Close the dialog
          },
          textConfirm: "OK",
        );
      }
    });
  }

  // Change the view (This Day, This Week, etc.)
  void changeView(String view) {
    selectedView.value = view; // Update selected view
  }

  void restartFocus() {
    stopFocusing(); // Stop any ongoing focus
    focusTimeRemaining.value = 1800; // Reset time to 30 minutes (or any default)
  }

  void pauseFocus() {
    if (isFocusing.value) {
      _timer?.cancel(); // Pause the timer
      isFocusing.value = false; // Set focusing state to false
    }
  }

  // Set custom focus time (in hours, minutes, and seconds)
  void setFocusTime(int hours, int minutes, int seconds) {
    final totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    focusTimeRemaining.value = totalSeconds; // Update the focus time remaining
  }
}
