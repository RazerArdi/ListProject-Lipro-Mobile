import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IndexController extends GetxController {
  // Variables for filtering
  var selectedDateRange = 'Today'.obs;
  var selectedTaskStatus = 'Uncompleted'.obs;

  // Firebase Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Variable to store filtered tasks
  var filteredTasks = <Map<String, dynamic>>[].obs;

  // Fetch tasks from Firestore based on selected date range and task status
  void fetchTasks() async {
    try {
      print("Fetching tasks...");  // Debugging log
      QuerySnapshot snapshot;

      // Get the current date and calculate date range based on selectedDateRange
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate;

      // Handle different date range selections
      if (selectedDateRange.value == 'Today') {
        startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      } else if (selectedDateRange.value == 'This Week') {
        // Get the start of the current week (Monday)
        startDate = now.subtract(Duration(days: now.weekday - 1));
        // Get the end of the current week (Sunday)
        endDate = startDate.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
      } else if (selectedDateRange.value == 'This Month') {
        // Get the start of the current month
        startDate = DateTime(now.year, now.month, 1);
        // Get the end of the current month
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      } else {
        return; // Default if invalid range
      }

      // Convert the DateTime objects to Firestore timestamps
      Timestamp startTimestamp = Timestamp.fromDate(startDate);
      Timestamp endTimestamp = Timestamp.fromDate(endDate);

      // Query Firestore based on the selected date range and task status
      snapshot = await firestore
          .collection('tasks')
          .where('date', isGreaterThanOrEqualTo: startTimestamp)
          .where('date', isLessThanOrEqualTo: endTimestamp)
          .where('isCompleted', isEqualTo: selectedTaskStatus.value == 'Completed')
          .get();

      // Debugging log for snapshot size
      print("Snapshot docs length: ${snapshot.docs.length}");

      // Clear the previous list and add the new tasks
      filteredTasks.clear();
      for (var doc in snapshot.docs) {
        var taskData = doc.data() as Map<String, dynamic>?;
        if (taskData != null) {
          filteredTasks.add(taskData);  // This will trigger UI update
        } else {
          print("Error: Task data is null for document ${doc.id}");
        }
      }


      // Check if any tasks were found
      if (snapshot.docs.isEmpty) {
        print("No tasks found for the selected filters.");
      } else {
        // Process the snapshot to add tasks to filteredTasks
        for (var doc in snapshot.docs) {
          // Cast doc.data() to Map<String, dynamic> and ensure it's not null
          var taskData = doc.data() as Map<String, dynamic>?;
          if (taskData != null) {
            filteredTasks.add(taskData);
          } else {
            print("Error: Task data is null for document ${doc.id}");
          }
        }
        print("Successfully fetched tasks: ${snapshot.docs.length} tasks.");
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }


  // Method to change selected date range and fetch tasks again
  void changeDateRange(String newRange) {
    selectedDateRange.value = newRange;
    fetchTasks();
  }

  // Method to change selected task status and fetch tasks again
  void changeTaskStatus(String newStatus) {
    selectedTaskStatus.value = newStatus;
    fetchTasks();
  }
}
