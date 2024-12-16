import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/views/User/IndexPage/TaskDetailScreen.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String category;
  final int taskCount;
  final Map<String, dynamic> taskData; // Include task details

  const TaskCard({
    Key? key,
    required this.title,
    required this.time,
    required this.category,
    required this.taskCount,
    required this.taskData, // Pass full task data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color categoryColor;
    IconData categoryIcon;

    // Customize category colors and icons based on category type
    switch (category) {
      case 'University':
        categoryColor = Colors.blue;
        categoryIcon = Icons.school;
        break;
      case 'Home':
        categoryColor = Colors.red;
        categoryIcon = Icons.home;
        break;
      case 'Work':
        categoryColor = Colors.orange;
        categoryIcon = Icons.work;
        break;
      default:
        categoryColor = Colors.grey;
        categoryIcon = Icons.label;
        break;
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => TaskDetailScreen(taskData: taskData));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Added horizontal margin
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.radio_button_unchecked, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(categoryIcon, size: 16, color: categoryColor),
                            const SizedBox(width: 4),
                            Text(
                              category,
                              style: TextStyle(color: categoryColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$taskCount',
                          style: const TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}