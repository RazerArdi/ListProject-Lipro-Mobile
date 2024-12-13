import 'package:flutter_test/flutter_test.dart';
import 'package:lipro_mobile/app/modules/home/controllers/ThemeController.dart';
import 'package:lipro_mobile/app/modules/home/Model/EventTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  late ThemeController themeController;

  setUp(() {
    // Initialize the ThemeController before each test
    themeController = ThemeController();
  });

  test('selectThemeByCurrentDate should select the correct theme based on current date', () {
    // Set a specific date for testing
    DateTime fixedDate = DateTime(2024, 8, 17);  // Simulate "Kemerdekaan RI" event date
    themeController.selectThemeByCurrentDate();

    // Mock the current date to fixedDate
    themeController.availableThemes[0].startDate = fixedDate;

    // Call selectThemeByCurrentDate again with the fixed date
    themeController.selectThemeByCurrentDate();

    // Assert that the selected theme is the one corresponding to the fixed date
    expect(themeController.currentTheme.value?.id, 'independence_day');
  });

  test('selectThemeManually should select the correct theme by id', () {
    // Manually select a theme by its ID
    themeController.selectThemeManually('idul_fitri');

    // Assert that the correct theme was selected
    expect(themeController.currentTheme.value?.id, 'idul_fitri');
  });

  test('getCurrentTheme should return the currently selected theme', () {
    // Set a specific date for testing and select theme based on the current date
    DateTime fixedDate = DateTime(2024, 8, 17);  // Simulate "Kemerdekaan RI" event date
    themeController.selectThemeByCurrentDate();

    // Mock the current date to fixedDate
    themeController.availableThemes[0].startDate = fixedDate;

    // Call getCurrentTheme and assert it returns the correct theme
    EventTheme currentTheme = themeController.getCurrentTheme();
    expect(currentTheme.id, 'independence_day');
  });

  test('selectThemeByCurrentDate should default to the first theme if no theme matches the current date', () {
    // Set the current date to a date outside of any event range
    DateTime fixedDate = DateTime(2024, 12, 31);  // A date outside any event range
    themeController.selectThemeByCurrentDate();

    // Check that the default theme is selected (first theme in the list)
    expect(themeController.currentTheme.value?.id, 'independence_day');  // Default theme
  });
}
