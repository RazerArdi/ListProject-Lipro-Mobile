import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/SettingsController.dart';

/// A stateless widget representing the application settings screen.
class AppSettings extends StatelessWidget {
  /// Instantiate and initialize the SettingsController with GetX's dependency injection.
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header for settings.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Settings',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // ListTile for changing app color.
            ListTile(
              leading: Icon(Icons.color_lens, color: Colors.white),
              title: Text(
                'Change app color',
                style: TextStyle(color: Colors.white),
              ),
              // Displays the currently selected color using an Obx widget to reflect real-time updates.
              trailing: Obx(() => CircleAvatar(
                backgroundColor: settingsController.selectedColor.value,
                radius: 10,
              )),
              // Example onTap to change color; would likely be replaced by a color picker.
              onTap: () {
                settingsController.changeColor(Colors.red); // Changes color to red as an example.
              },
            ),
            Divider(color: Colors.grey.shade800),

            // ListTile for changing app typography.
            ListTile(
              leading: Icon(Icons.font_download, color: Colors.white),
              title: Text(
                'Change app typography',
                style: TextStyle(color: Colors.white),
              ),
              // Displays the currently selected typography.
              trailing: Obx(() => Text(
                settingsController.selectedTypography.value,
                style: TextStyle(color: Colors.white),
              )),
              // Example onTap to change typography style; triggers typography change in the controller.
              onTap: () {
                settingsController.changeTypography("Serif");
              },
            ),
            Divider(color: Colors.grey.shade800),

            // ListTile for changing app language.
            ListTile(
              leading: Icon(Icons.language, color: Colors.white),
              title: Text(
                'Change app language',
                style: TextStyle(color: Colors.white),
              ),
              // Displays the currently selected language.
              trailing: Obx(() => Text(
                settingsController.selectedLanguage.value,
                style: TextStyle(color: Colors.white),
              )),
              // Example onTap to change language; triggers language change in the controller.
              onTap: () {
                settingsController.changeLanguage("Spanish");
              },
            ),
            Divider(color: Colors.grey.shade800),

            // Section header for import options.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Import',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // ListTile for importing from Google Calendar.
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.white),
              title: Text(
                'Import from Google calendar',
                style: TextStyle(color: Colors.white),
              ),
              // Displays the current import status; a check icon if imported, arrow otherwise.
              trailing: Obx(() => Icon(
                settingsController.isCalendarImported.value
                    ? Icons.check
                    : Icons.arrow_forward,
                color: settingsController.isCalendarImported.value
                    ? Colors.green
                    : Colors.white,
              )),
              // Triggers the import action from Google Calendar in the controller.
              onTap: () {
                settingsController.importFromGoogleCalendar();
              },
            ),
          ],
        ),
      ),
    );
  }
}
