import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;  // Add the id field
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String category;
  final String priority;
  final bool isCompleted;

  Task({
    this.id = '',  // Default to empty string if not set yet
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

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var selectedDate = Rx<DateTime>(DateTime.now());
  var selectedTime = Rx<TimeOfDay>(TimeOfDay.now());
  var selectedCategory = Rx<String>("General");
  var selectedPriority = Rx<String>("Low");

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Add task to Firebase
  void addTask(Task task) async {
    try {
      await firestore.collection('tasks').add(task.toMap());
      fetchTasks(); // Refresh tasks after adding
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  // Fetch tasks from Firebase
  void fetchTasks() async {
    try {
      final snapshot = await firestore.collection('tasks').get();
      tasks.clear();
      for (var doc in snapshot.docs) {
        // Pass both doc.data() and doc.id to fromMap
        tasks.add(Task.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }



  // Remove task from Firebase
  void removeTask(Task task) async {
    try {
      final snapshot = await firestore
          .collection('tasks')
          .where('title', isEqualTo: task.title)
          .where('date', isEqualTo: task.date.toIso8601String())
          .get();
      for (var doc in snapshot.docs) {
        await firestore.collection('tasks').doc(doc.id).delete();
      }
      fetchTasks(); // Refresh tasks after removal
    } catch (e) {
      print("Error removing task: $e");
    }
  }

  // Select Date
  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  // Select Time
  void selectTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  // Select Category
  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  // Select Priority
  void selectPriority(String priority) {
    selectedPriority.value = priority;
  }
}
