import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarController extends GetxController {
  var tasks = <Task>[].obs; // List of tasks
  var selectedDate = DateTime.now().obs; // Currently selected date
  var selectedTime = TimeOfDay.now().obs; // Currently selected time
  var selectedCategory = ''.obs; // Selected category (as String)
  var selectedPriority = 1.obs; // Selected priority (as int)

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Computed property to get the month as a formatted string
  String get selectedMonth => DateFormat('MMMM yyyy').format(selectedDate.value);

  // Methods to add and update tasks
  void addTask(Task task) async {
    await firestore.collection('tasks').add({
      'title': task.title,
      'description': task.description,
      'date': task.date.toIso8601String(),
      'time': task.time.format(Get.context!), // Format to string for storage
      'category': task.category,
      'priority': task.priority,
    });
    fetchTasks(); // Fetch tasks after adding a new one
  }

  void fetchTasks() async {
    final snapshot = await firestore.collection('tasks').get();
    tasks.clear(); // Clear current tasks before fetching new ones
    for (var doc in snapshot.docs) {
      final data = doc.data();
      tasks.add(Task(
        title: data['title'],
        description: data['description'],
        date: DateTime.parse(data['date']),
        time: TimeOfDay(
          hour: int.parse(data['time'].split(':')[0]),
          minute: int.parse(data['time'].split(':')[1]),
        ),
        category: data['category'],
        priority: data['priority'],
      ));
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date; // Update selected date
  }

  void selectTime(TimeOfDay time) {
    selectedTime.value = time; // Update selected time
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void selectPriority(String priority) {
    selectedPriority.value = priority == 'Low' ? 1 : priority == 'Medium' ? 2 : 3;
  }
}

class Task {
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String category;
  final int priority;

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    required this.priority,
  });
}
