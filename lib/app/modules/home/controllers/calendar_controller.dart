import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Task class definition with toMap and fromMap methods
class CalendarController extends GetxController {
  var tasks = <Task>[].obs;
  var selectedDate = DateTime.now().obs;
  var startDate = DateTime.now().obs;
  var selectedTab = 'Today'.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Getter for formatted month
  String get selectedMonth => DateFormat('MMMM yyyy').format(startDate.value);

  // Add task to Firestore
  void addTask(Task task) async {
    try {
      await firestore.collection('tasks').add(task.toMap());
      fetchTasks(); // Refresh tasks after adding
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  // Fetch tasks for Today
  void showTodayTasks() {
    selectedDate.value = DateTime.now();
    fetchTasks(); // Fetch tasks for today
  }

  // Fetch completed tasks
  void showCompletedTasks() async {
    try {
      final snapshot = await firestore
          .collection('tasks')
          .where('isCompleted', isEqualTo: true)
          .get();

      tasks.clear();

      if (snapshot.docs.isEmpty) {
        print("No completed tasks found.");
      } else {
        print("Successfully fetched completed tasks: ${snapshot.docs.length} tasks.");
        for (var doc in snapshot.docs) {
          tasks.add(Task.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        }
      }
    } catch (e) {
      print("Error fetching completed tasks: $e");
    }
  }

  // Fetch tasks for a specific date
  void fetchTasks() async {
    try {
      final selectedDateStart = DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
          0, 0, 0, 0
      );

      final selectedDateEnd = DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
          23, 59, 59, 999
      );

      final startTimestamp = Timestamp.fromDate(selectedDateStart);
      final endTimestamp = Timestamp.fromDate(selectedDateEnd);

      final snapshot = await firestore
          .collection('tasks')
          .where('date', isGreaterThanOrEqualTo: startTimestamp)
          .where('date', isLessThanOrEqualTo: endTimestamp)
          .get();

      tasks.clear();

      if (snapshot.docs.isEmpty) {
        print("No tasks found for the selected date.");
      } else {
        print("Successfully fetched tasks: ${snapshot.docs.length} tasks.");
        for (var doc in snapshot.docs) {
          // Pass the document ID to the fromMap method
          tasks.add(Task.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        }
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  // Mark a task as completed
  void completeTask(Task task) async {
    try {
      // Update the task's 'isCompleted' field in Firestore
      await firestore.collection('tasks').doc(task.id).update({
        'isCompleted': true,
      });

      // After updating, fetch tasks again to reflect the change
      fetchTasks();
    } catch (e) {
      print("Error completing task: $e");
    }
  }

  // Switch between "Today" and "Completed" tabs
  void selectTab(String tab) {
    selectedTab.value = tab;
    if (tab == 'Today') {
      showTodayTasks();
    } else {
      showCompletedTasks();
    }
  }

  // Navigate to the next month
  void nextMonth() {
    startDate.value = DateTime(startDate.value.year, startDate.value.month + 1, 1);
    fetchTasks();
  }

  // Navigate to the previous month
  void previousMonth() {
    startDate.value = DateTime(startDate.value.year, startDate.value.month - 1, 1);
    fetchTasks();
  }

  // Select a specific date
  void selectDate(DateTime date) {
    selectedDate.value = date;
    fetchTasks(); // Fetch tasks for the selected date
  }

  // Getter to calculate the number of days in the selected month
  int get daysInSelectedMonth {
    final firstDayOfMonth = DateTime(startDate.value.year, startDate.value.month, 1);
    final lastDayOfMonth = DateTime(startDate.value.year, startDate.value.month + 1, 0);
    return lastDayOfMonth.day;
  }

  // Edit task in Firestore
  void editTask(Task task) async {
    try {
      await firestore.collection('tasks').doc(task.id).update(task.toMap());
      fetchTasks(); // Refresh tasks after editing
      print("Task updated successfully.");
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  // Toggle task's completed status
  void toggleTaskCompletion(Task task) async {
    try {
      // Toggle the isCompleted field between true and false
      bool newStatus = !task.isCompleted;

      await firestore.collection('tasks').doc(task.id).update({
        'isCompleted': newStatus,
      });

      // After updating, fetch tasks again to reflect the change
      fetchTasks();
      print("Task completion toggled: ${newStatus ? 'Completed' : 'Uncompleted'}");
    } catch (e) {
      print("Error toggling task completion: $e");
    }
  }

}


class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String category;
  final String priority;
  final bool isCompleted;

  Task({
    this.id = '',
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    required this.priority,
    this.isCompleted = false,
  });

  // Convert Task to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp
      'time': '${time.hour}:${time.minute}', // Store time as a string
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  // Convert Firestore data to Task object
  static Task fromMap(Map<String, dynamic> map, String id) {
    TimeOfDay time = TimeOfDay(
      hour: int.parse(map['time'].split(':')[0]),
      minute: int.parse(map['time'].split(':')[1]),
    );

    return Task(
      id: id,
      title: map['title'],
      description: map['description'],
      date: (map['date'] as Timestamp).toDate(),  // Convert Firestore Timestamp to DateTime
      time: time,
      category: map['category'],
      priority: map['priority'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

