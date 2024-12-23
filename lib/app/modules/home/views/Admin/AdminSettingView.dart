import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/AdminControllers/AdminSettingController.dart';

class AdminSettingView extends StatelessWidget {
  final AdminSettingController controller = Get.put(AdminSettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          'Admin Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Notification Settings
            buildSectionTitle('Notification Settings'),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Obx(() => buildCustomSwitch(
                    'Email Notifications',
                    controller.emailNotifications.value,
                    controller.toggleEmailNotifications,
                    Icons.email_outlined,
                  )),
                  Divider(height: 1, color: Colors.grey[800]),
                  Obx(() => buildCustomSwitch(
                    'Push Notifications',
                    controller.pushNotifications.value,
                    controller.togglePushNotifications,
                    Icons.notifications_outlined,
                  )),
                  Divider(height: 1, color: Colors.grey[800]),
                  buildCustomListTile(
                    'Custom Notifications',
                    Icons.edit_notifications_outlined,
                    onTap: () {/* Open custom notifications */},
                  ),
                ],
              ),
            ),

            // Section: System Settings
            buildSectionTitle('System Settings'),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Obx(() => buildCustomListTile(
                    'System Name',
                    Icons.settings_outlined,
                    subtitle: controller.systemName.value,
                  )),
                  Divider(height: 1, color: Colors.grey[800]),
                  buildCustomListTile(
                    'Theme Color',
                    Icons.palette_outlined,
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[800]),
                  Obx(() => buildCustomListTile(
                    'Language Settings',
                    Icons.language_outlined,
                    subtitle: controller.selectedLanguage.value,
                  )),
                  Divider(height: 1, color: Colors.grey[800]),
                  Obx(() => buildCustomListTile(
                    'Time Zone Settings',
                    Icons.access_time_outlined,
                    subtitle: controller.timeZone.value,
                  )),
                ],
              ),
            ),

            // Section: Security Settings
            buildSectionTitle('Security Settings'),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Obx(() => buildCustomSwitch(
                    'Two-Factor Authentication',
                    controller.is2FAEnabled.value,
                        (value) => controller.is2FAEnabled.value = value,
                    Icons.security_outlined,
                  )),
                  Divider(height: 1, color: Colors.grey[800]),
                  buildCustomListTile(
                    'Session Management',
                    Icons.devices_outlined,
                  ),
                ],
              ),
            ),

            // Section: Backup & Maintenance
            buildSectionTitle('Backup & Maintenance'),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Obx(() => buildCustomListTile(
                    'Backup Status',
                    Icons.backup_outlined,
                    subtitle: controller.backupStatus.value,
                  )),
                  Divider(height: 1, color: Colors.grey[800]),
                  Obx(() => buildCustomSwitch(
                    'Maintenance Mode',
                    controller.maintenanceMode.value,
                        (value) => controller.maintenanceMode.value = value,
                    Icons.build_outlined,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget buildCustomListTile(String title, IconData icon, {
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: Colors.blue, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null ? Text(
        subtitle,
        style: TextStyle(color: Colors.grey[400]),
      ) : null,
      trailing: trailing ?? Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[600],
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget buildCustomSwitch(String title, bool value, Function(bool) onChanged, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: Colors.blue, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
        activeTrackColor: Colors.blue.withOpacity(0.3),
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[700],
      ),
    );
  }
}