import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends GetxController {
  var profileImageUrl = ''.obs; // Observable string for profile image URL

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Load user profile data from Firestore
  void loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        profileImageUrl.value = userDoc['profileImageUrl'] ?? '';
        // Load additional user data if needed
      }
    }
  }

  // Save user profile image URL to Firestore
  Future<void> saveUserProfileImage(String url) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'profileImageUrl': url,
      }, SetOptions(merge: true)); // Use merge to avoid overwriting other user data
      profileImageUrl.value = url; // Update local state
    }
  }

  // Logout function
  Future<void> logout() async {
    await _auth.signOut();
    // Navigate to the login page or other relevant screen
    Get.offAllNamed('/login'); // Assuming you have a named route for login
  }
}
