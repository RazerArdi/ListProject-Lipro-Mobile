import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/ProfileController.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen() {
    controller.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: Obx(() {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.black,
                        backgroundImage: controller.profileImageUrl.value.isNotEmpty
                            ? NetworkImage(controller.profileImageUrl.value)
                            : null,
                        child: controller.profileImageUrl.value.isEmpty
                            ? Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.userName.value.isNotEmpty ? controller.userName.value : 'User',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TaskCounter(title: '${controller.profileImageUrl.value.isNotEmpty ? 1 : 0} Task left'),
                          SizedBox(width: 16),
                          TaskCounter(title: '5 Task done'), // Static value; adjust if needed
                        ],
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 24),
              Divider(color: Colors.grey[700]),
              SizedBox(height: 16),
              _buildSectionTitle('Settings'),
              ProfileOption(icon: Icons.settings, label: 'App Settings'),
              SizedBox(height: 24),
              _buildSectionTitle('Account'),
              ProfileOption(icon: Icons.person, label: 'Change account name'),
              ProfileOption(
                icon: Icons.lock,
                label: 'Change account password',
                onTap: () => _showChangePasswordDialog(context), // Call the dialog here
              ),
              ProfileOption(
                icon: Icons.image,
                label: 'Change account Image',
                onTap: () async {
                  await controller.changeProfileImage();  // Call the changeProfileImage method
                },
              ),
              SizedBox(height: 24),
              _buildSectionTitle('Uptodo'),
              ProfileOption(icon: Icons.info, label: 'About US'),
              ProfileOption(icon: Icons.help, label: 'FAQ'),
              ProfileOption(icon: Icons.feedback, label: 'Help & Feedback'),
              ProfileOption(icon: Icons.support, label: 'Support US'),
              SizedBox(height: 24),
              ProfileOption(
                icon: Icons.logout,
                label: 'Log out',
                isLogout: true,
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.grey[400], fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // Change Password Dialog
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String oldPassword = '';
        String newPassword = '';

        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            "Change account Password",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                onChanged: (value) => oldPassword = value,
                decoration: InputDecoration(
                  labelText: 'Enter old password',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              TextField(
                obscureText: true,
                onChanged: (value) => newPassword = value,
                decoration: InputDecoration(
                  labelText: 'Enter new password',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 24),
              ),
              onPressed: () async {
                // Call changePassword method in controller
                await controller.changePassword(oldPassword, newPassword);
                Navigator.of(context).pop(); // Close the dialog after the password change attempt
              },
              child: Text("Edit"),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.logout();
                Navigator.of(context).pop();
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

class TaskCounter extends StatelessWidget {
  final String title;

  TaskCounter({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLogout;
  final VoidCallback? onTap;

  ProfileOption({required this.icon, required this.label, this.isLogout = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.white),
      title: Text(
        label,
        style: TextStyle(color: isLogout ? Colors.red : Colors.white),
      ),
      onTap: onTap,
    );
  }
}
