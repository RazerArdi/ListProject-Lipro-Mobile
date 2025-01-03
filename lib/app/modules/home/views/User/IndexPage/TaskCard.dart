// TaskCard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/views/User/IndexPage/TaskDetailScreen.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String category;
  final String description;
  final int taskCount;
  final Map<String, dynamic> taskData;

  const TaskCard({
    Key? key,
    required this.title,
    required this.time,
    required this.category,
    required this.description,
    required this.taskCount,
    required this.taskData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Print untuk debugging
    print('TaskData being passed: $taskData');

    Color categoryColor;
    IconData categoryIcon;

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

    // Get description for preview
    String description = taskData['description'] ?? 'No description';
    String descriptionPreview = description.length > 50
        ? description.substring(0, 50) + '...'
        : description;

    return GestureDetector(
      onTap: () {
        // Memastikan semua data terisi sebelum navigasi
        final completeTaskData = {
          ...taskData, // Spread existing taskData first
          'title': title,
          'time': time,
          'category': category,
          'description': description ?? '',
          'date': taskData['date'],
          'isCompleted': taskData['isCompleted'] ?? false,
          'priority': taskData['priority'] ?? 'Low',
        };

        print('Complete task data: $completeTaskData');
        Get.to(() => TaskDetailScreen(taskData: completeTaskData));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to top
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                  taskData['isCompleted'] == true
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: Colors.grey
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with better text overflow handling
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Description preview
                  Text(
                    descriptionPreview,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4
                        ),
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
                              style: TextStyle(
                                  color: categoryColor,
                                  fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (taskData['priority'] != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(
                                taskData['priority']
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            taskData['priority'],
                            style: TextStyle(
                                color: _getPriorityColor(taskData['priority']),
                                fontSize: 12
                            ),
                          ),
                        ),
                      ],
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

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}