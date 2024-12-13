import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/Model/EventTheme.dart';

class ThemeController extends GetxController {
  // Reactive variable for the current theme
  Rx<EventTheme?> currentTheme = Rx<EventTheme?>(null);

  // List of available themes
  List<EventTheme> availableThemes = [
    EventTheme(
      id: 'independence_day',
      name: 'Kemerdekaan RI',
      primaryColor: Colors.red,
      secondaryColor: Colors.white,
      backgroundColor: Color(0xFFFF0000),
      startDate: DateTime(DateTime.now().year, 8, 17),
      endDate: DateTime(DateTime.now().year, 8, 18),
    ),
    EventTheme(
      id: 'idul_fitri',
      name: 'Idul Fitri',
      primaryColor: Colors.green,
      secondaryColor: Colors.white,
      backgroundColor: Color(0xFF4CAF50),
      startDate: DateTime(DateTime.now().year, 4, 10),
      endDate: DateTime(DateTime.now().year, 4, 12),
    ),
    EventTheme(
      id: 'kartini_day',
      name: 'Hari Kartini',
      primaryColor: Colors.pink,
      secondaryColor: Colors.white,
      backgroundColor: Color(0xFFFF69B4),
      startDate: DateTime(DateTime.now().year, 4, 21),
      endDate: DateTime(DateTime.now().year, 4, 22),
    ),
    // Default theme when no event matches the current date
    EventTheme(
      id: 'default_theme',
      name: 'Default Theme',
      primaryColor: Colors.purple,
      secondaryColor: Colors.white,
      backgroundColor: Color(0xFF1F1D2B),
      startDate: DateTime(DateTime.now().year, 1, 1),  // Always active
      endDate: DateTime(DateTime.now().year, 12, 31), // Always active
    ),
  ];

  // Method to select theme based on current date with improved logging
  void selectThemeByCurrentDate() {
    DateTime now = DateTime.now();
    print('Current date: $now'); // Debug print

    EventTheme? selectedTheme = availableThemes.firstWhere(
          (theme) {
        bool isWithinRange = now.isAfter(theme.startDate.subtract(Duration(days: 1))) &&
            now.isBefore(theme.endDate.add(Duration(days: 1)));
        print('Theme: ${theme.name}, Start: ${theme.startDate}, End: ${theme.endDate}, Is Active: $isWithinRange');
        return isWithinRange;
      },
      orElse: () {
        print('No active theme found, using default');
        return availableThemes.firstWhere((theme) => theme.id == 'default_theme');
      },
    );

    currentTheme.value = selectedTheme;
    print('Selected Theme: ${selectedTheme.name}'); // Debug print
  }

  // Method to select theme manually
  void selectThemeManually(String themeId) {
    currentTheme.value = availableThemes.firstWhere(
          (theme) => theme.id == themeId,
      orElse: () => availableThemes.firstWhere((theme) => theme.id == 'default_theme'),
    );
  }

  // Method to get current theme, ensuring a theme is always set
  EventTheme getCurrentTheme() {
    if (currentTheme.value == null) {
      selectThemeByCurrentDate();
    }
    return currentTheme.value!;
  }
}
