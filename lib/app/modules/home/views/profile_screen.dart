import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/ProfileController.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController()); // Initialize ProfileController

  ProfileScreen() {
    // Load the user profile data when the screen is initialized
    controller.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color matching the dark theme
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevents the column from taking full vertical space
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40), // Spacer for top padding
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      // Observe profileImageUrl to display the profile image dynamically
                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: controller.profileImageUrl.value.isNotEmpty
                            ? NetworkImage(controller.profileImageUrl.value)
                            : AssetImage('assets/default_profile_image.jpg') as ImageProvider, // Default image if no URL
                      );
                    }),
                    SizedBox(height: 8),
                    Text(
                      'Martha Hays', // Update this to fetch a name if available in Firestore
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TaskCounter(title: '${controller.profileImageUrl.value.isNotEmpty ? 1 : 0} Task left'), // Access the length of tasks
                        SizedBox(width: 16),
                        TaskCounter(title: '5 Task done'), // Static value, adjust as needed
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Divider(color: Colors.grey[700]), // Divider for separation
              SizedBox(height: 16),
              SectionTitle(title: 'Settings'),
              ProfileOption(icon: Icons.settings, label: 'App Settings'),
              SizedBox(height: 24),
              SectionTitle(title: 'Account'),
              ProfileOption(icon: Icons.person, label: 'Change account name'),
              ProfileOption(icon: Icons.lock, label: 'Change account password'),
              ProfileOption(icon: Icons.image, label: 'Change account Image'),
              SizedBox(height: 24),
              SectionTitle(title: 'Uptodo'),
              ProfileOption(icon: Icons.info, label: 'About US'),
              ProfileOption(icon: Icons.help, label: 'FAQ'),
              ProfileOption(icon: Icons.feedback, label: 'Help & Feedback'),
              ProfileOption(icon: Icons.support, label: 'Support US'),
              SizedBox(height: 24),
              ProfileOption(
                icon: Icons.logout,
                label: 'Log out',
                isLogout: true,
                onTap: () => _confirmLogout(context), // Call the confirmation dialog
              ),
            ],
          ),
        ),
      ),
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
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.logout(); // Call the logout method
                Navigator.of(context).pop(); // Close the dialog
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

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: Colors.grey[400], fontSize: 16, fontWeight: FontWeight.bold),
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
      onTap: onTap, // Use the onTap callback
    );
  }
}
