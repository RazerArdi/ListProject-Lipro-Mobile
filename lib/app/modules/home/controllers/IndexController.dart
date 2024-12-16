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

      // Hitung rentang waktu
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate;

      if (selectedDateRange.value == 'Today') {
        startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      } else if (selectedDateRange.value == 'This Week') {
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
      } else if (selectedDateRange.value == 'This Month') {
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      } else {
        return; // Tidak valid
      }

      // Konversi ke Timestamp
      Timestamp startTimestamp = Timestamp.fromDate(startDate);
      Timestamp endTimestamp = Timestamp.fromDate(endDate);

      // Query Firestore
      snapshot = await firestore
          .collection('tasks')
          .where('date', isGreaterThanOrEqualTo: startTimestamp)
          .where('date', isLessThanOrEqualTo: endTimestamp)
          .where('isCompleted', isEqualTo: selectedTaskStatus.value == 'Completed')
          .get();

      // Kosongkan list sebelum menambah data baru
      filteredTasks.clear();

      // Tambahkan data ke list
      for (var doc in snapshot.docs) {
        var taskData = doc.data() as Map<String, dynamic>?;
        if (taskData != null) {
          filteredTasks.add(taskData);
        }
      }

      print("Successfully fetched tasks: ${filteredTasks.length} tasks.");
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
