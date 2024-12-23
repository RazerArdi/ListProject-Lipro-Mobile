import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables for dashboard metrics
  var totalUsers = 0.obs;
  var pendingFeedbacks = 0.obs;
  var resolvedFeedbacks = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardMetrics();
  }

  Future<void> fetchDashboardMetrics() async {
    try {
      // Fetch total users
      var userSnapshot = await _firestore.collection('users').get();
      totalUsers.value = userSnapshot.docs.length;

      // Fetch feedback metrics
      var pendingSnapshot = await _firestore
          .collection('user_feedback')
          .where('status', isEqualTo: 'pending')
          .get();
      pendingFeedbacks.value = pendingSnapshot.docs.length;

      var resolvedSnapshot = await _firestore
          .collection('user_feedback')
          .where('status', isEqualTo: 'resolved')
          .get();
      resolvedFeedbacks.value = resolvedSnapshot.docs.length;
    } catch (e) {
      print('Error fetching dashboard metrics: $e');
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }
}