import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  // Change the type of selectedColor to Color
  var selectedColor = Color(0xFF2196F3).obs;

  var selectedTypography = 'Default'.obs;
  var selectedLanguage = 'English'.obs;
  var isCalendarImported = false.obs;

  // Method to change the app color
  void changeColor(Color newColor) {
    selectedColor.value = newColor;
  }

  // Method to change the typography
  void changeTypography(String typography) {
    selectedTypography.value = typography;
  }

  // Method to change the language
  void changeLanguage(String language) {
    selectedLanguage.value = language;
  }

  // Method to simulate Google Calendar import
  void importFromGoogleCalendar() {
    isCalendarImported.value = true;
  }
}